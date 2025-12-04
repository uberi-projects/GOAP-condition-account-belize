# data_validation.r

# Source scripts ---------------------------
source("helper_scripts/packages_load.r")
source("helper_scripts/functions_define.r")
source("data_restructuring.r")

# Initialize validation messages vector ---------------------------
validation_msgs <- c()

# Define vectors of required columns ---------------------------
columns_sites <- c(
    "Site", "Depth", "Latitude", "Longitude", "MPA_Management", "Management_Zone",
    "Protection_Status", "Reef_Zone", "Reef_Type"
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
