function xplus = g(x)

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
p = x(1); %controller selection
q = x(2); %switch position
il = x(3); % inductor current
vc = x(4); % capacitor voltage

pplus = p;
qplus = q;

Vz0 = (il/a)^2 + (vc/b)^2;

%TODO: This block also appears in D_inv - make these global so you can
%calculate once and change parameters in run_inv!

%======================
%Error Band and Parameter
%======================
mEpsilon = .5;
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

%{
% jump map
pplus = 1;
z1plus = il;
z2plus = vc;
if ((q ~= -1) && (((abs(Vz0 - coutut) < err) && (il >= 0) && ~M1) || ((abs(Vz0 - cinn) < 1e-6) && (il <= 0))))
    qplus = -1;
elseif ((q ~= 1) && (((abs(Vz0 - coutut) < err) && (il <= 0) && ~M2) || ((abs(Vz0 - cinn) < 1e-6) && (il >= 0))))
    qplus = 1;
elseif ((M1 && (q == 1)) || (M2 && (q == -1)))
    qplus = 0;
else
    qplus = q;
end
%}

%======================
%For the Hs Controller
%======================
if(p == 2)
    if((Vz0 >= cin) && (Vz0 <= cout))
        pplus = 1;
    end
else
    pplus = p;    
end

%======================
%For the Hfw Controller
%======================

if(p == 1)    
    if(q ~= -1)
        if( ((abs(Vz0-cout) <= err) && (il >= 0) && (~M1)) || (((abs(Vz0-cin) <= err)) && (il <= 0)) )
        qplus = -1;
        end
    elseif ( ((M1) && (abs(il - mEpsilon) >= err) && (q == 1)) || ((M2) && (abs(il + mEpsilon) >= err) && (q == -1)) )
            qplus = 0;
    elseif(q ~= 1)
        if( ((abs(Vz0 - cout) <= err) && (il <= 0) && (~M2)) || (((abs(Vz0 - cin) <= err)) && (il >= 0)) )
            qplus = 1;
        end
    else
        qplus = q;        
    end
end


%======================
%For the Hg Controller
%======================
if(p == 2)
    if((Vz0 >= cin) && (Vz0 < cout))
        pplus = 1;
    else
        pplus = p;
    end
end


xplus = [pplus;qplus;il;vc];
end