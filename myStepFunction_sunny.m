function [NextObs,Reward,IsDone,LoggedSignals,tot_energy,compute_energy,communication_energy,compute_delay,communication_delay,accuracy_ret] = myStepFunction_sunny(Action,LoggedSignals)
load('const');
load('num_user.mat');
time_const=delay_constraint;
%accuracy=accuracy_constraint;
% Custom step function to construct cart-pole environment for the function
% name case.
%
% This function applies the given action to the environment and evaluates
% the system dynamics for one simulation step.

% Define the environment constants.

% Max force the input can apply
MaxForce = 1;
% Sample time
Ts = 0.02;

RewardForNotFalling = 0.002;
% Penalty when the cart-pole fails to balance
PenaltyForFalling = -0.002;

% Check if the given action is valid.
if ~ismember(Action,[MaxForce MaxForce+1 MaxForce+2])
    error('Action must be %g for going left and %g for going right.',...
        -MaxForce,MaxForce);
end
Force = Action;

% Unpack the state vector from the logged signals.
State = LoggedSignals.State;

XDot = State(1);
XDotDot = State(2);
ThetaDot = State(3);
ThetaDotDot = State(4);
XDDot= State(5);

ee=[6 140 400];%W energy_weight device es cs
ee_ops=[8.2 38.7 44.8];
w1_1=(1/num_users)*[11 153.4 312];%TOPS device es cs capability delay_weight computation
w3=[30 37 12.6];%communication device es cs nJ/bit
w1_2=num_users*[10 0.00178 0.00022];%communication delay_weight (1/bitrate) nanosec per bit

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
ac2=accuracy(2,:);%(60.32/79.17)*[32.86 43.78 79.17];%%%%memory
mem_constraint=[20000000 400000000 800000000];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

total_layers=1;
flag=0;
for j=3:5
for i=1:6
    ii=randi([1,6],1,1);
    if(accuracy(ii,j)>=accuracy_constraint && accuracy(ii,j)<=max(accuracy_constraint+10,40) && flag==0)
        total_layers=j;
        source=ii;
        flag=1;
    end
%     if(i==3 && flag==0)
%         total_layers=5;
%     end
end
end
%if(flag==0)
flag_=0;
for j=3:5
for i=1:6
    %ii=randi([1,6],1,1);
    if(accuracy(i,j)>=accuracy_constraint && flag_==0)
        total_layers_=j;
        source_=i;
        flag_=1;
    end
%     if(i==3 && flag==0)
%         total_layers=5;
%     end
end
end
if(flag==0 || ops_layer(source,2)>ops_layer(source_,2))
    source=source_;
    total_layers=total_layers_;
end
    
%end
% Cache to avoid recomputation.
%CosTheta = cos(Theta);
%SinTheta = sin(Theta);
%SystemMass = CartMass + PoleMass;
%temp = (Force + PoleMass*HalfPoleLength*ThetaDot*ThetaDot*SinTheta)/SystemMass;

% Apply motion equations.
%ThetaDotDot = (Gravity*SinTheta - CosTheta*temp) / ...
%    (HalfPoleLength*(4.0/3.0 - PoleMass*CosTheta*CosTheta/SystemMass));
%XDotDot  = temp - PoleMass*HalfPoleLength*ThetaDotDot*CosTheta/SystemMass;

% Perform Euler integration.
LoggedSignals.State = abs(max((State + (floor(Ts.*[XDot;XDotDot;ThetaDot;ThetaDotDot;XDDot]))),2));

% Transform state to observation.
NextObs = LoggedSignals.State;

%%
compute_delay=0;
communication_delay=0;
for i=1:5
    if(State(i)<1)
        State(i)=1;
    end
end
%State=ax(State
sum1=0;
for jj=1:total_layers
    k=State(jj);
   %sum1=sum1+1;
 compute_delay=compute_delay+(ops_layer(source,jj)/(w1_1(1,k)*1000000000));
   if(jj>1 && k>State(jj-1))
    communication_delay=communication_delay+(feature_layer(source,jj)*w1_2(1,k)/(10^9))+(feature_layer(source,jj)*w1_2(1,State(jj-1))/(10^9));
   end  
end

compute_delay;
communication_delay;
% Check terminal condition.
%X = NextObs(1);
%Theta = NextObs(3);
%IsDone = abs(X) > DisplacementThreshold || abs(Theta) > AngleThreshold;
time_const;
IsDone = (compute_delay+communication_delay)<time_const;%(5*(10^(-3)));
% Get reward.
if ~IsDone
    Reward = PenaltyForFalling;
    compute_delay+communication_delay;
    State;
else
    Reward = RewardForNotFalling;
    compute_delay+communication_delay;
end
compute_delay+communication_delay;
compute_energy=0;
communication_energy=0;
sum1=0;
for jj=1:total_layers
%for k=1:State(jj)
k=State(jj);
  % sum1=sum1+1;
  % if(sum1<=total_layers+1)%5)
 compute_energy=compute_energy+(ee(1,k)*ops_layer(source,jj)/(w1_1(1,k)*1000000000));    
 %compute_delay=compute_delay+(ops_layer(1,sum1)/(w1_1(1,jj)*1000));
 if(jj>1 && k>State(jj-1))
 communication_energy=communication_energy+(feature_layer(source,jj)*w3(1,k)/1000000000)+(feature_layer(source,jj)*w3(1,k)/1000000000);
 end  
 end
%end
here=0000;
tot_energy=compute_energy+communication_energy;
accuracy_ret=accuracy(source,total_layers);
here=1111;
end