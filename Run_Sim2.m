function [t,XX,YY,ZZ] = Run_Sim2(AA,R,RR,BR,SP,II,IIs,PS, timestep, Tmax)

% default initial values (originals listed in comments)
if nargin == 0
   AA=1;                    % rate for Susceptibles + superspreaders(1)
   R=5;                    % NEW INFECTION RATE for Superspreaders 

   RR=0.1;                  % Recovery rate for Infected (1/10)
   BR=5.9e-4;                 % Birth rate = death rate (5.9e-4)
   PS=50000;                 % Initial population size (50000)
   II=ceil(BR*PS/RR);       % Initial Infected 
   IIs=ceil(0.1*BR*PS/RR);  % NEW Initial Infected Superspreaders = 0;
                            % 10% of the infected are superspreaders
   SP=floor(RR*PS/AA);      % Initial Susceptible Population (BB*N0/AA)
   timestep=1;              % timestep is days
   Tmax=5*365;              % Total run time of simulation (5*365 days)
end

% Initial recovered population Z0
% = Initial total population - Initial Susceptibles - Initial Infectious 
Z0=PS-SP-II-IIs; 

% after that, run A42 with starting values to evolve population
[t, pop]=Loop_Counter2([0 Tmax],[SP II IIs Z0],[AA R RR BR PS timestep]);
T=t/365; 
XX=pop(:,1); % susceptible population
YY=pop(:,2)+pop(:,3); % infectious population = average+superspreaders
ZZ=pop(:,4); % recovered population

% Cumulative cases and recoveries
cumulative_cases = cumsum(YY);
cumulative_recoveries = cumsum(ZZ);

figure;
subplot(2,1,1)
plot(T, cumulative_cases, '-b');
xlabel 'Time in years'
ylabel 'Cumulative Cases'
title('Cumulative Cases Over Time')

subplot(2,1,2)
plot(T, cumulative_recoveries, '-m');
xlabel 'Time in years'
ylabel 'Cumulative Recoveries'
title('Cumulative Recoveries Over Time')



% Box plots
figure;
boxplot([XX, YY, ZZ], 'Labels', {'Susceptible', 'Infectious', 'Recovered'});
xlabel 'Population Groups'
ylabel 'Population Size'
title('Epidemic Simulation: Box Plots')

% Original subplots
figure;
subplot(3,1,1)
h=plot(T,XX,'-g');
xlabel 'Time in years'
ylabel 'Susceptible'

subplot(3,1,2)
h=plot(T,YY,'-r');
xlabel 'Time in years'
ylabel 'Infectious'

subplot(3,1,3)
h=plot(T,ZZ,'-k');
xlabel 'Time in years'
ylabel 'Recovered'

