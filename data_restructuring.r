# data_restructuring.r

# Source scripts ---------------------------
source("helper_scripts/packages_load.r")
source("helper_scripts/functions_define.r")
source("helper_scripts/data_test_load.r")

# Read AGRRA data as exported from AGRRA platform ---------------------------
filepath_benthic <- file.path("data_deposit", "BenthicRaw.xlsx")
filepath_coral <- file.path("data_deposit", "CoralRaw.xlsx")
filepath_fish <- file.path("data_deposit", "FishRaw.xlsx")
filepath_metadata <- file.path("data_deposit", "Metadata.xlsx")
df_benthic_transects <- read_excel(filepath_benthic, sheet = 3, skip = 1)
df_benthic_cover_preliminary <- read_excel(filepath_benthic, sheet = 4, skip = 1)
df_quadrats <- read_excel(filepath_benthic, sheet = 5, skip = 1)
df_recruits_preliminary <- read_excel(filepath_benthic, sheet = 6, skip = 1)
df_coral_community_transects <- read_excel(filepath_coral, sheet = 3)
df_coral_community <- read_excel(filepath_coral, sheet = 4, skip = 3)
df_coral_community_diseases <- read_excel(filepath_coral, sheet = 5)
df_coral_community_counts <- read_excel(filepath_coral, sheet = 6)
df_fish <- read_excel(filepath_fish, sheet = 3, skip = 1)
df_organisms_preliminary <- read_excel(filepath_metadata, sheet = 6)
df_organisms_group <- read_excel(filepath_metadata, sheet = 5)
df_coralspp <- read_excel(filepath_metadata, sheet = 7)
df_transects <- read_excel(filepath_metadata, sheet = 4)
df_surveys <- read_excel(filepath_metadata, sheet = 3)

# Covert AGRRA formatted data to GOAP formatted data ---------------------------
df_sites <- df_surveys %>%
    mutate(
        EAA_Code = NA, Site = paste(Code, Name), Depth = NA, MPA_Management = NA,
        Management_Zone = NA, Reef_Zone = NA, Reef_Type = `Reef Zone`, Notes = Comments
    ) %>%
    select(
        EAA_Code, Site, Depth, Latitude, Longitude, MPA_Management, Management_Zone,
        Reef_Zone, Reef_Type, Notes
    )
df_benthic_cover <- df_benthic_cover_preliminary %>%
    left_join(df_benthic_transects %>% rename(Transect = ID), by = "Transect") %>%
    left_join(df_transects %>% rename(Transect = ID), by = "Transect") %>%
    left_join(df_surveys %>% rename(Survey.x = ID), by = "Survey.x") %>%
    mutate(
        EA_Period = NA, Date = format(Surveyed, format = "%Y-%m-%d"), Organism = Primary,
        Site = paste(Code, Name.y), Time = format(Surveyed, format = "%H:%M"),
        Temp = `Water Temperature (°C)`, Visibility = NA, Weather = NA, Start_Depth = NA,
        End_Depth = NA, Point = `Point Index`, Organism = Primary,
        Algae_Height = `Algal Height (cm)`, Collector = Surveyor, Notes = Comments.x
    ) %>%
    select(
        Date, EA_Period, Site, Time, Temp, Visibility, Weather, Start_Depth, End_Depth, Transect,
        Point, Organism, Secondary, Algae_Height, Collector, Notes
    )
df_recruits <- df_recruits_preliminary %>%
    left_join(df_benthic_transects %>% rename(Transect = ID), by = "Transect") %>%
    left_join(df_transects %>% rename(Transect = ID), by = "Transect") %>%
    left_join(df_surveys %>% rename(Survey.x = ID), by = "Survey.x") %>%
    left_join(df_quadrats, by = c("Transect", "Quadrat Index")) %>%
    left_join(df_organisms_preliminary %>% rename(Taxonomy = ID), by = "Taxonomy") %>%
    mutate(
        Date = format(Surveyed, format = "%Y-%m-%d"), EA_Period = NA, Site = paste(Code, Name.y),
        Temp = `Water Temperature (°C)`, Visibility = NA, Weather = NA, Quadrat = `Quadrat Index`,
        Primary_Substrate = Primary, Secondary_Substrate = Secondary, Organism = Name,
        LR = Large, SR = Small, Collector = Surveyor, Notes = Comments.x
    ) %>%
    pivot_longer(cols = c("SR", "LR"), names_to = "Size", values_to = "Num") %>%
    select(
        Date, EA_Period, Site, Temp, Visibility, Weather, Transect, Quadrat, Primary_Substrate,
        Secondary_Substrate, Organism, Size, Num, Collector, Notes
    )
df_organisms <- df_organisms_preliminary %>%
    left_join(df_coralspp, by = "ID") %>%
    left_join(df_organisms_group %>% rename(Category = ID), by = "Category") %>%
    mutate(Code = ID, `Scientific Name` = paste(Genus, Species), Type = Name) %>%
    select(Code, `Scientific Name`, Type)
