function [InitialObservation, LoggedSignal] = myResetFunction_sunny()
% Reset function to place custom cart-pole environment into a random
% initial state.
ee=[6 140 400];%W energy_weight device es cs
ee_ops=[8.2 38.7 44.8];
w1_1=[11 153.4 312];%TOPS device es cs capability delay_weight computation
w3=[30 37 12.6];%communication device es cs nJ/bit
w1_2=[10 0.00178 0.00022];%communication delay_weight (1/bitrate) nanosec per bit

ops_layer = (10^9)*[0 1.776 10.88 31.69 49.83 
    0 15.5 57.93 118.3 110.47
    0 2.95 11.50 33.05 21.65
    0 17.276 135.4 355.9 256.6
    0 18.45 293.3 808.3 615.4
    0 4.726 143.3 399 238.9];
%ops_layer=[camera_only stem branch1Res18 branch1Res50 branch1Res101
% radar_only stem branch2Res18 branch2Res50 branch1Res101
% lidar_only stem branch3Res18 branch3Res50 branch3Res101
% camera_rad stem+stem branch4Res18 branch4Res50 branch4Res101
% rad_lid stem+stem branch5Res18 branch5Res50 branch5Res101
% lid_camera stem+stem branch6Res18 branch6Res50 branch6Res101]
accuracy=[0 0 35 52 70
    0 0 45 68 79
    0 0 37 55 71
    0 0 45 74 81.5
    0 0 50 80 81.1
    0 0 55 82.3 83];
%accuracy=[cam+stem+branch1Res18 cam+stem+branch1Res50 cam+stem+branch1Res101
% rad+stem+branch2Res18 rad+stem+branch2Res50 rad+stem+branch1Res101
% lid+stem+branch3Res18 lid+stem+branch3Res50 lid+stem+branch3Res101
% cam_rad+stem+stem+branch4Res18 cam_rad+stem+stem+branch4Res50 cam_rad+stem+stem+branch4Res101
% rad_lid+stem+stem+branch5Res18 rad_lid+stem+stem+branch5Res50 rad_lid+stem+stem+branch5Res101
% lid_cam+stem+stem+branch6Res18 lid_cam+stem+stem+branch6Res50 lid_cam+stem+stem+branch6Res101]
feature_layer = [(672*376*24) (64*168*94*32*(10^6)) 40.20*32*(10^6) 165.06*32*(10^6) 184.05*32*(10^6)
    (1152*1152*24) (64*288*288*32*(10^6)) 40.20*32*(10^6) 165.06*32*(10^6) 184.05*32*(10^6)
    (672*376*24)  (64*168*94*32*(10^6)) 40.20*32*(10^6) 165.06*32*(10^6) 184.05*32*(10^6)
    (672*376*24)+(1152*1152*24)  (64*168*94*32*(10^6))+(64*288*288*32*(10^6)) 40.28*32*(10^6) 165.06*32*(10^6) 184.05*32*(10^6)
    (1152*1152*24)+(672*376*24)  (64*168*94*32*(10^6))+(64*288*288*32*(10^6)) 40.28*32*(10^6) 165.06*32*(10^6) 184.05*32*(10^6)
    (672*376*24)+(672*376*24)  (64*168*94*32*(10^6))+(64*168*94*32*(10^6)) 40.31*32*(10^6) 165.06*32*(10^6) 184.05*32*(10^6)];  




mem_layer=[feature_layer];
ac1=accuracy(1,:);
ac2=accuracy(2,:);%(60.32/79.17)*[32.86 43.78 79.17];

%%%%memory
mem_constraint=[2000000000 400000000000 800000000000];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Theta (randomize)
T0=1;
Td0=1;
X0=1;
Xd0=1;
Xdd0=1;

if(mem_layer(1,T0)<mem_constraint(1,T0))
    T0 = randi([1,2],1,1);
end
% Thetadot
if(mem_layer(1,Td0)<mem_constraint(1,Td0))
    Td0 =randi([min(T0,1),2],1,1);
end
% X
if(mem_layer(1,X0)<mem_constraint(1,X0))
    X0 = max(randi([min(1,Td0),2],1,1),Td0);
end
% Xdot
if(mem_layer(1,Xd0)<mem_constraint(1,Xd0))
    Xd0 = max(randi([min(1,X0),2],1,1),X0);
    Xdd0= max(randi([min(1,X0),2],1,1),Xd0);
    
end


here=1111;
% Return initial environment state variables as logged signals.
LoggedSignal.State = [X0;Xd0;T0;Td0;Xdd0];
InitialObservation = LoggedSignal.State;

end

