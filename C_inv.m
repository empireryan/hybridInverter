function inC = C(x)

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


% state
p = x(1); %coutntroller selection
q = x(2); % switch position
il = x(3); % inductor current
vc = x(4); % capacintor voltage

% tracking band parameters
%{
epsilon = 0.1;
cmid = 1;
cinn = cmid - epsilon;
coutut = cmid + epsilon;

% trajectory function
Vz = (z1/a)^2 + (z2/b)^2;
%}

Vz0 = (il/a)^2 + (vc/b)^2;


%{
% Hs is in the loop
if ((Vz0 <= coutut) && (Vz0 >= cinn) && (p == 1))
    Cfw = 1;
else
    Cfw = 0;
end

% Hg is in the loop
if (((Vz0 >= coutut) || (Vz0 <= cinn)) && (p == 2))
    Cg = 1;
else
    Cg = 0;
end

%closed-loop system flow set
if (Cfw || Cg)
    v = 1; % report flow
else
    v = 0; % do not report flow
end
%}

%======================
%For the Hs Controller
%======================

%p == 1 -> Hfw in the loop
%p == 2 -> Hg in the loop

%Hfw Controller
if(p == 1)
    %if we're between the tracking bands, flow
    if((Vz0 >= cin) && (Vz0 <= cout))
        inCHS = 1;
    else
        inCHS = 0;
    end
%Hg Controller (Out of tracking bands)    
else 
    if(Vz0 >= cout)        %if we're beyond Co
        inCHS = 1;
    elseif(Vz0 <= cin);       %if we're within Ci
        inCHS = 1;
    else 
        inCHS = 0;
    end
end
    
%======================
%For the Hfw Controller
%======================
if(p == 1)    
    if((Vz0 >= cin) && (Vz0 <= cout))
        inCHFW = 1;
    else
        inCHFW = 0;
    end
else
    inCHFW = 0;
end

%======================
%For the Hg Controller
%======================
if(p == 2)
    if((Vz0 <= cin) || (Vz0 >= cout))
        inCHG = 1;
    else
        inCHG = 0;
    end
else
    inCHG = 0;
end

if(inCHS || inCHFW || inCHG)
   inC = 1;
else
    inC = 0;
end

end

