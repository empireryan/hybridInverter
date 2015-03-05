function xdot = f(x)

global E
global R
global L
global C
global P
global tol
global vcStar;
global ilStar;



% state
il = x(1); % inductor current
vc = x(2); % capacitor voltage
q = x(3); % switch position

ildot = 0;
vcdot = 0;
qdot = 0;

% flow map
if(q == 0)
    if((il > 0) || (vc < E && ((il-0)<tol)))
        a = sprintf('M1')        
        ildot = -((1/L)*vc) + (E/L);
        vcdot = (-1/(R*C))*vc + 1/C*il;
    elseif((vc > E) && ((il-0)<tol))
        b = sprintf('M1')        
        ildot = 0;
        vcdot = -(1/(R*C)*vc);
    end
elseif(q == 1)
    ildot = E/L;
    vcdot = -1/(R*C)*vc;
end

xdot = [ildot;vcdot;qdot];
end