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
    "Point", "organism", "Secondary", "Algae_Height", "Collector"
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
    "End_Depth", "Organism", "Isolates", "Max_Length", "Max_Width", "Max_Height", "Percent_Pale", "Percent_Bleach",
    "OD", "Disease", "Clump_L", "Clump_P", "Clump_BL", "Clump_NM", "Clump_TM", "Clump_OM", "Clump_Other",
    "Clump_Interval", "Collector"
)
columns_relief <- c(
    "Date", "EA_Period", "Site", "Temp", "Visibility", "Weather", "Start_Depth", "End_Depth", "Max_Relief", "Collector"
)

# Validate  Sites ---------------------------

# Validate  Surveys ---------------------------

# Validate  Coral Community ---------------------------

# Validate  Benthic Cover ---------------------------

# Validate  Recruits ---------------------------

# Validate  Invertebrates ---------------------------

# Validate  Fish (Relief) ---------------------------

# Print validation messages to text file ---------------------------
writeLines(validation_msgs, "validation_report.txt")
