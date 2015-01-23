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
global Vz0
global w
global err


%======================
%       State
%======================
p = x(1); %coutntroller selection
q = x(2); %switch position
il = x(3); % inductor current
vc = x(4); % capacitor voltage

%==================================================================
%                   Tracking Band Parameters
%Use the current il vc solution to determine its position and phase
%==================================================================
Vz0 = (il/a)^2 + (vc/b)^2;
phase = atan((vc/b)^2/(il/a)^2);

%======================
%For the Hs Controller
%======================

%p == 1 -> Hfw in the loop
%p == 2 -> Hg in the loop

    %===============================
    %Hs Controller - Hfw in the loop
    %===============================
if(p == 1)
    %if we're between the tracking bands, flow
    if((Vz0 >= cin) && (Vz0 <= cout))
        inCHS = 1;
    %not in the tracking bands, report not-flowing
    else
        inCHS = 0;
    end
    %===============================
    %Hs Controller - Hg in the loop
    %===============================
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

