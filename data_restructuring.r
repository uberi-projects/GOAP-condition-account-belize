# data_restructuring.r

# Read AGRRA data as exported from AGRRA platform ---------------------------
filename_benthic <- "BenthicRaw.xlsx" # change this value if your filename is different
filepath_benthic <- file.path("data_deposit", filename_benthic)
df_input_benthic_transects <- read_excel(filepath_benthic, sheet = 3, skip = 1)
df_input_benthic_cover <- read_excel(filepath_benthic, sheet = 4, skip = 1)
df_input_benthic_quadrats <- read_excel(filepath_benthic, sheet = 5, skip = 1)
df_input_benthic_recruits <- read_excel(filepath_benthic, sheet = 6, skip = 1)

# Covert AGRRA formatted data to GOAP formatted data ---------------------------



# Prepare formatted data for data validation ---------------------------
