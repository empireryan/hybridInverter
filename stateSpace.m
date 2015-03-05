%function [i,h,t] = stateSpace() 
global R
global Rf
global R2
global L
global Lg
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

%A = [-R/L -1/L;1/C -1/(R*C)];
%A = [-R/L -1/L;1/C 0];

%B = [1/(L); 0];

A = [-(R+Rf)/L Rf/L -1/L; Rf/Lg -(R2+Rf)/Lg 1/Lg; 1/C -1/C 0];
B = [1/L 0;0 -1/Lg; 0 0];

Cstar = [1 0 0; 0 1 0;0 0 1];
D = 0;

t = linspace(0, 100/60, 1*10^6);
u = [160*sin(w*t); 160*sin(w*t)];

ssModel = ss(A,B,Cstar,D);
[h,t] = lsim(ssModel, u, t);
hold on;
plot(t,h(1), 'g');
plot(t, h(2), 'b');
