
clear;clc;
path = 'C:\Users\sophi\Desktop\AI心理学研究\3-转移推理\3_数据分析\Data\';
result_file = path + "TI_3.5-Turbo_10item.xlsx";
% GPT_10item_result = xlsread(result_file);
GPT_10item_resultTable = readtable(result_file);
% one step result
oneStepId = [1,10,11,20,21,30,31,40,41,50,51,60,61,70,71,80,81,90];
oneStepId_all = [];
for times = 0:5
    temp_id = oneStepId + times*90;
    oneStepId_all = [oneStepId_all,temp_id];
end
result_oneStep = GPT_10item_resultTable(oneStepId_all,:);

% merge the same item pair of sequence
result_oneStep = result_oneStep(:,[1,2,end]);
odd_row = result_oneStep(1:2:end,:);
even_row = result_oneStep(2:2:end,:);
result_oneStep_merge = odd_row;
result_oneStep_merge.Result = (even_row.Result+odd_row.Result)/2;

% merge the same item pair of context and order
result_oneStep_mat = cell2mat(table2cell(result_oneStep_merge));
oneStep_split = zeros(9,6);
for i = 1:6
    start_point = 1+9*(i-1);
    end_point = 9*i;
    oneStep_split(:,i) = result_oneStep_mat(start_point:end_point,3);
end

oneStep_mean = mean(oneStep_split,2);
plot(oneStep_mean,'b--o')
xticklabels({'AB','BC','CD','DE','EF','FG','GH','HI','IJ'})
ylabel('Accuracy of LLM')
xlabel('Adjacent item pairs')
title('Location difference of adjacent relation recall performance')




