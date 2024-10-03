library(dplyr)

# Initialize an empty dataframe for colocalization
process_colocalization <- function(file_paths, row_names) {
  colocalization <- data.frame(
    Sample = row_names, 
    colocalized = numeric(length(row_names)),
    total_measurements = numeric(length(row_names)),
    percentage_colocalized = numeric(length(row_names)), 
    stringsAsFactors = FALSE
  )
  
# function to count samples that colocalize
  count_close_pairs <- function(combined_coordinates) {
    count <- 0
    used_gfp <- logical(nrow(combined_coordinates))
    
    for (i in seq_along(combined_coordinates$X_B1)) {
      x_b1 <- combined_coordinates$X_B1[i]
      differences <- abs(x_b1 - combined_coordinates$X_GFP)
      
      close_indices <- which(differences < 1)
      
      if (length(close_indices) > 0) {
        for (idx in close_indices) {
          if (!used_gfp[idx]) {
            count <- count + 1
            used_gfp[idx] <- TRUE
            break
          }
        }
      }
    }
    
    return(count)
  }
  
# Loop over each sample and process
  for (i in seq_along(row_names)) {
    sample_name <- row_names[i]
    
# Get file paths for this sample
    file_path_B1 <- file_paths[2 * (i - 1) + 1]
    file_path_GFP <- file_paths[2 * (i - 1) + 2]
    
# Read and process the CSV files
    coordinates_B1 <- read.csv(file_path_B1, row.names = 1)
    coordinates_GFP <- read.csv(file_path_GFP, row.names = 1)
    
# Remove unnecessary columns
    coordinates_B1 <- coordinates_B1 %>% select(-Area, -Mean, -Min, -Max)
    coordinates_GFP <- coordinates_GFP %>% select(-Area, -Mean, -Min, -Max)
    colnames(coordinates_B1)[colnames(coordinates_B1) == "X"] <- "X_B1"
    colnames(coordinates_B1)[colnames(coordinates_B1) == "Y"] <- "Y_B1"
    colnames(coordinates_GFP)[colnames(coordinates_GFP) == "X"] <- "X_GFP"
    colnames(coordinates_GFP)[colnames(coordinates_GFP) == "Y"] <- "Y_GFP"
    
# Align the number of rows by adding NA values to the shorter dataframe
    max_rows <- max(nrow(coordinates_B1), nrow(coordinates_GFP))
    
    if (nrow(coordinates_B1) < max_rows) {
      coordinates_B1[(nrow(coordinates_B1) + 1):max_rows, ] <- NA
    }
    
    if (nrow(coordinates_GFP) < max_rows) {
      coordinates_GFP[(nrow(coordinates_GFP) + 1):max_rows, ] <- NA
    }
    
# Combine the dataframes
    combined_coordinates <- cbind(coordinates_B1, coordinates_GFP)
    
# Calculate colocalized and total measurements
    result <- count_close_pairs(combined_coordinates)
    total_values <- nrow(combined_coordinates)
    
    # Update the colocalization dataframe
    colocalization$colocalized[i] <- result
    colocalization$total_measurements[i] <- total_values
    
# Calculate percentage colocalized
    if (total_values > 0) {
      colocalization$percentage_colocalized[i] <- result / total_values * 100
    } else {
      colocalization$percentage_colocalized[i] <- NA  # Handle case where total_measurements is 0
    }
  }
  
  return(colocalization)
}

# Use the functions to calculate the colocalization
file_paths <- c("Enter_the_path_to_your_File")
row_names <- c("Enter_the_name_of_your_sample")
colocalization <- process_colocalization(file_paths, row_names)

# Print the results
print(colocalization)
mean(colocalization$percentage_colocalized)
mean(colocalization$Pearson_Coefficient)


