% Enhanced Epidemic Modeling with Progressive Susceptible Population Decline

% Parameters
population_size = 50000;% Adjust to your specific neeeds be warned that it will affect run time
initial_infected = 1;%I want to start with only one infected person. While this could make
%the model run for a long time, this can be adjusted
% Define the number of time steps
time_steps = round(100);% Running the simulation for about 100days.I have initialized 
%my timesteps as daily, meaning i am recording number of infected,recovered
%and susceptible individuals daily.For 100 which is an arbitrary number.
% Defining the vaccination rate and social distancing factor
vaccination_rate = 0.7; %70% of susceptible individuals get vaccinated each time step
social_distancing_factor = 0.5;% Reduces the probability of infection by 50%

% Defining the infection probability
infection_probability = 0.05;% 5% chance of a susceptible individual getting infected each day
%which means there’s a 5% chance of a susceptible individual getting infected each day.
recovery_duration = 14; % The number of days an infected individual takes to fully recover
%i.e 14 

% Initialize health status
health_status = zeros(population_size, 1);%Each element in this array represents the 
%health status of an individual. Since  all values to zero, it implies that everyone 
%is currently healthy (susceptible)
health_status(randperm(population_size, initial_infected)) = 1; % Infected individuals

% Initialize counts
% Initialize the counts
%The codes below are used to keep track of the number of susceptible,
%infected and recovered individuals at each time step.
susceptible_count = zeros(time_steps, 1);
infected_count = zeros(time_steps, 1);
recovered_count = zeros(time_steps, 1);

% simulate through days
for t = 1:time_steps
    % Update health status based on disease transmission rules
    infected_individuals = find(health_status == 1);
    susceptible_individuals = find(health_status == 0);
    for i = 1:length(infected_individuals)
        % Each infected individual can infect susceptible individuals
        susceptible_to_infect = susceptible_individuals(rand(size(susceptible_individuals)) < infection_probability * (1 - social_distancing_factor));
        health_status(susceptible_to_infect) = 1;
    end
    
    % Apply mitigation strategies
    % Vaccination
    susceptible_individuals = find(health_status == 0);
    num_vaccinated = round(vaccination_rate * length(susceptible_individuals));
    health_status(susceptible_individuals(randperm(length(susceptible_individuals), num_vaccinated))) = 2;
    
    % Progressively move infected to recovered after recovery duration
    recovered_individuals = find(health_status == 1);
    for i = 1:length(recovered_individuals)
        if rand < 1 / recovery_duration
            health_status(recovered_individuals(i)) = 2; % Move to recovered state
        end
    end
    
    % Update susceptible count
    susceptible_count(t) = sum(health_status == 0);
    
    % Collect data
    infected_count(t) = sum(health_status == 1);
    recovered_count(t) = sum(health_status == 2);
end

% Plot results
figure;
plot(1:time_steps, susceptible_count, 'b', 1:time_steps, infected_count, 'r', 1:time_steps, recovered_count, 'g');
legend('Susceptible', 'Infected', 'Recovered');
xlabel('Time Step');
ylabel('Count');
title('Epidemic Modeling with Progressive Susceptible Population Decline');


