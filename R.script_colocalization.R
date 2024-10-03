library(dplyr)
setwd("C:/Users/keesd/Documents/Neuroscience and Cognition/Internship - Kenna lab/Lab/Analysis/Colocalization")

process_colocalization <- function(file_paths, row_names) {
  # Initialize an empty dataframe for colocalization
  colocalization <- data.frame(
    Sample = row_names, 
    colocalized = numeric(length(row_names)),
    total_measurements = numeric(length(row_names)),
    percentage_colocalized = numeric(length(row_names)), # New column
    stringsAsFactors = FALSE
  )
  
  # Define a function to count close pairs
  count_close_pairs <- function(combined_coordinates) {
    count <- 0
    used_gfp <- logical(nrow(combined_coordinates)) # Track used GFPs
    
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
    
    # Rename columns for consistency
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

# Example usage with multiple files
file_paths <- c("Results_MAX_Stack_GFP.tiff.csv", "Results_MAX_Stack_GFP.tiff_1.csv",
                "Results_MAX_Stack_GFP.tiff_2.csv", "Results_MAX_Stack_GFP.tiff_3.csv",
                "Results_MAX_Stack_GFP.tiff_4.csv", "Results_MAX_Stack_GFP.tiff_5.csv",
                "Results_MAX_Stack_GFP.tiff_20.csv", "Results_MAX_Stack_GFP.tiff_21.csv",
                "Results_MAX_Stack_GFP.tif_6.csv", "Results_MAX_Stack_GFP.tif_7.csv",
                "Results_MAX_Stack_GFP.tif_18.csv", "Results_MAX_Stack_GFP.tif_19.csv",
                "Results_MAX_Stack_GFP.tif_10.csv", "Results_MAX_Stack_GFP.tif_11.csv",
                "Results_MAX_Stack_GFP.tif_12.csv", "Results_MAX_Stack_GFP.tif_13.csv",
                "Results_MAX_Stack_GFP.tif_14.csv", "Results_MAX_Stack_GFP.tif_15.csv",
                "Results_MAX_Stack_GFP.tif_16.csv", "Results_MAX_Stack_GFP.tif_17.csv",
                "Results_MAX_Stack_GFP.tiff_44.csv", "Results_MAX_Stack_GFP.tiff_45.csv",
                "Results_MAX_Stack_GFP.tiff_26.csv","Results_MAX_Stack_GFP.tiff_27.csv",
                "Results_MAX_Stack_GFP.tiff_32.csv","Results_MAX_Stack_GFP.tiff_33.csv",
                "Results_MAX_Stack_GFP.tiff_34.csv","Results_MAX_Stack_GFP.tiff_35.csv",
                "Results_MAX_Stack_GFP.tiff_38.csv","Results_MAX_Stack_GFP.tiff_39.csv",
                "Results_MAX_Stack_GFP.tiff_46.csv","Results_MAX_Stack_GFP.tiff_47.csv",
                "Results_MAX_Stack_GFP.tif_22.csv","Results_MAX_Stack_GFP.tif_23.csv",
                "Results_MAX_Stack_GFP.tif_24.csv","Results_MAX_Stack_GFP.tif_25.csv",
                "Results_MAX_Stack_GFP.tif_36.csv","Results_MAX_Stack_GFP.tif_37.csv",
                "Results_MAX_Stack_GFP.tif_42.csv","Results_MAX_Stack_GFP.tif_43.csv"
                
)
row_names <- c("KIF4_WT_11_1", "KIF4A_WT_11_2", "KIF4A_WT_12_1", "KIF4A_WT_12_2", "KIF4A_WT_13_1", 
               "KIF4A_WT_13_2", "KIF4A_WT_14_1", "KIF4A_WT_14_2", "KIF4A_WT_14_3", "KIF4A_WT_15_1", "KIF4A_WT_11_3", "KIF4A_WT_11_4","KIF4A_WT_11_5",
               "KIF4A_WT_12_3", "KIF4A_WT_12_4", "KIF4A_WT_12_5", "KIF4A_WT_13_3", "KIF4A_WT_14_4", "KIF4A_WT_14_5", "KIF4A_WT_15_2")

# Call the function
colocalization_KIF4A_WT <- process_colocalization(file_paths, row_names)
colocalization_KIF4A_WT$Pearson_Coefficient <- c(0.835, 0.807, 0.816, 0.974, 0.917, 0.941, 0.869, 0.700, 0.818, 0.886, 0.832, 0.876, 0.885, 0.958, 0.932, 0.907, 0.926, 0.833, 0.732, 0.788)  


# Print the updated dataframe
print(colocalization_KIF4A_WT)
mean(colocalization_KIF4A_WT$percentage_colocalized)
mean(colocalization_KIF4A_WT$Pearson_Coefficient)


