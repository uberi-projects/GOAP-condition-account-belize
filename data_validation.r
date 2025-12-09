# data_validation.r

# Source scripts ---------------------------
source("helper_scripts/packages_load.r")
source("helper_scripts/functions_define.r")
source("data_restructuring.r")
source("helper_scripts/data_test_load.r")

# Define vectors of required columns ---------------------------
columns_sites <- c(
    "EAA_Code", "Site", "Depth", "Latitude", "Longitude", "MPA_Management", "Management_Zone",
    "Protection_Status", "Reef_Zone", "Reef_Type"
)
columns_benthic_cover <- c(
    "Date", "EA_Period", "Site", "Temp", "Visibility", "Weather", "Start_Depth", "End_Depth", "Transect",
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
    "Date", "EA_Period", "Site", "Transect", "Area_Surveyed", "Temp", "Visibility", "Weather", "Start_Depth",
    "End_Depth", "Organism", "Isolates", "Max_Length", "Max_Width", "Max_Height", "Percent_Pale",
    "Percent_Bleach", "OD", "Disease", "Clump_L", "Clump_P", "Clump_BL", "Clump_NM", "Clump_TM", "Clump_OM",
    "Clump_Other", "Clump_Interval", "Collector"
)
columns_relief <- c(
    "Date", "EA_Period", "Site", "Temp", "Visibility", "Weather", "Start_Depth", "End_Depth", "Max_Relief",
    "Collector"
)

# Validate  Sites ---------------------------
checks_sites <- list(
    quote(check_completeness(df_test_sites, columns_sites)),
    quote(check_grouping(df_test_sites$EAA_Code, c("EAA1", "EAA2", "EAA3", "EAA4", "EAA5"))),
    quote(check_grouping(df_test_sites$Site, c("SPR01", "SPR02", "SPR03", "SPR04", "SPR05", "SPR06", "SPR07", "SPR08", "SPR09"))),
    quote(check_range(df_test_sites$Depth, 0, 65, type = "numeric")),
    quote(check_range(df_test_sites$Latitude, 16.1, 18.2, type = "numeric")),
    quote(check_range(df_test_sites$Longitude, -88.7, -87.45, type = "numeric")),
    quote(check_grouping(df_test_sites$MPA_Management, c("None", "BCCMR", "HCMR", "CCMR", "TAMR", "GRMR", "SWCMR", "GSSCMR", "LBCMR", "SCMR", "PHMR", "HMCNM"))),
    quote(check_grouping(df_test_sites$Protection_Status, c("None", "PUZ", "GUZ", "CUZ", "NTZ"))),
    quote(check_grouping(df_test_sites$Reef_Zone, c("BR", "SFR", "DFR"))),
    quote(check_grouping(df_test_sites$`Reef Type`, c("Fringing", "Barrier", "Atoll", "Patch")))
)
validation_msgs_sites <- sapply(checks_sites, eval)

# Validate  Surveys ---------------------------

# Validate  Coral Community ---------------------------
check_completeness(df_test_coral_community, columns_coral_community)
check_date(df_test_coral_community$Date)
check_grouping(df_test_coral_community$EA_Period, c("Opening", "Closing"))
check_grouping(df_test_coral_community$Site, c(
    "SPR01", "SPR02", "SPR03", "SPR04", "SPR05", "SPR06", "SPR07",
    "SPR08", "SPR09"
))
check_range(df_test_coral_community$Transect, 1, 6, c("int"))
check_range(df_test_coral_community$Area_Surveyed, 0, 10, c("int"))
check_range(df_test_coral_community$Temp, 70, 90, c("numeric"))
check_range(df_test_coral_community$Visibility, 1, 50, c("numeric"))
check_grouping(df_test_coral_community$Weather, c("Sunny", "Partly Cloudy", "Overcast", "Windy", "Rainy"))
check_range(df_test_coral_community$Start_Depth, 0, 65, c("numeric"))
check_range(df_test_coral_community$End_Depth, 0, 65, c("numeric"))
check_grouping(df_test_coral_community$Organism, df_test_coralspp$Code)
check_range(df_test_coral_community$Isolates, 0, 30, c("int"))
check_range(df_test_coral_community$Max_Length, 4, 200, c("int"))
check_range(df_test_coral_community$Max_Width, 4, 200, c("int"))
check_range(df_test_coral_community$Max_Height, 4, 200, c("int"))
check_range(df_test_coral_community$Percent_Pale, 0, 100, c("int"))
check_range(df_test_coral_community$Percent_Bleach, 0, 100, c("int"))
check_range(df_test_coral_community$OD, 0, 100, c("int"))
check_grouping(df_test_coral_community$Disease, df_test_disease$Code)
check_range(df_test_coral_community$Clump_L, 0, 30, c("int"))
check_range(df_test_coral_community$Clump_P, 0, 30, c("int"))
check_range(df_test_coral_community$Clump_BL, 0, 30, c("int"))
check_range(df_test_coral_community$Clump_NM, 0, 30, c("int"))
check_range(df_test_coral_community$Clump_TM, 0, 30, c("int"))
check_range(df_test_coral_community$Clump_OM, 0, 30, c("int"))
check_range(df_test_coral_community$Clump_Other, 0, 30, c("int"))
check_range(df_test_coral_community$Clump_Interval, 0, 30, c("int"))

# Validate  Benthic Cover ---------------------------
check_completeness(df_test_benthic_cover, columns_benthic_cover)
check_date(df_test_benthic_cover$Date)
check_grouping(df_test_benthic_cover$EA_Period, c("Opening", "Closing"))
check_grouping(df_test_benthic_cover$Site, c(
    "SPR01", "SPR02", "SPR03", "SPR04", "SPR05", "SPR06", "SPR07",
    "SPR08", "SPR09"
))
check_range(df_test_benthic_cover$Temp, 70, 90, c("numeric"))
check_range(df_test_benthic_cover$Visibility, 1, 50, c("numeric"))
check_grouping(df_test_benthic_cover$Weather, c("Sunny", "Partly Cloudy", "Overcast", "Windy", "Rainy"))
check_range(df_test_benthic_cover$Start_Depth, 0, 65, c("numeric"))
check_range(df_test_benthic_cover$End_Depth, 0, 65, c("numeric"))
check_range(df_test_benthic_cover$Transect, 1, 6, c("int"))
check_range(df_test_benthic_cover$Point, 0, 9.9, c("numeric"))
check_grouping(df_test_benthic_cover$Organism, df_test_organisms$Code)
check_grouping(df_test_benthic_cover$Secondary, df_test_organisms$Code)

# Validate  Recruits ---------------------------
check_completeness(df_test_recruits, columns_recruits)
check_date(df_test_recruits$Date)
check_grouping(df_test_recruits$EA_Period, c("Opening", "Closing"))
check_grouping(df_test_recruits$Site, c(
    "SPR01", "SPR02", "SPR03", "SPR04", "SPR05", "SPR06", "SPR07",
    "SPR08", "SPR09"
))
check_range(df_test_recruits$Temp, 70, 90, c("numeric"))
check_range(df_test_recruits$Visibility, 1, 50, c("numeric"))
check_grouping(df_test_recruits$Weather, c("Sunny", "Partly Cloudy", "Overcast", "Windy", "Rainy"))
check_range(df_test_recruits$Start_Depth, 0, 65, c("numeric"))
check_range(df_test_recruits$End_Depth, 0, 65, c("numeric"))
check_range(df_test_recruits$Transect, 1, 6, c("int"))
check_range(df_test_recruits$Quadrat, 1, 5, c("int"))
check_grouping(df_test_recruits$Primary_Substrate, df_test_substrate$Code)
check_grouping(df_test_recruits$Secondary_Substrate, df_test_substrate$Code)
check_grouping(df_test_recruits$Organism, df_test_organisms$Code)
check_grouping(df_test_recruits$Size, c("SR", "LR"))
check_range(df_test_recruits$Num, 0, 30, c("int"))

# Validate  Invertebrates ---------------------------
check_completeness(df_test_invertebrates, columns_recruits)
check_date(df_test_invertebrates$Date)
check_grouping(df_test_invertebrates$EA_Period, c("Opening", "Closing"))
check_grouping(df_test_invertebrates$Site, c(
    "SPR01", "SPR02", "SPR03", "SPR04", "SPR05", "SPR06", "SPR07",
    "SPR08", "SPR09"
))
check_range(df_test_invertebrates$Temp, 70, 90, c("numeric"))
check_range(df_test_invertebrates$Visibility, 1, 50, c("numeric"))
check_grouping(df_test_invertebrates$Weather, c("Sunny", "Partly Cloudy", "Overcast", "Windy", "Rainy"))
check_range(df_test_invertebrates$Start_Depth, 0, 65, c("numeric"))
check_range(df_test_invertebrates$End_Depth, 0, 65, c("numeric"))
check_range(df_test_invertebrates$Transect, 1, 6, c("int"))
check_grouping(df_test_invertebrates$Species, c(
    "Conch", "Lobster", "Adult Diadema",
    "Juvenille Diadema", "Sea Cucumber", "Other Urchins"
))
check_range(df_test_invertebrates$Num, 0, 99, c("int"))

# Validate  Fish (Relief) ---------------------------

# Print validation messages to text file ---------------------------
writeLines(validation_msgs, "validation_report.txt")
