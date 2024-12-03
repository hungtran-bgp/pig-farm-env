import numpy as np
import matplotlib.pyplot as plt

# Define the function
def y_function(x):
    return -0.0007 * x**4 + 0.0059 * x**3 + 0.2453 * x**2 + 0.0173 * x + 4.0051

# Generate x-values for 24 hours (600 points)
x_values = np.linspace(0, 24, 600)

# Compute y-values
y_values = y_function(x_values)

# Plot the graph
plt.figure(figsize=(10, 6))
plt.plot(x_values, y_values, label=r'$y = -0.0007x^4 + 0.0059x^3 + 0.2453x^2 + 0.0173x + 4.0051$', color='blue')
plt.title("Graph of the Function Over 24 Hours", fontsize=16)
plt.xlabel("Hour (x)", fontsize=14)
plt.ylabel("y", fontsize=14)
plt.xticks(range(0, 25, 1))  # Show all 24 hours on the x-axis
plt.axhline(0, color='black', linewidth=0.7, linestyle='--')  # Add x-axis
plt.axvline(0, color='black', linewidth=0.7, linestyle='--')  # Add y-axis
plt.grid(True)
plt.legend(fontsize=12)
plt.tight_layout()  # Adjust layout to fit the x-axis labels
plt.show()

percent = float(1)
for i in range(24):
    percent = percent * (1 - y_function(i))
print(percent)
