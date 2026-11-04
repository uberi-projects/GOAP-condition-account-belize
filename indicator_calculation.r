# indicator_calculation.r

# Set boolean for whether test data or AGRRA data should be used ---------------------------
test_on <- FALSE

# Source scripts ---------------------------
source("data_validation.r")

# Set vectors ---------------------------
coral_category <- ifelse(test_on == TRUE, "Coral", "Calcifiers :: Coral")
algae_category <- ifelse(test_on == TRUE, "Fleshy Macroalgae", "Algae :: Macro :: Fleshy")
quadrats_per_transect <- 5 # AGRRA recruit quadrats per benthic transect
quadrat_area_m2 <- 0.25 * 0.25 # AGRRA recruit quadrat is 25 x 25 cm

# Check inputs ---------------------------
stopifnot(
    "Duplicate organism codes in df_organisms" = !anyDuplicated(df_organisms$Code),
    "Missing Site in benthic data" = !anyNA(df_benthic_cover$Site),
    "Missing Site in coral data" = !anyNA(df_coral_community$Site),
    "Missing Site in fish data" = !anyNA(df_fish$Site)
)
unknown_codes <- setdiff(df_benthic_cover$Organism, df_organisms$Code)
if (length(unknown_codes) > 0) {
    stop("Benthic codes missing from df_organisms: ", paste(unknown_codes, collapse = ", "))
}
# A site whose transects fall in different years is usually a mis-typed survey date
split_sites <- bind_rows(
    df_benthic_cover %>% distinct(Site, Transect, Date),
    df_coral_community %>% distinct(Site, Transect, Date),
    df_fish %>% distinct(Site, Transect, Date)
) %>%
    mutate(Year = format(as.Date(Date), format = "%Y")) %>%
    group_by(Site) %>%
    filter(n_distinct(Year) > 1) %>%
    count(Site, Year)
if (nrow(split_sites) > 0) {
    warning("Sites with transects in more than one year (check survey dates):\n",
            paste(capture.output(print(as.data.frame(split_sites))), collapse = "\n"))
}

# Prepare data ---------------------------
# "Newly Dead" coral is not live coral, so it gets its own type for the coral presence calculation
if (!"State" %in% names(df_organisms)) df_organisms$State <- NA_character_
df_organisms_unique <- df_organisms %>%
    distinct(Code, Type, State) %>%
    mutate(Coral_Type = ifelse(State %in% "Newly Dead", "Newly Dead Coral", Type))
benthic_cover_presence <- df_benthic_cover %>%
    left_join(df_organisms_unique %>% select(Code, Primary_Type = Type, Primary_Coral_Type = Coral_Type), by = c("Organism" = "Code")) %>%
    left_join(df_organisms_unique %>% select(Code, Secondary_Type = Type, Secondary_Coral_Type = Coral_Type), by = c("Secondary" = "Code")) %>%
    mutate(
        Coral_Presence = Vectorize(calculate_type_presence)(Primary_Coral_Type, Secondary_Coral_Type, coral_category),
        Algae_Presence = Vectorize(calculate_type_presence)(Primary_Type, Secondary_Type, algae_category),
        Year = format(as.Date(Date), format = "%Y")
    )

# Calculate live coral and macroalgae cover ---------------------------
benthic_cover_tran <- benthic_cover_presence %>%
    group_by(Year, Site, Transect) %>%
    summarize(
        Coral_Cover_Tran = 100 * mean(Coral_Presence),
        Algae_Cover_Tran = 100 * mean(Algae_Presence),
        .groups = "drop"
    )
benthic_cover_site <- benthic_cover_tran %>%
    group_by(Year, Site) %>%
    summarize(
        Coral_Cover_Site = mean(Coral_Cover_Tran),
        Algae_Cover_Site = mean(Algae_Cover_Tran),
        .groups = "drop"
    )
summarize_cover <- function(site_col, tran_col) {
    site_stats <- benthic_cover_site %>%
        group_by(Year) %>%
        summarize(
            `Min (Site)` = min({{ site_col }}),
            `Av. (Site)` = mean({{ site_col }}),
            `Median (Site)` = median({{ site_col }}),
            `Max (Site)` = max({{ site_col }})
        )
    tran_stats <- benthic_cover_tran %>%
        group_by(Year) %>%
        summarize(
            `Min (Transect)` = min({{ tran_col }}),
            `Av. (Transect)` = mean({{ tran_col }}),
            `Median (Transect)` = median({{ tran_col }}),
            `Max (Transect)` = max({{ tran_col }})
        )
    left_join(site_stats, tran_stats, by = "Year") %>%
        mutate(across(-Year, ~ round(.x, 2)))
}
indicator_lcc <- summarize_cover(Coral_Cover_Site, Coral_Cover_Tran)
indicator_fma <- summarize_cover(Algae_Cover_Site, Algae_Cover_Tran)

# Calculate recruit density ---------------------------
# Every benthic transect is surveyed for recruits, so sites with no recruit rows count as zero.
# Surveyed area comes from the number of benthic transects at the site.
recruits_site <- df_recruits %>%
    mutate(Year = format(as.Date(Date), format = "%Y")) %>%
    group_by(Year, Site) %>%
    summarize(
        Recruits = sum(Num, na.rm = TRUE),
        `Small Recruits` = sum(Num[Size == "SR"], na.rm = TRUE),
        `Large Recruits` = sum(Num[Size == "LR"], na.rm = TRUE),
        .groups = "drop"
    )
unmatched_recruits <- anti_join(recruits_site, benthic_cover_tran, by = c("Year", "Site"))
if (nrow(unmatched_recruits) > 0) {
    warning("Recruit sites with no benthic cover data (dropped): ", paste(unmatched_recruits$Site, collapse = ", "))
}
benthic_recruits_rd <- benthic_cover_tran %>%
    count(Year, Site, name = "Transects") %>%
    left_join(recruits_site, by = c("Year", "Site")) %>%
    mutate(across(c(Recruits, `Small Recruits`, `Large Recruits`), ~ coalesce(.x, 0))) %>%
    transmute( # calculate density per square meter
        Year, Site,
        All = Recruits / (Transects * quadrats_per_transect * quadrat_area_m2),
        Small = `Small Recruits` / (Transects * quadrats_per_transect * quadrat_area_m2),
        Large = `Large Recruits` / (Transects * quadrats_per_transect * quadrat_area_m2)
    )
indicator_rd <- benthic_recruits_rd %>%
    pivot_longer(cols = c(All, Small, Large), names_to = "Size", values_to = "Value") %>%
    group_by(Year, Size) %>%
    summarize(
        Min = min(Value),
        `Av.` = mean(Value),
        Median = median(Value),
        Max = max(Value),
        .groups = "drop"
    ) %>%
    mutate(across(-c(Year, Size), ~ round(.x, 2)))

# Calculate live coral diversity ---------------------------
coral_community_cd <- df_coral_community %>%
    mutate(Year = format(as.Date(Date), format = "%Y")) %>%
    filter(!is.na(Organism), Organism != "") %>%
    group_by(Year, Date, Site, Transect, Organism) %>%
    summarize(
        Abundance = n(),
    ) %>%
    group_by(Year, Date, Site, Transect) %>%
    mutate(
        p_i = Abundance / sum(Abundance) # relative abundance
    ) %>%
    summarize(
        Diversity = -sum(p_i * log(p_i), na.rm = TRUE),
        Richness = n_distinct(Organism),
    ) %>%
    group_by(Year, Date, Site) %>%
    summarize(
        Diversity = mean(Diversity, na.rm = TRUE),
        Richness = mean(Richness, na.rm = TRUE),
    )
indicator_cd <- coral_community_cd %>%
    group_by(Year, Site) %>%
    summarize(
        Diversity = mean(Diversity, na.rm = TRUE),
        Richness = mean(Richness, na.rm = TRUE),
    ) %>%
    pivot_longer(
        cols = c(Diversity, Richness),
        names_to = "Metric",
        values_to = "Value"
    ) %>%
    group_by(Year, Metric) %>%
    summarize(
        Min = min(Value, na.rm = TRUE),
        `Av.` = mean(Value, na.rm = TRUE),
        Median = median(Value, na.rm = TRUE),
        Max = max(Value, na.rm = TRUE)
    ) %>%
    mutate(across(where(is.numeric), ~ round(.x, 2)))

# Calculate max relief ---------------------------
fish_relief <- df_fish %>%
    mutate(Year = format(as.Date(Date), format = "%Y")) %>%
    group_by(Year, Site) %>%
    summarize(Relief_Site = mean(Max_Relief, na.rm = TRUE))
indicator_relief <- fish_relief %>%
    group_by(Year) %>%
    summarize(
        `Min (Site)` = min(Relief_Site, na.rm = TRUE),
        `Av. (Site)` = mean(Relief_Site, na.rm = TRUE),
        `Median (Site)` = median(Relief_Site, na.rm = TRUE),
        `Max (Site)` = max(Relief_Site, na.rm = TRUE)
    ) %>%
    mutate(across(-Year, ~ round(.x, 2)))
# =============================================================================                        
# EXPORT SITE-LEVEL INDICATOR VALUES                                                                   
# =============================================================================                        
# This output bridges the data processing pipeline to the SEEA EA            
# accounting steps (normalization, geographic aggregation, table assembly).                            
# Output format: one row per site per indicator per year.                                             
# Columns: Year, Site, Indicator, Value                                                                

message("---- Exporting site-level indicator values ----")                                             

site_coral_cover <- benthic_cover_site %>%
  transmute(Year, Site, Value = Coral_Cover_Site, Indicator = "Live_Coral_Cover")

site_macroalgae <- benthic_cover_site %>%
  transmute(Year, Site, Value = Algae_Cover_Site, Indicator = "Fleshy_Macroalgae_Cover")

site_recruits <- benthic_recruits_rd %>%                                                               
  ungroup() %>%                                   
  group_by(Year, Site) %>%                                                                           
  summarize(Value = mean(All, na.rm = TRUE), .groups = "drop") %>%                                   
  mutate(Indicator = "Recruit_Density")                                                            

site_diversity <- coral_community_cd %>%                                     
  ungroup() %>%                                                                                    
  group_by(Year, Site) %>%                       
  summarize(Value = mean(Diversity, na.rm = TRUE), .groups = "drop") %>%                             
  mutate(Indicator = "Coral_Diversity_H") 

site_relief <- fish_relief %>%                                               
  ungroup() %>%                                                                                      
  mutate(Value = Relief_Site, Indicator = "Reef_Relief") %>%
  select(Year, Site, Value, Indicator)                                                               

site_indicators <- bind_rows(                                                                        
  site_coral_cover,                                                                                  
  site_macroalgae,                               
  site_recruits,                                                                                     
  site_diversity,                                                          
  site_relief                                                                                      
) %>%                                                  
  select(Year, Site, Indicator, Value) %>%                                                           
  arrange(Year, Site, Indicator)     

write.csv(site_indicators, "outputs/site_level_indicators.csv", row.names = FALSE)
message("  Exported ", nrow(site_indicators), " rows to outputs/site_level_indicators.csv")          
message("  Years: ", paste(unique(site_indicators$Year), collapse = ", "))                             
message("  Indicators: ", paste(unique(site_indicators$Indicator), collapse = ", "))
message("  Sites: ", n_distinct(site_indicators$Site))  

