import matplotlib.pyplot as plt
import pandas as pd
import glob
import numpy as np
import math

def drawDFI(file):
    data = pd.read_csv(file)
        
    day = data.iloc[:, 0]        # 'Day' column
    dfi = data.iloc[:, 3]
    plt.figure(figsize=(6, 6))
    plt.plot(day, dfi)
    plt.xlabel('Day')
    plt.ylabel('DFI (kg)')
    plt.legend()
    plt.grid(True)
    plt.show()

def drawAllDFI(file_pattern):
    files = glob.glob(file_pattern)
    plt.figure(figsize=(6,6))
    for file in files:
        data = pd.read_csv(file)
        day_data = data.iloc[:, 0]
        dfi_data = data.iloc[:, 3]
        plt.plot(day_data,dfi_data)
    plt.xlabel('Day')
    plt.ylabel('DFI (kg)')
    plt.legend()
    plt.grid(True)
    plt.show()

def DFI_pen_bar(pen_pattern):
    files = glob.glob(pen_pattern)
    final_weights = []
    ADGs = []
    ADFIs = []
    for file in files:
        data = pd.read_csv(file)
        final_weight = data.iloc[-1,6]
        final_weights.append(final_weight)
        ADGs.append((final_weight - data.iloc[0,6])/len(data))
        ADFIs.append(data.iloc[-1,5] / len(data))
    ADG = sum(ADGs) / len(ADGs)
    ADFI = sum(ADFIs) / len(ADFIs)
    ABW = sum(final_weights) / len(final_weights)
    pig_ids = range(len(files))
    description =   f"ADG: {ADG:.2f} kg/day\n" \
                    f"ADFI: {ADFI:.2f} kg/day\n" \
                    f"ABW:{ABW:.2f} kg"
    plt.figure(figsize=(10, 6))
    plt.bar(pig_ids, final_weights, color='skyblue', edgecolor='black',width=0.6)
    plt.xlabel('Pig ID')
    plt.ylabel('Final Weight (kg)')
    plt.title(description)
    plt.xticks(pig_ids)  # Rotate x-axis labels for better readability

    # Annotate each bar with its value
    for i, weight in enumerate(final_weights):
        plt.text(i, weight + 0.5, f'{weight:.2f}', ha='center', fontsize=8)

    
    # plt.figtext(0.1, 0, description, wrap=True, horizontalalignment='left', fontsize=10)
    # plt.subplots_adjust(bottom=0.5)
    # Show the plot
    plt.tight_layout()
    plt.show()

def get_total_data(folder_pattern):
    files = glob.glob(folder_pattern)
    final_weights = []
    final_cfis = []
    adgs = []
    for file in files:
        data = pd.read_csv(file)
        final_weight = data.iloc[-1,6]
        final_weights.append(final_weight)
        weight_gain = final_weight - data.iloc[0,6]
        adgs.append(weight_gain/(len(data)-1))
        final_cfis.append(data.iloc[-1,5])
    return final_weights, final_cfis,adgs
def draw_season_result(autumn = "qui/autumn/*/*.csv",summer="qui/summer/*/*.csv"):
    autumn_weights, autumn_cfis,adg_autumn = get_total_data(autumn)
    summer_weights, summer_cfis,adg_summer = get_total_data(summer)
    print(sum(adg_summer) / len(adg_summer))
    print(sum(adg_autumn) / len(adg_autumn))

    max_autumn = max(autumn_weights)
    min_autumn = min(autumn_weights)
    avg_autumn = sum(autumn_weights) / len(autumn_weights)
    
    max_summer = max(summer_weights)
    min_summer = min(summer_weights)
    avg_summer = sum(summer_weights) / len(summer_weights)

    labels = ['Max', 'Min', 'Avg']
    autumn_stats = [max_autumn, min_autumn, avg_autumn]
    summer_stats = [max_summer, min_summer, avg_summer]

    # X-axis positions for bars
    x = range(len(labels))

    # Plot the data
    bar_width = 0.2  # Width of each bar
    plt.figure(figsize=(10,6))
    plt.bar(x, autumn_stats, width=bar_width, color='skyblue', edgecolor='black')
    plt.bar([i + bar_width for i in x], summer_stats, width=bar_width, color='orange', edgecolor='black')

    # Add labels and title
    plt.xlabel('Statistic')
    plt.ylabel('Weight (kg)')
    plt.title('Comparison of Max, Min, and Avg Weight Between Seasons')
    plt.xticks([i + bar_width / 2 for i in x], labels)  # Center the x-ticks
    plt.legend()

    # Annotate each bar with its value
    for i in x:
        plt.text(i, autumn_stats[i] + 0.5, f'{autumn_stats[i]:.2f}', ha='center', fontsize=9, color='black')
        plt.text(i + bar_width, summer_stats[i] + 0.5, f'{summer_stats[i]:.2f}', ha='center', fontsize=9, color='black')

    # Show the plot
    plt.tight_layout()
    plt.show()

# def get_slauter_data(folder_pattern):
#     files = glob.glob(folder_pattern)


# def experiment_analysis(folder_pattern0,folder_pattern1):
#     files = glob.glob(folder_pattern)
#     final_weights = []
#     final_cfis = []
#     for file in files:
#         data = pd.read_csv(file)
#         final_weight = data.iloc[-1,6]
#         final_weights.append(final_weight)
#         final_cfis.append(data.iloc[-1,5])
def get_slaughter_pig(folder_pattern, weight_threshold=110, day_limit=75):
    files = glob.glob(folder_pattern)
    count =0
    for file in files:
        data = pd.read_csv(file)
        weights = data.iloc[:,6]
        days = data.iloc[:,0]
        reached_day = days[weights >= weight_threshold].min() if (weights >= weight_threshold).any() else None
        if reached_day and reached_day <= day_limit:
                count += 1
    return count
def cmp_cfi_season(autumn = "qui/autumn/*/*.csv",summer="qui/summer/*/*.csv"):
    autumn_files = glob.glob(autumn)
    summer_files = glob.glob(summer)
    cfi_autumn = None
    cfi_summer = None
    for file in autumn_files:
        data = pd.read_csv(file)
        cfi = data.iloc[:,5]
        if cfi_autumn is None:
            cfi_autumn = cfi
        else:
            cfi_autumn = cfi_autumn.add(cfi, fill_value=0)
    for file in summer_files:
        data = pd.read_csv(file)
        cfi = data.iloc[:,5]
        if cfi_summer is None:
            cfi_summer = cfi
        else:
            cfi_summer = cfi_summer.add(cfi, fill_value=0)        
    cfi_autumn = cfi_autumn / len(autumn_files)
    cfi_summer = cfi_summer / len(summer_files)

    plt.figure(figsize=(10, 6))
    day1 = range(81)
    day2 = range(91)
    # Plot for folder 1
    plt.plot(day1, cfi_autumn, label='CFI autumn', marker='o', color='blue')

    # Plot for folder 2
    plt.plot(day2, cfi_summer, label='CFI summer', marker='x', color='orange')

    # Adding labels, title, and legend
    plt.xlabel('Day')
    plt.ylabel('Average CFI (kg)')
    plt.title('Average Cumulative Feed Intake Comparison')
    plt.legend()
    plt.grid(True)
    plt.show()
    
def get_area(T, BW):
    return math.e**(-0.6064) * ((1/65)**0.6832) * (math.e**(0.0044*T))*(BW**0.6832)
def cmp_cfi_VN(autumn = "qui/autumn/*/*.csv",summer="qui/summer/*/*.csv"):
    autumn_files = glob.glob(autumn)
    summer_files = glob.glob(summer)
    cfi_autumn = None
    cfi_summer = None
    for file in autumn_files:
        data = pd.read_csv(file)
        cfi = data.iloc[:,5]
        if cfi_autumn is None:
            cfi_autumn = cfi
        else:
            cfi_autumn = cfi_autumn.add(cfi, fill_value=0)
    for file in summer_files:
        data = pd.read_csv(file)
        cfi = data.iloc[:,5]
        if cfi_summer is None:
            cfi_summer = cfi
        else:
            cfi_summer = cfi_summer.add(cfi, fill_value=0)        
    cfi_autumn = cfi_autumn / len(autumn_files)
    cfi_summer = cfi_summer / len(summer_files)

    plt.figure(figsize=(10, 6))
    day1 = range(len(cfi_autumn))
    day2 = range(len(cfi_summer))
    # Plot for folder 1
    plt.plot(day1, cfi_autumn, marker='o', color='blue')

    # Plot for folder 2
    plt.plot(day2, cfi_summer, marker='x', color='orange')

    # Adding labels, title, and legend
    plt.xlabel('Day')
    plt.ylabel('Average CFI (kg)')
    plt.title('Average Cumulative Feed Intake Comparison')
    plt.legend()
    plt.grid(True)
    plt.show()

def calculate_reach_110kg(folder_pattern):
    files = glob.glob(folder_pattern)  # Lấy tất cả các file CSV trong thư mục
    total_pigs = len(files)  # Tổng số cá thể
    reached_count = 0  # Số cá thể đạt 110 kg
    total_days = 0  # Tổng số ngày của các cá thể đạt 110 kg
    
    for file in files:
        data = pd.read_csv(file)  # Đọc dữ liệu từ file
        weight_column = data.iloc[:, 6]  # Cột cân nặng (giả định là cột cuối)
        day_column = data.iloc[:, 0]  # Cột ngày (giả định là cột đầu)
        
        # Tìm ngày đầu tiên cân nặng đạt hoặc vượt 110 kg
        reached = weight_column[weight_column >= 100]
        if not reached.empty:
            reached_count += 1
            first_day = day_column[reached.index[0]]
            total_days += first_day
    
    # Tính phần trăm cá thể đạt 110 kg
    percentage_reached = (reached_count / total_pigs) * 100
    
    # Tính thời gian trung bình (nếu có cá thể nào đạt 110 kg)
    average_days = total_days / reached_count if reached_count > 0 else None
    
    return {
        "percentage_reached": percentage_reached,
        "average_days": average_days
    }


pig0 = "qui/autumn/0/0.csv"
pig1 = "qui/summer/0/0.csv"

# drawDFI(pig0)
#drawDFI(pig1)
list_pig0 = "qui/autumn/0/*.csv"
list_pig1 = "qui/summer/0/*.csv"
qui_autumn = "qui/autumn/*/*.csv"
qui_summer = "qui/summer/*/*.csv"


# drawAllDFI(list_pig0)
# drawAllDFI(list_pig1)
# DFI_pen_bar(list_pig1)
# draw_season_result("vn_qui/autumn/*/*.csv","vn_qui/summer/*/*.csv")
# draw_season_result("vn_rena/autumn/*/*.csv","vn_rena/summer/*/*.csv")
# print(get_slaughter_pig(qui_autumn,110,80))
# cmp_cfi_season()
#print(get_area(25,70))
# drawDFI("vn_rena/summer/0/0.csv")
#drawAllDFI("vn_rena/summer/*/*.csv")
# cmp_cfi_VN("vn_qui/autumn/*/*.csv","vn_qui/summer/*/*.csv")
# cmp_cfi_VN("qui/summer/*/*.csv","qui/summer_restrict/*/*.csv")
# draw_season_result("qui/summer/*/*.csv","qui/summer_restrict/*/*.csv")

result = calculate_reach_110kg("vn_qui/summer/*/*.csv")
print(f"Phần trăm cá thể đạt 110 kg: {result['percentage_reached']}%")
print(f"Thời gian trung bình đạt 110 kg: {result['average_days']} ngày")