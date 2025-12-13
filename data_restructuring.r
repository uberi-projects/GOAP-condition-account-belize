# data_restructuring.r

# Read AGRRA data as exported from AGRRA platform ---------------------------
filepath_benthic <- file.path("data_deposit", "BenthicRaw.xlsx")
filepath_coral <- file.path("data_deposit", "CoralRaw.xlsx")
filepath_fish <- file.path("data_deposit", "FishRaw.xlsx")
filepath_metadata <- file.path("data_deposit", "Metadata.xlsx")
df_benthic_transects <- read_excel(filepath_benthic, sheet = 3, skip = 1)
df_benthic_cover <- read_excel(filepath_benthic, sheet = 4, skip = 1)
df_invertebrates <- read_excel(filepath_benthic, sheet = 5, skip = 1)
df_recruits <- read_excel(filepath_benthic, sheet = 6, skip = 1)
df_coral_community_transects <- read_excel(filepath_coral, sheet = 3)
df_coral_community <- read_excel(filepath_coral, sheet = 4, skip = 3)
df_coral_community_diseases <- read_excel(filepath_coral, sheet = 5)
df_coral_community_counts <- read_excel(filepath_coral, sheet = 6)
df_fish <- read_excel(filepath_fish, sheet = 3, skip = 1)
df_sites <- read_excel(filepath_metadata, sheet = 3)
df_organisms <- read_excel(filepath_metadata, sheet = 6)
df_organisms_group <- read_excel(filepath_metadata, sheet = 5)
df_coralspp <- read_excel(filepath_metadata, sheet = 7)
# df_substrate - not present in AGRRA export
# df_disease - not present in AGRRA export

# Covert AGRRA formatted data to GOAP formatted data ---------------------------



# Prepare formatted data for data validation ---------------------------
