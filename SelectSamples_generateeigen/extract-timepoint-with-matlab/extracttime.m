function starttimestr = extracttime( timestr )
%Description:
%   ����ȡ�������ڲ���ˣ�ֱ����datestr�ܳ���
%Input:
%   timestr:ʱ���ַ���
%Output:
%   starttimestr:PostgresSQL֧�ֵ�ʱ���ַ���
%������������������������������������������������������������������������%
%��ʱ���ַ�������ȡ���ꡢ�¡��ա�ʱ���֡���
year=timestr(end-3:end);
month=timestr(end-6:end-5);
day=timestr(end-9:end-8);

hour=timestr(1:2);
min=timestr(4:5);
sec=timestr(7:8);

%����ȡ������������ʱ����ת��Ϊ��ֵ����
year=str2num(year);
month=str2num(month);
day=str2num(day);

hour=str2num(hour);
min=str2num(min);
sec=str2num(sec);

%ʱ���ʽת��
time_value=[year month day hour min sec];
time_tmp=datenum(time_value);%����ֵ����ת��Ϊʱ���͵�˫������ֵ
starttimestr=datestr(time_tmp,31);%ת��Ϊpostgresql֧�ֵĸ�ʽ
end

