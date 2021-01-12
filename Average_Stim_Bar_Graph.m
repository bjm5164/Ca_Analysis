% Compare Multiple Conditions DF/F 

%% Get Data

number_of_conditions = input('How Many Conditions?')
for i = 1:number_of_conditions
    [filename, pathname] = uigetfile('Post_Stimulus_Df')
    load(strcat(pathname,'/',filename));
    experiment_name = strsplit(filename,'.');
    experiment_name = experiment_name{1,1};
    Experiments(i).Experiment_Name = experiment_name; clear filename and experiment_name and pathname
    Experiments(i).Post_Stim_Df = Post_stimulus_delta_f; clear Post_stimulus_delta_f
    Experiments(i).Condition = input('Title of Condition ie ATR+ (ENTER IT LIKE A STRING BOUNDED with '')');
end
for i = 1:number_of_conditions
    Conditions{i} = Experiments(i).Condition;
end
Condition_1_mean = mean(Experiments(1).Post_Stim_Df)
Condition_2_mean = mean(Experiments(2).Post_Stim_Df)
Condition_1_std = std(Experiments(1).Post_Stim_Df)
Condition_2_std = std(Experiments(2).Post_Stim_Df)
%% Run hypothesis tests

[h_ktest_c1,p_ktest_c1,k_teststat1] = kstest(Experiments(1).Post_Stim_Df)
[h_ktest_c2,p_ktest_c2, k_teststat2] = kstest(Experiments(2).Post_Stim_Df)
if h_ktest_c1 == 0 & p_ktest_c1<=.05 & h_ktest_c2==0 & p_ktest_c2<=.05
    disp('Doing ttest')
    [~,pval_ttest,ci,ttest_stats] = ttest2(Experiments(1).Post_Stim_Df,Experiments(2).Post_Stim_Df)
else
    disp('Doing Mann-Whitney')
    [pval_mw,~, mw_stats] = ranksum(Experiments(1).Post_Stim_Df,Experiments(2).Post_Stim_Df)
end
%disp(['P-Value:']); 
%% Plot graphs 
figure; hold on 
bar([Condition_1_mean,Condition_2_mean])
errorbar([Condition_1_mean,Condition_2_mean],[Condition_1_std,Condition_2_std],'.','Color','k')
ylabel('Mean post-stimulus DF/F') 
xlim([.5,2.5])
ylim([-0.5, 3])
xticks([1,2])
xticklabels(Conditions)
plot([1,2],[mean([2.5,max([Condition_1_mean+Condition_1_std,Condition_2_mean+Condition_2_std])]),mean([2.5,max([Condition_1_mean+Condition_1_std,Condition_2_mean+Condition_2_std])])],'k')
if exist('pval_mw') == 1
    if  pval_mw < .05
        text(1.5,mean([2.5,max([Condition_1_mean+Condition_1_std,Condition_2_mean+Condition_2_std])]) + .1*mean([2.5,max([Condition_1_mean+Condition_1_std,Condition_2_mean+Condition_2_std])]), strcat('p=',num2str(pval_mw)))
    else 
        text(1.5,mean([2.5,max([Condition_1_mean+Condition_1_std,Condition_2_mean+Condition_2_std])]) + .1*mean([2.5,max([Condition_1_mean+Condition_1_std,Condition_2_mean+Condition_2_std])]), 'NS')
    end
elseif exist('pval_ttest') == 1
        if pval_ttest < .05
            text(1.5,mean([2.5,max([Condition_1_mean+Condition_1_std,Condition_2_mean+Condition_2_std])]) + .1*mean([2.5,max([Condition_1_mean+Condition_1_std,Condition_2_mean+Condition_2_std])]), strcat('p=',num2str(pval_ttest)))
        else
            text(1.5,mean([2.5,max([Condition_1_mean+Condition_1_std,Condition_2_mean+Condition_2_std])]) + .1*mean([2.5,max([Condition_1_mean+Condition_1_std,Condition_2_mean+Condition_2_std])]), 'NS')
        end
end
set(gcf,'Color','w')
set(findall(gcf,'-property','FontSize'),'FontSize',18);

%%
disp('Select output directory');
saveas(gcf,strcat(uigetdir,'/',input('Figure_Name?'),'.svg'))
