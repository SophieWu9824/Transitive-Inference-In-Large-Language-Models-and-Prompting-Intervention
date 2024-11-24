

clear;clc;
path = 'C:\Users\sophi\Desktop\AIPsyResearch\3_TransitiveInference\2_DataAnalysis\DataOriginal\';
result_file = path + "TransInfer_data.xlsx";
result_file_nan = path + "TransInfer_data_NAN.xlsx";
TI_resultTable = readtable(result_file);
% cell 2 string
variable_pool = string(zeros(1,12));
for ind = 1:12
    variable_pool(ind) = cellstr(TI_resultTable.Properties.VariableNames(ind+6));
end
% model_groups = {'GPT-3.5-Turbo','GPT-4','Llama3-8B','Qwen'};
model_groups = ["GPT-3.5-Turbo","GPT-4","Llama3-8B","Qwen"];

SybolStats = grpstats(TI_resultTable,"SymDis",{"mean","std","sem"},...
    "DataVars",variable_pool);
% figure;
% hold on;
% each result: origin and promotion
FigNames = ["GPT-3.5-Turbo","GPT-4","Llama3-8B","Qwen",...
    "Confidence: GPT-3.5-Turbo","CoT: GPT-3.5-Turbo",...
    "Confidence: GPT-4","CoT: GPT-4",...
    "Confidence: Llama3-8B","CoT: Llama3-8B",...
    "Confidence: Qwen","CoT: Qwen"];
% display according to category
modelID = struct();
modelID.GPT35 = [1,5,6];
modelID.GPT4 = [2,7,8];
modelID.Llama3 = [3,9,10];
modelID.Qwen = [4,11,12];
promotionID = struct();
promotionID.origin = [1,2,3,4];
promotionID.confidence = [5,7,9,11];
promotionID.CoT = [6,8,10,12];

%% accuracy: recall vs infer
% ttest for the recall performance
recall = TI_resultTable(TI_resultTable.SymDis == 0,:);
infer = TI_resultTable(TI_resultTable.SymDis > 0,:);
% compare between models
RecalInferPlot(recall,infer,variable_pool,1)
StudyCondPlot(recall,infer,variable_pool,1) % origin, models comp
% modelComp(variable_pool)
% % plot recall, inference * chain, jump, four models

CondStats_recall = grpstats(recall,"Context",{"mean","std"},...
    "DataVars",variable_pool);
CondStats_infer = grpstats(infer,"Context",{"mean","std"},...
    "DataVars",variable_pool);

%% some human-like behavior effects
% % % % % 1. end item effect % % % % % 
EndItem_effect(variable_pool,TI_resultTable,model_groups,1)

% % % % % 2. symbolic distance effect % % % % %
% original symbolic distance of models
SymdisPlot1(TI_resultTable,variable_pool,model_groups)
SymdisPlot3(TI_resultTable,variable_pool,model_groups)

% % % % % 3. Context effect % % % % %
GPT35_ordat = [256,87,104,93]; % a,b,c,d
GPT4_ordat = [246,148,114,32];
Llama3_ordat = [245,104,115,76];
Qwen_ordat = [216,104,144,76];
OddRatio(GPT35_ordat)
OddRatio(GPT4_ordat)
OddRatio(Llama3_ordat)
OddRatio(Qwen_ordat)

% occasion=1: baseline performance
ContextPlot(TI_resultTable,variable_pool,model_groups,1); 

%% promotion performance
% % % 1. overall accuracy at original condition and promotion % % %
acc_prom = mean(TI_resultTable(:,7:18));

% plot_choice = "promotion";
plot_choice = "model";
SymdisPlot2(plot_choice,SybolStats,variable_pool,FigNames,modelID,promotionID)

% % 2. end-item effect amplification in models with badly performance % %
EndItem_effect(variable_pool,TI_resultTable,model_groups,2) % Prob
EndItem_effect(variable_pool,TI_resultTable,model_groups,3) % CoT

% % 3. context effect % %
ContextPlot(TI_resultTable,variable_pool,model_groups,2) % Prob
ContextPlot(TI_resultTable,variable_pool,model_groups,3) % CoT
% model confidence
OddRatioCompute.m

% % 4. influence of promotion to inference performance % %
RecalInferPlot(recall,infer,variable_pool,2) % Prob
RecalInferPlot(recall,infer,variable_pool,3)% CoT

% % 5. Chain vs Jump % %
StudyCondPlot(recall,infer,variable_pool,2) % Prob
StudyCondPlot(recall,infer,variable_pool,3) % CoT


