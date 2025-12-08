# data_validation.r

# Source scripts ---------------------------
source("helper_scripts/packages_load.r")
source("helper_scripts/functions_define.r")
source("data_restructuring.r")
source("helper_scripts/data_test_load.r")

# Initialize validation messages vector ---------------------------
validation_msgs <- c()

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
check_completeness(df_test_sites, columns_sites)
check_grouping(df_test_sites$EAA_Code, c("EAA1", "EAA2", "EAA3", "EAA4", "EAA5"))
check_grouping(df_test_sites$Site, c(
    "SPR01", "SPR02", "SPR03", "SPR04", "SPR05", "SPR06", "SPR07", "SPR08",
    "SPR09"
))
check_range(df_test_sites$Depth, 0, 65, type = c("numeric"))
check_range(df_test_sites$Latitude, 16.100000, 18.200000, type = c("numeric"))
check_range(df_test_sites$Longitutde, -87.450000, -88.700000, type = c("numeric"))
check_grouping(df_test_sites$MPA_Management, c(
    "None", "BCCMR", "HCMR", "CCMR", "TAMR", "GRMR", "SWCMR", "GSSCMR",
    "LBCMR", "SCMR", "PHMR", "HMCNM"
))
check_grouping(df_test_sites$Protection_Status, c("None", "PUZ", "GUZ", "CUZ", "NTZ"))
check_grouping(df_test_sites$Reef_Zone, c("BR", "SFr", "DFR"))
check_grouping(df_test_sites$`Reef Type`, c("Fringing", "Barrier", "Atoll", "Patch"))

# Validate  Surveys ---------------------------

# Validate  Coral Community ---------------------------

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
check_range(df_test_benthic_cover$Transect, 1, 6, c("numeric"))
check_range(df_test_benthic_cover$Point, 0, 9.9, c("numeric"))
check_grouping(df_test_benthic_cover$Organism, df_test_organisms$Code)
check_grouping(df_test_benthic_cover$Secondary, df_test_organisms$Code)

# Validate  Recruits ---------------------------

# Validate  Invertebrates ---------------------------

# Validate  Fish (Relief) ---------------------------

# Print validation messages to text file ---------------------------
writeLines(validation_msgs, "validation_report.txt")
