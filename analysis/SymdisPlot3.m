% chain vs jump for 4 models
function SymdisPlot3(TI_resultTable,variable_pool,model_groups)
data_symdis = grpstats(TI_resultTable,["TraOrd","SymDis"],"mean","DataVars",variable_pool(1:4));
% studyCond*symbol distance*model /*ci
means = [];
means(1,:,:) = table2array(data_symdis(1:9,4:end));
means(2,:,:) = table2array(data_symdis(10:end,4:end));
ci = [];
for StudyCon_i =1:2
    for i=1:4
        for j=1:9
            ci(StudyCon_i,j,i,1:2)=bootci(1000,@(x) mean(x),eval(strcat("TI_resultTable.",...
                variable_pool(i),"(TI_resultTable.SymDis==",string(j-1),...
                "&TI_resultTable.TraOrd==",string(StudyCon_i-1),")")))';
        end
    end
end
ci_lower = squeeze(ci(:,:,:,1));
ci_upper = squeeze(ci(:,:,:,2));
error_lower = means - ci_lower;
error_upper = ci_upper - means;

numSymdis = size(means, 2);
numCond = size(means, 1);
% colors = lines(numCond);
markers = {'o','s'};

figure
for model_i = 1:size(means, 3)
    subplot(1,4,model_i)
    hold on
    for i = 1:numCond
        errorbar(1:numSymdis, squeeze(means(i,:,model_i)), ...
            squeeze(error_lower(i,:,model_i)),squeeze(error_upper(i,:,model_i)),...
            '-o','Marker',markers(i),'CapSize', 5, 'LineWidth', 1.5,'DisplayName',string(model_groups(i)));
    end
    title(model_groups(model_i))
    xlabel('Symbolic distance')
    ylabel('Accuracy')
    xlim([0.5,9.5])
    ylim([-0.05,1.1])
    yline(0.5,'--','LineWidth',0.5,'Color','k')
    legend("Chain","Jump")
    set(gca,'XTick',1:numSymdis,'XTickLabel',1:9)

end
hold off

end
