% rlcseries.m
% Ricardo E. Avila / ricardoavila.org / 2011 Mar. 06

% Solution of a RLC circuit, connected in series, 
% using a Fourier series expansion with real terms 

clc; % clear Matlab command window 
 
clear; % clear Matlab memory space 
 
disp('Time response of RLC series circuit')
% Physical parameters of RLC circuit 
freq = 60;  % Hz
R = .6;  % ohm
L = 100e-3; % henry 
C = 560E-4; % farad 
T = 1/freq; % period of voltage signal driving the circuit 
el = T/2; % half length of period 

% Simulation parameters
end_time = 5*T;     % end time of simulation 
n_steps = 200;  % number of fixed time steps in simulation 

% number of terms in Fourier series. Suggested value: 20 
N_terms = input('How many terms to use in Fourier series? '); 

A = zeros(2, 2);  % a matrix for calculation of Fourier series
RHS = zeros(2, 1)'; % right-hand-side for a 2x2 linear system 
x = zeros(2, 1)';  % temporary variable, solution of linear system 

% Memory allocation for variables used in Matlab simulation
t = (0 : end_time/n_steps : end_time)'; % time, s (column array)
t_rows = size(t, 1);    % This is the size of the time array. 
q_t = zeros(t_rows, 1); % Electric charge q(t), a column array. 
fourier_c = zeros(N_terms, 2); % matrix of Fourier coefficients 

% Processing 
for t_index = 1 : t_rows
    % Optional display of time step: remove semicolon of next line  
    time_step = t(t_index);

    % Calculate elements of matrix for Fourier coefficients
    for n_index = 1 : N_terms; % n_index is the nth. Fourier term 
        % nth. frequency component of Fourier series
        n_coef = n_index * pi/el;  
    RHS = zeros(2, 1); % right-hand-side for a 2x2 linear system 
    A(1,1) = 1/C - L * n_coef^2;
    A(1,2) = n_coef * R;
    A(2,1) = -A(1,2);
    A(2,2) = A(1,1);

    % Calculate right-hand side of linear equations: for odd term 
    % of Fourier series, the Fourier coefficients of square wave.   
    if (rem(n_index, 2)~=0); % Use Matlab's remainder (rem) function. 
       RHS(2, 1) = 4/(n_index * pi); % For odd numbered terms. 
    else 
       RHS(2, 1) = 0; % Even numbered coefficients are zero. 
    end; 
 
    % Solve a 2x2 algebraic linear system for Fourier coefficients: 
    x = A \ RHS; % solve system using an efficient Matlab algorithm 
    fourier_c(n_index, 1) = x(1); % Coefficient for cosines 
    fourier_c(n_index, 2) = x(2); % Coefficient for sines 

    % Build Fourier series, adding terms with Fourier coefficients 
    q_t(t_index) =  q_t(t_index) + ... 
       fourier_c(n_index, 1) * cos(n_coef * t(t_index)) + ... 
       fourier_c(n_index, 2) * sin(n_coef * t(t_index)); 
    end; % end for nth. frequency component of Fourier series
end % end calculation of Fourier coefficients for one time step

% Post-processing

% For a capacitor, Voltage = charge/Capacitance.
V_out = (1/C)*q_t;  

figure(1)
plot(t, V_out, 'r', 'LineWidth', 2) 
axis auto 
grid 
xlabel('time, s') 
ylabel('Output voltage, Vout')
title('Time response of RLC series circuit') 

figure(2) 
subplot(2, 1, 1) 
plot(fourier_c(:, 1), 'b', 'LineWidth', 2)
xlabel('Output voltage series: Fourier coefficients for cosines ') 
grid
subplot(2, 1, 2) 
plot(fourier_c(:, 2), 'k', 'LineWidth', 2)
xlabel('Output voltage series: Fourier coefficients for sines ')
grid

disp(' ')
disp('Matlab program executed with success.') 
disp('_____________________________________')