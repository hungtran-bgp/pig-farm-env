import matplotlib.pyplot as plt
import pandas as pd
import glob

def calculate_daily_averages(file_pattern):
    # Gather all files matching the pattern (e.g., 'pig*.csv')
    files = glob.glob(file_pattern)
    
    # Initialize DataFrames to accumulate sums for each attribute
    cfi_sum = None
    weight_sum = None
    days = None

    for file in files:
        # Load each CSV file
        data = pd.read_csv(file)
        
        # Extract columns by position (assuming Day, DFI, and Weight in that order)
        day_data = data.iloc[:, 0]        # 'Day' column
        cfi_data = data.iloc[:, 5]        # 'Cummulative Feed Intake' column
        weight_data = data.iloc[:, 6]     # 'Weight' column

        # Initialize accumulation if first file
        if cfi_sum is None:
            days = day_data
            cfi_sum = cfi_data
            weight_sum = weight_data
        else:
            cfi_sum += cfi_data
            weight_sum += weight_data

    # Calculate the averages by dividing sums by the number of files (pigs)
    num_pigs = len(files)
    avg_cfi = cfi_sum / num_pigs
    avg_weight = weight_sum / num_pigs
    ADG = max(avg_weight) / 90
    # Combine into a DataFrame with days
    averages = pd.DataFrame({
        'Day': days,
        'ACFI': avg_cfi,
        'ABW': avg_weight
    })

    return averages,ADG

# Example usage: assuming files are named as 'pig1.csv', 'pig2.csv', ..., 'pig20.csv'
qui_autumn,qui_autumn_adg= calculate_daily_averages('qui/autumn/-*.csv')
qui_summer,qui_summer_adg= calculate_daily_averages('qui/summer/-*.csv')
rena_autumn,rena_autumn_adg= calculate_daily_averages('rena/autumn/-*.csv')
rena_summer,rena_summer_adg= calculate_daily_averages('rena/summer/-*.csv')


plt.figure(figsize=(14, 8))
plt.subplot(1,2,1)
# Plot Average Daily Feed Intake
plt.plot(qui_autumn['Day'], qui_autumn['ACFI'], label='CFI in autumn', marker='o', color='blue')

# Plot Average Weight
plt.plot(qui_summer['Day'], qui_summer['ACFI'], label='CFI in summer', marker='x', color='orange')

# Adding labels, title, and legend
plt.xlabel('Day')
plt.ylabel('CFI(kg)')
plt.title('Compare pig of quiniou in 2 condition weather')
plt.legend()
plt.grid(True)
description_qui = f"Average Daily Gain in autumn: {qui_autumn_adg:.2f} kg/day\n" \
                  f"Average Daily Gain in summer: {qui_summer_adg:.2f} kg/day"
plt.figtext(0.2, 0.1, description_qui, ha='center', fontsize=10, color="blue")

plt.subplot(1,2,2)
plt.plot(rena_autumn['Day'], rena_autumn['ACFI'], label='CFI in autumn', marker='o', color='blue')
plt.plot(rena_summer['Day'], rena_summer['ACFI'], label='CFI in summer', marker='x', color='orange')
plt.xlabel('Day')
plt.ylabel('CFI(kg)')
plt.title('Compare pig of renadeau in 2 condition weather')
plt.legend()
plt.grid(True)
description_rena = f"Average Daily Gain in autumn: {rena_autumn_adg:.2f} kg/day\n" \
                   f"Average Daily Gain in summer: {rena_summer_adg:.2f} kg/day"
plt.figtext(0.7, 0.1, description_rena, ha='center', fontsize=10, color="orange")

plt.tight_layout(rect=[0, 0.15, 1, 0.95])  # Adjust bottom space for descriptions
plt.show()