% ��ת����ʵ�� 
% ���÷������Ƚ��㵼����������ת��������ϵ
clc;clear;
%% ��ȡ���ݲ�����
data  = load('5������ʵ������.mat');
lengthTotalData = 97500;
lengthStill = 64550;
lengthDynamic = lengthTotalData - lengthStill;
fibbx(1,:)=data.temp_data(:,1)*9.80;                                       %x����ı�������
fibby(1,:)=data.temp_data(:,2)*9.80;                                       %y����ı�������
fibbz(1,:)=data.temp_data(:,3)*9.80;                                       %z����ı�������
Wibx(1,:)=data.temp_data(:,4)*pi/180;                                      %��ȡ����������������ʲ�����
Wiby(1,:)=data.temp_data(:,5)*pi/180;                                      %��ȡ����������������ʲ�����
Wibz(1,:)=data.temp_data(:,6)*pi/180;                                      %��ȡ������������ʲ�����

L(1,:)=zeros(1,lengthTotalData);
Lambda(1,:)=zeros(1,lengthTotalData);
Vx(1,:)=zeros(1,lengthTotalData);
Vy(1,:)=zeros(1,lengthTotalData);
Vz(1,:)=zeros(1,lengthTotalData);
Rx(1,:)=zeros(1,lengthTotalData);                                          %������î��Ȧ���ʰ뾶���ݵľ���
Ry(1,:)=zeros(1,lengthTotalData);                                          %����������Ȧ���ʰ뾶���ݵľ���
psi(1,:)=zeros(1,lengthTotalData);                                         %������ƫ�������ݵľ���
theta(1,:)=zeros(1,lengthTotalData);                                       %�����Ÿ��������ݵľ���
gamma(1,:)=zeros(1,lengthTotalData);                                       %�����Ź�ת�����ݵľ���
I=eye(4);                                                                  %�����Ľ׾������ڼ�����Ԫ��

%������س���
g0=9.7803267714;
gk1=0.00193185138639;
gk2=0.00669437999013;
Wie=7.292115147e-5;                                                        %������ת���ٶ�
Re=6378245;                                                                %���뾶
e=1/298.3;                                                                 %��Բ��
t=1/500;                                                                   %��������

%�����ʼ״̬
L(1,1)=39.976419/180*pi;                                                   %γ�ȳ�ʼֵ ��λ������
Lambda(1,1)=116.340561/180*pi;                                             %���ȳ�ʼֵ ��λ������
H=57;                                                                      %�߶�
Vx(1,1)=0;                                                                 %��ʼ�ٶ�x�������
Vy(1,1)=0;                                                                 %��ʼ�ٶ�y�������
Vz(1,1)=0;                                                                 %��ʼ�ٶ�z�������
psi(1,1)=2*pi-75 /180*pi;                                                  %ƫ���ǳ�ʼֵ ��λ������
theta(1,1)=0;                                                              %�����ǳ�ʼֵ�������㣩 ��λ������
gamma(1,1)=0;                                                              %��ת�ǳ�ʼֵ�������㣩 ��λ������

%�����ʼֵ
ave_S_fibbx = mean(fibbx(1,1:60000));
ave_S_fibby = mean(fibby(1,1:60000));
ave_S_fibbz = mean(fibbz(1,1:60000));
theta(1,1) = asin(ave_S_fibby/ave_S_fibbz);                                %�����ǳ�ֵ��������⣩
gamma(1,1) = asin(ave_S_fibbx/ave_S_fibbz);                                %��ת�ǳ�ֵ��������⣩

%�����Ԫ��ϵ��q0,q1,q2,q3�ĳ�ֵ
q(1,1)=cos(psi(1,1)/2)*cos(theta(1,1)/2)*cos(gamma(1,1)/2)...
      +sin(psi(1,1)/2)*sin(theta(1,1)/2)*sin(gamma(1,1)/2);                %q0
q(2,1)=cos(psi(1,1)/2)*sin(theta(1,1)/2)*cos(gamma(1,1)/2)...
      +sin(psi(1,1)/2)*cos(theta(1,1)/2)*sin(gamma(1,1)/2);                %q1
q(3,1)=cos(psi(1,1)/2)*cos(theta(1,1)/2)*sin(gamma(1,1)/2)...
      -sin(psi(1,1)/2)*sin(theta(1,1)/2)*cos(gamma(1,1)/2);                %q2
q(4,1)=cos(psi(1,1)/2)*sin(theta(1,1)/2)*sin(gamma(1,1)/2)...
      -sin(psi(1,1)/2)*cos(theta(1,1)/2)*cos(gamma(1,1)/2);                %q3

%% ѭ�����㵼������������״̬����ֹ��
for i=1:lengthStill-1
    g=g0*(1+gk1*sin(L(i)^2)*(1-2*H/Re)/sqrt(1-gk2*sin(L(i)^2)));           %�����������ٶ�
    Rx(i)=Re/(1-e*(sin(L(i)))^2);                                          %����γ�ȼ���î��Ȧ���ʰ뾶
    Ry(i)=Re/(1+2*e-3*e*(sin(L(i)))^2);                                    %����γ�ȼ�������Ȧ���ʰ뾶
    %�����Ԫ����̬����
    q0=q(1,i);q1=q(2,i);q2=q(3,i);q3=q(4,i);
    Ctb=[q0^2+q1^2-q2^2-q3^2, 2*(q1*q2+q0*q3), 2*(q1*q3-q0*q2);
        2*(q1*q2-q0*q3),q2^2-q3^2+q0^2-q1^2,2*(q2*q3+q0*q1);
        2*(q1*q3+q0*q2),2*(q2*q3-q0*q1),q3^2-q2^2-q1^2+q0^2;];
    Cbt=Ctb';
    fibt=Cbt*[fibbx(i);fibby(i);fibbz(i)];                                 %��������
    fibtx(i)=fibt(1,1);fibty(i)=fibt(2,1);fibtz(i)=fibt(3,1);
    Vx(1,i+1)=(fibtx(i)+(2*Wie*sin(L(i))+Vx(i)*tan(L(i))/Rx(i))*Vy(i)...
             -(2*Wie*cos(L(i))+Vx(i)/Rx(i))*Vz(i))*t+Vx(i);                %�����ٶ�x�������
    Vy(1,i+1)=(fibty(i)-(2*Wie*sin(L(i))+Vx(i)*tan(L(i))/Rx(i))*Vx(i)...
             +Vy(i)*Vz(i)/Ry(i))*t+Vy(i);                                  %�����ٶ�y�������
    Vz(1,i+1)=(fibtz(i)+(2*Wie*cos(L(i)+Vx(i))/Rx(i))*Vx(i)...
             +Vy(i)*Vy(i)/Ry(i)-g)*t+Vz(i);                                %�����ٶ�z�������
    Witt=[-Vy(i)/Ry(i);
        Wie*cos(L(i))+Vx(i)/Rx(i);
        Wie*sin(L(i))+Vx(i)*tan(L(i))/Rx(i)];                              %���ƽָ̨����ٶ�ֵ
    Wibb=[Wibx(i);Wiby(i);Wibz(i)];
    Wtbb=Wibb-Ctb*Witt;                                                    %��ָ����ٶ�ת����ƽ̨����ϵ,�����Wtbb
    L(1,i+1)=t*Vy(i)/Ry(i)+L(i);
    Lambda(1,i+1)=t*Vx(i)/(Rx(i)*cos(L(i)))+ Lambda(i);
    x=Wtbb(1,1)*t;y=Wtbb(2,1)*t;z=Wtbb(3,1)*t;                             %��ȡ���������еĸ���theta
    A=[0 -x -y -z;x 0 z -y;y -z 0 x;z y -x 0];                             %��ȡ��������[��theta]
    T=x^2+y^2+z^2;                                                         %����[��theta]^2��
    q(:,i+1)=((1-T/8+T^2/384)*I+(1/2-T/48)*A)*q(:,i);                      %��q
    theta(i+1)=asin(Ctb(2,3));
    %��ֵ�ж�
    if(Ctb(2,2)>0)
        if(Ctb(2,1)>=0)
            psi(i+1)=2*pi-(atan(Ctb(2,1)/Ctb(2,2)));
        else
            psi(i+1)=2*pi-(atan(Ctb(2,1)/Ctb(2,2))+2*pi);
        end
    elseif(Ctb(2,2)<0)
        if(Ctb(2,1)>0)
            psi(i+1)=2*pi-(atan(Ctb(2,1)/Ctb(2,2))+pi);
        else
            psi(i+1)=2*pi-(atan(Ctb(2,1)/Ctb(2,2))+pi);
        end
    end
    if(Ctb(3,3)>0)
        gamma(i+1)=atan(-Ctb(1,3)/Ctb(3,3));
    elseif(Ctb(1,3)<0)
        gamma(i+1)=atan(-Ctb(1,3)/Ctb(3,3))+pi;
    else
        gamma(i+1)=atan(-Ctb(1,3)/Ctb(3,3))-pi;
    end
end

%% ��̬���ֳ�ֵ�趨
L(1,lengthStill+1)=39.976419/180*pi;                                       %γ�ȳ�ʼֵ ��λ������
Lambda(1,lengthStill+1)=116.340561/180*pi;                                 %���ȳ�ʼֵ ��λ������
H=57;                                                                      %�߶�
Vx(1,lengthStill+1)=0;                                                     %��ʼ�ٶ�x�������
Vy(1,lengthStill+1)=0;                                                     %��ʼ�ٶ�y�������
Vz(1,lengthStill+1)=0;                                                     %��ʼ�ٶ�z�������
theta(1,lengthStill+1) = theta(1,1);
gamma(1,lengthStill+1) = gamma(1,1);
psi(1,lengthStill+1)=2*pi-75 /180*pi;                                      %ƫ���ǳ�ʼֵ ��λ������

%�����Ԫ��ϵ��q0,q1,q2,q3�ĳ�ֵ
q(1,lengthStill+1)=cos(psi(1,1)/2)*cos(theta(1,1)/2)*cos(gamma(1,1)/2)...
      +sin(psi(1,1)/2)*sin(theta(1,1)/2)*sin(gamma(1,1)/2);                %q0
q(2,lengthStill+1)=cos(psi(1,1)/2)*sin(theta(1,1)/2)*cos(gamma(1,1)/2)...
      +sin(psi(1,1)/2)*cos(theta(1,1)/2)*sin(gamma(1,1)/2);                %q1
q(3,lengthStill+1)=cos(psi(1,1)/2)*cos(theta(1,1)/2)*sin(gamma(1,1)/2)...
      -sin(psi(1,1)/2)*sin(theta(1,1)/2)*cos(gamma(1,1)/2);                %q2
q(4,lengthStill+1)=cos(psi(1,1)/2)*sin(theta(1,1)/2)*sin(gamma(1,1)/2)...
      -sin(psi(1,1)/2)*cos(theta(1,1)/2)*cos(gamma(1,1)/2);                %q3

%% ѭ�����㵼������������״̬����̬��
for i=lengthStill+1:lengthTotalData-1
    g=g0*(1+gk1*sin(L(i)^2)*(1-2*H/Re)/sqrt(1-gk2*sin(L(i)^2)));           %�����������ٶ�
    Rx(i)=Re/(1-e*(sin(L(i)))^2);                                          %����γ�ȼ���î��Ȧ���ʰ뾶
    Ry(i)=Re/(1+2*e-3*e*(sin(L(i)))^2);                                    %����γ�ȼ�������Ȧ���ʰ뾶
    %�����Ԫ����̬����
    q0=q(1,i);q1=q(2,i);q2=q(3,i);q3=q(4,i);
    Ctb=[q0^2+q1^2-q2^2-q3^2, 2*(q1*q2+q0*q3), 2*(q1*q3-q0*q2);
        2*(q1*q2-q0*q3),q2^2-q3^2+q0^2-q1^2,2*(q2*q3+q0*q1);
        2*(q1*q3+q0*q2),2*(q2*q3-q0*q1),q3^2-q2^2-q1^2+q0^2;];
    Cbt=Ctb';
    fibt=Cbt*[fibbx(i);fibby(i);fibbz(i)];                                 %��������
    fibtx(i)=fibt(1,1);fibty(i)=fibt(2,1);fibtz(i)=fibt(3,1);
    Vx(1,i+1)=(fibtx(i)+(2*Wie*sin(L(i))+Vx(i)*tan(L(i))/Rx(i))*Vy(i)...
             -(2*Wie*cos(L(i))+Vx(i)/Rx(i))*Vz(i))*t+Vx(i);                %�����ٶ�x�������
    Vy(1,i+1)=(fibty(i)-(2*Wie*sin(L(i))+Vx(i)*tan(L(i))/Rx(i))*Vx(i)...
             +Vy(i)*Vz(i)/Ry(i))*t+Vy(i);                                  %�����ٶ�y�������
    Vz(1,i+1)=(fibtz(i)+(2*Wie*cos(L(i)+Vx(i))/Rx(i))*Vx(i)...
             +Vy(i)*Vy(i)/Ry(i)-g)*t+Vz(i);                                %�����ٶ�z�������
    Witt=[-Vy(i)/Ry(i);
        Wie*cos(L(i))+Vx(i)/Rx(i);
        Wie*sin(L(i))+Vx(i)*tan(L(i))/Rx(i)];                              %���ƽָ̨����ٶ�ֵ
    Wibb=[Wibx(i);Wiby(i);Wibz(i)];
    Wtbb=Wibb-Ctb*Witt;                                                    %��ָ����ٶ�ת����ƽ̨����ϵ,�����Wtbb
    L(1,i+1)=t*Vy(i)/Ry(i)+L(i);
    Lambda(1,i+1)=t*Vx(i)/(Rx(i)*cos(L(i)))+ Lambda(i);
    x=Wtbb(1,1)*t;y=Wtbb(2,1)*t;z=Wtbb(3,1)*t;                             %��ȡ���������еĸ���theta
    A=[0 -x -y -z;x 0 z -y;y -z 0 x;z y -x 0];                             %��ȡ��������[��theta]
    T=x^2+y^2+z^2;                                                         %����[��theta]^2��
    q(:,i+1)=((1-T/8+T^2/384)*I+(1/2-T/48)*A)*q(:,i);                      %��q
    theta(i+1)=asin(Ctb(2,3));
    %��ֵ�ж�
    if(Ctb(2,2)>0)
        if(Ctb(2,1)>=0)
            psi(i+1)=2*pi-(atan(Ctb(2,1)/Ctb(2,2)));
        else
            psi(i+1)=2*pi-(atan(Ctb(2,1)/Ctb(2,2))+2*pi);
        end
    elseif(Ctb(2,2)<0)
        if(Ctb(2,1)>0)
            psi(i+1)=2*pi-(atan(Ctb(2,1)/Ctb(2,2))+pi);
        else
            psi(i+1)=2*pi-(atan(Ctb(2,1)/Ctb(2,2))+pi);
        end
    end
    if(Ctb(3,3)>0)
        gamma(i+1)=atan(-Ctb(1,3)/Ctb(3,3));
    elseif(Ctb(1,3)<0)
        gamma(i+1)=atan(-Ctb(1,3)/Ctb(3,3))+pi;
    else
        gamma(i+1)=atan(-Ctb(1,3)/Ctb(3,3))-pi;
    end
end
psi(1,1) = 75 /180*pi;
psi(1,lengthStill+1)=75 /180*pi;

%% ƽ̨ϵ������ϵ
base_Vx(1,:)=zeros(1,lengthTotalData);
base_Vy(1,:)=zeros(1,lengthTotalData);
base_Vz(1,:)=zeros(1,lengthTotalData);
base_theta(1,:)=zeros(1,lengthTotalData);                                       %�����Ÿ��������ݵľ���
base_gamma(1,:)=zeros(1,lengthTotalData);                                       %�����Ź�ת�����ݵľ���
base_psi(1,:)=zeros(1,lengthTotalData);                                         %������ƫ�������ݵľ���
tempAngle = 0;

for i=lengthStill+1:lengthTotalData
    tempAngle = tempAngle + 20 * 1 / 500;
    tempAngle = mod(tempAngle,360);
    angle = tempAngle * pi / 180;
    base_psi(i) = psi(i) + angle;
    if base_psi(i)>2*pi
        base_psi(i) = base_psi(i) - 2*pi;
    end
    base_theta(1,i) = theta(1,1)+theta(1,i) - theta(1,83000) * sin(angle+75*pi/180);
    base_gamma(1,i) = gamma(1,1)+gamma(1,i) + gamma(1,83000+90/20*500) * cos(angle+75*pi/180);
end

%% ͳһ��ͼ
ts=linspace(0,(lengthStill-1)/500,lengthStill);
td=linspace((lengthStill)/500,(lengthTotalData-1)/500,lengthDynamic);

figure, hold on;
plot(Lambda(1:lengthStill)*180/pi,L(1:lengthStill)*180/pi,'b'); 
plot(Lambda(lengthStill+1:lengthTotalData)*180/pi,L(lengthStill+1:lengthTotalData)*180/pi,'r');
title('��γ��λ������'); xlabel('����/��'); ylabel('γ��/��'); legend('��̬','��̬','Location','northwest'); 
grid on; axis equal; hold off;

figure, hold on;
plot(ts,Vx(1:lengthStill),'b'); plot(td,Vx(lengthStill+1:lengthTotalData),'r');
title('���������ٶ�');xlabel('ʱ��/s');ylabel('�ٶ�/m/s');legend('��̬','��̬','Location','northwest');
grid on; hold off;

figure, hold on;
plot(ts,Vy(1:lengthStill),'b'); plot(td,Vy(lengthStill+1:lengthTotalData),'r');
title('�ϱ������ٶ�');xlabel('ʱ��/s');ylabel('�ٶ�/m/s');legend('��̬','��̬','Location','northwest');
grid on; hold off;

figure, hold on;
plot(ts,theta(1:lengthStill)*180/pi,'b');
plot(td,theta(lengthStill+1:lengthTotalData)*180/pi,'g');
plot(td,base_theta(lengthStill+1:lengthTotalData)*180/pi,'r');
title('������');xlabel('ʱ��/s');ylabel('��');legend('��̬','ƽ̨','����','Location','northeast');
grid on; hold off;

figure, hold on;
plot(ts,gamma(1:lengthStill)*180/pi,'b');
plot(td,gamma(lengthStill+1:lengthTotalData)*180/pi,'g');
plot(td,base_gamma(lengthStill+1:lengthTotalData)*180/pi,'r');
title('��ת��');xlabel('ʱ��/s');ylabel('��');legend('��̬','ƽ̨','����','Location','northwest');
grid on; hold off;

figure, hold on;
plot(ts,psi(1:lengthStill)*180/pi,'b');
plot(td,psi(lengthStill+1:lengthTotalData)*180/pi,'g');
plot(td,base_psi(lengthStill+1:lengthTotalData)*180/pi,'r');
title('ƫ����');xlabel('ʱ��/s');ylabel('��');legend('��̬','ƽ̨','����','Location','northwest');
grid on; hold off;