% plot the distance effect
function SymdisPlot2(choice,SybolStats,variable_pool,FigNames,modelID,promotionID)
figure
PromotionNames = ["Origin","Confidence","CoT"];
% influence of promotion strategy for each model
if choice == "promotion"
    % 4 models, 3 lines in each subplot
    for model_i = 1:4
        switch model_i
            case 1
                modelid = modelID.GPT35;
            case 2
                modelid = modelID.GPT4;
            case 3
                modelid = modelID.Llama3;
            case 4
                modelid = modelID.Qwen;
        end
        subplot(1,4,model_i)
        hold on
        for line_j = modelid
            temp_mean = eval(['SybolStats.mean_',cell2mat(cellstr(variable_pool(line_j)))]);
            temp_std = eval(['SybolStats.sem_',cell2mat(cellstr(variable_pool(line_j)))]);
            errorbar(SybolStats.SymDis+1,temp_mean,temp_std,...
                '-o','LineWidth',1.5,'MarkerSize',8,'DisplayName',FigNames(line_j));
        end
        title(FigNames(model_i))
        xlabel('Symbolic distance')
        ylabel('Accuracy')
        xlim([0.5,9.5])
        ylim([0.1,1.1])
        set(gca,'XTick',1:9,'XTickLabel',1:9)
        yline(0.5,'--','LineWidth',0.5,'Color','k')
        % legend("show")
        legend(PromotionNames)
        hold off   
    end
    

% compare different models' performance
elseif choice == "model"
    % 3 promotion strategies, 4 lines in each sublplot
    for promotion_i = 1:3
        subplot(1,3,promotion_i)
        hold on
        switch promotion_i
            case 1
                promotion_id = promotionID.origin;
            case 2
                promotion_id = promotionID.confidence;
            case 3
                promotion_id = promotionID.CoT;
        end
  
        for line_p = promotion_id
            temp_mean = eval(['SybolStats.mean_',cell2mat(cellstr(variable_pool(line_p)))]);
            temp_std = eval(['SybolStats.sem_',cell2mat(cellstr(variable_pool(line_p)))]);
            errorbar(SybolStats.SymDis+1,temp_mean,temp_std,...
                '-o','LineWidth',1.5,'MarkerSize',8,'DisplayName',FigNames(line_p));
        end
        title(PromotionNames(promotion_i))
        xlabel('Symbolic distance')
        ylabel('Accuracy')
        xlim([0.5,9.5])
        ylim([0.1,1.1])
        set(gca,'XTick',1:9,'XTickLabel',1:9)
        yline(0.5,'--','LineWidth',0.5,'Color','k')
        % legend("show")
        legend(FigNames(1:4))
        hold off

    end


end

end
