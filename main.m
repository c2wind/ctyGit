% copyright 2020, Precise Pervasive Lab
% Jingyuan Cheng, version 1.0.0
%
% the basic function finished
% the main function
% please set a breakpoint after each function to see the result of each
function main()

    %close all figures
    close all;
    
    %setup reference path for the sourcecode
    addpath('./sourcecode');
    
    %set plot background and conditions
    set(0,'DefaultAxesFontsize',15);                                                                                %句柄为0表示对背景设置
    set(0,'DefaultTextFontsize',15);
    set(0,'defaultfigurecolor','w');
            
    %the global parameter
    
    %grid size for the two models
    % !! these two parameters significantly influence the simulation time
    % please consider change it only slightly (e.g. decrease 20%) at the first time

    gridHeart=0.004;    %in meter                                                                                   %两个全局变量     心脏4mm，身体1cm
    gridBody=0.01;      %in meter
    
    %the time period for simulation, 
    %you can decrease the overall time and select a smaller grid to see the details
    % e.g. t=0.01:0.001:0.02
    %this parameter significantly influences the simulation time,
    
    t=0.05:0.005:0.8;    %in second                                                                                 %仿真时间，可以修改长度和间隔
    
    %the center of heart
    %used for creating the heart and also for ECG nodes' location
    shiftC=[-0.01,0.03,0.35];
    
    shiftC=[-0.02,0.02,0.35];                                                                                       %用哪个则把另一个注释掉
    
    %how to view the models
    dirView=[-168,13];                                                                                              %模型视角
    
    %create the body and heart model
    %the last parameter set to 1 to view the result
    heart=createHeartModel(gridHeart,shiftC,dirView,0);                                                             %最后一个参数把0改成1可以看结果，0就是不显示结果，均如此
    body=createBodyModel(gridBody,shiftC,dirView,0);
    
    %plot the two models
    %plotHeartABody(heart,body,0.2,dirView);                                                                         %plotHeartABody函数作图     %不显示createHeartModel和createBodyModel，直接用他们以及dirView作图
    
    %create how bipoles (should to be changed to dipoles) propogate through the whole heart within one period
    heart=pulsePropogate(heart,dirView,0);
    save('./sourcecode/model.mat','body','heart');                                                                  %把body和heart的变量保存到model.mat文件中
  
%    load('./sourcecode/model.mat');                                                                                %先注释掉，目前已经存了数据，之后改变的时候再load
    %create the voltages within the heart
    heart=getHeartVoltage(heart,t,dirView,0);                                                                       %获取心脏电压
    

    %create voltage at a ball around the heart, which is used later for calculate ECG at body surface               %心脏周围创建一个ECGball，为了在后面先计算包球上的电压分布  
    fileName='./sourcecode/V_leftbundlehinder.mat'; %save the result to this file                                   %左束支阻滞的情况
    createECGBall(body,heart,fileName,0);                                                                           %在左束支阻滞的情况下创建包球

    %visualize the ECG results
    % if multiple results shall be views, put them into the fileNameList and 
    % make sure the variable 't's are the same in all files                                                         %多元可视化时，自己把文件加入List里面
    fileNameList={fileName};
    viewECGSurf(fileNameList);

end