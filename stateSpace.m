%function [i,h,t] = stateSpace() 

global R
global L
global C
global Vdc
global a
global b
global cin
global cout

global i;
global h;
global t;

global u
global w

A = [-R/L -1/L;1/C 0];
B = [1/(L); 0];
Cstar = [1 0];
Dlicious = 0;


t = linspace(0, 1000/60, 1*10^6);
u  = zeros(size(t));
u = 110*sin(w*t);
%u = u*110;

%h is current
ssModel = ss(A,B,Cstar,Dlicious);
[h,t] = lsim(ssModel, u, t);

%i is current
Cstar = [0 1];
ssModel = ss(A,B,Cstar,Dlicious);
[i,t] = lsim(ssModel, u, t);
