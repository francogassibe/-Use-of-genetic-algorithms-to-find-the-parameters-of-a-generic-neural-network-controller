close all
clc 
clear

popsize=40;
n_generations=1000;

n_features=60;
n_hiden_layers=2;
n_neurons=[20 5];

nparam=(n_features+1)*n_neurons(1)+n_neurons(end)+1;
if n_hiden_layers>1
    for j=1:n_hiden_layers-1
    
        nparam=nparam+(n_neurons(j)+1)*n_neurons(j+1);

    end
end
nparam;
 
options=optimoptions(@ga,'PopulationSize',popsize,'MaxGenerations',n_generations);
lb=-10000;
ub=10000;

best_NNLaw_param=ga(@LQR_NNLaw,nparam,[],[],[],[],lb,ub,[],[],options)



nparam=3;
n_generations=200;
options=optimoptions(@ga,'PopulationSize',popsize,'MaxGenerations',n_generations);
bestparam=ga(@LQRpid,nparam,-eye(nparam),zeros(nparam,1),[],[],[0,0,0],[1000000,100000,100000],[],[],options)

figure(1)
hold on 
title('Respons from a 2deg sistem to a step')
xlabel('time');
ylabel('Position');
plot(step_pid(bestparam),'r');
plot(step_NNLaw(best_NNLaw_param),'b');
hold off
