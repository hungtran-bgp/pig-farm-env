import pandas as pd
import matplotlib.pyplot as plt

# Load the data from the CSV files
pig_autumn_data = pd.read_csv('qui_autumn.csv')
pig_summer_data = pd.read_csv('qui_summer.csv')
pig3_data = pd.read_csv('rena_autumn.csv')
pig4_data = pd.read_csv('rena_summer.csv')
# Assuming each CSV has 'Day' and 'Weight' columns
# Adjust column names if different
autumn_day = pig_autumn_data.iloc[:,0]
autumn_weight = pig_autumn_data.iloc[:,6]
summer_day = pig_summer_data.iloc[:,0]
summer_weight = pig_summer_data.iloc[:,6]

# Plotting the data
plt.figure(figsize=(14, 6))
plt.subplot(1, 2, 1)

plt.plot(autumn_day, autumn_weight, label='Autumn', marker='o')
plt.plot(summer_day, summer_weight, label='Summer', marker='x')

# Adding labels and title
plt.xlabel('Day')
plt.ylabel('Weight (kg)')
plt.title('Pig Growth Comparison Over Time')
plt.legend()
plt.grid(True)

plt.subplot(1, 2, 2)
plt.plot(pig3_data.iloc[:, 0], pig3_data.iloc[:, 6], label='Pig 3', marker='o')
plt.plot(pig4_data.iloc[:, 0], pig4_data.iloc[:, 6], label='Pig 4', marker='x')
plt.xlabel('Day')
plt.ylabel('Weight (kg)')
plt.title('Pig Growth Comparison (Pig 3 vs Pig 4)')
plt.legend()
plt.grid(True)

plt.tight_layout()
plt.show()
