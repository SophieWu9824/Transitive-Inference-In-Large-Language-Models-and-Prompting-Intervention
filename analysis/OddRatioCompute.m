
% 
% model confidence
GPT35_ordat_Prob = [203,83,157,97]; % a,b,c,d
GPT4_ordat_Prob = [326,178,34,2];
Llama3_ordat_Prob = [255,105,105,75];
Qwen_ordat_Prob = [156,49,204,131];
OddRatio(GPT35_ordat_Prob)
OddRatio(GPT4_ordat_Prob)
OddRatio(Llama3_ordat_Prob)
OddRatio(Qwen_ordat_Prob)
% chain-of-thought
GPT35_ordat_CoT = [138,101,222,79]; % a,b,c,d
GPT4_ordat_CoT = [275,144,85,36];
Llama3_ordat_CoT = [219,138,141,42];
Qwen_ordat_CoT = [196,98,164,82];
OddRatio(GPT35_ordat_CoT)
OddRatio(GPT4_ordat_CoT)
OddRatio(Llama3_ordat_CoT)
OddRatio(Qwen_ordat_CoT)