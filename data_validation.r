# data_validation.r

# Source scripts ---------------------------
source("helper_scripts/packages_load.r")
source("helper_scripts/functions_define.r")
source("data_restructuring.r")

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
# check_completeness(df_benthic_sites, columns_benthic_sites, "Benthic Sites")
# e.g., grouping type: check_grouping(df_benthic_sites$`Protection Status`, c("None", "NTZ", "CUZ", "GUZ", "PUZ"), "Protection Status")
# e.g., range type: check_range(df_benthic_sites$`Visibility (ft)`, 1, 50, "Visibility", "int")

# Validate Benthic Cover ---------------------------

# Validate Benthic Quadrats ---------------------------

# etc.
