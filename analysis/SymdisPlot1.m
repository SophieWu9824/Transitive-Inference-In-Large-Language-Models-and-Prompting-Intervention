function SymdisPlot1(TI_resultTable,variable_pool,model_groups)
data_symdis = grpstats(TI_resultTable,"SymDis","mean","DataVars",variable_pool(1:4));
data_sem = grpstats(TI_resultTable,"SymDis","sem","DataVars",variable_pool(1:4));
% symbol distance: 0-8 (row 1-9)
means = table2array(data_symdis(:,3:end));
sem = table2array(data_sem(:,3:end));
ci = [];
for i=1:4
    for j=1:9
        ci(j,1:2,i)=bootci(1000,@(x) mean(x),eval(strcat("TI_resultTable.",...
            variable_pool(i),"(TI_resultTable.SymDis==",string(j-1),")")))';
    end
end
ci_lower = squeeze(ci(:,1,:));
ci_upper = squeeze(ci(:,2,:));
error_lower = means - ci_lower;
error_upper = ci_upper - means;

numSymdis = size(means, 1);
numLines = size(means, 2);
colors = lines(numLines);
markers = {'o','s','d','x'};

figure
hold on
% for i = 1:4%numLines
%     errorbar(1:numSymdis, means(:,i), sem(:,i),'--o',...
%         'Marker',markers(i),'CapSize', 5, 'LineWidth', 1.5,...
%         'DisplayName',string(model_groups(i)));
% end

% 95% CI
for i = 1:numLines
    errorbar(1:numSymdis, means(:,i), error_lower(:,i), error_upper(:,i),'-o',...
        'Marker',markers(i),...
        'CapSize', 5, 'LineWidth', 1.5,...
        'DisplayName',string(model_groups(i)));
end
xlabel('Symbolic distance')
ylabel('Accuracy')
legend(model_groups)
xlim([0.5,9.5])
ylim([0.2,1.1])
set(gca,'XTick',1:numSymdis,'XTickLabel',1:9)

hold off


end