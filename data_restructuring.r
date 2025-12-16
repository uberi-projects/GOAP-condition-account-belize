# data_restructuring.r

# Source scripts ---------------------------
source("helper_scripts/packages_load.r")
source("helper_scripts/functions_define.r")

# Check whether AGRRA data is present in the data deposit ---------------------------
filepath_benthic <- file.path("data_deposit", "BenthicRaw.xlsx")
filepath_coral <- file.path("data_deposit", "CoralRaw.xlsx")
filepath_fish <- file.path("data_deposit", "FishRaw.xlsx")
filepath_metadata <- file.path("data_deposit", "Metadata.xlsx")
files <- c(filepath_benthic, filepath_coral, filepath_fish, filepath_metadata)
missing <- files[!file.exists(files)]
if (length(missing)) stop("Missing files: ", paste(missing, collapse = ", "), ". Please place AGRRA data in the data_deposit folder or switch to testing mode by setting test_on <- TRUE.")

# Read AGRRA data as exported from AGRRA platform ---------------------------
df_benthic_transects <- read_excel(filepath_benthic, sheet = 3, skip = 1)
df_benthic_cover_preliminary <- read_excel(filepath_benthic, sheet = 4, skip = 1)
df_quadrats <- read_excel(filepath_benthic, sheet = 5, skip = 1)
df_recruits_preliminary <- read_excel(filepath_benthic, sheet = 6, skip = 1)
df_coral_community_transects <- read_excel(filepath_coral, sheet = 3)
df_coral_community_preliminary <- read_excel(filepath_coral, sheet = 4, skip = 2)
df_coral_community_diseases <- read_excel(filepath_coral, sheet = 5)
df_coral_community_counts <- read_excel(filepath_coral, sheet = 6)
df_fish_preliminary <- read_excel(filepath_fish, sheet = 3, skip = 1)
df_organisms_preliminary <- read_excel(filepath_metadata, sheet = 6)
df_organisms_group <- read_excel(filepath_metadata, sheet = 5)
df_coralspp <- read_excel(filepath_metadata, sheet = 7)
df_transects <- read_excel(filepath_metadata, sheet = 4)
df_surveys <- read_excel(filepath_metadata, sheet = 3)

# Read files not included in AGRRA exports ---------------------------
df_substrate <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = "Ref_Substrate", na = "NA")
df_disease <- read_excel("data_dummy/Dummy_data_OA_Coral Data Template.xlsx", sheet = "Ref_Disease", na = "NA")

# Convert AGRRA formatted data to GOAP formatted data ---------------------------
df_sites <- df_surveys %>%
    mutate(
        EAA_Code = NA, Site = ifelse(!is.na(Code) & Code != "", Code, Name), Depth = NA, MPA_Management = NA,
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
        Site = ifelse(!is.na(Code) & Code != "", Code, Name.y), Time = format(Surveyed, format = "%H:%M"),
        Temp = `Water Temperature (°C)`, Visibility = NA, Weather = NA, Start_Depth = NA,
        End_Depth = NA, Point = `Point Index` / 10, Organism = Primary,
        Algae_Height = `Algal Height (cm)`, Collector = Surveyor, Notes = Comments.x
    ) %>%
    group_by(Survey.x) %>%
    mutate(Transect = match(Transect, unique(Transect))) %>%
    ungroup() %>%
    select(
        Date, EA_Period, Site, Time, Temp, Visibility, Weather, Start_Depth, End_Depth, Transect,
        Point, Organism, Secondary, Algae_Height, Collector, Notes
    )
df_recruits <- df_recruits_preliminary %>%
    left_join(df_benthic_transects %>% rename(Transect = ID), by = "Transect") %>%
    left_join(df_transects %>% rename(Transect = ID), by = "Transect") %>%
    left_join(df_surveys %>% rename(Survey.x = ID), by = "Survey.x") %>%
    left_join(df_quadrats, by = c("Transect", "Quadrat Index")) %>%
    left_join(df_coralspp %>% rename(Taxonomy = ID), by = "Taxonomy") %>%
    mutate(
        Date = format(Surveyed, format = "%Y-%m-%d"), EA_Period = NA, Site = ifelse(!is.na(Code) & Code != "", Code, Name.y),
        Temp = `Water Temperature (°C)`, Visibility = NA, Weather = NA, Quadrat = `Quadrat Index`,
        Primary_Substrate = Primary, Secondary_Substrate = Secondary, Organism = Taxonomy,
        LR = Large, SR = Small, Collector = Surveyor, Notes = Comments.x
    ) %>%
    pivot_longer(cols = c("SR", "LR"), names_to = "Size", values_to = "Num") %>%
    group_by(Survey.x) %>%
    mutate(Transect = match(Transect, unique(Transect))) %>%
    ungroup() %>%
    select(
        Date, EA_Period, Site, Temp, Visibility, Weather, Transect, Quadrat, Primary_Substrate,
        Secondary_Substrate, Organism, Size, Num, Collector, Notes
    )
df_invertebrates <- df_benthic_transects %>%
    rename(Transect = ID) %>%
    left_join(df_transects %>% rename(Transect = ID), by = "Transect") %>%
    left_join(df_surveys %>% rename(Survey.x = ID), by = "Survey.x") %>%
    mutate(
        Date = format(Surveyed, format = "%Y-%m-%d"), EA_Period = NA, Site = ifelse(!is.na(Code) & Code != "", Code, Name.y),
        Temp = `Water Temperature (°C)`, Visibility = NA, Weather = NA, Collector = Surveyor, Notes = Comments.x
    ) %>%
    pivot_longer(cols = c("Juvenile Diadema", "Adult Diadema", "Other Urchins", "Lobster", "Conch", "Sea Cucumber"), names_to = "Species", values_to = "Num") %>%
    group_by(Survey.x) %>%
    mutate(Transect = match(Transect, unique(Transect))) %>%
    ungroup() %>%
    select(Date, EA_Period, Site, Temp, Visibility, Weather, Transect, Species, Num, Collector, Notes)
df_organisms <- df_organisms_preliminary %>%
    left_join(df_coralspp, by = "ID") %>%
    left_join(df_organisms_group %>% rename(Category = ID), by = "Category") %>%
    mutate(Code = ID, `Scientific Name` = paste(Genus, Species), Type = Name) %>%
    select(Code, `Scientific Name`, Type)
df_coral_community <- df_coral_community_preliminary %>%
    left_join(df_coral_community_transects %>% rename(Transect = ID), by = "Transect") %>%
    left_join(df_transects %>% rename(Transect = ID), by = "Transect") %>%
    left_join(df_surveys %>% rename(Survey.x = ID), by = "Survey.x") %>%
    left_join(df_coralspp %>% rename(Taxonomy = ID), by = "Taxonomy") %>%
    mutate(
        Date = format(Surveyed, format = "%Y-%m-%d"), EA_Period = NA, Site = ifelse(!is.na(Code) & Code != "", Code, Name.y),
        Time = format(Surveyed, format = "%H:%M"), Area_Surveyed = `Length Surveyed (m)`, Temp = `Water Temperature (°C)`,
        Visibility = NA, Weather = NA, Start_Depth = NA, End_Depth = NA, Organism = Name, Max_Length = Length,
        Max_Width = Width, Max_Height = Height, Percent_Pale = Pale*100, Percent_Bleach = Bleached*100, OD = Old*100, TD = Transitional*100,
        RD = New*100, Clump_L = NA, Clump_P = NA, Clump_BL = NA, Clump_NM = NA, Clump_TM = NA, Clump_OM = NA, Clump_Other = NA,
        Clump_Interval = NA, Collector = Surveyor, Notes = Comments.x
    ) %>%
    left_join(df_coral_community_diseases, by = "Coral") %>%
    group_by(Survey.x) %>%
    mutate(Transect = Transect.x, Transect = match(Transect, unique(Transect))) %>%
    ungroup() %>%
    select(
        Date, EA_Period, Site, Time, Transect, Area_Surveyed, Temp, Visibility, Weather, Start_Depth, End_Depth, Organism, Isolates,
        Max_Length, Max_Width, Max_Height, Percent_Pale, Percent_Bleach, OD, TD, RD, Disease, Clump_L, Clump_P, Clump_BL, Clump_NM,
        Clump_TM, Clump_OM, Clump_Other, Clump_Interval, Collector, Notes
    )
df_fish <- df_fish_preliminary %>%
    mutate(Transect = ID) %>%
    left_join(df_transects %>% rename(Transect = ID), by = "Transect") %>%
    left_join(df_surveys %>% rename(Survey.x = ID), by = "Survey.x") %>%
    mutate(
        Date = format(Surveyed, format = "%Y-%m-%d"), EA_Period = NA, Site = ifelse(!is.na(Code) & Code != "", Code, Name.y),
        Temp = `Water Temperature (°C)`, Visibility = NA, Weather = NA, Start_Depth = NA, End_Depth = NA, Max_Relief = Maximum,
        Collector = Surveyor, Notes = Comments.x
    ) %>%
    group_by(Survey.x) %>%
    mutate(Transect = match(Transect, unique(Transect))) %>%
    ungroup() %>%
    select(Date, EA_Period, Site, Transect, Temp, Visibility, Weather, Start_Depth, End_Depth, Max_Relief, Collector, Notes)
