function [info_clust info_clust1 num_users X_v idx idx_vr pos application config_num_overall] = User_cluster_compare(num_users,num_clusters,num_applications)
%%360degree video parameters
config_hori_num = 1;
config_ver_num = 3;
%%==========================MBMS grid=======================================
Rad3Over2 = sqrt(3) / 2;
[X Y] = meshgrid(0:1:11);
n = size(X,1);
X = Rad3Over2 * X;
Y = Y + repmat([0 0.5],[n,n/2]);
% Plot the hexagonal mesh, including cell borders
[XV YV] = voronoi(X(:),Y(:)); plot(XV,YV,'k-');
XV;
YV;
X;
Y;
%axis equal, 
%axis([4.5 7.5 4 8]), zoom on
axis([2.5 9 3.5 9.5]), zoom on
%figure;
hold on

X1=[4.619   4.907   5.485   5.774   5.485   4.907];
Y1=[7   7.5    7.5  7   6.5 6.5];
h= fill(X1,Y1,[0.9 0.9 0.9]);
set(h,'edgecolor','k','linewidth',2.0)
X_v=[X1'];
Y_v=[Y1'];
for i=0:3
    X_=X1;
    Y_=Y1-i;
    h= fill(X_,Y_,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    if i>0
    X_v=[X_v X_'];
    Y_v=[Y_v Y_'];
    end
    X_=X1-0.85;
    Y_=Y1-i-0.5;
    h= fill(X_,Y_,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
            X_=X1-0.85;
    Y_=Y1+i+0.5;
        h= fill(X_,Y1+i+0.5,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
            X_=X1+0.85;
    Y_=Y1-i-0.5;
     h= fill(X_,Y1-i-0.5,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
       X_=X1+0.85;
    Y_=Y1+i+0.5;
        h= fill(X_,Y1+i+0.5,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
    
        X_=X1-1.733;
    Y_=Y1-i;
    h= fill(X1-1.733,Y1-i,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
    X_=X1-1.733;
    Y_=Y1+i;
        h= fill(X1-1.733,Y1+i,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
    X_=X1+1.733;
    Y_=Y1-i;
     h= fill(X1+1.733,Y1-i,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
    X_=X1+1.733;
    Y_=Y1+i;
        h= fill(X1+1.733,Y1+i,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
        if i>0
        X_=X1;
        Y_=Y1+i;
    h= fill(X1,Y1+i,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
        end
    for j=1:3
    if mod(j,2)==0
        X_=X1-1.733*j;
        Y_=Y1-i;
        h= fill(X_,Y_,[0.9 0.9 0.9]);
        set(h,'edgecolor','k','linewidth',2.0)
        X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
        X_=X1-1.733*j;
        Y_=Y1+i;
        h= fill(X_,Y_,[0.9 0.9 0.9]);
        set(h,'edgecolor','k','linewidth',2.0)
        X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
    end
    if mod(j,2)==1
        X_=X1-0.866*j;
        Y_=Y1-i-0.5;
        h= fill(X_,Y_,[0.9 0.9 0.9]);
        set(h,'edgecolor','k','linewidth',2.0)
        X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
        X_=X1-0.866*j;
        Y_=Y1+i+0.5;
        h= fill(X_,Y_,[0.9 0.9 0.9]);
        set(h,'edgecolor','k','linewidth',2.0)
        X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
    end
    
    if mod(j,2)==0
        X_=X1+1.733*j;
        Y_=Y1+i;
    h= fill(X1+1.733*j,Y1+i,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
        X_=X1+1.733*j;
        Y_=Y1-i;
    h= fill(X1+1.733*j,Y1-i,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
    end
     if mod(j,2)==1
         X_=X1+0.866*j;
         Y_=Y1+i+0.5;
    h= fill(X1+0.866*j,Y1+i+0.5,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
         X_=X1+0.866*j;
         Y_=Y1-i-0.5;
    h= fill(X1+0.866*j,Y1-i-0.5,[0.9 0.9 0.9]);
    set(h,'edgecolor','k','linewidth',2.0)
    X_v=[X_v X_'];
        Y_v=[Y_v Y_'];
     end
    end
end
% X2=X1;
% Y2=Y1-1.0;
% h= fill(X2,Y2,[0.9 0.9 0.9]);
% set(h,'edgecolor','k','linewidth',2.0)
% X3=X1;
% Y3=Y2-1.0;
% h= fill(X3,Y3,[0.9 0.9 0.9]);
% set(h,'edgecolor','k','linewidth',2.0)
% 
% X4=X1+1.733;
% Y4=Y1;
% h= fill(X4,Y4,[0.9 0.9 0.9]);
% set(h,'edgecolor','k','linewidth',2.0)
% X5=X2+1.733;
% Y5=Y2;
% h= fill(X5,Y5,[0.9 0.9 0.9]);
% set(h,'edgecolor','k','linewidth',2.0)
% X6=X3+1.733;
% Y6=Y3;
% h= fill(X6,Y6,[0.9 0.9 0.9]);
% set(h,'edgecolor','k','linewidth',2.0)
% 
% X7=X1+0.866;
% Y7=Y1+0.5;
% h= fill(X7,Y7,[0.9 0.9 0.9]);
% set(h,'edgecolor','k','linewidth',2.0)
% X8=X7;
% Y8=Y7-1.0;
% h= fill(X8,Y8,[0.9 0.9 0.9]);
% set(h,'edgecolor','k','linewidth',2.0)
% X9=X7;
% Y9=Y8-1.0;
% h= fill(X9,Y9,[0.9 0.9 0.9]);
% set(h,'edgecolor','k','linewidth',2.0)
% X10=X7;
% Y10=Y9-1.0;
% h= fill(X10,Y10,[0.9 0.9 0.9]);
% set(h,'edgecolor','k','linewidth',2.0)
% X11=X1-0.9;
% Y11=Y8;
% h= fill(X11,Y11,[0.9 0.9 0.9]);
% set(h,'edgecolor','k','linewidth',2.0)
% 
% X_v=[X1' X2' X3' X4' X5' X6' X7' X8' X9' X10' X11'];
% Y_v=[Y1' Y2' Y3' Y4' Y5' Y6' Y7' Y8' Y9' Y10' Y11'];
hold all;
size(X_v,2)
test=imread('BS.jpg');
for i=1:size(X_v,2)
    x_val=((X_v(1,i)+X_v(4,i))/2);
    y_val=Y_v(1,i);
    image([x_val+0.15 x_val-0.15],[y_val+0.3 y_val-0.1],test);
    hold all;
end
%%%%%%%%%%%________________________________LTE BS image
% test=imread('BS.jpg');
% for i=1:size(X_v,2)
%     x_val=((X_v(1,i)+X_v(4,i))/2);
%     y_val=Y_v(1,i);
%     image([x_val+0.15 x_val-0.15],[y_val+0.3 y_val-0.1],test);
%     %hold all;
% end
%%==============================================================
%%%%%%________________________________

pos=zeros((num_users*size(X_v,2)),8);
type=zeros((num_users*size(X_v,2)),1);
application=zeros((num_users*size(X_v,2)),1);
config_num_hor=zeros((num_users*size(X_v,2)),1);
config_num_ver=zeros((num_users*size(X_v,2)),1);
config_num_overall=zeros((num_users*size(X_v,2)),1);
for k=1:size(X_v,2)
   temp=((k-1)*num_users)+1;
   pos(temp:(k*num_users),1)=random('unif',X_v(1,k),X_v(4,k),1,num_users);%position x
   pos(temp:(k*num_users),2)=random('unif',Y_v(5,k),Y_v(2,k),1,num_users);%position y
   type(temp:(k*num_users),1)=uint8(random('unif',1,3,1,num_users));   %User type   
   application(temp:(k*num_users),1)=double(uint8(random('unif',1,num_applications,1,num_users)));   %Program
   config_num_overall(temp:(k*num_users),1)=double(uint8(random('unif',1,(config_hori_num*config_ver_num),1,num_users)));   %Program
   %config_num_ver(temp:(k*num_users),1)=double(uint8(random('unif',1,config_ver_num,1,num_users)));   %Program
end
for i=1:size(X_v,2)
    start=((i-1)*num_users);    
    for j=1:num_users
        pos(start+j,3)=sqrt(((pos(start+j,1)-((X_v(1,i)+X_v(4,i))/2))*(pos(start+j,1)-((X_v(1,i)+X_v(4,i))/2)))+((pos(start+j,2)-((Y_v(5,i)+Y_v(2,i))/2))*(pos(start+j,2)-((Y_v(5,i)+Y_v(2,i))/2))));
    end
end

pos(:,4)=accurate_SINR_user(pos, pos(:,3), num_users*size(X_v,2)); %%% obtain SINR
%pos(:,4)=alt_SINR_user(pos, pos(:,3), num_users*size(X_v,2)); %%% obtain SINR

%%==================k-means clsutering====================
%[idx,C] = kmeans([pos(:,1) pos(:,2) pos(:,3) application(:) type(:) config_num_overall(:)],num_clusters,'emptyaction','singleton');
[idx,C] = kmeans([pos(:,1) pos(:,2) ],num_clusters,'emptyaction','singleton');
[idx_vr,C_vr] = kmeans([pos(:,1) pos(:,2) ],1,'emptyaction','singleton');
while length(unique(idx))<3 ||  histc(histc(idx,[1 2 3]),1)~=0
% i.e. while one of the clusters is empty -- or -- we have one or more clusters with only one member
%[idx,C] = kmeans([double(pos(:,1)) double(pos(:,2)) pos(:,3) application(:) type(:) config_num_overall(:)],num_clusters,'emptyaction','singleton');
[idx,C] = kmeans([double(pos(:,1)) double(pos(:,2))],num_clusters,'emptyaction','singleton');
[idx_vr,C_vr] = kmeans([double(pos(:,1)) double(pos(:,2))],1,'emptyaction','singleton');
end      
%%============plotting the clustered users======================    
for i=1:(size(X_v,2)*num_users)
    if(idx(i)==1)
      h=stem(pos(i,1),pos(i,2),'diamond','color',[0 0 0],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[0 0 0]);
    elseif(idx(i)==2)
      h=stem(pos(i,1),pos(i,2),'square','color',[1 0 0],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[1 0 0]);
    elseif(idx(i)==3)
      h=stem(pos(i,1),pos(i,2),'x','color',[0.1 1 0.1],'linestyle','none','MarkerSize',6);
      set(h,'MarkerFaceColor',[0.1 1 0.1]);
    elseif(idx(i)==4)
      h=stem(pos(i,1),pos(i,2),'diamond','color',[0 0 1],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[0 0 1]);
    elseif(idx(i)==5)
      h=stem(pos(i,1),pos(i,2),'*','color',[0 1 1],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[0 1 1]);
    elseif(idx(i)==6)
      h=stem(pos(i,1),pos(i,2),'+','color',[0 1 0],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[0 1 0]);
    elseif(idx(i)==7)
      h=stem(pos(i,1),pos(i,2),'X','color',[1 0 1],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[1 0 1]);
    elseif(idx(i)==8)
      h=stem(pos(i,1),pos(i,2),'square','color',[1 1 0],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[1 1 0]);
      else
      h=stem(pos(i,1),pos(i,2),'+','color',[0 0 1],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[0 0 1]);
    end
end
info_clust=zeros(num_clusters,4);%%1=num_users, 2,3,4=type, 
%%%Cluster Information %%% type
for i=1:(size(X_v,2)*num_users)
    for j=1:num_clusters
        if (idx(i,1)==j)
            info_clust(j,1)=info_clust(j,1)+1;
        end
    end
    for j=1:3
        if (type(i)==j)
            info_clust(idx(i),j+1)=info_clust(idx(i),j+1)+1;
        end
    end
end
%figure;
      h=stem(pos(i,1),pos(i,2),'diamond','color',[0 0 0],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[0 0 0]);
      hold all;
      h=stem(pos(i,1),pos(i,2),'square','color',[1 0 0],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[1 0 0]);
      h=stem(pos(i,1),pos(i,2),'x','color',[0.1 1 0.1],'linestyle','none','MarkerSize',6);
      set(h,'MarkerFaceColor',[0.1 1 0.1]);
      h=stem(pos(i,1),pos(i,2),'color',[0 0 1],'linestyle','none','MarkerSize',4);
      set(h,'MarkerFaceColor',[0 0 1]);

info_clust1=zeros(num_clusters,num_applications+1);%%1=num_users, 2,3,4=type, 
info_clust1(:,1)=info_clust(:,1);
%%%Cluster Information %%% application
for i=1:(size(X_v,2)*num_users)
    for j=1:num_applications
        if(application(i)==j)
            info_clust1(idx(i),j+1)=info_clust1(idx(i),j+1)+1;
        end
    end
end

info_clust  ;%%Device type count
info_clust1  ;%% Devive application choice count
%%===================Clustering completes
X_v;
Y_v;
