import pandas as pd
from scipy.stats import pearsonr
import glob

def calculate_average_pearson(folder1, folder2, dfi_column=3):
    # Get all file paths from both folders
    folder1_files = sorted(glob.glob(f"{folder1}/*.csv"))
    folder2_files = sorted(glob.glob(f"{folder2}/*.csv"))
    
    # Ensure both folders have the same number of files
    if len(folder1_files) != len(folder2_files):
        raise ValueError("The two folders must contain the same number of files.")
    
    pearson_values = []  # To store Pearson correlation coefficients

    # Iterate through each pair of files
    for file1, file2 in zip(folder1_files, folder2_files):
        # Load the DFI data from both files
        data1 = pd.read_csv(file1)
        data2 = pd.read_csv(file2)
        
        # Extract the DFI column
        dfi1 = data1.iloc[:, dfi_column]  # Adjust the column index if needed
        dfi2 = data2.iloc[:, dfi_column]  # Adjust the column index if needed
        
        # Calculate Pearson correlation
        correlation, _ = pearsonr(dfi1, dfi2)
        pearson_values.append(correlation)
    
    # Calculate the average Pearson correlation
    average_pearson = sum(pearson_values) / len(pearson_values)
    
    return average_pearson, pearson_values

# Example usage
folder1 = "qui/autumn/0"  # Replace with the path to the first folder
folder2 = "qui/autumn/1"  # Replace with the path to the second folder
average_pearson, all_pearsons = calculate_average_pearson(folder1, folder2)

# Output results
print(f"Average Pearson Correlation: {average_pearson}")
print("Individual Pearson Correlations:", all_pearsons)
