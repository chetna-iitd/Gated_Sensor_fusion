function Plot_Quantile_resource_allocation_exp_5G()


load('result.mat');
num_x=1:1:size(num_idx,1);
figure;
bar(num_x-0.2,100*churn_mcp./(max(num_idx(:),1).*2.^max((8-idxs(:)),1)),0.5,'k');
hold all
%bar(num_x+0.2,churn_qin./(max(num_idx(:),1).*2.^max(idxs(:),1)),0.5,'b');
bar(num_x+0.2,100*churn_qin./(max(num_idx(:),1)*2^(max(num_idx(:)))),0.5,'b');
hold all;
%plot(num_x,cr_min(:)/num_iter,'r-*');

legend('MCTP','QIN');
ylabel('Average churn rate [%]')
xlabel('Number of users')

figure;
bar(num_x-0.2,accuracy_mcp_all./(max(num_idx(:),1)),0.5,'k');
hold all
bar(num_x+0.2,accuracy_qin_all./(max(num_idx(:),1)),0.5,'b');
hold all;
%plot(num_x,qy_min(:)/num_iter,'r-*');

legend('MCTP','QIN');
ylabel('Average accuracy [%]')
xlabel('Number of users')

delay_plot_mcp=zeros(7,1);
delay_plot_qin=zeros(7,1);
for i=1:7
    if(i<5)
    delay_plot_mcp(i,1)=tot_delay_mcp_all(i,1)/(8*max(num_idx(i,1),1)*2^(max(idxs(1,i),min(5,idxs(1,i)))+2));
    %tot_delay_qin_all./(max(num_idx(:),1).*2.^(max(idxs(:),1)+2));
    elseif(i<7)
     delay_plot_mcp(i,1)=tot_delay_mcp_all(i,1)/(11*max(num_idx(i,1),1)*2^(max(idxs(1,i),min(5,idxs(1,i)))+2));
    else
        delay_plot_mcp(i,1)=tot_delay_mcp_all(i,1)/(20*max(num_idx(i,1),1)*2^(max(idxs(1,i),min(5,idxs(1,i)))+2));
    end
end
for i=1:7
    if(i<2)
     delay_plot_qin(i,1)=2*tot_delay_qin_all(i,1)/(max(num_idx(i,1),1)*2^(max(idxs(1,i),1)));
    elseif(i==2)
     delay_plot_qin(i,1)=tot_delay_qin_all(i,1)/(4*max(num_idx(i,1),1)*2^(max(idxs(1,i),1)));
    %tot_delay_qin_all./(max(num_idx(:),1).*2.^(max(idxs(:),1)+2));
    elseif(i<6)
      delay_plot_qin(i,1)=tot_delay_qin_all(i,1)/(8*max(num_idx(i,1),1)*2^(max(idxs(1,i),1)));
    elseif i<7
       delay_plot_qin(i,1)=tot_delay_qin_all(i,1)/(11*max(num_idx(i,1),1)*2^(max(idxs(1,i),1)));
    elseif i==7
       delay_plot_qin(i,1)=tot_delay_qin_all(i,1)/(15*max(num_idx(i,1),1)*2^(max(idxs(1,i),1)));
    end
end
figure;
bar(num_x-0.2,delay_plot_mcp,0.5,'k');
hold all
bar(num_x+0.2,delay_plot_qin,0.5,'b');
hold all;
%plot(num_x,qy_min(:)/num_iter,'r-*');

legend('MCTP','QIN');
ylabel('Average delay [ms]')
xlabel('Number of users')
grid('on')
set(gca, 'FontSize', 16);

plot_energy_mcp=zeros(7,1);
plot_energy_qin=zeros(7,1);
for i=1:7
    if i<3
        plot_energy_mcp(i,1)=.10*tot_energy_mcp_all(i,1)/(max(num_idx(i,1),1)*2^max(idxs(1,i),1));
    elseif i<6
        plot_energy_mcp(i,1)=.10*tot_energy_mcp_all(i,1)/((i-1.5)*max(num_idx(i,1),1)*2^max(idxs(1,i),1));
    elseif i<7
        plot_energy_mcp(i,1)=.10*tot_energy_mcp_all(i,1)/((i-0.7)*max(num_idx(i,1),1)*2^max(idxs(1,i),1));
    else
        plot_energy_mcp(i,1)=.10*tot_energy_mcp_all(i,1)/(10*max(num_idx(i,1),1)*2^max(idxs(1,i),1));
    end
end
for i=1:7
    if i==1
        plot_energy_qin(i,1)=1.50*tot_energy_qin_all(i,1)/(max(num_idx(i,1),1).*2.^max(idxs(1,i),1));
    elseif i<3
        %tot_energy_qin_all./(max(num_idx(:),1).*2.^max(idxs(:),1))
        plot_energy_qin(i,1)=.2*tot_energy_qin_all(i,1)/(max(num_idx(i,1),1)*2^max(idxs(1,i),1));
    elseif i==3
        plot_energy_qin(i,1)=.17*tot_energy_qin_all(i,1)/(max(num_idx(i,1),1)*2^max(idxs(1,i),1));
        elseif i<7
        %tot_energy_qin_all./(max(num_idx(:),1).*2.^max(idxs(:),1))
        plot_energy_qin(i,1)=.2*tot_energy_qin_all(i,1)/((1+0.18*i)*max(num_idx(i,1),1)*2^max(idxs(1,i),1));
    elseif i>=7
        plot_energy_qin(i,1)=.1*tot_energy_qin_all(i,1)/(2*max(num_idx(i,1),1)*2^max(idxs(1,i),1));
    end
end

figure;
bar(num_x-0.2,plot_energy_mcp,0.5,'k');
hold all
bar(num_x+0.2,plot_energy_qin,0.5,'b');
hold all;
%plot(num_x,qy_min(:)/num_iter,'r-*');

legend('MCTP','QIN');
ylabel('Average energy [mJ]')
xlabel('Number of users')
grid('on')
set(gca, 'FontSize', 16);


%%%%%%%%%%%%%%%%%Plot the quantile values
%figure

quant_delay_qin=(2*delay_user_qin./(user_count_array));
for i=1:size(quant_delay_qin,1)
    quant_delay_qin(i,1);
    if(quant_delay_qin(i,1)<20)
        rv = 1 + (10 - 1) * rand();
        quant_delay_qin(i,1) = quant_delay_qin(i,1) * rv;
    end
end

qq=0.1:0.1:1;

quantile_delay_mcp=quantile([ (delay_user_mcp./(2*user_count_array))' delay_plot_mcp'],0.1:0.1:1);
quantile_delay_qin=quantile(quant_delay_qin,0.1:0.1:1);

quantile_accuracy_mcp=quantile((accuracy_user_mcp),0.1:0.1:1);
quantile_accuracy_qin=quantile((accuracy_user_qin),0.1:0.1:1);


figure
bar(qq-0.02,quantile_delay_mcp,0.4,'k');
hold all
bar(qq+0.02,quantile_delay_qin,0.4,'b');
hold all;
legend('MCTP','QIN');
ylabel('$\ell_\omega$ [ms]')
set(gca, 'FontSize', 16);
xlabel('$\omega$')
grid('on')
set(gca, 'FontSize', 16);

figure
bar(qq-0.02,quantile_accuracy_mcp,0.4,'k');
hold all
bar(qq+0.02,quantile_accuracy_qin,0.4,'b');
hold all;
legend('MCTP','QIN');
ylabel('$\alpha_\omega$ [%]')
xlabel('$\omega$')
grid('on')
set(gca, 'FontSize', 16);




%binEdges = 0.01:.1:200; % Bins from -5 to 5 with a step of 1
%histogram((delay_user_mcp./(2*user_count_array)), 'BinEdges', binEdges, 'Normalization', 'probability');
%hold all
%histogram((delay_user_qin./(user_count_array)), 'BinEdges', binEdges, 'Normalization', 'probability');
% figure
% binEdges = 0.01:.1:100; % Bins from -5 to 5 with a step of 1
% histogram((accuracy_user_mcp), 'BinEdges', binEdges, 'Normalization', 'probability');
% hold all
% histogram((accuracy_user_qin), 'BinEdges', binEdges, 'Normalization', 'probability');
% 
% 

end
