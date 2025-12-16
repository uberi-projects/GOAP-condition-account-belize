# indicator_calculation.r

# Set boolean for whether test data or AGRRA data should be used ---------------------------
test_on <- TRUE

# Source scripts ---------------------------
source("data_validation.r")

# Set vectors ---------------------------
coral_category <- ifelse(test_on == TRUE, "Coral", "Calcifiers :: Coral")

# Prepare data ---------------------------
df_organisms_unique <- df_organisms %>% distinct(Code, Type)
benthic_cover_presence <- df_benthic_cover %>%
    left_join(df_organisms_unique %>% select(Code, Primary_Type = Type), by = c("Organism" = "Code")) %>%
    left_join(df_organisms_unique %>% select(Code, Secondary_Type = Type), by = c("Secondary" = "Code")) %>%
    mutate(
        Coral_Presence = Vectorize(calculate_type_weight)(Primary_Type, Secondary_Type, coral_category),
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


# Calculate recruit density ---------------------------


# Calculate live coral diversity ---------------------------


# Calculate rugosity ---------------------------
