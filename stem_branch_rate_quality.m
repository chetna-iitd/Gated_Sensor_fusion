function [ rate, accuracy] = stem_branch_rate_quality()
%TILE_RATE_PSNR_BER Summary of this function goes here
%   Detailed explanation goes here
per_coeff=32;%bits
image_coeff=24;%bits
data_stem_input=[1 672*376*image_coeff %LR camera
    2 1152*1152*image_coeff %Radar polar
    3 672*376*image_coeff]; %Lidar proj
data_stem_output=[1 64*168*94*per_coeff %LR camera
    2 64*288*288*per_coeff %Radar polar
    3 64*168*94*per_coeff]; %Lidar proj
per_coeff=32;%bits
 
data_config_set=[1 (40.20*per_coeff)+ data_stem_output(1,2)%branch_18 camera
    2 (40.20*per_coeff)+data_stem_output(2,2) %branch_18 radar
    3 (40.20*per_coeff)+data_stem_output(3,2) %branch_18 lidar
    4 (40.28*per_coeff)+data_stem_output(1,2)+data_stem_output(2,2) %branch_18 dual-cam
    5 (40.28*per_coeff)+data_stem_output(2,2)+data_stem_output(3,2) %branch_18 radar-lidar
    6 (40.31*per_coeff)+data_stem_output(1,2)+data_stem_output(3,2) %branch_18 cam-lidar
    7 (165.06*per_coeff)+data_stem_output(1,2) %branch_50 camera
    8 (165.06*per_coeff)+data_stem_output(2,2) %branch_50 radar
    9 (165.06*per_coeff)+data_stem_output(3,2) %branch_50 lidar
    10 (165.06*per_coeff)+data_stem_output(1,2)+data_stem_output(2,2) %branch_50 dual-cam
    11 (165.06*per_coeff)+data_stem_output(2,2)+data_stem_output(3,2) %branch_50 radar-lidar
    12 (165.06*per_coeff)+data_stem_output(1,2)+data_stem_output(3,2) %branch_50 cam-lidar
    13 (184.05*per_coeff)+data_stem_output(1,2) %branch_101 camera 
    14 (184.05*per_coeff)+data_stem_output(2,2) %branch_101 radar 
    15 (184.05*per_coeff)+data_stem_output(3,2) %branch_101 lidar
    16 (184.05*per_coeff)+data_stem_output(1,2)+data_stem_output(2,2) %branch_101 dual-cam
    17 (184.05*per_coeff)+data_stem_output(2,2)+data_stem_output(3,2) %branch_101 lid-rad
    18 (184.05*per_coeff)+data_stem_output(1,2)+data_stem_output(3,2) %branch_101 cam-lidar
    ];
data_config=[1 (40.20*per_coeff)+ data_stem_output(1,2) (40.20*per_coeff)+data_stem_output(2,2) (40.20*per_coeff)+data_stem_output(3,2) (40.28*per_coeff)+data_stem_output(1,2)+data_stem_output(2,2) (40.28*per_coeff)+data_stem_output(2,2)+data_stem_output(3,2) (40.31*per_coeff)+data_stem_output(1,2)+data_stem_output(3,2) 
    2 (165.06*per_coeff)+data_stem_output(1,2) (165.06*per_coeff)+data_stem_output(2,2) (165.06*per_coeff)+data_stem_output(3,2) (165.06*per_coeff)+data_stem_output(1,2)+data_stem_output(2,2) (165.06*per_coeff)+data_stem_output(2,2)+data_stem_output(3,2) (165.06*per_coeff)+data_stem_output(1,2)+data_stem_output(3,2)
    3 (184.05*per_coeff)+data_stem_output(1,2) (184.05*per_coeff)+data_stem_output(2,2) (184.05*per_coeff)+data_stem_output(3,2) (184.05*per_coeff)+data_stem_output(1,2)+data_stem_output(2,2) (184.05*per_coeff)+data_stem_output(2,2)+data_stem_output(3,2) (184.05*per_coeff)+data_stem_output(1,2)+data_stem_output(3,2)
     ];
 qual_config_sunny=[1 35 45 37 45 50 55 
    2 52 68 55 74 80 82.3 
    3 70 79 71 81.5 81.1 83 
    ];

qual_config_sunny_set=[1 35 %branch_18 camera
    2 45 %branch_18 radar
    3 37 %branch_18 lidar
    4 45 %branch_18 dual-cam
    5 50 %branch_18 radar-lidar
    6 55 %branch_18 cam-lidar
    7 152 %branch_50 camera
    8 68 %branch_50 radar
    9 55 %branch_50 lidar
    10 74 %branch_50 dual-cam
    11 80 %branch_50 radar-lidar
    12 82.3 %branch_50 cam-lidar
    13 70 %branch_101 camera 
    14 79 %branch_101 radar 
    15 71 %branch_101 lidar
    16 81.5 %branch_101 dual-cam
    17 81.1 %branch_101 lid-rad
    18 83 %branch_101 cam-lidar
    ];
    
for i=1:1:3
    k=1;
    for j=2:1:7
    rate(i,k)=data_config(i,j);
    accuracy(i,k)=qual_config_sunny(i,j);
    k=k+1;
    end
end

% figure
% plot(rate);
% xlabel('Config');
% ylabel('Bit rate (bps)')
% figure
% plot(accuracy);
% xlabel('Config');
% ylabel('Accuracy %')



end

