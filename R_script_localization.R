#Enter your results file and name of sample
file_paths <- c("Enter_the_path_to_your_File")

row_names <- c("Enter_the_name_of_your_sample")


# Initialize an empty dataframe 
results_protein_presence <- data.frame(
  Sample = row_names, 
  proportion_nucleus = numeric(length(row_names)),
  proportion_perinuclear = numeric(length(row_names)),
  proportion_neurites = numeric(length(row_names)),
  stringsAsFactors = FALSE
)

# Loop through each file, calculate the overlaps, and add the results to the dataframe
for (i in 1:length(file_paths)) {
  # Read the CSV file
  overlap <- read.csv(file_paths[i], row.names = 1)
  
  # Set row names for the CSV file
  new_rownames <- c("nucleus", "overlap_nucleus", "perinuclear", "overlap_perinuclear", "neurites", "overlap_neurites", "protein_presence")
  rownames(overlap) <- new_rownames
  
  # Calculate the percentage protein presence per region
  Proportion_overlap <- overlap$Area[7] / (overlap$Area[2] + overlap$Area[4] + overlap$Area[6])
  Proportion_nucleus <- ((overlap$Area[2]*Proportion_overlap) / overlap$Area[7] * 100) 
  Proportion_perinucleus <- ((overlap$Area[4]*Proportion_overlap) / overlap$Area[7] * 100)
  Proportion_neurites <- ((overlap$Area[6]*Proportion_overlap) / overlap$Area[7] * 100)
  
  
  # Add the results to the dataframe
  results_protein_presence[i, "proportion_nucleus"] <- Proportion_nucleus
  results_protein_presence[i, "proportion_perinuclear"] <- Proportion_perinucleus
  results_protein_presence[i, "proportion_neurites"] <- Proportion_neurites
  
}

# View the final dataframe

print(results_protein_presence)
mean(results_protein_presence$proportion_nucleus)
mean(results_protein_presence$proportion_perinuclear)
mean(results_protein_presence$proportion_neurites)

