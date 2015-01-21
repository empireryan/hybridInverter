%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: plotInverterWavforms(t,j,x)
%
% This function plots the output waveforms of the inverter simulation
% utilizing the plotting functions from the Hybrid EQ Toolbox.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotInverterWaveforms(t,j,x)

% plot continuous evolution of inductor current
subplot(3,2,1)
plotflows(t,j,x(:,3))
grid on
ylabel('i_L')
title('Continuous Evolution of Inductor Current')

% plot discrete evolution of inductor current
subplot(3,2,2)
plotjumps(t,j,x(:,3))
grid on
ylabel('i_L')
title('Discrete Evolution of Inductor Current')

% plot continuous evolution of capacitor/load voltage
subplot(3,2,3)
plotflows(t,j,x(:,4))
grid on
ylabel('v_{load}')
title('Continuous Evolution of Capacitor/Load Voltage')

% plot discrete evolution of inductor current
subplot(3,2,4)
plotjumps(t,j,x(:,4))
grid on
ylabel('v_{load}')
title('Discrete Evolution of Capacitor/Load Voltage')

% plot switching waveform of switching variable
subplot(3,2,5:6)
plotflows(t,j,x(:,2))
ylim([-2 2])
grid on
ylabel('q')
title('Continuous Evolution of Switching State q')

% calculate minimum time between state transitions
tj = zeros((max(j) + 1),3);
tj(1,:) = [0,0,1];
k = 1;
i = 1;
while (i <= length(t))
    if (j(i) ~= tj(k,2))
        k = k + 1;
        tj(k,:) = [t(i),j(i),0];
        tj(k,3) = (tj(k,1) - tj(k-1,1));
        if (tj(k,3) == 0)
            tj(k,3) = 1;
        end
    end
    i = i + 1;
end

% calculate minimum required switching frequency
fsmin = 1 / min(tj(:,3));

% Print minimum time between switching events
outputString = sprintf('Minimum period between switching events is %d seconds   ==>   f_{s,min} = %d Hz', min(tj(:,3)),fsmin);
text(0,-3.5,outputString);

end