% 选择文件夹
folder_path = uigetdir();  % 弹出窗口选择文件夹

% 列出文件夹中包含“大于7m”的所有文件
% file_list = dir(fullfile(folder_path, '*大于7m*.mat'));
% file_list = dir(fullfile(folder_path, '*拥堵*.mat'));
file_list = dir(fullfile(folder_path, '*自由流*.mat'));

% 初始化存储Bus和Truck数据的变量
bus_data = [];
truck_data = [];
car_data = [];

% 循环找到的“大于7m”文件
for i = 1:length(file_list)
    file_name = file_list(i).name;

    % 根据文件名筛选出Bus文件
    if contains(file_name, 'Bus')
        file_path = fullfile(folder_path, file_name);
        data = load(file_path);  % 加载MAT文件

        % 提取第1，2，4，7-14列
        bus_data = data.LKParaBus(:, [1, 2, 4, 7:14]);

        % 根据文件名筛选出Truck文件
    elseif contains(file_name, 'Truck')
        file_path = fullfile(folder_path, file_name);
        data = load(file_path);  % 加载MAT文件

        % 提取第1，2，4，7-14列
        truck_data = data.LKParaTruck(:, [1, 2, 4, 7:14]);

    elseif contains(file_name, 'Car')
        file_path = fullfile(folder_path, file_name);
        data = load(file_path);  % 加载MAT文件

        % 提取第1，2，4，7-14列
        car_data = data.LKParaCar(:, [1, 2, 4, 7:14]);

    end
end
combined_data = [bus_data; truck_data];
% 保存合并后的数据到Excel文件
output_file = fullfile(folder_path, 'Combined_lanekeep自由流.xlsx');
writematrix(car_data, output_file, 'Sheet', 'Car');
writematrix(combined_data, output_file, 'Sheet', 'Bus_Truck');