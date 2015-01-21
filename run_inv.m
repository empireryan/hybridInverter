close all; clear all; clc;

global R
global L
global C
global vdc
global Rload
global a
global b

global epsilon
global cmid
global cin
global cout

global i;
global h;
global t;
global Vz0
global w
global err



% circuit parameters
R = 0.6;
L = 0.1;
C = 0.04;
Rload = 8;
vdc = 170;

R = 0.6;
L = 0.1*10^-4;
C = 0.0277;
Rload = 1;
vdc = 170;

% tracking band parameters
freq = 60;
w = 2*pi*freq;
a = 1/(sqrt(R^2 + (L*w - 1/(C*w))^2 ));
b = 1/(C*w*sqrt(R^2 + (L*w - 1/(C*w))^2 ));

stateSpace();
figure(4)
hold on
%plot(t, y);
%plot(h(10000:20000)/a,i(10000:20000)/b, 'm');
plot(h(50000:51000)/a,i(50000:51000)/b, 'm');

%Vz0 = ((h(50000)/a)^2 + (i(50000)/b)^2)

epsilon = 0.05;
cmid = ((h(50000)/a)^2 + (i(50000)/b)^2)
cin = (1-epsilon)*((h(50000)/a)^2 + (i(50000)/b)^2)
cout = (1+epsilon)*((h(50000)/a)^2 + (i(50000)/b)^2)
err = 1e-3;


% initial conditions
p = 2;
q = 1; 
il = 0; 
vc = 0;
x0 = [p;q;il;vc];

% simulate horizon
TSPAN = [0,1.50];
JSPAN = [0,500];

% rule for jumps
% rule = 1 -> priority for jumps
% rule = 2 -> priority for flows
rule = 1;

options = odeset('RelTol',1e-6,'MaxStep',1e-4);

t = 0;
% simulate
[t,j,x] = HyEQsolver(@f_inv,@g_inv,@C_inv,@D_inv,x0,TSPAN,JSPAN,rule,options);

% check initial value of trajectory function

if (Vz0 <= cout) && (Vz0 >= cin)
    fprintf('Trajectory is initialized inside of the tracking band.\n\n');
else
    fprintf('Trajectory is initialized outside of the tracking band.\n\n');
end

% plot output waveforms
figure(1)
clf
plotInverterWaveforms(t,j,x)

% ellipse tracking band
te = -pi:0.01:pi;
xe = a*cos(te);
ye = b*sin(te);

% ellipse outer band
aeo = sqrt(cout) * a;
beo = sqrt(cout) * b;
xeo = aeo*cos(te);
yeo = beo*sin(te);

% ellipse inner band
aei = sqrt(cin) * a;
bei = sqrt(cin) * b;
xei = aei*cos(te);
yei = bei*sin(te);

% plot output trajectories, reference trajectory, and tracking band
figure(2)
clf
subplot(1,1,1)
%plot(x(:,3),x(:,4),'m',xe,ye,'k',xeo,yeo,'--b',xei,yei,'--b', (1-epsilon)*h(50000:51000)/a, (1-epsilon)*i(50000:51000)/b, '--b', (1+epsilon)*h(50000:51000)/a, (1+epsilon)*i(50000:51000)/b,'--b')%,xtwo(:,3),xtwo(:,4),'c',xthree(:,3),xthree(:,4),'r')
plot(x(:,3),x(:,4),'m',xe,ye,'r',xeo,yeo,'--b',xei,yei,'--b', (1-epsilon)*h(50000:51000)/a, (1-epsilon)*i(50000:51000)/b, '--b', (1+epsilon)*h(50000:51000)/a, (1+epsilon)*i(50000:51000)/b,'--b')
%plot(x(:,4),x(:,3),'m', (1-epsilon)*i(50000:51000)/b, ((1-epsilon)*h(50000:51000)/a), '--b', (1+epsilon)*i(50000:51000)/b, (1+epsilon)*h(50000:51000)/a,'--b')%,xtwo(:,3),xtwo(:,4),'c',xthree(:,3),xthree(:,4),'r')


xlabel('Inductor Current')
ylabel('Capacitor/Load Voltage')
grid on
title('Closed-Loop System Trajectories')