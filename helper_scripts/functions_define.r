# functions_define.r

# Initialize functions list ---------------------------
list_functions <- list()

# Check a dataframe for presence of required columns ---------------------------
#- df : The dataframe to check
#- required_columns : The vector of required columns
#- df_name : A string of the dataframe name to use in the output message
check_completeness <- function(df, required_columns, df_name) {
    missing_cols <- setdiff(required_columns, colnames(df))
    if (length(missing_cols) == 0) {
        return("Completeness is validated")
    } else {
        return(paste0("Missing required columns from ", df_name, ": ", paste(missing_cols, collapse = ", ")))
    }
}
list_functions$check_completeness <- check_completeness

# Check a column/vector for levels in a column/vector ---------------------------
#- grouping_col : The column or vector to check
#- grouping_vector : The column or vector of allowable values
#- col_name : A string of the column name to use in the output message
check_grouping <- function(grouping_col, grouping_vector, col_name) {
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
#- col_name : A string of the column name to use in the output message
#- type : Either "int" for integer ranges or "numeric" for continuous ranges
check_range <- function(range_col, range_lower, range_upper, col_name, type = c("numeric", "int")) {
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
            col_name, " values are expected to be within ", range_lower, "-", range_upper, ". ",
            paste0("These values are invalid: ", combine_words(invalid)),
            sprintf(" (unexpected values occurred %d times). ", sum(!valid & !is.na(num_col))),
            sprintf("Number of NAs: %d.", na_count)
        ))
    }
}
list_functions$check_range <- check_range

# Report on functions created ---------------------------
message("New functions created: ", paste(names(list_functions), collapse = ", "))
