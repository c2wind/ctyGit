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
    set(0,'DefaultAxesFontsize',15);                                                                                %���Ϊ0��ʾ�Ա�������
    set(0,'DefaultTextFontsize',15);
    set(0,'defaultfigurecolor','w');
            
    %the global parameter
    
    %grid size for the two models
    % !! these two parameters significantly influence the simulation time
    % please consider change it only slightly (e.g. decrease 20%) at the first time

    gridHeart=0.004;    %in meter                                                                                   %����ȫ�ֱ���     ����4mm������1cm
    gridBody=0.01;      %in meter
    
    %the time period for simulation, 
    %you can decrease the overall time and select a smaller grid to see the details
    % e.g. t=0.01:0.001:0.02
    %this parameter significantly influences the simulation time,
    
    t=0.05:0.005:0.8;    %in second                                                                                 %����ʱ�䣬�����޸ĳ��Ⱥͼ��
    
    %the center of heart
    %used for creating the heart and also for ECG nodes' location
    shiftC=[-0.01,0.03,0.35];
    
    shiftC=[-0.02,0.02,0.35];                                                                                       %���ĸ������һ��ע�͵�
    
    %how to view the models
    dirView=[-168,13];                                                                                              %ģ���ӽ�
    
    %create the body and heart model
    %the last parameter set to 1 to view the result
    heart=createHeartModel(gridHeart,shiftC,dirView,0);                                                             %���һ��������0�ĳ�1���Կ������0���ǲ���ʾ����������
    body=createBodyModel(gridBody,shiftC,dirView,0);
    
    %plot the two models
    %plotHeartABody(heart,body,0.2,dirView);                                                                         %plotHeartABody������ͼ     %����ʾcreateHeartModel��createBodyModel��ֱ���������Լ�dirView��ͼ
    
    %create how bipoles (should to be changed to dipoles) propogate through the whole heart within one period
    heart=pulsePropogate(heart,dirView,0);
    save('./sourcecode/model.mat','body','heart');                                                                  %��body��heart�ı������浽model.mat�ļ���
  
%    load('./sourcecode/model.mat');                                                                                %��ע�͵���Ŀǰ�Ѿ��������ݣ�֮��ı��ʱ����load
    %create the voltages within the heart
    heart=getHeartVoltage(heart,t,dirView,0);                                                                       %��ȡ�����ѹ
    

    %create voltage at a ball around the heart, which is used later for calculate ECG at body surface               %������Χ����һ��ECGball��Ϊ���ں����ȼ�������ϵĵ�ѹ�ֲ�  
    fileName='./sourcecode/V_leftbundlehinder.mat'; %save the result to this file                                   %����֧���͵����
    createECGBall(body,heart,fileName,0);                                                                           %������֧���͵�����´�������

    %visualize the ECG results
    % if multiple results shall be views, put them into the fileNameList and 
    % make sure the variable 't's are the same in all files                                                         %��Ԫ���ӻ�ʱ���Լ����ļ�����List����
    fileNameList={fileName};
    viewECGSurf(fileNameList);

end