function starttimestr = extracttime( timestr )
%Description:
%   将提取出的日期拆分了，直接用datestr总出错
%Input:
%   timestr:时间字符串
%Output:
%   starttimestr:PostgresSQL支持的时间字符串
%————————————————————————————————————%
%从时间字符串中提取出年、月、日、时、分、秒
year=timestr(end-3:end);
month=timestr(end-6:end-5);
day=timestr(end-9:end-8);

hour=timestr(1:2);
min=timestr(4:5);
sec=timestr(7:8);

%将提取出来的年月日时分秒转换为数值类型
year=str2num(year);
month=str2num(month);
day=str2num(day);

hour=str2num(hour);
min=str2num(min);
sec=str2num(sec);

%时间格式转换
time_value=[year month day hour min sec];
time_tmp=datenum(time_value);%将数值矩阵转换为时间型的双精度数值
starttimestr=datestr(time_tmp,31);%转换为postgresql支持的格式
end

