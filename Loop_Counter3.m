function [T,P]=Loop_Counter3(Time,Initial,Parameters)

Xstart=Initial(1);         % set Xstart = X0 = initial Susceptibles 
Ystart=Initial(2);         % set Ystart = Y0 = initial Infected
Ys_Start=Initial(3);       % Superspreaders  
Zstart=Initial(4);         % set Zstart = Z0 = initial Recovered
timestep=Parameters(6);    % set the timestep
vaccination_rate=Parameters(7); % set the vaccination rate

T=[0:timestep:Time(2)]; P(1,:)=[Xstart Ystart Ys_Start Zstart];
old=[Xstart Ystart Ys_Start Zstart];

loopcount=1;

% after setting everything up, A42 just runs the loop counter. 
% at each iteration it updates Ppopulation vector P = (X,Y,Z) 
% according to the master equation described in A43.

while (T(loopcount)<Time(2))  
    [new]=ME_Update2(old,Parameters);
    
    % Apply vaccination
    new(1) = new(1) - vaccination_rate * old(1); % Reduce susceptibles
    new(4) = new(4) + vaccination_rate * old(1); % Increase recovered
    
    loopcount=loopcount+1;
    P(loopcount,:)=new;
    old=new;
end
