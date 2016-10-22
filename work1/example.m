clc
clear
%% ��ȡ���ݲ��洢
a=load('jlfw.mat');
Wib_INSc=a.wib_INSc;f_INSc=a.f_INSc;
L(1,:)=zeros(1,48000);
Lambda(1,:)=zeros(1,48000);
Vx(1,:)=zeros(1,48000);
Vy(1,:)=zeros(1,48000);
Vz(1,:)=zeros(1,48000);
Rx(1,:)=zeros(1,48000);                                                     %������î��Ȧ���ʰ뾶���ݵľ���
Ry(1,:)=zeros(1,48000);                                                     %����������Ȧ���ʰ뾶���ݵľ���
psi(1,:)=zeros(1,48000);                                                    %������ƫ�������ݵľ���
theta(1,:)=zeros(1,48000);                                                  %�����Ÿ��������ݵľ���
gamma(1,:)=zeros(1,48000);                                                  %�����Ź�ת�����ݵľ���
I=eye(4);                                                                   %�����Ľ׾������ڼ�����Ԫ��
Wibx(1,:)=Wib_INSc(1,:);                                                    %��ȡ����������������ʲ�����
Wiby(1,:)=Wib_INSc(2,:);                                                    %��ȡ����������������ʲ�����
Wibz(1,:)=Wib_INSc(3,:);                                                    %��ȡ������������ʲ�����
fibbx(1,:)=f_INSc(1,:);                                                     %x����ı�������
fibby(1,:)=f_INSc(2,:);                                                     %y����ı�������
fibbz(1,:)=f_INSc(3,:);                                                     %z����ı�������
%% �����ʼ״̬
L(1,1)=39.975172/180*pi;                                                    %γ�ȳ�ʼֵ ��λ������
Lambda(1,1)=116.344695283/180*pi;                                           %���ȳ�ʼֵ ��λ������
Vx(1,1)=0.000048637;                                                        %��ʼ�ٶ�x�������
Vy(1,1)=0.000206947;                                                        %��ʼ�ٶ�y�������
Vz(1,1)=0.007106781;                                                        %��ʼ�ٶ�z�������
psi(1,1)=2*pi-91.637207 /180*pi;                                            %ƫ���ǳ�ʼֵ ��λ������
theta(1,1)=0.120992605 /180*pi;                                             %�����ǳ�ʼֵ ��λ������
gamma(1,1)=0.010445947 /180*pi;                                             %��ת�ǳ�ʼֵ ��λ������
%% ������س���
g0=9.7803267714;
gk1=0.00193185138639;
gk2=0.00669437999013;
Wie=7.292115147e-5;                                                         %������ת���ٶ�
Re=6378245;                                                                 %���뾶
e=1/298.3;                                                                  %��Բ��
t=1/80;                                                                     %����ʱ��
H=30;                                                                       %�߶�
%% �����Ԫ��ϵ��q0,q1,q2,q3�ĳ�ֵ ƫ����ʱ��Ϊ��
q(1,1)=cos(psi(1,1)/2)*cos(theta(1,1)/2)*cos(gamma(1,1)/2)...
      +sin(psi(1,1)/2)*sin(theta(1,1)/2)*sin(gamma(1,1)/2);                 %q0
q(2,1)=cos(psi(1,1)/2)*sin(theta(1,1)/2)*cos(gamma(1,1)/2)...
      +sin(psi(1,1)/2)*cos(theta(1,1)/2)*sin(gamma(1,1)/2);                 %q1
q(3,1)=cos(psi(1,1)/2)*cos(theta(1,1)/2)*sin(gamma(1,1)/2)...
      -sin(psi(1,1)/2)*sin(theta(1,1)/2)*cos(gamma(1,1)/2);                 %q2
q(4,1)=cos(psi(1,1)/2)*sin(theta(1,1)/2)*sin(gamma(1,1)/2)...
      -sin(psi(1,1)/2)*cos(theta(1,1)/2)*cos(gamma(1,1)/2);                 %q3
%% ѭ�����㵼������������״̬
for i=1:48000-1
    g=g0*(1+gk1*sin(L(i)^2)*(1-2*H/Re)/sqrt(1-gk2*sin(L(i)^2)));            %�����������ٶ�
    Rx(i)=Re/(1-e*(sin(L(i)))^2);                                           %����γ�ȼ���î��Ȧ���ʰ뾶
    Ry(i)=Re/(1+2*e-3*e*(sin(L(i)))^2);                                     %����γ�ȼ�������Ȧ���ʰ뾶
    %�����Ԫ����̬����
    q0=q(1,i);q1=q(2,i);q2=q(3,i);q3=q(4,i);
    Ctb=[q0^2+q1^2-q2^2-q3^2, 2*(q1*q2+q0*q3), 2*(q1*q3-q0*q2);
        2*(q1*q2-q0*q3),q2^2-q3^2+q0^2-q1^2,2*(q2*q3+q0*q1);
        2*(q1*q3+q0*q2),2*(q2*q3-q0*q1),q3^2-q2^2-q1^2+q0^2;];
    Cbt=Ctb';
    fibt=Cbt*[fibbx(i);fibby(i);fibbz(i)];                                  %��������
    fibtx(i)=fibt(1,1);fibty(i)=fibt(2,1);fibtz(i)=fibt(3,1);
    Vx(1,i+1)=(fibtx(i)+(2*Wie*sin(L(i))+Vx(i)*tan(L(i))/Rx(i))*Vy(i)...
             -(2*Wie*cos(L(i))+Vx(i)/Rx(i))*Vz(i))*t+Vx(i);                 %�����ٶ�x�������
    Vy(1,i+1)=(fibty(i)-(2*Wie*sin(L(i))+Vx(i)*tan(L(i))/Rx(i))*Vx(i)...
             +Vy(i)*Vz(i)/Ry(i))*t+Vy(i);                                   %�����ٶ�y�������
    Vz(1,i+1)=(fibtz(i)+(2*Wie*cos(L(i)+Vx(i))/Rx(i))*Vx(i)...
             +Vy(i)*Vy(i)/Ry(i)-g)*t+Vz(i);                                 %�����ٶ�z�������
    Witt=[-Vy(i)/Ry(i);
        Wie*cos(L(i))+Vx(i)/Rx(i);
        Wie*sin(L(i))+Vx(i)*tan(L(i))/Rx(i)];                               %���ƽָ̨����ٶ�ֵ
    Wibb=[Wibx(i);Wiby(i);Wibz(i)];
    Wtbb=Wibb-Ctb*Witt;                                                     %��ָ����ٶ�ת����ƽ̨����ϵ,�����Wtbb
    L(1,i+1)=t*Vy(i)/Ry(i)+L(i);
    Lambda(1,i+1)=t*Vx(i)/(Rx(i)*cos(L(i)))+ Lambda(i);
    x=Wtbb(1,1)*t;y=Wtbb(2,1)*t;z=Wtbb(3,1)*t;                              %��ȡ���������еĸ���theta
    A=[0 -x -y -z;x 0 z -y;y -z 0 x;z y -x 0];                              %��ȡ��������[��theta]
    T=x^2+y^2+z^2;                                                          %����[��theta]^2��
    q(:,i+1)=((1-T/8+T^2/384)*I+(1/2-T/48)*A)*q(:,i);                       %��q
    theta(i+1)=asin(Ctb(2,3));
    %��ֵ�ж�
    if(Ctb(2,2)>=0)
        if(Ctb(2,1)>=0)
            psi(i+1)=2*pi-(atan(Ctb(2,1)/Ctb(2,2)));
        else
            psi(i+1)=2*pi-(atan(Ctb(2,1)/Ctb(2,2))+2*pi);
        end
    else
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
psi(1,1)=91.637207 /180*pi;
%% ��ͼ����
figure;plot(Lambda*180/pi,L*180/pi);axis equal;
title('��γ��λ������');xlabel('����/��');ylabel('γ��/��');grid on;
t=linspace(0,600-1/80,48000);
figure; plot(t,Vx);title('���������ٶ�');xlabel('ʱ��/s');ylabel('�ٶ�/m/s');grid on;
figure; plot(t,Vy);title('�ϱ������ٶ�');xlabel('ʱ��/s');ylabel('�ٶ�/m/s');grid on;
figure; plot(t,theta*180/pi);title('������');xlabel('ʱ��/s');ylabel('��');grid on;
figure; plot(t,gamma*180/pi);title('��ת��');xlabel('ʱ��/s');ylabel('��');grid on;
figure; plot(t,psi*180/pi);title('ƫ����');xlabel('ʱ��/s');ylabel('��');grid on;