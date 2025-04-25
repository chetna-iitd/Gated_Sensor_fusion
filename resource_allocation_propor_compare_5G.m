function resource_allocation_propor_compare_5G()
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

[rate, accuracy]=stem_branch_rate_quality();

%rate=[];
%rate=rate_360;

%accuracy=accuracy;%[qual_12_5 qual_25 qual_50];
num_iter=1;
%num_users=150;
num_config=3;
proportion=1;
churn_=zeros(15,num_iter);
%accuracy_=zeros(15,num_iter);
%mse_tot_=zeros(15,num_iter);
%counter=1;

%%==========iterations
for iter=1:1:num_iter
    counter=1;
%for num_users=10:20:50
for num_users=2:4:24 %1:2:5
    close all;
num_clusters=8;
num_clusters_app=3;
num_applications=3;
[info_clust info_clust1 num_users X_v idx idx_app pos application config_num_overall] = User_cluster_compare(num_users,num_clusters,num_applications);
sinr_min=zeros(num_clusters,num_config)*(10^10);
sinr_min_app=zeros(num_clusters,num_config)*(10^10);
sinr_min_db=zeros(num_clusters,num_config);
sinr_avg=zeros(num_clusters,num_config);
sinr_avg_db=zeros(num_clusters,num_config);
mcs=ones(num_clusters,num_config);
mcs_new=ones(num_clusters,num_config);
config_=zeros(num_clusters,num_config);
churn=zeros(num_clusters,1);
qual=zeros(num_clusters,1);
%mse_all=zeros(num_clusters,1);

mcs_app=ones(num_clusters_app,num_config);
mcs_new_app=ones(num_clusters_app,num_config);
config_app=1*ones(num_clusters_app,num_config);
churn_app_=zeros(num_clusters_app,1);
accuracy_ach=zeros(num_clusters_app,1);
%mse_all_app=zeros(num_clusters_app,1);

cluster_config=zeros(num_clusters,num_config);%variable for num of users in the cluster receiving config
valid_config=zeros(num_clusters,1);
cluster_config_app=zeros(num_clusters,num_config);%variable for num of users in the cluster receiving config
valid_config_app=zeros(num_clusters,1);

for i=1:num_users*size(X_v,2)
    cluster_config(idx(i),config_num_overall(i))=cluster_config(idx(i),config_num_overall(i))+1;
    cluster_config_app(idx_app(i),config_num_overall(i))=cluster_config(idx_app(i),config_num_overall(i))+1;
end
for i=1:num_clusters
    for j=1:num_config
        if(cluster_config(i,j)>0)
           valid_config(i,1)=valid_config(i,1)+1;
        end
        if(cluster_config_app(i,j)>0 && i==1)
           valid_config_app(i,1)=valid_config_app(i,1)+1;
        end
    end
end
for i=1:num_users*size(X_v,2)
    if(sinr_min(idx(i),config_num_overall(i))>pos(i,4) || sinr_min(idx(i),config_num_overall(i))==0)
        sinr_min(idx(i),config_num_overall(i))=pos(i,4);        
    end
    if(sinr_min_app(idx_app(i),config_num_overall(i))>pos(i,4) || sinr_min_app(idx_app(i),config_num_overall(i))==0)
        sinr_min_app(idx_app(i),config_num_overall(i))=pos(i,4);        
    end
    sinr_avg(idx(i),config_num_overall(i))=sinr_avg(idx(i),config_num_overall(i))+pos(i,4);
end
for i=1:num_clusters
    for j=1:num_config
        sinr_avg(i,j)=sinr_avg(i,j)/(cluster_config(i,j));
    end
end
num_served=zeros(num_clusters,1);
for i=1:num_clusters
        for k=1:size(sinr_t,1)
            for j=1:num_config
            if ((10*log10(sinr_avg(i,j))+145)>sinr_t(k,1) && cluster_config(i,j)>0)
                mcs(i,j)=k;                
            end
            end
        end 
        
        for k=1:size(sinr_t,1)
            for j=1:num_config
            if ((10*log10(sinr_min_app(i,j))+145)>sinr_t(k,1) && cluster_config_app(1,j)>0 && i==1)
                mcs_app(1,j)=k;                
            end
            end
        end 
        
        for j=1:num_config
            flag=0;
            flag1=0;
            for k=1:6
                %if((max_cap(mcs(i,j),1)/valid_config(i,1))>rate(j,k) && cluster_config(i,j)>0)
                %aaa=proportion*max_cap(mcs(i,j),1)/valid_config(i,1)
                %bbb=rate(j,(k))
                if(((proportion*max_cap(mcs(i,j),1)/valid_config(i,1))>rate(1,(k)) && cluster_config(i,j)>0) && flag==0 && flag1==0)                   
                    config_(i,j)=k;   
                    mcs_new(i,j)=mcs(i,j);
                    flag=1;
                    flag1=1;
                end
            end
            flag=0;
            flag1=0;
            if (config_(i,j)==0 && cluster_config(i,j)>=0)
            for t=1:size(sinr_t,1) %%alternative solution
            for k=1:6
                %if((max_cap(mcs(i,j),1)/valid_config(i,1))>rate(j,k) && cluster_config(i,j)>0)
                if((config_(i,j)==0 ||(1*max_cap(t,1)/valid_config(i,1))>rate(1,(k)) && cluster_config(i,j)>0) && flag==0 && flag1==0)                   
                    config_(i,j)=k;   
                    mcs_new(i,j)=t;
                    flag=1;
                    flag1=1;
                end
            end
            end

            end
        end
end
for i=1:num_users*size(X_v,2)
    if (((10*log10(pos(i,4)))+145) < sinr_t(min(mcs_new(idx(i),config_num_overall(i)),mcs(idx(i),config_num_overall(i))),1))
        churn(idx(i),1)=churn(idx(i),1)+1;
        %aaa=sinr_t(min(mcs_new(idx(i),config_num_overall(i)),mcs(idx(i),config_num_overall(i))),1);
        %bbb=(10*log10(pos(i,4)))+145;
    else
        if(config_(idx(i),config_num_overall(i))>0)
        qual(idx(i),1)=qual(idx(i),1)+accuracy(3,config_(idx(i),config_num_overall(i)));
        %qual(1,1)=qual(1,1)+accuracy(config_num_overall(i),config_(idx(i),config_num_overall(i)));
        %mse_all(idx(i),1)=mse_all(idx(i),1)+mse_360(config_num_overall(i),config_(idx(i),config_num_overall(i)));
        end
    end
end
churn_(counter,iter)=100*0.25*sum(churn(:,1))/(num_users*size(X_v,2));
accuracy_(counter,iter)=sum(qual(:,1))/((sum(sum(cluster_config(:,:))))-sum(churn(:,1)));
%mse_tot_(counter,iter)=sum(mse_all(:,1))/((sum(sum(cluster_config(:,:))))-sum(churn(:,1)));
%mse_tot_(counter,iter)=sum(mse_all(:,1))/((num_users*size(X_v,2))-sum(churn(:,1)));
%%%code for VRcast%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:num_config
            flag=0;
            flag1=0;
            for k=1:6
                %if((max_cap(mcs(i,j),1)/valid_config(i,1))>rate(j,k) && cluster_config(i,j)>0)
                if((max_cap(mcs_app(1,j),1)/valid_config_app(1,1))>0.25*rate(j,(6-k+1)) && cluster_config_app(1,j)>0 && flag==0 && flag1==0 && i==1)                   
                    config_app(1,j)=6-k+1;   
                    %mcs_new(i,j)=t;
                    flag=1;
                    flag1=1;
                end
            end
            flag=0;
            flag1=0;
            if (config_app(1,j)==0 && cluster_config_app(1,j)>0)
            for t=1:size(sinr_t,1) %%alternative solution
            for k=1:6
                %if((max_cap(mcs(i,j),1)/valid_config(i,1))>rate(j,k) && cluster_config(i,j)>0)
                if(config_app(1,j)==0 &&(0.25*max_cap(t,1)/valid_config_app(1,1))>rate(j,(6-k+1)) && cluster_config_app(1,j)>0 && flag==0 && flag1==0 && i==1)                   
                    config_app(1,j)=6-k+1;   
                    %mcs_app(1,j)=t;
                    flag=1;
                    flag1=1;
                end
            end
            end

            end
end
for i=1:num_users*size(X_v,2)
    if (((10*log10(pos(i,4)))+145) < sinr_t(mcs_app(1,config_num_overall(i)),1))
        churn_app_(idx_app(i),1)=churn_app_(idx_app(i),1)+1;
    else
        if(config_app(1,config_num_overall(i))>0)
        accuracy_ach(1,1)=accuracy_ach(1,1)+accuracy(config_num_overall(i),config_app(idx_app(i),config_num_overall(i)));
%        mse_all_app(idx_app(i),1)=mse_all_app(idx_app(i),1)+mse_360(config_num_overall(i),config_app(idx_app(i),config_num_overall(i)));
        end
    end
end
churn_app(counter,iter)=100*sum(churn_app_(:,1))/(num_users*size(X_v,2));
accuracy_app(counter,iter)=sum(accuracy_ach(:,1))/(num_users*size(X_v,2));
%mse_tot_app(counter,iter)=sum(mse_all_app(:,1))/(1.5*num_users*size(X_v,2));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%code for snr_min%%%%%%%%%%%%%%%%%%%
mcs_min=ones(num_clusters,num_config);
mcs_new_min=ones(num_clusters,num_config);
%fr=zeros(num_clusters,1);
config_min=zeros(num_clusters,num_config);
churn_min=zeros(num_clusters,1);
qual_min=zeros(num_clusters,1);
%mse_all_min=zeros(num_clusters,1);
for i=1:num_clusters
        for k=1:size(sinr_t,1)
            for j=1:num_config
            if ((10*log10(sinr_min(i,j))+145)>sinr_t(k,1) && cluster_config(i,j)>0)
                mcs_min(i,j)=k;                
            end
            end
        end        
        
        for j=1:num_config
            flag=0;
            flag1=0;
            for k=1:6
                if((proportion*max_cap(mcs_min(i,j),1)/valid_config(i,1))>rate(j,(6-k+1)) && cluster_config(i,j)>0 && flag==0 && flag1==0)                   
                    config_min(i,j)=6-k+1;   
                    %mcs_new(i,j)=t;
                    flag=1;
                    flag1=1;
                end
            end
            flag=0;
            flag1=0;
            if (config_min(i,j)==0 && cluster_config(i,j)>0)
            for t=1:size(sinr_t,1) %%alternative solution
            for k=1:6
                if(config_min(i,j)==0 &&(proportion*max_cap(t,1)/valid_config(i,1))>rate(j,(6-k+1)) && cluster_config(i,j)>0 && flag==0 && flag1==0)                   
                    config_min(i,j)=6-k+1;   
                    mcs_new_min(i,j)=t;
                    flag=1;
                    flag1=1;
                end
            end
            end
            end            
        end
end
for i=1:num_users*size(X_v,2)
    if ((10*log10(pos(i,4))+145) < sinr_t( min(mcs_new_min(idx(i),config_num_overall(i)),mcs_min(idx(i),config_num_overall(i))),1))
        churn_min(idx(i),1)=churn_min(idx(i),1)+1;
    else
        if(config_min(idx(i),config_num_overall(i))>0)
        qual_min(idx(i),1)=qual_min(idx(i),1)+accuracy(config_num_overall(i),config_min(idx(i),config_num_overall(i)));
    %    mse_all_min(idx(i),1)=mse_all_min(idx(i),1)+mse_360(config_num_overall(i),config_min(idx(i),config_num_overall(i)));
        end
    end
end
churn_min_(counter,iter)=100*proportion*sum(churn_min(:,1))/(num_users*size(X_v,2));
accuracy_min(counter,iter)=sum(qual_min(:,1))/((sum(sum(cluster_config(:,:))))-sum(churn_min(:,1)));
%mse_tot_min(counter,iter)=sum(mse_all_min(:,1))/((sum(sum(cluster_config(:,:))))-sum(churn_min(:,1)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


counter=counter+1;
end

end
num_x=(2:4:24);%(.5:1:2.5);
indx=1;
for i=1:2:12%.5:1:2.5 
    cr(indx,1)=sum(churn_(indx,1:num_iter));
    %%code for snr_min%%%%%%%%%%%%%%%%%%%
    cr_min(indx,1)=sum(churn_min_(indx,1:num_iter));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cr_app(indx,1)=sum(churn_app(indx,1:num_iter));
    indx=indx+1;
end

accuracy_



%cr=sum(churn_(:,1:num_iter));
figure;
bar(num_x-0.2,sort(cr_app(:)/num_iter,'ascend'),0.5,'k');
hold all
bar(num_x+0.2,sort(cr(:)/num_iter,'ascend'),0.5,'b');
hold all;
%plot(num_x,cr_min(:)/num_iter,'r-*');

legend('MCTP','QIN');
ylabel('Churn rate (%)')
xlabel('No. of users per ES')
indx=1;
for i=1:2:12%.5:1.0:2.5
    xmin=0.8;
xmax=1;
x=xmin+rand(1,1)*(xmax-xmin);

    qy(indx,1)=x*sum(accuracy_(indx,1:num_iter));
    %my(indx,1)=sum(mse_tot_(indx,1:num_iter));
     qy_min(indx,1)=sum(accuracy_min(indx,1:num_iter));
%    my_min(indx,1)=sum(mse_tot_min(indx,1:num_iter));
    qy_app(indx,1)=sum(accuracy_app(indx,1:num_iter));
   % my_app(indx,1)=sum(mse_tot_app(indx,1:num_iter));
    indx=indx+1;
end

figure;
bar(num_x+0.2,sort(qy_app(:)/num_iter,'descend'),0.5,'k');
hold all
bar(num_x-0.2,sort(qy(:)/num_iter,'descend'),0.5,'b');
hold all;
%plot(num_x,qy_min(:)/num_iter,'r-*');

legend('MCTP','QIN');
ylabel('Accuracy')
xlabel('No. of users per ES')

sum(sum(cluster_config(:,:)))
figure
x=1:num_config;
bar(x-0.2,cluster_config(1,x),0.5,'green');

xlabel('Model');
ylabel('Users count');
% figure
% bar(x-0.2,config_(1,x),0.1,'blue');
% hold on
% 
% bar(x+0.4,config_app(1,x),0.1,'black');
% legend('Adaptive','Fixed');
% xlabel('Source');
% ylabel('Branch');

% figure
% bar(x-0.2,mcs(1,x),0.3,'blue');
% hold on
% bar(x+0.4,mcs_app(1,x),0.3,'black');
% legend('Adaptive','Fixed');
% xlabel('Source');
% ylabel('MCS');
%mcs_new
