# data_validation.r

# Source scripts ---------------------------
source("helper_scripts/packages_load.r")
source("helper_scripts/functions_define.r")
source("data_restructuring.r")

# Initialize validation messages vector ---------------------------
validation_msgs <- c()

# Define vectors of required columns ---------------------------
columns_sites <- c(
    "EAA Code", "Site ID", "Site Name", "Depth (ft)", "Latitude", "Longitude", "MPA", "Management",
    "Protection Status", "Reef Zone", "Reef Type"
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
