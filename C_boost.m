function inC = C(x)

global E
global R
global L
global C
global P
global tol
global vcStar;
global ilStar;

%======================
%       State
%======================
il = x(1); % inductor current
vc = x(2); % capacitor voltage
q = x(3); %switch position
   
%======================
%       Determine M0
%======================
if(il >= 0)
    M0 = 1;
else
    M0 = 0;
end

%======================
%       Determine M1
%======================
if(vc >= 0)
    M1 = 1;
else
    M1 = 0;
end

%========================
%       Determine Gamma0
%========================
Gamma0 = 2*(P(1,1)*[(vc-vcStar)*(-1/(R*C) + il/C)] + P(2,2)*[(il-ilStar)*((-vc+E)/L)]);
%========================
%       Determine Gamma1
%========================
Gamma1 = 2*(P(1,1)*[(vc-vcStar)*(-1/(R*C))] + P(2,2)*[(il-ilStar)*((E)/L)]);

if(q == 0)
    if(M0 && (Gamma0 <= 0))
        inC = 1;
    else
        inC = 0;
    end
elseif(q == 1) 
    if(M1 && (Gamma1 <= 0))
        inC = 1;
    else
        inC = 0;
    end
end

end


