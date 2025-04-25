function [compute_energy1, compute_energy2, communication_energy1, communication_energy2, tot_energy1, tot_energy2,compute_delay,communication_delay,accuracy_ret] = weighted_fn1_night(delay_constraint,accuracy_constraint,num_users)
%WEIGHTED_FN Summary of this function goes here
%   weighted_fn(30,40)

factor=random('uniform',1.1,3);
num_users=num_users*factor;

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
accuracy=[0 0 32.5 44.5 46.9
    0 0 49 52.2 56.4
    0 0 51.3 53 53.2
    0 0 30.6 32.9 36.5
    0 0 51.8 53.4 60.2
    0 0 49.1 52.3 43.2]; %Night
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

w1_2=num_users*[10 0.00178 0.00022];%communication delay_weight (1/bitrate) nanosec per bit
%w1 is delay
%w2 is accuracy
%delay_constraint=30;
%accuracy_constraint=40;
%if((100-delay_constraint)>accuracy_constraint)
%    accuracy_constraint=1;
%end
p=zeros(5,2);
for i=1:5 %layer_num
    if (i==1)%% layer 1 constraint
        w1(i,1)=(ops_layer(1,1)/11000000000);%*6000;
        w1(i,2)=(ops_layer(1,1)/11000000000);%*600;
        w2(i,1)=ac1(1,1);
        w2(i,2)=ac2(1,1);
        we_1(i)=max(0.5*w1(i,1)/delay_constraint,accuracy_constraint/w2(i,1));
        p(1,1)=1;
        p(1,2)=1;
    else
        val_d=ops_layer(1,i)/11000000000;
        val_es=(ops_layer(1,i)/153400000000) + (feature_layer(1,i-1)*w1_2(1,2));
        val_cs=(ops_layer(1,i)/312000000000) + (feature_layer(1,i-1)*w1_2(1,3));
        if(i==3)
        w2(i,1)=ac1(1,2);
        w2(i,2)=ac2(1,2);
        elseif(i==5)
            w2(i,1)=ac1(1,3);
            w2(i,2)=ac2(1,3);
        else
            w2(i,1)=ac1(1,i-1);
            w2(i,2)=ac2(1,i-1);
        end
        w1(i,1)=min([val_d,val_es,val_cs]);%*6000;
        w1(i,2)=min([val_d,val_es,val_cs]);%*600;
        we_1(i)=max(0.5*sum(w1(1:i,1))/delay_constraint,accuracy_constraint/w2(i,1));        
        if(val_d<val_es && (we_1(i)>0.85 || p((i-1),2)>=i) && p((i-1),1)==1)
            p(i,1)=1;     
            if(i<4)
                p(:,2)=min(i,2);
            else
                p(:,2)=min(i,3);
            end
            w1(i,1)=val_d;%*6000;
            w1(i,2)=val_d;%*600;
        elseif(val_d>val_es && (we_1(i)>0.85|| p((i-1),2)>=i) && p((i-1),1)==1)
            p(i,1)=2;     
            if(i<4)
                p(:,2)=min(i,2);
            else
                p(:,2)=min(i,3);
            end
            w1(i,1)=val_es;%*6000;
            w1(i,2)=val_es;%*600;
        elseif(val_es>val_cs && (we_1(i)>0.85 || p((i-1),2)>=i) && p((i-1),1)>=1)
            p(i,1)=3;     
            if(i<4)
                p(:,2)=min(i,2);
            else
                p(:,2)=min(i,3);
            end
            w1(i,1)=val_cs;%*6000;
            w1(i,2)=val_cs;%*600;   
        end        
        we_1(i)=max(sum(0.5*w1(1:i,1))/delay_constraint,accuracy_constraint/w2(i,1));        
    end
end
we_1;
w1./delay_constraint;
accuracy_constraint./w2;
%if(delay_constraint==25 && accuracy_constraint==80)
%p;
%end

ee=[6 140 400];%W energy_weight device es cs
ee_ops=[8.2 38.7 44.8];
w1_1=(1/num_users)*[11 153.4 312];%TOPS device es cs capability delay_weight computation
w3=[30 37 12.6];%communication device es cs nJ/bit

compute_energy=0;
communication_energy=0;
compute_delay=0;
communication_delay=0;
accuracy1=0;
accuracy2=0;

%for k=1:size(config,3)
    ct=p;%config(:,:,k);
    k=1;
    for i=1:5
     if(ct(i,1)~=0)
        compute_energy(1,k)=compute_energy(1,k)+(ee(1,ct(i,1))*ops_layer(6,i)/(w1_1(1,ct(i,1))*1000000000));    
        compute_delay(1,k)=compute_delay(1,k)+(ops_layer(6,i)/(w1_1(1,ct(i,1))*1000000000));
        if(i>1 && ct(i,1)>ct(i-1,1))
        communication_energy(1,k)=communication_energy(1,k)+(feature_layer(6,i-1)*w3(1,ct(i,1))/1000000000)+(feature_layer(6,i-1)*w3(1,ct(i-1,1))/1000000000);
        communication_delay(1,k)=communication_delay(1,k)+(feature_layer(6,i-1)*w1_2(1,ct(i,1))/1000000000);
        end
     end
    end
    accuracy1(1,k)=ac1(1,ct(1,2));
   accuracy2(1,k)=ac2(1,ct(1,2)); 
%end


compute_energy1=compute_energy;%.*6000;
compute_energy2=compute_energy;%.*600;
communication_energy1=communication_energy;%.*6000;
communication_energy2=communication_energy;%.*600;
tot_energy1=compute_energy1+communication_energy1;
tot_energy2=compute_energy2+communication_energy2;
tot_delay1=(compute_delay+communication_delay);%*6000;
tot_delay2=(compute_delay+communication_delay);%*600;
accuracy_ret=max(accuracy1(1,:),accuracy2(1,:));

end

