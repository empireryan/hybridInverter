%function [i,h,t] = stateSpace() 

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
global Vz0
global w
global err

A = [-R/L -1/L;1/C -1/(R*C)];
B = [1/(L); 0];
Cstar = [1 0; 0 1];
D = 0;


t = linspace(0, 1000/60, 1*10^6);
u = 110*sin(w*t);

ssModel = ss(A,B,Cstar,D);
[h,t] = lsim(ssModel, u, t);
