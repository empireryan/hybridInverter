function xdot = f(x)

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


% state
p = x(1); %coutntroller selection
q = x(2); %switch position
il = x(3); % inductor current
vc = x(4); % capacitor voltage

% flow map
pdot = 0;
qdot = 0;
ildot = -((R/L)*il) - ((1/L)*vc) + ((vdc/L)*q);
vcdot = (1/C)*il - (1/(Rload*C))*vc;



z = [il;vc];
A = [-R/L -1/L;1/C 0];
B = [1/(L); 0];
%B = [0; 1/L];


if (q == -1)
    B = [-1/L; 0];
elseif (q == 0)
    B = [0; 0];
else
    %(q == 1)
    B = [1/L; 0];
end


u = vdc;

%I think Vg would be Vc-Ig*R2...

%xdot = [pdot; qdot; ildot; vcdot];

xdot = [pdot; qdot; (A*z) + (B*u)];

end