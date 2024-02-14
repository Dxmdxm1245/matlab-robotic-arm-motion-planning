% ����1������
clear;clc
format short
L_1=4; L_2=3; L_3=2;
theta1=pi/4; theta2=pi/6; theta3=pi/12;


L(1)=Link([pi/4 4 0 pi/2 0]);
L(2)=Link([pi/6 0 3 0 0]);
L(3)=Link([pi/12 0 2 0 0]);



L(1).qlim=[-pi/2 pi/2];
L(2).qlim=[-pi/2 pi/2];
L(3).qlim=[0 pi/2];
three_link=SerialLink(L,'name','three links')
%% ����2��ÿ���ؽڶ����˶�
% ��һ���ؽ��˶�

Qt1=jtraj([-pi/2;0;0],[pi/2;0;0],20); %�켣�滮
Qt2=jtraj([0;-pi/2;0],[0;pi/2;0],20); %�켣�滮
Qt3=jtraj([0;0;0],[0;0;pi/2],20); %�켣�滮

figure(1);clf
three_link.plot(Qt1,'view',[45 45])    %����
figure(2);
three_link.plot(Qt2,'view',[45 45])    %����
figure(3);
three_link.plot(Qt3,'view',[45 45])    %����



%% ����3�������ռ�
N=1000;   %�������
theta1=-pi/2+pi*rand(N,1); 
theta2=-pi/2+pi*rand(N,1);
theta3=pi/2*rand(N,1); 

pos = {1,N};
% ���˶�ѧ���
for i=1:N
    pos{i}=three_link.fkine([theta1(i) theta2(i) theta3(i)]);
end
% ��ͼ
figure(1);clf
three_link.plot([0 0 pi/4],'jointdiam',1);
axis equal;
view(0,90)
hold on;
for i=1:N
    plot3(pos{i}.t(1),pos{i}.t(2),pos{i}.t(3),'r.');
    hold on;
end
grid off
%% 3.д��
%λ��
close all;
P_j=[0	2	0.351005879	4.825216732
0	2	0.397563082	4.673601346
0	2	-0.361197533	3.37818593
1	2	-1.023422536	2.559123772
0	2	0.113458962	3.737917825
0	2	0.213537572	3.727108914
0	2	1.256762143	4.033730444
0	2	0.638763715	2.758514266
0	2	-0.263150611	1.771734076
1	2	-1.502457955	0.926493872
0	2	-0.34173319	3.20183876
0	2	0.052547083	2.738301188
0	2	-0.089289075	1.615772982
0	2	-0.087572936	0.129803807
0	2	-0.003288345	1.665672505
0	2	1.504677864	1.820318814
0	2	1.328386054	0.435442709
0	2	-0.116038707	0.293847363
0	2	1.342198209	0.411271438]








%��ʾ��
for i=1:size(P_j,1)-1
    if P_j(i,1)~=1
       plot3([P_j(i,2) P_j(i+1,2)],[P_j(i,3) P_j(i+1,3)],[P_j(i,4) P_j(i+1,4)],'r','Linewidth',2);
       hold on;
    end
end

for i=1:size(P_j,1)-1
    t=linspace(0,1,10);  %��ֵ
    Traj=mtraj(@tpoly,P_j(i,2:4),P_j(i+1,2:4),t); % ����ά��λ�� �ٶ� ���ٶ�

    n=size(Traj,1);
    T=zeros(4,4,n);
    for j=1:n
        T(:,:,j)=transl(Traj(j,:));  % ��ת�任����
    end
    
    Qtraj=three_link.ikine(T,'mask',[1 1 1 0 0 0]); % �ؽڱ���
   
    three_link.plot(Qtraj,'trail','b');
%     three_link.plot(Qtraj,'trail','b','movie','trail.gif');
end