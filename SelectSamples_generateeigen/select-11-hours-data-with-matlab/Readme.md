# Content
***
* [Abstract](#abstract)
    * [loaddata.m](#loaddata)  
    * [age.m](#age)
    * [selectAHE.m](#selectahe)
        * [findAHE.m](#findahe)
        * [AHEEpisode.m](#aheepisode) 
    *  [select_nonAHE](#select_nonahe) 
        * [mvdir.m](#mvdir)
        * [selectnon.m](#selectnon)
        * [findnonAHE.m](#findnonahe)
        
 ## abstract
    该文件夹内程序的主要功能为：  
        1. 对原始波形文件去除基线和增益，按照特定顺序排列各参数
        2. 从每个数据记录对应的头文件中提取年龄和性别
        3. 根据AHE定义，从全部数据记录中筛选发生AHE的11小时数据段
        4. 挑选完AHE患者后，从剩余患者中筛选出未发生AHE的11小时数据段
### loaddata
    % Description：
    %   本程序对convert_wavedata之后的原始波形文件进行格式转换，按照基线、增益处理后，
    %   将生理参数按照特定的顺序进行排列：HR、SBP、DBP、MBP、PULSE、RESP、SPO2
    %Input data：
    %   path='D:\Available_yj\already\，convert_wavedata之后的数据
    %Output data：
    %   以"_selected.mat"结尾的文件，存放到path里


### age
    % Description:
    %   从.hea文件中提取患者的年龄和性别，对于缺失情况用-100代替，然后从临床数据库
    %   中提取或插值补全
    % Input:
    %   path='D:\Available_yj\already\*nm.hea'
    %Output:
    %   path='D:\Available_yj\already\*_age.mat'


### selectahe
    %Description：
    %   从path='D:\Available_yj\already\*_selected.mat'文件中筛选发生急性低血压的样本，
    %   将发生的存储到path=‘D:\1yj_AHE\'中
    %Input:
    %   path='D:\Available_yj\already\*_select.mat'
    %Output:
    %   path='D:\1yj_AHE\*_AHE.mat'
    
#### findahe
        function [AHEdata] = findAHE( inputdata,ForecastWin,Win,VAL,TOL)
        %------------------------程序功能说明-------------------%
        %本程序的功能为按照急性低血压的定义：预测窗口内（1个小时）对于给定的每分钟
        %采样一次的动脉平均压值，在任意30分钟或更长的时间段内，有超过90%的血压值
        %低于60mmHg时，认为该患者出现了急性低血压。
        %
        %首先判断数据长度：
        %       当数据长度不足十一小时时，记录当前编号，输出提示：数据长度不足；
        %       当数据长度超过十一小时时，从第十个小时之后的点开始判断是否会发生AHE       
        %       重叠长度为10min，整个11个小时长度的数据段，重叠长度为10min进行移动
        %
        % 输出参数：
        %       AHEdata：最后1个小时发生了急性低血压的共11(或3)小时的数据
        %
        %输入参数：
        %       inputdata：待判断数据段
        %       ForcastWin：预测窗口的长度，1个小时，（输入60）
        %       Win:最小的移动窗口的长度，半个小时（输入21）
        %       VAL：发生低血压时血压值的最低限值，60mmHg（输入60）
        %       TOL：Win内血压值地与VAL的个数占整个窗口的比例（输入0.9）
        
#### aheepisode
        function [ ahe_find] = AHEEpisode( input,WIN,VAL,TOL )
        %Description:
        %   该函数的功能为判断1个小时的数据窗口内是否发生了急性低血压
        %输出参数：
        %   ahe_find:标识该1小时的预测窗口内是否发生了急性低血压，
        %            值为1表示发生，值为0表示未发生       
        %
        %输入参数：
        %	input：待判断的1小时的数据段
        %   WIN：判断窗的长度，30min或更长
        %   VAL：发生低血压的ABPMean下限值，为60mmHg
        %   TOL：发生AHE时，低于下限值VAL的点所占的比例，为0.9

### select_nonahe
    文件夹，里面的两个文件用来筛选对照组：未发生急性低血压的样本

#### mvdir
    %Description:
    %   1.提取出所有发生低血压的病例的文件名称
    %   2.将发生低血压的病例的数据文件夹移动到指定位置，剩下的即为未发生低血压的数据
    % Input：
    %   pathahe='D:\1yj_AHE'
    %Output:
    %   path='D:\Available_yj\AHEdir'

#### selectnon
    function [ startpoint,output_data ] = selectnon( input_data )
    %selectnon 函数筛选未发生低血压的病例
    %筛选规则：
    %   1.数据长度大于11小时
    %   2.最后1小时数据中，大于60mmHg的有27个以上
    %   3.最后1小时数据中，小于等于0的值在10%以下
    %   4.前10个小时的数据，所有数据缺失比例在30%以内
    %
    %   Input：
    %       input_data:输入的待判断数据段；
    %   Output：
    %       output_data:筛选结果，遇到1个符合规则的即保存，后续数据不再进行判断
    %       startpoint:11小时数据段的起始位置

#### findnonahe
    %Description:
    %   调用selectnon.m文件，筛选未发生急性低血压的样本
    %Input:
    %   path_nonAHE='D:\Available_yj\already\*select.mat'：该路径下的发生AHE的原始数据已转移
    %Output：
    %   path='D:\1yj_nonAHE\*_non.mat'