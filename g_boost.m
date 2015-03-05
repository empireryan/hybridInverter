function xplus = g(x)

global E
global R
global L
global C
global P
global tol
global vcStar;
global ilStar;

%======================
%State
%======================
il = x(1); % inductor current
vc = x(2); % capacitor voltage
q = x(3); % switch position

%======================
%For the Hg Controller
%======================

%========================
%       Determine Gamma0
%========================
Gamma0 = 2*(P(1,1)*[(vc-vcStar)*(-1/(R*C) + il/C)] + P(2,2)*[(il-ilStar)*((-vc+E)/L)]);
%========================
%       Determine Gamma1
%========================
Gamma1 = 2*(P(1,1)*[(vc-vcStar)*(-1/(R*C))] + P(2,2)*[(il-ilStar)*((E)/L)]);

if((q == 0) && (Gamma0-0)<tol)
    qplus = 1-q;
elseif((q ==1) && (Gamma1-0)<tol)
    qplus = 1-q;
else 
    qplus = q;
end


xplus = [il;vc;qplus];
end