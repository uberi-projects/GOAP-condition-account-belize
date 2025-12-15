# indicator_calculation.r

# Source scripts ---------------------------
source("data_validation.r")

# Define required indicators ---------------------------
indicator_lcc_include <- TRUE # live coral cover
indicator_mac_include <- TRUE # macroalgae cover
indicator_red_include <- TRUE # recruit density
indicator_lcd_include <- TRUE # live coral diversity
indicator_rug_include <- TRUE # rugosity

# Prepare data ---------------------------
df_organisms_unique <- df_organisms %>% distinct(Code, Type)
benthic_cover_presence <- df_benthic_cover %>%
    left_join(df_organisms_unique %>% select(Code, Primary_Type = Type), by = c("Organism" = "Code")) %>%
    left_join(df_organisms_unique %>% select(Code, Secondary_Type = Type), by = c("Secondary" = "Code")) %>%
    mutate(
        Coral_Presence = Vectorize(calculate_type_weight)(Primary_Type, Secondary_Type, "Coral")
    )

# Calculate live coral cover ---------------------------


# Calculate macroalgae cover ---------------------------


# Calculate recruit density ---------------------------


# Calculate live coral diversity ---------------------------


# Calculate rugosity ---------------------------
