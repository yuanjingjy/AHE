% predict_ahe_event1.m - forecast acute hypotension using ABP waveform for Event 1
% Copyright (C) 2009  Xiaoxiao Chen <chenxia7@msu.edu>
%
% NOTE:
% Syntax: patientH = predict_ahe_event1(ABP)
% ABP: input matrix with each column corresponding to 5-min ABP waveform
%      of each patient respectively in Event 1
% patientH: indices of patients with acute hypotension

function patientH = predict_ahe_event1(ABP)

meanABP = mean(ABP); 
[ABPs idx] = sort(meanABP);
patientH = sort(idx(1:5));

end