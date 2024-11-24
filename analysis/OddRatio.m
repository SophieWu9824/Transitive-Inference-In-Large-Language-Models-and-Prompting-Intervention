function OddRatio(data)
a=data(1);b=data(2);c=data(3);d=data(4);
% 计算 Odds Ratio (OR)
OR = (a * d) / (b * c);

% 计算 log(OR) 的标准误差
SE_log_OR = sqrt((1/a) + (1/b) + (1/c) + (1/d));

% 计算 log(OR) 的置信区间
log_OR = log(OR);
CI_log_OR = [log_OR - 1.96 * SE_log_OR, log_OR + 1.96 * SE_log_OR];

% 转换为 OR 的置信区间
CI_OR = exp(CI_log_OR);

% 显示结果
disp(['Odds Ratio (OR): ', num2str(OR)]);
disp(['95% 置信区间: [', num2str(CI_OR(1)), ', ', num2str(CI_OR(2)), ']']);

end