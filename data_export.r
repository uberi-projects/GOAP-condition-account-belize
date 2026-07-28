# data_export.r

# Source scripts
source("packages_load.r")

# Set boolean for wether test data should be exported
export_test_data <- FALSE

# Source code for wether test or restructured data should be used ---------------------------
if (export_test_data == TRUE) {
    source("data_test_load.r")
} else {
    source("helper_scripts/data_restructuring.r")
}

# Check wether AGRRA data os present in the data deposit
filepath_benthic <- file.path("data_deposit", "BenthicRaw.xlsx")
filepath_coral <- file.path("data_deposit", "CoralRaw.xlsx")
filepath_fish <- file.path("data_deposit", "FishRaw.xlsx")
filepath_metadata <- file.path("data_deposit", "Metadata.xlsx")
files <- c(filepath_benthic, filepath_coral, filepath_fish, filepath_metadata)
missing <- files[!file.exists(files)]
if (length(missing)) stop("Missing files: ", paste(missing, collapse = ", "), ". Please place AGRRA data in the data_deposit folder or switch to testing mode by setting test_on <- TRUE.")

# Remove organism ID codes and rplacoing them with organism names in required dataframes
df_benthic_export <- df_benthic_cover %>% 
    left_join(df_organisms_preliminary %>% select(ID, Name), by = c("Organism" = "ID")) %>% 
    mutate(Organism = Name) %>% select(-Name)

df_recruits_export <- df_recruits %>% 
    left_join(df_coralspp %>% select(ID, Name), by = c("Organism" = "ID")) %>% 
    mutate(Organism = Name) %>% select(-Name)

df_coral_export <- df_coral_community %>% 
    left_join(df_coralspp %>% select(ID, Name), by = c("Organism" = "ID")) %>% 
    mutate(Organism = Name) %>% select(-Name)

# Adding in required sheets to each excel export
OA_Benthic_Data <- list( 
    "Read Me!!!" = df_read_me, "Substrate" = df_substrate, "Organism" = df_organisms,
    "Validation Rules" = df_validation_benthic, "Sites" = df_sites, "Benthic Cover" = df_benthic_export,
    "Recruits" = df_recruits_export, "Invertebrates" = df_invertebrates
    )
OA_Coral_Data <- list(
    "Read Me!!!" = df_read_me, "Ref_Disease" = df_disease, "Ref_Formations" = df_formations,
    "Ref_Coral" = df_coralspp, "Validation Rules" = df_validation_coral, "Sites" = df_sites,
    "Coral Community" = df_coral_export
    )
OA_Relief_Data <- list(
    "Read Me!!!" = df_read_me, "Validation Rules" = df_validation_relief, "Sites" = df_sites,
    "Relief" = df_fish
    )

# Listing export files and file path
data_exports <- list(
    "OA_Benthic_Data" = OA_Benthic_Data, "OA_Coral_Data" = OA_Coral_Data, "OA_Relief_Data" = OA_Relief_Data
    )
if (!dir.exists("exports")) {
    dir.create("exports")
} 
for (file_name in names(data_exports)) {
    writexl::write_xlsx(data_exports[[file_name]], 
    path = paste0("exports/" ,file_name, ".xlsx"))
}
