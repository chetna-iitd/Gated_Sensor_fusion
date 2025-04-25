function [tot_energy_mcp,tot_energy_qin,tot_delay_mcp,tot_delay_qin,accuracy_mcp,accuracy_qin] = qin_sunny_exhaustive_constraint(delay,accuracy_con,num_users)
%%[a,b,c,d,e,f]=qin_sunny_exhaustive_constraint(50,50,2)
%delay=20;
%accuracy_con=50;
compute_energy1=zeros(size(delay,2),size(accuracy_con,2));
compute_energy2=zeros(size(delay,2),size(accuracy_con,2));
communication_energy1=zeros(size(delay,2),size(accuracy_con,2)); 
communication_energy2=zeros(size(delay,2),size(accuracy_con,2));
tot_energy1=zeros(size(delay,2),size(accuracy_con,2));
tot_energy2=zeros(size(delay,2),size(accuracy_con,2));

compute_energy1_qin=zeros(size(delay,2),size(accuracy_con,2));
compute_energy2_qin=zeros(size(delay,2),size(accuracy_con,2));
communication_energy1_qin=zeros(size(delay,2),size(accuracy_con,2)); 
communication_energy2_qin=zeros(size(delay,2),size(accuracy_con,2));
tot_energy1_qin=zeros(size(delay,2),size(accuracy_con,2));
tot_energy2_qin=zeros(size(delay,2),size(accuracy_con,2));

tot_energy_qin=zeros(size(delay,2),size(accuracy_con,2));
compute_energy_qin=zeros(size(delay,2),size(accuracy_con,2));
communication_energy_qin=zeros(size(delay,2),size(accuracy_con,2));

communication_delay_mcp=zeros(size(delay,2),size(accuracy_con,2));
compute_delay_mcp=zeros(size(delay,2),size(accuracy_con,2));
communication_delay_qin=zeros(size(delay,2),size(accuracy_con,2));
compute_delay_qin=zeros(size(delay,2),size(accuracy_con,2));
accuracy_qin=zeros(size(delay,2),size(accuracy_con,2));
accuracy_mcp=zeros(size(delay,2),size(accuracy_con,2));


for i=1:1:size(delay,2) %delay
    for j=1:1:size(accuracy_con,2) %accuracy
        save('num_user.mat','num_users');
[tot_energy_qin(i,j),compute_energy_qin(i,j),communication_energy_qin(i,j),compute_delay_qin(i,j),communication_delay_qin(i,j),accuracy_qin(i,j)]=policy_gradient1_sunny(delay(1,i),accuracy_con(1,j),num_users);
[compute_energy1(i,j), compute_energy2(i,j), communication_energy1(i,j), communication_energy2(i,j), tot_energy1(i,j), tot_energy2(i,j),compute_delay_mcp(i,j),communication_delay_mcp(i,j),accuracy_mcp(i,j)]=weighted_fn1_sunny(delay(1,i),accuracy_con(1,j),num_users);
%[compute_energy1_ifg(i,j), compute_energy2_ifg(i,j), communication_energy1_ifg(i,j), communication_energy2_ifg(i,j), tot_energy1_ifg(i,j), tot_energy2_ifg(i,j)]=ifg_high(delay(1,i)*10^-3,accuracy(1,j));
%%qin

%[a,b,c,d,e,f]=qin(delay(1,i),accuracy(1,j));
compute_energy1_qin(i,j)=compute_energy_qin(i,j);
compute_energy2_qin(i,j)=compute_energy_qin(i,j);
communication_energy1_qin(i,j)=communication_energy_qin(i,j);
communication_energy2_qin(i,j)=communication_energy_qin(i,j);
tot_energy1_qin(i,j)=tot_energy_qin(i,j);
tot_energy2_qin(i,j)=tot_energy_qin(i,j);
    end
end

tot_energy11=tot_energy2;


tot_energy_mcp=tot_energy11;
tot_energy_qin=tot_energy1_qin;
tot_delay_mcp=compute_delay_mcp+communication_delay_mcp;
tot_delay_qin=compute_delay_qin+communication_delay_qin;
accuracy_qin;
accuracy_mcp;


% 
% best_communication_e+best_compute_e
% best_commun_enery_d+best_compute_energy_d