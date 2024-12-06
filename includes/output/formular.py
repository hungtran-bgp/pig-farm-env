import numpy as np
import matplotlib.pyplot as plt
import math
# Define the function
def y_function(x):
    return -0.0007 * x**4 + 0.0059 * x**3 + 0.2453 * x**2 + 0.0173 * x + 4.0051
def draw_pig_eat():
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


# Định nghĩa hàm DFI
def calculate_dfi(ET, BW):
    return -1264 + 117 * ET - 2.4 * ET**2 + 73.6 * BW - 0.26 * BW**2 - 0.95 * ET * BW

def calculate_dfi2(et, bw):
    uct = 40.9 - 4.4 * math.log(1 + bw)
    dfi = (140 - 3.42 * math.log(1 + math.exp(et - uct))) * (bw ** 0.69)
    return dfi

def draw_DFI_qui():
# Thiết lập giá trị ET và BW
    ET_values = np.linspace(5, 35, 100)  # ET từ 5 đến 35
    BW_values = [35, 70, 110]  # Các giá trị BW

    # Vẽ đồ thị cho mỗi giá trị BW
    plt.figure(figsize=(10, 6))
    for BW in BW_values:
        DFI_values = calculate_dfi(ET_values, BW)
        plt.plot(ET_values, DFI_values, label=f'BW = {BW} kg')

    # Thêm nhãn và tiêu đề
    plt.xlabel('Effective Temperature (ET)')
    plt.ylabel('Daily Feed Intake (DFI)')
    plt.title('Daily Feed Intake (DFI) vs Environmental Temperature (ET) for different BW')
    plt.legend()
    plt.grid(True)

    # Hiển thị đồ thị
    plt.show()

def draw_DFI_renau():
    et_values = np.linspace(5, 35, 100)

    # Các mức cân nặng: 35 kg, 70 kg, 110 kg
    bw_values = [35, 70, 110]

    plt.figure(figsize=(10, 6))

    # Vẽ từng đường biểu diễn cho từng cân nặng
    for bw in bw_values:
        dfi_values = [calculate_dfi2(et, bw) for et in et_values]
        plt.plot(et_values, dfi_values, label=f'BW = {bw} kg')

    # Thiết lập nhãn, tiêu đề và chú thích
    plt.xlabel('Effective Temperature (°C)', fontsize=12)
    plt.ylabel('DFI (g)', fontsize=12)
    plt.title('DFI vs Environmental Temperature for 35 kg, 70 kg, and 110 kg', fontsize=14)
    plt.legend(title='Body Weights', fontsize=10)
    plt.grid(True)

    # Hiển thị đồ thị
    plt.tight_layout()
    plt.show()

def calculate_dfi(ET, BW):
    return -1264 + 117 * ET - 2.4 * ET**2 + 73.6 * BW - 0.26 * BW**2 - 0.95 * ET * BW

draw_DFI_renau()
# Giá trị nhiệt độ và cân nặng
ET_1 = 20  # Nhiệt độ ban đầu
ET_2 = 30  # Nhiệt độ sau
BW_70 = 70
BW_110 = 110

# Tính DFI cho từng trường hợp
DFI_70_ET1 = calculate_dfi2(ET_1, BW_70)
DFI_70_ET2 = calculate_dfi2(ET_2, BW_70)
DFI_110_ET1 = calculate_dfi2(ET_1, BW_110)
DFI_110_ET2 = calculate_dfi2(ET_2, BW_110)
print(DFI_110_ET1)
print(DFI_110_ET2)
# Tính sự giảm của DFI
reduction_70 = DFI_70_ET1 - DFI_70_ET2
reduction_110 = DFI_110_ET1 - DFI_110_ET2

# Tính phần trăm giảm
percentage_reduction_70 = (reduction_70 / DFI_70_ET1) * 100
percentage_reduction_110 = (reduction_110 / DFI_110_ET1) * 100

# In kết quả
print(f"Sự giảm DFI của lợn 70 kg: {reduction_70:.2f} ({percentage_reduction_70:.2f}%)")
print(f"Sự giảm DFI của lợn 110 kg: {reduction_110:.2f} ({percentage_reduction_110:.2f}%)")