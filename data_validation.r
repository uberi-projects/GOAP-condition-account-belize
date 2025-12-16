# data_validation.r

# Set boolean for whether test data or AGRRA data should be used ---------------------------
test_on <- FALSE

# Source code based on whether real data is being used or not ---------------------------
if (test_on == FALSE) {
    source("data_restructuring.r")
} else {
    source("helper_scripts/data_test_load.r")
}

# Define vectors of required columns ---------------------------
columns_sites <- c(
    "EAA_Code", "Site", "Depth", "Latitude", "Longitude", "MPA_Management", "Management_Zone",
    "Protection_Status", "Reef_Zone", "Reef_Type"
)
columns_benthic_cover <- c(
    "Date", "EA_Period", "Site", "Time", "Temp", "Visibility", "Weather", "Start_Depth", "End_Depth", "Transect",
    "Point", "Organism", "Secondary", "Algae_Height", "Collector"
)
columns_recruits <- c(
    "Date", "EA_Period", "Site", "Temp", "Visibility", "Weather", "Transect", "Quadrat", "Primary_Substrate",
    "Secondary_Substrate", "Organism", "Size", "Num", "Collector"
)
columns_invertebrates <- c(
    "Date", "EA_Period", "Site", "Temp", "Visibility", "Weather", "Transect", "Species", "Num", "Collector"
)
columns_coral_community <- c(
    "Date", "EA_Period", "Site", "Time", "Transect", "Area_Surveyed", "Temp", "Visibility", "Weather", "Start_Depth",
    "End_Depth", "Organism", "Isolates", "Max_Length", "Max_Width", "Max_Height", "Percent_Pale",
    "Percent_Bleach", "OD", "Disease", "Clump_L", "Clump_P", "Clump_BL", "Clump_NM", "Clump_TM", "Clump_OM",
    "Clump_Other", "Clump_Interval", "Collector"
)
columns_relief <- c(
    "Date", "EA_Period", "Site", "Temp", "Visibility", "Weather", "Start_Depth", "End_Depth", "Max_Relief",
    "Collector"
)

# Define allowable values for columns ---------------------------
values_site_codes <- paste0("SPR", sprintf("%02d", 1:9))
values_mpa_names <- c("None", "BCMR", "HCMR", "CCMR", "TAMR", "GRMR", "SWCMR", "GSSCMR", "LBCMR", "SCMR", "PHMR", "HMCNM")

# Validate  Sites ---------------------------
checks_sites <- list(
    quote(check_completeness(df_sites, columns_sites)),
    quote(check_grouping(df_sites$EAA_Code, c("EAA1", "EAA2", "EAA3", "EAA4", "EAA5"))),
    quote(check_grouping(df_sites$Site, values_site_codes)),
    quote(check_range(df_sites$Depth, 0, 65, type = "numeric")),
    quote(check_range(df_sites$Latitude, 16.1, 18.2, type = "numeric")),
    quote(check_range(df_sites$Longitude, -88.7, -87.45, type = "numeric")),
    quote(check_grouping(df_sites$MPA_Management, values_mpa_names)),
    quote(check_grouping(df_sites$Management_Zone, c("None", "PUZ", "GUZ", "CUZ", "NTZ"))),
    quote(check_grouping(df_sites$Reef_Zone, c("BR", "SFR", "DFR"))),
    quote(check_grouping(df_sites$Reef_Type, c("Fringing", "Barrier", "Atoll", "Patch")))
)
validation_msgs_sites <- sapply(checks_sites, eval)

# Validate  Surveys ---------------------------

# Validate  Coral Community ---------------------------
check_coral_community <- list(
    quote(check_completeness(df_coral_community, columns_coral_community)),
    quote(check_date(df_coral_community$Date)),
    quote(check_grouping(df_coral_community$EA_Period, c("Opening", "Closing"))),
    quote(check_grouping(df_coral_community$Site, values_site_codes)),
    quote(check_time(df_coral_community$Time, earliest_time = "06:00", latest_time = "18:00")),
    quote(check_range(df_coral_community$Transect, 1, 6, c("int"))),
    quote(check_range(df_coral_community$Area_Surveyed, 0, 10, c("int"))),
    quote(check_range(df_coral_community$Temp, 70, 90, c("numeric"))),
    quote(check_range(df_coral_community$Visibility, 1, 50, c("numeric"))),
    quote(check_grouping(df_coral_community$Weather, c("Sunny", "Partly Cloudy", "Overcast", "Windy", "Rainy"))),
    quote(check_range(df_coral_community$Start_Depth, 0, 65, c("numeric"))),
    quote(check_range(df_coral_community$End_Depth, 0, 65, c("numeric"))),
    quote(check_grouping(df_coral_community$Organism, df_coralspp$Code)),
    quote(check_range(df_coral_community$Isolates, 0, 30, c("int"))),
    quote(check_range(df_coral_community$Max_Length, 4, 200, c("int"))),
    quote(check_range(df_coral_community$Max_Width, 4, 200, c("int"))),
    quote(check_range(df_coral_community$Max_Height, 4, 200, c("int"))),
    quote(check_range(df_coral_community$Percent_Pale, 0, 100, c("int"))),
    quote(check_range(df_coral_community$Percent_Bleach, 0, 100, c("int"))),
    quote(check_range(df_coral_community$OD, 0, 100, c("int"))),
    quote(check_grouping(df_coral_community$Disease, df_disease$Code)),
    quote(check_range(df_coral_community$Clump_L, 0, 30, c("int"))),
    quote(check_range(df_coral_community$Clump_P, 0, 30, c("int"))),
    quote(check_range(df_coral_community$Clump_BL, 0, 30, c("int"))),
    quote(check_range(df_coral_community$Clump_NM, 0, 30, c("int"))),
    quote(check_range(df_coral_community$Clump_TM, 0, 30, c("int"))),
    quote(check_range(df_coral_community$Clump_OM, 0, 30, c("int"))),
    quote(check_range(df_coral_community$Clump_Other, 0, 30, c("int"))),
    quote(check_range(df_coral_community$Clump_Interval, 0, 30, c("int")))
)
validation_msgs_coral <- sapply(check_coral_community, eval)

# Validate  Benthic Cover ---------------------------
check_benthic_cover <- list(
    quote(check_completeness(df_benthic_cover, columns_benthic_cover)),
    quote(check_date(df_benthic_cover$Date)),
    quote(check_grouping(df_benthic_cover$EA_Period, c("Opening", "Closing"))),
    quote(check_grouping(df_benthic_cover$Site, values_site_codes)),
    quote(check_time(df_benthic_cover$Time, earliest_time = "06:00", latest_time = "18:00")),
    quote(check_range(df_benthic_cover$Temp, 70, 90, c("numeric"))),
    quote(check_range(df_benthic_cover$Visibility, 1, 50, c("numeric"))),
    quote(check_grouping(df_benthic_cover$Weather, c("Sunny", "Partly Cloudy", "Overcast", "Windy", "Rainy"))),
    quote(check_range(df_benthic_cover$Start_Depth, 0, 65, c("numeric"))),
    quote(check_range(df_benthic_cover$End_Depth, 0, 65, c("numeric"))),
    quote(check_range(df_benthic_cover$Transect, 1, 6, c("int"))),
    quote(check_range(df_benthic_cover$Point, 0, 9.9, c("numeric"))),
    quote(check_grouping(df_benthic_cover$Organism, df_organisms$Code)),
    quote(check_grouping(df_benthic_cover$Secondary, df_organisms$Code))
)
validation_msgs_benthic <- sapply(check_benthic_cover, eval)

# Validate  Recruits ---------------------------
check_recruits <- list(
    quote(check_completeness(df_recruits, columns_recruits)),
    quote(check_date(df_recruits$Date)),
    quote(check_grouping(df_recruits$EA_Period, c("Opening", "Closing"))),
    quote(check_grouping(df_recruits$Site, values_site_codes)),
    quote(check_range(df_recruits$Temp, 70, 90, c("numeric"))),
    quote(check_range(df_recruits$Visibility, 1, 50, c("numeric"))),
    quote(check_grouping(df_recruits$Weather, c("Sunny", "Partly Cloudy", "Overcast", "Windy", "Rainy"))),
    quote(check_range(df_recruits$Start_Depth, 0, 65, c("numeric"))),
    quote(check_range(df_recruits$End_Depth, 0, 65, c("numeric"))),
    quote(check_range(df_recruits$Transect, 1, 6, c("int"))),
    quote(check_range(df_recruits$Quadrat, 1, 5, c("int"))),
    quote(check_grouping(df_recruits$Primary_Substrate, df_substrate$Code)),
    quote(check_grouping(df_recruits$Secondary_Substrate, df_substrate$Code)),
    quote(check_grouping(df_recruits$Organism, df_coralspp$ID)),
    quote(check_grouping(df_recruits$Size, c("SR", "LR"))),
    quote(check_range(df_recruits$Num, 0, 30, c("int")))
)
validation_msgs_recruits <- sapply(check_recruits, eval)

# Validate  Invertebrates ---------------------------
check_invertebrates <- list(
    quote(check_completeness(df_invertebrates, columns_invertebrates)),
    quote(check_date(df_invertebrates$Date)),
    quote(check_grouping(df_invertebrates$EA_Period, c("Opening", "Closing"))),
    quote(check_grouping(df_invertebrates$Site, values_site_codes)),
    quote(check_range(df_invertebrates$Temp, 70, 90, c("numeric"))),
    quote(check_range(df_invertebrates$Visibility, 1, 50, c("numeric"))),
    quote(check_grouping(df_invertebrates$Weather, c("Sunny", "Partly Cloudy", "Overcast", "Windy", "Rainy"))),
    quote(check_range(df_invertebrates$Start_Depth, 0, 65, c("numeric"))),
    quote(check_range(df_invertebrates$End_Depth, 0, 65, c("numeric"))),
    quote(check_range(df_invertebrates$Transect, 1, 6, c("int"))),
    quote(check_grouping(df_invertebrates$Species, c(
        "Conch", "Lobster", "Adult Diadema",
        "Juvenille Diadema", "Sea Cucumber", "Other Urchins"
    ))),
    quote(check_range(df_invertebrates$Num, 0, 99, c("int")))
)
validation_msgs_invertebrates <- sapply(check_invertebrates, eval)

# Validate  Fish (Relief) ---------------------------
check_relief <- list(
    quote(check_completeness(df_fish, columns_relief)),
    quote(check_date(df_fish$Date)),
    quote(check_grouping(df_fish$EA_Period, c("Opening", "Closing"))),
    quote(check_grouping(df_fish$Site, values_site_codes)),
    quote(check_range(df_fish$Transect, 1, 10, c("int"))),
    quote(check_range(df_fish$Temp, 70, 90, c("numeric"))),
    quote(check_range(df_fish$Visibility, 1, 50, c("numeric"))),
    quote(check_grouping(df_fish$Weather, c("Sunny", "Partly Cloudy", "Overcast", "Windy", "Rainy"))),
    quote(check_range(df_fish$Start_Depth, 0, 65, c("numeric"))),
    quote(check_range(df_fish$End_Depth, 0, 65, c("numeric"))),
    quote(check_range(df_fish$End_Depth, 0, 65, c("numeric"))),
    quote(check_range(df_fish$Max_Relief, 0, 99, c("int")))
)
validation_msgs_fish <- sapply(check_relief, eval)

# Print validation messages to text file ---------------------------
validation_msgs_sections <- list(
    "Sites" = validation_msgs_sites,
    "Coral Community" = validation_msgs_coral,
    "Benthic Cover" = validation_msgs_benthic,
    "Recruits" = validation_msgs_recruits,
    "Invertebrates" = validation_msgs_invertebrates,
    "Fish (Relief)" = validation_msgs_fish
)
if (test_on == TRUE) {
    validation_msgs <- c("==== Validation Report (Test Data) ====", "")
} else {
    validation_msgs <- c("==== Validation Report ====", "")
}
for (section_name in names(validation_msgs_sections)) {
    validation_msgs <- c(
        validation_msgs,
        paste0("==== ", section_name, " Validation ===="),
        validation_msgs_sections[[section_name]], ""
    )
}
writeLines(validation_msgs, "outputs/validation_report.txt")
