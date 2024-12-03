import numpy as np
import matplotlib.pyplot as plt

# Define body weights (BW) as a range of values
bw = np.linspace(10, 120, 100)  # Body weights from 10 to 150 kg

# Define the equations
uct = 40.9 - 4.4 * np.log(1 + bw)  # Upper critical temperature
lct = 37.254 - 5.867 * np.log(bw)  # Lower critical temperature

# Plot the results
plt.figure(figsize=(10, 6))
plt.plot(bw, uct, label='UCT (Upper Critical Temperature)', color='red')
plt.plot(bw, lct, label='LCT (Lower Critical Temperature)', color='blue')

# Add labels, title, and legend
plt.xlabel('Body Weight (kg)')
plt.ylabel('Temperature (°C)')
plt.title('Upper and Lower Critical Temperature vs Body Weight')
plt.legend()
plt.grid(True)

# Show the plot
plt.show()
