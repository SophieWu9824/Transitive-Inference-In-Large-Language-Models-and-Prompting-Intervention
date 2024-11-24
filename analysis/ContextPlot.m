function ContextPlot(TI_resultTable,variable_pool,model_groups,occasion)
% id for model and promotion method
origin_id = [1,2,3,4];
Prob_id = [5,7,9,11];
CoT_id = [6,8,10,12];
title_pool = ["","Confidence","Chain-of-Thought"];
switch occasion
    case 1
        name_id = origin_id;
    case 2
        name_id = Prob_id;
    case 3
        name_id = CoT_id;
end
% accuracy of each model in social and non-social context
%  plot for the chain and jump condition respectively
data_interest = TI_resultTable(:,[1,2,name_id+6]);
data_social = data_interest(data_interest.Context~=2,:);
data_nonsocial = data_interest(data_interest.Context==2,:);
means_social = grpstats(data_social,"TraOrd","mean","DataVars",...
    variable_pool(name_id));
means_nonsocial = grpstats(data_nonsocial,"TraOrd","mean","DataVars",...
    variable_pool(name_id));

% context*model*chain/jump
% row1-social, row2-nonsocial
chain_means = [table2array(means_social(1,3:end));...
    table2array(means_nonsocial(1,3:end))];
jump_means = [table2array(means_social(2,3:end));...
    table2array(means_nonsocial(2,3:end))];
means_contxt(:,:,1) = chain_means;
means_contxt(:,:,2) = jump_means;

% ci的结构与means是一样的
ci_contxt = [];
for StudyCond_i = 1:2
    temp = 0;
    for model_i = name_id
        temp = temp +1;
        % social/nonsocial, ci, model_i, chain/jump
        % row1-social, row2-nonsocial
        ci_contxt(1:2,1:2,temp,StudyCond_i) = [bootci(1000,@(x) mean(x),...
            eval(strcat("data_social.",variable_pool(model_i),"(data_social.TraOrd==",string(StudyCond_i-1),")")))';
            bootci(1000,@(x) mean(x),...
            eval(strcat("data_social.",variable_pool(model_i),"(data_social.TraOrd==",string(StudyCond_i-1),")")))'];
    end
end
ci_lower = squeeze(ci_contxt(:,1,:,:));
ci_upper = squeeze(ci_contxt(:,2,:,:));
error_lower = means_contxt-ci_lower;
error_upper = ci_upper-means_contxt;

figure
cond = ["Chain","Jump"];
for i=1:2 % chain or jump
    x = squeeze(means_contxt(1,:,i));
    y = squeeze(means_contxt(2,:,i));
    x_err_lower = error_lower(1,:,i);
    x_err_upper = error_upper(1,:,i);
    y_err_lower = error_lower(2,:,i);
    y_err_upper = error_upper(2,:,i);
    
    subplot(1,2,i)
    hold on
    for model_j = 1:4
        errorbar(x(model_j),y(model_j),y_err_lower(model_j),y_err_upper(model_j),...
            x_err_lower(model_j),x_err_upper(model_j),'o','MarkerSize', 8, 'MarkerFaceColor', 'auto', 'LineWidth', 1.5);
    end
    plot([0,1],[0,1],'k--');
    title(strcat(title_pool(occasion)," ",cond(i)))
    xlabel("Accuracy in social context")
    ylabel("Accuracy in non-social context")
    grid on;
    legend(model_groups)

end

hold off



end