close all; clear all; clc;


global E
global R
global L
global C
global P
global tol
global vcStar;
global ilStar;

vcStar = 17;
ilStar = 2;
tol = .001;
% circuit parameters
E = 10;
R = 10;
L = 0.2;
C = 0.1;
P = [C/2 0;0 L/2];
err = .0001;


% initial conditions
q = 0; 
il = 0; 
vc = 0;
x0 = [il;vc;q];

% simulate horizon
TSPAN = [0,5];
JSPAN = [0,1000];

% rule for jumps
% rule = 1 -> priority for jumps
% rule = 2 -> priority for flows
rule = 2;

options = odeset('RelTol',1e-6,'MaxStep',1e-3);

t = 0;
% simulate
[t,j,x] = HyEQsolver(@f_boost,@g_boost,@C_boost,@D_boost,x0,TSPAN,JSPAN,rule,options);



% plot continuous evolution of inductor current
subplot(3,2,1)
plotflows(t,j,x(:,1))
grid on
ylabel('i_L')
title('Continuous Evolution of Inductor Current')

% plot discrete evolution of inductor current
subplot(3,2,2)
plotflows(t,j,x(:,2))
grid on
ylabel('v_c')
title('Discrete Evolution of Capacitor Voltage')

% plot continuous evolution of capacitor/load voltage
subplot(3,2,3)
plotjumps(t,j,x(:,3))
grid on
ylabel('q')
title('Continuous Evolution of Capacitor/Load Voltage')