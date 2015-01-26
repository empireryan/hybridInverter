function inD = D(x)

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


%=========================
%State
%=========================
p = x(1); %controller selection
q = x(2); % switch position
il = x(3); % inductor current
vc = x(4); % capacitor voltage


%=========================
%Trajectory Function
%=========================
Vz0 = (il/a)^2 + (vc/b)^2;

%=========================
%Error Band and Parameters
%=========================
mEpsilon = 150;
if ((abs(Vz0 - cout) < err) && ((il >= 0) && (il <= mEpsilon)) && (vc <= 0))
    M1 = 1;
else
    M1 = 0;
end
if ((abs(Vz0 - cout) < err) && ((il >= -mEpsilon) && (il <= 0)) && (vc >= 0))
    M2 = 1;
else
    M2 = 0;
end


%@TODO: make this work like a sieve, as in the flow set 'C'. 
%Set each controller to trigger its own 'local' inD flag, and then check
%for any of these flags at the end. 

%======================
%For the Hs Controller
%======================

%p == 1 -> Hfw in the loop
%p == 2 -> Hg in the loop


if(p == 2)
    if((Vz0 >= cin) && (Vz0 <= cout))
        inD = 1;
    end
else
    inD = 0;    
end

%======================
%For the Hfw Controller
%======================
if(p == 1)
    if(q ~= 0)
       if( (abs(Vz0-cin) <= err) && (il*q <= 0))
           inD = 1;
       elseif( (abs(Vz0-cout) <= err) && (il*q >= 0))
           inD = 1;
       end
    elseif (q == 0)
        if( (abs(Vz0-cin) <= err) && (q == 0))
            inD = 1;
        end   
    end
end

%======================
%For the Hg Controller
%======================
if(p == 2)
    if((Vz0 >= cin) && (Vz0 <= cout))
        inD = 1;
    else
        inD = 0;
    end
end

end