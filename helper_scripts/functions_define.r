# functions_define.r

# Initialize functions list ---------------------------
list_functions <- list()

# Check a dataframe for presence of required columns ---------------------------
#- df : The dataframe to check
#- required_columns : The vector of required columns
check_completeness <- function(df, required_columns) {
    df_name <- deparse(substitute(df))
    missing_cols <- setdiff(required_columns, colnames(df))
    if (length(missing_cols) == 0) {
        return(paste0("Completeness is validated for ", df_name))
    } else {
        return(paste0("Missing required columns from ", df_name, ": ", paste(missing_cols, collapse = ", ")))
    }
}
list_functions$check_completeness <- check_completeness

# Check a column/vector for levels in a column/vector ---------------------------
#- grouping_col : The column or vector to check
#- grouping_vector : The column or vector of allowable values
check_grouping <- function(grouping_col, grouping_vector) {
    col_name <- deparse(substitute(grouping_col))
    na_count <- sum(is.na(grouping_col))
    valid <- is.na(grouping_col) | grouping_col %in% grouping_vector
    invalid <- unique(grouping_col[!valid & !is.na(grouping_col)])
    if (all(valid, na.rm = TRUE)) {
        return(paste0(col_name, " is validated. ", sprintf("Number of NAs: %d.", na_count)))
    } else {
        return(paste0(
            col_name, " values are expected to be ", combine_words(grouping_vector), ". ",
            paste0("These values are invalid: ", combine_words(invalid)),
            sprintf(" (unexpected values occurred %d times). ", sum(!valid & !is.na(grouping_col))),
            sprintf("Number of NAs: %d.", na_count)
        ))
    }
}
list_functions$check_grouping <- check_grouping

# Check a column/vector for values in a range ---------------------------
#- range_col : The column or vector to check
#- range_lower : Lower bound of the range (a number)
#- range_upper : Upper bound of the range (a number)
#- type : Either "int" for integer ranges or "numeric" for continuous ranges
check_range <- function(range_col, range_lower, range_upper, type = c("numeric", "int")) {
    col_name <- deparse(substitute(range_col))
    type <- match.arg(type)
    num_col <- as.numeric(range_col)
    na_count <- sum(is.na(num_col))
    if (type == "int") {
        valid <- num_col %in% seq.int(range_lower, range_upper)
    } else if (type == "numeric") {
        valid <- num_col <= range_upper & num_col >= range_lower
    }
    invalid <- unique(num_col[!valid & !is.na(num_col)])
    if (all(valid, na.rm = TRUE)) {
        return(paste0(col_name, " is validated. ", sprintf("Number of NAs: %d.", na_count)))
    } else {
        return(paste0(
            col_name, " values are expected to be of type ", type, " within ", range_lower, "-", range_upper, ". ",
            paste0("These values are invalid: ", combine_words(invalid)),
            sprintf(" (unexpected values occurred %d times). ", sum(!valid & !is.na(num_col))),
            sprintf("Number of NAs: %d.", na_count)
        ))
    }
}
list_functions$check_range <- check_range

# Check a column/vector for dates formatted to YYYY-MM-DD ---------------------------
#- date_col : The column or vector to check
check_date <- function(date_col) {
    col_name <- deparse(substitute(date_col))
    na_count <- sum(is.na(date_col))
    valid <- is.na(date_col) | (grepl("^\\d{4}-\\d{2}-\\d{2}$", date_col) & !is.na(as.Date(date_col, format = "%Y-%m-%d")))
    invalid <- unique(date_col[!valid & !is.na(date_col)])
    if (all(valid, na.rm = TRUE)) {
        return(paste0(col_name, " is validated. ", sprintf("Number of NAs: %d.", na_count)))
    } else {
        return(paste0(
            col_name, " values are expected to be in formatted YYYY-MM-DD. ",
            paste0("These values are invalid: ", combine_words(invalid)),
            sprintf(" (unexpected values occurred %d times). ", sum(!valid & !is.na(date_col))),
            sprintf("Number of NAs: %d.", na_count)
        ))
    }
}
list_functions$check_date <- check_date

# Check a column/vector for times formatted to 24-hr HH:MM and fall within specified time range ---------------------------
#- time_col : The column or vector to check
#- earliest_time : A string of the earliest 24hr HH:MM time allowable
#- latest_time : A string of the latest 24hr HH:MM time allowable
check_time <- function(time_col, earliest_time = "06:00", latest_time = "18:00") {
    col_name <- deparse(substitute(time_col))
    na_count <- sum(is.na(time_col))
    time_col_parsed <- strptime(time_col, format = "%H:%M")
    is_time <- !is.na(time_col_parsed)
    is_daylight <- format(time_col_parsed, "%H:%M") <= latest_time & format(time_col_parsed, "%H:%M") >= earliest_time
    valid <- is.na(time_col) | (is_time & is_daylight)
    invalid <- unique(time_col[!valid & !is.na(time_col)])
    if (all(valid, na.rm = TRUE)) {
        return(paste0(col_name, " is validated. ", sprintf("Number of NAs: %d.", na_count)))
    } else {
        return(paste0(
            col_name, " values are expected to be formatted in 24-hr HH:MM time within ", earliest_time, "-", latest_time, " time range. ",
            paste0("These values are invalid: ", combine_words(invalid)),
            sprintf(" (unexpected values occurred %d times). ", sum(!valid & !is.na(time_col))),
            sprintf("Number of NAs: %d.", na_count)
        ))
    }
}
list_functions$check_time <- check_time

# Report on functions created ---------------------------
message("New functions created: ", paste(names(list_functions), collapse = ", "))
