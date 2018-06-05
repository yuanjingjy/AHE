function [y]=mmNormalize(X, minV ,maxV)

X=X(:);
% X=X+dbia;
%========================== Range [minV..maxV]
maxX=max(X);
minX=min(X);
den=maxX-minX;

if maxX==minX
    y=X;
else
    y= minV + (maxV-minV)*(X-minX)/(maxX-minX);
end

end

