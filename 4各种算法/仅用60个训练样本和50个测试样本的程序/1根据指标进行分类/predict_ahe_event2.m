% predict_ahe_event2.m - forecast acute hypotension using ABP waveform for Event 2
% Copyright (C) 2009  Xiaoxiao Chen <chenxia7@msu.edu>
%
% NOTE:
% Syntax: [Bidx patientH] = predict_ahe_event2(ABP)
% ABP: input matrix with each column corresponding to 5-min ABP waveform
%      of each patient respectively in Event 2
% Bidx: total number of classified patients with acute hypotension
% patientH: indices of classified patients with acute hypotension

function [Bidx patientH] = predict_ahe_event2(ABP)

meanABP = mean(ABP); 
[ABPs idx] = sort(meanABP);
DABP = diff(ABPs);  
% find the maximal gap while keep H within 10~16
[diffm idxm] = max(DABP(10:16)); 
Bidx = idxm+10-1; % Number of patients in H group
patientH = sort(idx(1:Bidx));

end