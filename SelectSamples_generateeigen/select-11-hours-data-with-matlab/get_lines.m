function lines = get_lines( fid )
%This function can be used to get the lines of a plain text file
%   Input:
%       fid: id of the file
%   Output:
%       lines: lines of the input file

lines=0;
while ~feof(fid)
    fgetl(fid);
    lines=lines+1;
end

end

