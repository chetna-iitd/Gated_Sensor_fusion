function resource_allocation_exp_5G()

file = 'merged_filtered.csv';

% Read the .csv file into a table
dataTable = readtable(file);

% Extract specific columns (for example, columns 2 and 4)
mcs = dataTable{:, 6}; % Assuming MCS is in column 6
signalEntries = dataTable.signal; % Assuming 'Signal' is the name of the column
numericValues = cellfun(@(x) str2double(regexp(x, '-?\d+', 'match')), signalEntries, 'UniformOutput', false);
snr = [numericValues{:}]';
x = 1:numel(mcs); % Assuming x-axis is just the row numbers
num_users_exp = dataTable{:, 9};
% Create the plot
figure;
[ax, h1, h2] = plotyy(x, mcs, x, snr, 'plot');

% Customize the plot
xlabel('Time stamp');
ylabel(ax(1), 'MCS'); % Left y-axis label
ylabel(ax(2), 'RSSI'); % Right y-axis label

% Customize line styles and colors if needed
set(h1, 'LineStyle', '-', 'Color', 'b'); % Left axis data
set(h2, 'LineStyle', '--', 'Color', 'k'); % Right axis data

% Add a legend
legend('MCS', 'SNR');

%figure
%Compares Adaptive with fixed
% FDD mode BW=10MHz 
% %of carriers allocated to application follows the load pattern
%%========spectral efficiency==========
s_e=[0.1523 
0.2344 
0.3770 
0.6010 
0.8770 
1.1758 
1.4766 
1.6141 
2.4063 
2.7305 
3.3223 
3.6023 
4.5234 
5.1152 
5.5547 ];
%%==============SINR threshold===============
sinr_t=[-6.48
-6.66
-4.10
-1.80
0.40
2.42
4.46
6.37
8.46
10.27
12.22
14.12
15.85
17.76
16.81];
%%=============min capacity======================
min_cap=(10^6)*[0.0048 
0.0074 
0.0118 
0.0188 
0.0274 
0.0367 
0.0461 
0.0568 
0.0752 
0.0853 
0.1038 
0.1216 
0.1414 
0.1566 
0.1736 ];%%corresponds to 0.3% carriers
%%============max capacity===================
max_cap=(1/0.6)*(10^6)*[0.6138
1.4064
2.2620
3.6060
5.2620
7.0548
8.8566
11.4846
14.4378
16.3830
16.6338
23.4138
27.1404
30.6612
33.3282];%%corresponds to 60% carriers used

%rate=[];
%rate=rate_360;
num_time=1601;
idxs=1:log2(128);
num_idx=zeros(log2(128),1);
churn_mcp=zeros(size(num_idx,1),1);
qual_mcp=zeros(size(num_idx,1),1);
churn_qin=zeros(size(num_idx,1),1);
qual_qin=zeros(size(num_idx,1),1);
delay_mcp=zeros(size(num_idx,1),1);
energy_mcp=zeros(size(num_idx,1),1);
delay_qin=zeros(size(num_idx,1),1);
energy_qin=zeros(size(num_idx,1),1);
tot_energy_mcp_all=zeros(size(num_idx,1),1);
tot_energy_qin_all=zeros(size(num_idx,1),1);
tot_delay_mcp_all=zeros(size(num_idx,1),1);
tot_delay_qin_all=zeros(size(num_idx,1),1);
accuracy_mcp_all=zeros(size(num_idx,1),1);
accuracy_qin_all=zeros(size(num_idx,1),1);

%accuracy_=zeros(15,num_iter);
%mse_tot_=zeros(15,num_iter);
%counter=1;

%%==========iterations
for time=1:100:num_time%size(num_users_exp,1)
num_users=num_users_exp(time,1);
idx=log2(num_users);
num_idx(idx,1)=num_idx(idx,1)+1;
num_applications=3;
application(1:(num_users),1)=double(uint8(random('unif',1,num_applications,1,num_users)));   %Program
tot_energy_mcp=zeros(num_users,1);
tot_energy_qin=zeros(num_users,1);
tot_delay_mcp=zeros(num_users,1);
tot_delay_qin=zeros(num_users,1);
accuracy_mcp=zeros(num_users,1);
accuracy_qin=zeros(num_users,1);
    for i=1:num_users
        if(application(i,1)==1)
            [tot_energy_mcp(i,1),tot_energy_qin(i,1),tot_delay_mcp(i,1),tot_delay_qin(i,1),accuracy_mcp(i,1),accuracy_qin(i,1)]=qin_sunny_exhaustive_constraint(50,50,num_users);
        end
        if(application(i,1)==2)
            [tot_energy_mcp(i,1),tot_energy_qin(i,1),tot_delay_mcp(i,1),tot_delay_qin(i,1),accuracy_mcp(i,1),accuracy_qin(i,1)]=qin_night_exhaustive_constraint(50,50,num_users);
        end
        if(application(i,1)==3)
            [tot_energy_mcp(i,1),tot_energy_qin(i,1),tot_delay_mcp(i,1),tot_delay_qin(i,1),accuracy_mcp(i,1),accuracy_qin(i,1)]=qin_motorway_exhaustive_constraint(50,50,num_users);
        end

    end
    for i=1:num_users
        %if (accuracy_mcp(i,1)<49 || (tot_delay_mcp(i,1)/num_users)>50)
        if (accuracy_mcp(i,1)<49 || (tot_delay_mcp(i,1)/num_users)>70)
            
            churn_mcp(idx,1)=churn_mcp(idx,1)+(1/num_users);
        end
        if (accuracy_qin(i,1)<49|| (tot_delay_qin(i,1))>50)
            churn_qin(idx,1)=churn_qin(idx,1)+(1/num_users);
        end
    end
tot_energy_mcp_all(idx,1)=tot_energy_mcp_all(idx,1)+sum(tot_energy_mcp(:,1));
tot_energy_qin_all(idx,1)=tot_energy_qin_all(idx,1)+sum(tot_energy_qin(:,1));
tot_delay_mcp_all(idx,1)=tot_delay_mcp_all(idx,1)+sum(tot_delay_mcp(:,1));
tot_delay_qin_all(idx,1)=tot_delay_qin_all(idx,1)+sum(tot_delay_qin(:,1));
accuracy_mcp_all(idx,1)=accuracy_mcp_all(idx,1)+mean(accuracy_mcp(:,1));
accuracy_qin_all(idx,1)=accuracy_qin_all(idx,1)+mean(accuracy_qin(:,1));
end
num_x=1:1:size(num_idx,1);
figure;
bar(num_x-0.2,churn_mcp./(max(num_idx(:),1).*2.^max((8-idxs(:)),1)),0.5,'k');
hold all
%bar(num_x+0.2,churn_qin./(max(num_idx(:),1).*2.^max(idxs(:),1)),0.5,'b');
bar(num_x+0.2,churn_qin./(max(num_idx(:),1)*2^(max(num_idx(:)))),0.5,'b');
hold all;
%plot(num_x,cr_min(:)/num_iter,'r-*');

legend('MCTP','QIN');
ylabel('Average churn rate [%]')
xlabel('Number of users')

figure;
bar(num_x+0.2,accuracy_mcp_all./(max(num_idx(:),1)),0.5,'k');
hold all
bar(num_x-0.2,accuracy_qin_all./(max(num_idx(:),1)),0.5,'b');
hold all;
%plot(num_x,qy_min(:)/num_iter,'r-*');

legend('MCTP','QIN');
ylabel('Average Accuracy [%]')
xlabel('Number of users')

figure;
bar(num_x+0.2,tot_delay_mcp_all./(max(num_idx(:),1).*2.^max(idxs(:),1)),0.5,'k');
hold all
bar(num_x-0.2,tot_delay_qin_all./(max(num_idx(:),1).*2.^max(idxs(:),1)),0.5,'b');
hold all;
%plot(num_x,qy_min(:)/num_iter,'r-*');

legend('MCTP','QIN');
ylabel('Average delay [ms]')
xlabel('Number of users')

figure;
bar(num_x+0.2,tot_energy_mcp_all./(max(num_idx(:),1).*2.^max(idxs(:),1)),0.5,'k');
hold all
bar(num_x-0.2,tot_energy_qin_all./(max(num_idx(:),1).*2.^max(idxs(:),1)),0.5,'b');
hold all;
%plot(num_x,qy_min(:)/num_iter,'r-*');

legend('MCTP','QIN');
ylabel('Average energy [mJ]')
xlabel('Number of users')
save('result.mat')
end
