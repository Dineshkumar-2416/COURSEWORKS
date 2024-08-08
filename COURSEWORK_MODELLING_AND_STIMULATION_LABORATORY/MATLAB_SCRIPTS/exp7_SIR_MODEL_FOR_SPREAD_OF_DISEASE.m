%MATLAB code
% Model parameters
beta = 5*10^-9; % rate of infection
gamma = 0.07; % rate of recovery
delta = 0; %delta= 0.01% rate of immunity loss
N = 9*10^7; % Total population N = S + I + R
I0 = 100; % initial number of infected
T = 300; % period of 300 days
dt = 1/4; % time interval of 6 hours (1/4 of a day)
fprintf('Value of parameter R0 is %.2f',N*beta/gamma)
% Calculate the model
[S,I,R] = sir_model(beta,gamma,delta,N,I0,T,dt);
% Plots that display the epidemic outbreak
tt = 0:dt:T-dt;
% Curve
figure()
plot(tt,S,'b',tt,I,'r',tt,R,'g','LineWidth',2); grid on;
xlabel('Days'); ylabel('Number of individuals');
legend('S','I','R');
% Map
figure()
plot(I(1:(T/dt)-1),I(2:T/dt),"LineWidth",1,"Color",'r');
hold on; grid on;
plot(I(2),I(1),'ob','MarkerSize',4);
xlabel('Infected at time t'); ylabel('Infected at time t+1');
hold off;
function [S,I,R] = sir_model(beta,gamma,delta,N,I0,T,dt)
% if delta = 0 we assume a model without immunity loss
S = zeros(1,T/dt);
S(1) = N;
I = zeros(1,T/dt);
I(1) = I0;
R = zeros(1,T/dt);
for tt = 1:(T/dt)-1
    % Equations of the model
    dS = (-beta*I(tt)*S(tt) + delta*R(tt)) * dt;
    dI = (beta*I(tt)*S(tt) - gamma*I(tt)) * dt;
    dR = (gamma*I(tt) - delta*R(tt)) * dt;
    S(tt+1) = S(tt) + dS;
    I(tt+1) = I(tt) + dI;
    R(tt+1) = R(tt) + dR;
 end
end