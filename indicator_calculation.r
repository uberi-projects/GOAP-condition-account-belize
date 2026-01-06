# indicator_calculation.r

# Set boolean for whether test data or AGRRA data should be used ---------------------------
test_on <- FALSE

# Source scripts ---------------------------
source("data_validation.r")

# Set vectors ---------------------------
coral_category <- ifelse(test_on == TRUE, "Coral", "Calcifiers :: Coral")
algae_category <- ifelse(test_on == TRUE, "Fleshy Macroalgae", "Algae :: Macro :: Fleshy")

# Prepare data ---------------------------
df_organisms_unique <- df_organisms %>% distinct(Code, Type)
benthic_cover_presence <- df_benthic_cover %>%
    left_join(df_organisms_unique %>% select(Code, Primary_Type = Type), by = c("Organism" = "Code")) %>%
    left_join(df_organisms_unique %>% select(Code, Secondary_Type = Type), by = c("Secondary" = "Code")) %>%
    mutate(
        Coral_Presence = Vectorize(calculate_type_presence)(Primary_Type, Secondary_Type, coral_category),
        Algae_Presence = Vectorize(calculate_type_presence)(Primary_Type, Secondary_Type, algae_category),
        Year = format(as.Date(Date), format = "%Y")
    )

# Calculate live coral cover ---------------------------
benthic_cover_presence_lcc <- benthic_cover_presence %>%
    group_by(Year, Site, Transect) %>%
    mutate(Coral_Cover_Tran = 100 * sum(Coral_Presence) / n()) %>%
    group_by(Year, Site) %>%
    mutate(Coral_Cover_Site = mean(Coral_Cover_Tran))
indicator_lcc <- benthic_cover_presence_lcc %>%
    group_by(Year) %>%
    summarize(
        `Min (Site)` = min(Coral_Cover_Site),
        `Av. (Site)` = mean(Coral_Cover_Site),
        `Median (Site)` = median(Coral_Cover_Site),
        `Max (Site)` = max(Coral_Cover_Site),
        `Min (Transect)` = min(Coral_Cover_Tran),
        `Av. (Transect)` = mean(Coral_Cover_Tran),
        `Median (Transect)` = median(Coral_Cover_Tran),
        `Max (Transect)` = max(Coral_Cover_Tran)
    ) %>%
    mutate(across(-Year, ~ round(.x, 2)))

# Calculate macroalgae cover ---------------------------
benthic_cover_presence_fma <- benthic_cover_presence %>%
    group_by(Year, Site, Transect) %>%
    mutate(Algae_Cover_Tran = 100 * sum(Algae_Presence) / n()) %>%
    group_by(Year, Site) %>%
    mutate(Algae_Cover_Site = mean(Algae_Cover_Tran))
indicator_fma <- benthic_cover_presence_fma %>%
    group_by(Year) %>%
    summarize(
        `Min (Site)` = min(Algae_Cover_Site),
        `Av. (Site)` = mean(Algae_Cover_Site),
        `Median (Site)` = median(Algae_Cover_Site),
        `Max (Site)` = max(Algae_Cover_Site),
        `Min (Transect)` = min(Algae_Cover_Tran),
        `Av. (Transect)` = mean(Algae_Cover_Tran),
        `Median (Transect)` = median(Algae_Cover_Tran),
        `Max (Transect)` = max(Algae_Cover_Tran)
    ) %>%
    mutate(across(-Year, ~ round(.x, 2)))

# Calculate recruit density ---------------------------
benthic_recruits_rd <- df_recruits %>%
    mutate(Year = format(as.Date(Date), format = "%Y")) %>%
    group_by(Year, Date, Site) %>%
    complete(Transect, Quadrat = 1:4, fill = list(Num = 0, Size = NA_character_)) %>%
    group_by(Year, Date, Site, Transect, Quadrat) %>%
    summarize(
        Recruits = sum(Num, na.rm = TRUE),
        `Small Recruits` = sum(Num[Size == "SR"], na.rm = TRUE),
        `Large Recruits` = sum(Num[Size == "LR"], na.rm = TRUE)
    ) %>%
    group_by(Year, Date, Site) %>%
    summarize( # calculate density per meter
        All = sum(Recruits) / 25,
        Small = sum(`Small Recruits`) / 25,
        Large = sum(`Large Recruits`) / 25
    )
indicator_rd <- benthic_recruits_rd %>%
    pivot_longer(cols = 4:6, names_to = "Size", values_to = "Value") %>%
    group_by(Year, Size) %>%
    summarize(
        Min = min(Value),
        `Av.` = mean(Value),
        Median = median(Value),
        Max = max(Value)
    )
mutate(across(-Year, ~ round(.x, 2)))

# Calculate live coral diversity ---------------------------


# Calculate rugosity ---------------------------
