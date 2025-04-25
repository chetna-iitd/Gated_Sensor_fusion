function [tot_energy,compute_energy,communication_energy,compute_delay,communication_delay,accuracy_ret] = policy_gradient1_motorway(delay_constraint,accuracy_constraint,num_usesrs)
%%Create MATLAB Environment Using Custom Functions

%Cart-Pole MATLAB Environment
% rlFunctionEnv

ObservationInfo = rlNumericSpec([5 1]);
ObservationInfo.Name = 'Block deployment states';
ObservationInfo.Description = 'device, edge';

ActionInfo = rlFiniteSetSpec([1 2]);
ActionInfo.Name = 'Deployment Action';

Action=randi([1,2],1,1);

% Theta (randomize)
T0 = 1;%2 * 0.05 * rand() + 0.005;
% Thetadot
Td0 = 1;
% X
X0 = 1;
% Xdot
Xd0 = 1;

% Xddot
Xdd0 = 1;



% Return initial environment state variables as logged signals.
LoggedSignal.State = [X0;Xd0;T0;Td0;Xdd0];
InitialObservation = LoggedSignal.State;
save('const','delay_constraint','accuracy_constraint');
[Observation,Reward,IsDone,LoggedSignals,tot_energy,compute_energy,communication_energy,compute_delay,communication_delay,accuracy_ret] = myStepFunction_motorway(Action,LoggedSignal);

env = rlFunctionEnv(ObservationInfo,ActionInfo,'myStepFunction_motorway','myResetFunction_motorway');

obsInfo = getObservationInfo(env);
numObservations = obsInfo.Dimension(1);
actInfo = getActionInfo(env);
numActions = numel(actInfo.Elements);

rng(0);

actorNetwork = [
    featureInputLayer(numObservations,'Normalization','none','Name','state')
    fullyConnectedLayer(numActions,'Name','action','BiasLearnRateFactor',0)];

actorOpts = rlRepresentationOptions('LearnRate',5e-3,'GradientThreshold',1);

actor = rlStochasticActorRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'state'},actorOpts);

baselineNetwork = [
    featureInputLayer(numObservations,'Normalization','none','Name','state')
    fullyConnectedLayer(8,'Name','BaselineFC')
    reluLayer('Name','CriticRelu1')
    fullyConnectedLayer(1,'Name','BaselineFC2','BiasLearnRateFactor',0)];

baselineOpts = rlRepresentationOptions('LearnRate',5e-3,'GradientThreshold',1);

baseline = rlValueRepresentation(baselineNetwork,obsInfo,'Observation',{'state'},baselineOpts);

agentOpts = rlPGAgentOptions(...
    'UseBaseline',true, ...
    'DiscountFactor',0.9);

agent = rlPGAgent(actor,baseline,agentOpts);

%%%Train 
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',50, ...
    'MaxStepsPerEpisode',50, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',0.5,...
    Plots='none');

%plot(env)

%doTraining = true;

%if doTraining    
    % Train the agent.
  %  agent.trainParam.showWindow = 0; 
    trainingStats = train(agent,env,trainOpts);
%else
    % Load the pretrained parameters for the example.
%    load('DoubleIntegPGBaseline.mat');
%end


simOptions = rlSimulationOptions('MaxSteps',100);
experience = sim(env,agent,simOptions);
totalReward = sum(experience.Reward);
tot_energy;
end