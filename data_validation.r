# data_validation.r

# Source scripts ---------------------------
source("helper_scripts/packages_load.r")
source("helper_scripts/functions_define.r")
source("data_restructuring.r")

# Initialize validation messages vector ---------------------------
validation_msgs <- c()

# Define vectors of required columns ---------------------------
columns_benthic_sites <- c(
    "EA Period", "EAA Code", "Site ID", "Depth", "Latitude", "Longitude", "MPA", "Management",
    "Protection Status", "Reef Zone", "Reef Type", "Visibility (ft)", "Weather"
)
# add benthic cover
# add benthic quadrat
# add benthic invert
# add coral sites
# add coral cover
# add coral counts

# Validate Benthic Sites ---------------------------
# validation_msgs <- c(validation_msgs, check_completeness(df_benthic_sites, columns_benthic_sites))
# validation_msgs <- c(validation_msgs, check_grouping(df_benthic_sites$`Protection Status`, c("None", "NTZ", "CUZ", "GUZ", "PUZ"), "Protection Status"))
# validation_msgs <- c(validation_msgs, check_range(df_benthic_sites$`Visibility (ft)`, 1, 50, "Visibility", "int"))

# Validate Benthic Cover ---------------------------

# Validate Benthic Quadrats ---------------------------

# etc.

# Print validation messages to text file ---------------------------
writeLines(validation_msgs, "validation_report.txt")
