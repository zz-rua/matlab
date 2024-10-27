%%
%-------------Ñ¡ï¿½ï¿½Ô­Ê¼ï¿½ï¿½ï¿½ï¿½Î»ï¿½ï¿½
function [bool_yesorno,str_error_code,js]=auto_extract(inputDir)
     ErrorFileNum = 0;
     errorLogging = {};
     segments={};
     TestErrorTable1= '';
     TestErrorTable2='';
     TestErrorTable3='';
     TestErrorTable4='';
     TestErrorTable5='';
     TestErrorTable6='';
     TestErrorTable7='';
     TestErrorTable8='';
    try

    [infor]=createInfor(inputDir);                      %³õÊ¼»¯±íÍ·
    path_json= strcat(inputDir,'/');                   % ï¿½ï¿½ï¿½ï¿½Â·ï¿½ï¿½
    getfilename=dir(strcat(path_json,'*thredlimit*'));
    path_json1={getfilename.name}';

    for i=1:1:size(path_json,1)
        fname=fullfile(path_json,path_json1{i});
        jsonData=loadjson(fname);
    end
    jsonDataName=fieldnames(jsonData);%ï¿½ï¿½Ã½á¹¹ï¿½ï¿½ï¿½Ö¶ï¿½ï¿½ï¿½ï¿½ï¿?

    %% ï¿½ï¿½Ê¼ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ð¶ï¿½ï¿½Ç·ï¿½ï¿½ï¿½È¡ï¿½Ã³ï¿½ï¿½ï¿½ï¿½Ä²ï¿½ï¿½ï¿½
    laneChangingBackwardTimeLeft=[];
    laneChangingBackwardTimeRight=[];
    laneChangingForwardTimeRight=[];
    OvertakingBackwardTimeLeft=[];
    OvertakingForwardTimeLeft=[];
    PositionXlimitLeft=[];
    OvertakingBackwardTimeRight=[];
    OvertakingForwardTimeRight=[];
    PositionXlimitRight=[];
    TurnForwardTimeLeft=[];
    TurnBackwardTimeLeft=[];
    SteerAngleLimitLeft=[];
    YawRateLimitLeft=[];
    TurnForwardTimeRight=[];
    TurnBackwardTimeRight=[];
    SteerAngleLimitRight=[];
    YawRateLimitRight=[];
    SteerAngleLimit2=[];
    YawRateLimit2=[];
    TurnAroundForwardTimeLeft=[];
    TurnAroundBackwardTimeLeft=[];
    carfollowingTHWLimit=[];
    carfollowingTimeLimit=[];
    carfollowingTHWLimitLevel=[];
    carfollowing_a1_duringtime=[];
    carfollowing_a2_duringtime=[];
    cutinBackwardTime=[];
    cutinForwardTime=[];
    cutoutBackwardTime=[];
    cutoutForwardTime=[];
    freedrivingTimeLimit=[];
    dangerForwardTime=[];
    dangerBackwardTime=[];
    laneChangingForwardTimeLeft=[];
    
    
    for i=1:size(jsonDataName,1)
        jsonDataNamesplit=strsplit(cell2mat(jsonDataName(i)),{'x0x3','_'});
        if isnan(str2double((cell2mat((jsonDataNamesplit(3))))))==0         
           jsonNum1=cell2mat(jsonDataNamesplit(2));
           jsonNum2=cell2mat(jsonDataNamesplit(3));
           jsonNum=str2double([jsonNum1,jsonNum2]);
           if jsonNum==10           
              a14=strsplit(jsonData.x0x31_0,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½ï¿½ó»»µï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              laneChangingBackwardTimeRightidx=find(strcmp(a14(1,:),'laneChangingBackwardTime'));              
              laneChangingBackwardTimeRight=str2double(cell2mat(a14(laneChangingBackwardTimeRightidx+1)));%ï¿½Ò»ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ô¤ï¿½ï¿½Ê±ï¿½ä£¬Ä¬ï¿½ï¿?15s
              laneChangingForwardTimeRightidx=find(strcmp(a14(1,:),'laneChangingForwardTime'));
              laneChangingForwardTimeRight=str2double(cell2mat(a14(laneChangingForwardTimeRightidx+1)));%ï¿½Ò»ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ç°Ô¤ï¿½ï¿½Ê±ï¿½ä£¬Ä¬ï¿½ï¿½15s
           end
           if jsonNum==11           
              a1=strsplit(jsonData.x0x31_1,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½ï¿½ó³¬³ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              OvertakingBackwardTimeLeftidx=find(strcmp(a1(1,:),'overtakingBackwardTime'));    
              OvertakingBackwardTimeLeft=str2double(cell2mat(a1(OvertakingBackwardTimeLeftidx+1)));%ï¿½ó³¬³ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ô¤ï¿½ï¿½Ê±ï¿½ä£¬Ä¬ï¿½ï¿?15s
              OvertakingForwardTimeLeftidx=find(strcmp(a1(1,:),'overtakingForwardTime'));    
              OvertakingForwardTimeLeft=str2double(cell2mat(a1(OvertakingForwardTimeLeftidx+1)));
              PositionXlimitLeftidx=find(strcmp(a1(1,:),'positionXlimit'));
              PositionXlimitLeft=str2double(cell2mat(a1(PositionXlimitLeftidx+1)));%ï¿½ó³¬³ï¿½Ê±ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Öµ                            
           end
           if jsonNum==12           
              a2=strsplit(jsonData.x0x31_2,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½ï¿½Ò³ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              OvertakingBackwardTimeRightidx=find(strcmp(a2(1,:),'overtakingBackwardTime'));    
              OvertakingBackwardTimeRight=str2double(cell2mat(a2(OvertakingBackwardTimeRightidx+1)));
              OvertakingForwardTimeRightidx=find(strcmp(a2(1,:),'overtakingForwardTime'));    
              OvertakingForwardTimeRight=str2double(cell2mat(a2(OvertakingForwardTimeRightidx+1)));
              PositionXlimitRightidx=find(strcmp(a2(1,:),'positionXlimit'));    
              PositionXlimitRight=str2double(cell2mat(a2(PositionXlimitRightidx+1)));                          
           end
           if jsonNum==13           
              a3=strsplit(jsonData.x0x31_3,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½ï¿½ï¿½×ªï¿½ä³¡ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              TurnForwardTimeLeftidx=find(strcmp(a3(1,:),'turnForwardTime'));    
              TurnForwardTimeLeft=str2double(cell2mat(a3(TurnForwardTimeLeftidx+1)));
              TurnBackwardTimeLeftidx=find(strcmp(a3(1,:),'turnBackwardTime'));    
              TurnBackwardTimeLeft=str2double(cell2mat(a3(TurnBackwardTimeLeftidx+1)));
              SteerAngleLimitLeftidx=find(strcmp(a3(1,:),'steerAngleLimit1'));    
              SteerAngleLimitLeft=str2double(cell2mat(a3(SteerAngleLimitLeftidx+1)));
              YawRateLimitLeftidx=find(strcmp(a3(1,:),'yawRateLimit1'));    
              YawRateLimitLeft=str2double(cell2mat(a3(YawRateLimitLeftidx+1)));                           
           end
           if jsonNum==14           
              a4=strsplit(jsonData.x0x31_4,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½ï¿½ï¿½×ªï¿½ä³¡ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              TurnForwardTimeRightidx=find(strcmp(a4(1,:),'turnForwardTime'));    
              TurnForwardTimeRight=str2double(cell2mat(a4(TurnForwardTimeRightidx+1)));
              TurnBackwardTimeRightidx=find(strcmp(a4(1,:),'turnBackwardTime'));    
              TurnBackwardTimeRight=str2double(cell2mat(a4(TurnBackwardTimeRightidx+1)));
              SteerAngleLimitRightidx=find(strcmp(a4(1,:),'steerAngleLimit1'));    
              SteerAngleLimitRight=str2double(cell2mat(a4(SteerAngleLimitRightidx+1)));
              YawRateLimitRightidx=find(strcmp(a4(1,:),'yawRateLimit1'));    
              YawRateLimitRight=str2double(cell2mat(a4(YawRateLimitRightidx+1)));
           end
           if jsonNum==15           
              a5=strsplit(jsonData.x0x31_5,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½Äµï¿½Í·ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              SteerAngleLimit2idx=find(strcmp(a5(1,:),'steerAngleLimit2'));    
              SteerAngleLimit2=str2double(cell2mat(a5(SteerAngleLimit2idx+1)));
              YawRateLimit2idx=find(strcmp(a5(1,:),'yawRateLimit2'));    
              YawRateLimit2=str2double(cell2mat(a5(YawRateLimit2idx+1)));
              TurnAroundForwardTimeLeftidx=find(strcmp(a5(1,:),'turnForwardTime'));    
              TurnAroundForwardTimeLeft=str2double(cell2mat(a5(TurnAroundForwardTimeLeftidx+1)));
              TurnAroundBackwardTimeLeftidx=find(strcmp(a5(1,:),'turnBackwardTime'));    
              TurnAroundBackwardTimeLeft=str2double(cell2mat(a5(TurnAroundBackwardTimeLeftidx+1)));
           end
        else 
           jsonNumber=str2double(cell2mat(jsonDataNamesplit(2))); 
           if jsonNumber==1           
              a6=strsplit(jsonData.x0x31_,{':',',','{','}'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½Ä¸ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              carfollowingDistanceLimitidx=find(strcmp(a6(1,:),'"carfollowingDistanceLimit"'));%²éÕÒcarfollowingDistanceLimit
              carfollowingDistanceLimit=strsplit(cell2mat(a6(carfollowingDistanceLimitidx+1)),{'"','"'});              
              carfollowingDistanceLimit=str2double(cell2mat(carfollowingDistanceLimit(2)));
              if isnan(carfollowingDistanceLimit)
                 carfollowingDistanceLimit=150;%CarFollowingï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Öµï¿½ï¿½Ä¬ï¿½ï¿½Îªï¿½ï¿?
              end
              carfollowingTHWLimitLevelidx=find(strcmp(a6(1,:),'"carfollowingTHWLimitLevel"'));
              carfollowingTHWLimitLevel=strsplit(cell2mat(a6(carfollowingTHWLimitLevelidx+1)),{'"','"'});              
              carfollowingTHWLimitLevel=str2double(cell2mat(carfollowingTHWLimitLevel(2)));
              carfollowingTHWLimitidx=find(strcmp(a6(1,:),'"carfollowingTHWLimit"'));
              carfollowingTHWLimit=strsplit(cell2mat(a6(carfollowingTHWLimitidx+1)),{'"','"'});              
              carfollowingTHWLimit=str2double(cell2mat(carfollowingTHWLimit(2)));
              carfollowingDistanceLimitLevelidx=find(strcmp(a6(1,:),'"carfollowingDistanceLimitLevel"'));
              carfollowingDistanceLimitLevel=strsplit(cell2mat(a6(carfollowingDistanceLimitLevelidx+1)),{'"','"'});              
              carfollowingDistanceLimitLevel=str2double(cell2mat(carfollowingDistanceLimitLevel(2)));
              if isnan(carfollowingDistanceLimitLevel)
                 carfollowingDistanceLimitLevel=0;%CarFollowingï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ÆµÈ¼ï¿? 
              end
              carfollowingTimeLimitidx=find(strcmp(a6(1,:),'"carfollowingTimeLimit"'));
              carfollowingTimeLimit=strsplit(cell2mat(a6(carfollowingTimeLimitidx+1)),{'"','"'});              
              carfollowingTimeLimit=str2double(cell2mat(carfollowingTimeLimit(2)));
           end
           if jsonNumber==2          
              a7=strsplit(jsonData.x0x32_,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½Ä¸ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ù³ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              carfollowing_a1_duringtimeidx=find(strcmp(a7(1,:),'carfollowing_a1_duringtime'));    
              carfollowing_a1_duringtime=str2double(cell2mat(a7(carfollowing_a1_duringtimeidx+1)));
           end
           if jsonNumber==3          
              a8=strsplit(jsonData.x0x33_,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½Ä¸ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ù³ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              carfollowing_a2_duringtimeidx=find(strcmp(a8(1,:),'carfollowing_a2_duringtime'));    
              carfollowing_a2_duringtime=str2double(cell2mat(a8(carfollowing_a2_duringtimeidx+1)));
           end
           if jsonNumber==4          
              a9=strsplit(jsonData.x0x34_,{':',',','{','}'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ë³¡ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              cutinTHWLimitidx=find(strcmp(a9(1,:),'"cutinTHWLimit"'));
              cutinTHWLimit=strsplit(cell2mat(a9(cutinTHWLimitidx+1)),{'"','"'}); 
              if ~isempty(cell2mat(cutinTHWLimit(2)))
                  cutinTHWLimit=str2double(cell2mat(cutinTHWLimit(2)));
              else
                 cutinTHWLimit=cell2mat(cutinTHWLimit(2)); 
              end
              
              cutinBackwardTimeidx=find(strcmp(a9(1,:),'"cutinBackwardTime"'));
              cutinBackwardTime=strsplit(cell2mat(a9(cutinBackwardTimeidx+1)),{'"','"'});
              cutinBackwardTime=str2double(cell2mat(cutinBackwardTime(2)));
              cutinForwardTimeidx=find(strcmp(a9(1,:),'"cutinForwardTime"'));
              cutinForwardTime=strsplit(cell2mat(a9(cutinForwardTimeidx+1)),{'"','"'});
              cutinForwardTime=str2double(cell2mat(cutinForwardTime(2)));
              cutinDistanceLimitidx=find(strcmp(a9(1,:),'"cutinDistanceLimit"'));
              cutinDistanceLimit=strsplit(cell2mat(a9(cutinDistanceLimitidx+1)),{'"','"'});
              if ~isempty(cell2mat(cutinDistanceLimit(2)))
                  cutinDistanceLimit=str2double(cell2mat(cutinDistanceLimit(2))); 
              else
                  cutinDistanceLimit=cell2mat(cutinDistanceLimit(2));
              end
                                            
           end
            if jsonNumber==5          
              a10=strsplit(jsonData.x0x35_,{':',',','{','}'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½ï¿½Ð³ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              cutoutFOTHWLimitidx=find(strcmp(a10(1,:),'"cutoutFOTHWLimit"'));
              cutoutFOTHWLimit=strsplit(cell2mat(a10(cutoutFOTHWLimitidx+1)),{'"','"'});
              if ~isempty(cell2mat(cutoutFOTHWLimit(2)))
                  cutoutFOTHWLimit=str2double(cell2mat(cutoutFOTHWLimit(2)));
              else
                  cutoutFOTHWLimit=cell2mat(cutoutFOTHWLimit(2));
              end
              
              cutoutForwardTimeidx=find(strcmp(a10(1,:),'"cutoutForwardTime"'));
              cutoutForwardTime=strsplit(cell2mat(a10(cutoutForwardTimeidx+1)),{'"','"'});
              cutoutForwardTime=str2double(cell2mat(cutoutForwardTime(2)));
              cutotuFFODistanceLimitidx=find(strcmp(a10(1,:),'"cutotuFFODistanceLimit"'));
              cutotuFFODistanceLimit=strsplit(cell2mat(a10(cutotuFFODistanceLimitidx+1)),{'"','"'});
              if ~isempty(cell2mat(cutotuFFODistanceLimit(2)))
                  cutotuFFODistanceLimit=str2double(cell2mat(cutotuFFODistanceLimit(2)));
              else
                  cutotuFFODistanceLimit=cell2mat(cutotuFFODistanceLimit(2));
              end
              
              cutoutFFOTHWLimitidx=find(strcmp(a10(1,:),'"cutoutFFOTHWLimit"'));
              cutoutFFOTHWLimit=strsplit(cell2mat(a10(cutoutFFOTHWLimitidx+1)),{'"','"'});
              if ~isempty(cell2mat(cutoutFFOTHWLimit(2)))
                  cutoutFFOTHWLimit=str2double(cell2mat(cutoutFFOTHWLimit(2)));
              else
                  cutoutFFOTHWLimit=cell2mat(cutoutFFOTHWLimit(2));
              end
              
              cutoutFODistanceLimitidx=find(strcmp(a10(1,:),'"cutoutFODistanceLimit"'));
              cutoutFODistanceLimit=strsplit(cell2mat(a10(cutoutFODistanceLimitidx+1)),{'"','"'});
              if ~isempty(cell2mat(cutoutFODistanceLimit(2)))
                  cutoutFODistanceLimit=str2double(cell2mat(cutoutFODistanceLimit(2)));
              else
                  cutoutFODistanceLimit=cell2mat(cutoutFODistanceLimit(2));
              end
              
              cutoutBackwardTimeidx=find(strcmp(a10(1,:),'"cutoutBackwardTime"'));
              cutoutBackwardTime=strsplit(cell2mat(a10(cutoutBackwardTimeidx+1)),{'"','"'});
              cutoutBackwardTime=str2double(cell2mat(cutoutBackwardTime(2)));
           end
           if jsonNumber==6         
              a11=strsplit(jsonData.x0x36_,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ê»ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              freedrivingTimeLimitidx=find(strcmp(a11(1,:),'freedrivingTimeLimit'));    
              freedrivingTimeLimit=str2double(cell2mat(a11(freedrivingTimeLimitidx+1)));
           end
           if jsonNumber==8         
              a12=strsplit(jsonData.x0x38_,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½Î£ï¿½Õ³ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              dangerForwardTimeidx=find(strcmp(a12(1,:),'dangerForwardTime'));    
              dangerForwardTime=str2double(cell2mat(a12(dangerForwardTimeidx+1)));
              dangerBackwardTimeidx=find(strcmp(a12(1,:),'dangerBackwardTime'));    
              dangerBackwardTime=str2double(cell2mat(a12(dangerBackwardTimeidx+1)));
           end
           if jsonNumber==9         
              a13=strsplit(jsonData.x0x39_,{':',',','{','}','"','"'});%ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Æ½Ì¨Ç°ï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½ï¿½ó»»µï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
              laneChangingBackwardTimeLeftidx=find(strcmp(a13(1,:),'laneChangingBackwardTime'));    
              laneChangingBackwardTimeLeft=str2double(cell2mat(a13(laneChangingBackwardTimeLeftidx+1)));
              laneChangingForwardTimeLeftidx=find(strcmp(a13(1,:),'laneChangingForwardTime'));    
              laneChangingForwardTimeLeft=str2double(cell2mat(a13(laneChangingForwardTimeLeftidx+1)));
           end                    
        end
    end
 
    %%
    %-------------ï¿½ï¿½ï¿½Ã²ï¿½ï¿½ï¿½
    egoDisThreshold=2.5;%ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ß±ä»¯ï¿½ï¿½Öµ,2.5m
    objectDisThreshold=1.8;%Ä¿ï¿½ê³µï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ß±ä»¯ï¿½ï¿½Öµ,1.8m
    egoTimeThreshold=4;%ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ê±ï¿½ï¿½ï¿½ï¿½Öµ,4s
    
    freeDrivingSpecialLimit=0;
    freeDrivingSpecialLimitType='=';
    freeDrivingSpecialLimitTime=6;
    freeDrivingSpecialLimitBackwardTime=3;
    freeDrivingSpecialLimitForwardTime=3;
    %% ï¿½ï¿½ï¿½ä³¡ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
       
    carfollowing_al1_Limit=1.250;%99ï¿½ï¿½Î»ï¿½ï¿½ï¿½Ù¶ï¿½ï¿½ï¿½Öµ
    carfollowing_al2_Limit=-1.7813;%99ï¿½ï¿½Î»ï¿½ï¿½ï¿½Ù¶ï¿½ï¿½ï¿½Öµ       
        
    
    
    %%
    %----------ï¿½ï¿½ï¿½ï¿½Ä£ï¿½åµ¼ï¿½ï¿½
    
    rightStandard_agn = readtable('E:\ÏîÄ¿×÷Æ·\¼ÝÊ»³¡¾°ÌáÈ¡·ÂÕæ\PGÊý¾ÝÊäÈëÊä³ö/ÓÒ»»µÀÄ£°å.xlsx','ReadVariableNames',0);
    rightStandard=table2array(rightStandard_agn);%ï¿½Ò»ï¿½ï¿½ï¿½Ä£ï¿½ï¿½
    leftStandard_agn = readtable('E:\ÏîÄ¿×÷Æ·\¼ÝÊ»³¡¾°ÌáÈ¡·ÂÕæ\PGÊý¾ÝÊäÈëÊä³ö/×ó»»µÀÄ£°å.xlsx','ReadVariableNames',0);
    leftStandard=table2array(leftStandard_agn);%ï¿½ó»»µï¿½Ä£ï¿½ï¿½
    rightStandard2_agn = readtable('E:\ÏîÄ¿×÷Æ·\¼ÝÊ»³¡¾°ÌáÈ¡·ÂÕæ\PGÊý¾ÝÊäÈëÊä³ö/ÓÒ»»µÀÄ£°åRightLaneData','ReadVariableNames',0);
    rightStandard2=table2array(rightStandard2_agn);%ï¿½Ò»ï¿½ï¿½ï¿½Ä£ï¿½ï¿½RightLaneData.xlsx
    leftStandard2_agn = readtable('E:\ÏîÄ¿×÷Æ·\¼ÝÊ»³¡¾°ÌáÈ¡·ÂÕæ\PGÊý¾ÝÊäÈëÊä³ö/×ó»»µÀÄ£°åRightLaneData','ReadVariableNames',0);
    leftStandard2=table2array(leftStandard2_agn);%ï¿½ó»»µï¿½Ä£ï¿½ï¿½RightLaneData.xlsx
    
    
        %% setidï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
    setid1=cellstr(strsplit(jsonData.x0x31_8,','));%ï¿½ï¿½setidï¿½ï¿½ï¿½ï¿½ï¿½Ý¼ï¿½ï¿½ï¿½È¡ï¿½ï¿½ï¿½ï¿½
    for iFile=1:size(setid1,2)       
        setidStart=cell2mat(setid1(iFile));
        setidEnd=cell2mat(setid1(iFile));
    %%
    %-----------ï¿½ï¿½È¡
        PostgreSQL_json= strcat(inputDir,'/');                   % ï¿½ï¿½ï¿½ï¿½Â·ï¿½ï¿½
        PostgreSQLname=dir(strcat(PostgreSQL_json,'*config*'));
        PostgreSQL_json1={PostgreSQLname.name}';
        PostgreSQLname=fullfile(PostgreSQL_json,PostgreSQL_json1);
        PostgreSQLjsonData=loadjson(cell2mat(PostgreSQLname));
        userName=PostgreSQLjsonData.user;
        password= PostgreSQLjsonData.password;
        IPandPortNumber1= PostgreSQLjsonData.address;
        IPandPortNumber2=num2str(PostgreSQLjsonData.port);
        IPandPortNumber=strcat(IPandPortNumber1,':',IPandPortNumber2);
        readDatabase=PostgreSQLjsonData.dbname;
        frameRate=PostgreSQLjsonData.frameRate;

        readSchema = 'public';
        selectID = 'setid';
        startPosition = setidStart;
        endPosition = setidEnd;

        %% 1carData
        readCarTable = 'fusion_car_standard';
        readCarDataItem = 'frame_id,velocity,longitudinal_acceleration,lateral_acceleration,yaw_rate,steer_angle,brake_pedal_signal';
        [carElement,carData] = getPostgreSQLData(userName,password,IPandPortNumber,readDatabase,readSchema,readCarTable,readCarDataItem,selectID,startPosition,endPosition);
        idxVelocity=find(strcmp(carElement,'velocity'));%
        carData(isnan(cell2mat(carData(:,idxVelocity))),:)=[];%È¥ï¿½ï¿½
        carData=[carElement;carData];
        
        %% 2objectData
        readObjectTable = 'fusion_object';
        readObjectDataItem = 'frame_id,relative_position_x,relative_position_y,relative_velocity_x,cipv,object_id,lane,age';
        [objectElement,objectData] = getPostgreSQLData(userName,password,IPandPortNumber,readDatabase,readSchema,readObjectTable,readObjectDataItem,selectID,startPosition,endPosition);
        idxCIPVFlag=find(strcmp(objectElement,'cipv'));%ï¿½ï¿½ï¿½ï¿½CIPVï¿½ï¿½ï¿½ï¿½Î»ï¿½ï¿½
        idxPosX=find(strcmp(objectElement,'relative_position_x'));%ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Î»ï¿½ï¿?
        objectData(isnan(cell2mat(objectData(:,idxPosX)))|isnan(cell2mat(objectData(:,idxCIPVFlag))),:)=[];%ï¿½ï¿½ï¿½ï¿½CIPVï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Î»ï¿½ÃµÄ¿ï¿½ï¿½Æ£ï¿½È¥ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ðµï¿½ï¿½Ø¶ï¿½ï¿½ï¿½
        objectData=[objectElement;objectData];
        
        %% 3lane
        readLaneTable = 'fusion_lane';
        readLaneDataItem = 'frame_id,c0,quality,lane_id';
        [laneElement,lane_data] = getPostgreSQLData(userName,password,IPandPortNumber,readDatabase,readSchema,readLaneTable,readLaneDataItem,selectID,startPosition,endPosition);
        lane=[laneElement;lane_data];
        
            %%           
        %-------------ï¿½ï¿½ï¿½ï¿½æ´¢ï¿½ï¿½ï¿½ï¿?
        
        freeDrivingProcess={'DataName','BeginFrame','OverFrame','Type'};
        cutinProcess={'DataName','BeginFrame','CutInFrame','OverFrame','Type','CutInObject','CutInDistance','CutInTHW','FrontObjectID'};
        cutoutProcess={'DataName','BeginFrame','CutOutFrame','OverFrame','Type','CutOutObject','CutOutDistance','CutOutTHW','ForeFrontObjectID','ForeFrontObjectDistance','ForeFrontObjectTHW'};
        laneChangingLeftProcess={'DataName','BeginFrame','LaneChangeFrame','OverFrame','Type'};
        laneChangeingRightProcess={'DataName','BeginFrame','LaneChangeFrame','OverFrame','Type'};
        carfollowingProcess={'DataName','BeginFrame','OverFrame','Type','FrontObjectID'};
        dangerProcess={'DataName','BeginFrame','DangerFrame','OverFrame','Type','Criterion'};
        unDefinedProcess={'DataName','BeginFrame','OverFrame','Type','New_FrontObject','Original_FrontObject'};
        %%ï¿½ï¿½ï¿½ä³¡ï¿½ï¿½
        carfollowingProcess_speedup={'DataName','BeginFrame','OverFrame','Type','FrontObjectID'};
        carfollowingProcess_slowdown={'DataName','BeginFrame','OverFrame','Type','FrontObjectID'};
        OvertakingLeftProcess={'DataName','BeginFrame','OvertakingFrame','OverFrame','Type','OvertakingObjectID'};
        OvertakingRightProcess={'DataName','BeginFrame','OvertakingFrame','OverFrame','Type','OvertakingObjectID'};
        TurnLeftProcess={'DataName','BeginFrame','TurnPoint','OverFrame','Type'};
        TurnRightProcess={'DataName','BeginFrame','TurnPoint','OverFrame','Type'};
        TurnAroundLeftProcess={'DataName','BeginFrame','TurnPoint','OverFrame','Type'};
        TurnAroundRightProcess={'DataName','BeginFrame','TurnPoint','OverFrame','Type'};
        
        process=struct('Type',{'CutIn';'CutOut';'CarFollowing';'FreeDriving';'LaneChangeLeft';'LaneChangeRight';'Danger';'unDefinedProcess';'carfollowingProcess_speedup';'carfollowingProcess_slowdown';'OvertakingLeft';...
            'OvertakingRight';'TurnLeft';'TurnRight';'TurnAroundLeft';'TurnAroundRight'},'Infor',{cutinProcess;cutoutProcess;carfollowingProcess;freeDrivingProcess;...
            laneChangingLeftProcess;laneChangeingRightProcess;dangerProcess;unDefinedProcess;carfollowingProcess_speedup;carfollowingProcess_slowdown;...
            OvertakingLeftProcess;OvertakingRightProcess;TurnLeftProcess;TurnRightProcess;TurnAroundLeftProcess;TurnAroundRightProcess});
        

        frameLimit=cell2mat(carData(end,1));%ï¿½ï¿½ï¿½ï¿½Ö¡Ê±ï¿½ä³¤ï¿½ï¿½
        %-----------ï¿½ï¿½È¡Î£ï¿½Õ¹ï¿½ï¿½ï¿½
        try
            if ~isempty(dangerBackwardTime)
                dangerProcess=getDanger_003(dangerProcess,setidStart,carData,objectData,dangerBackwardTime,dangerForwardTime,frameRate,frameLimit);
            end
        catch                     
             TestErrorTable1=';æå–è§„åˆ™-getDanger_003';
        end
            
       
         
        %---------ï¿½ï¿½È¡Ç±ï¿½Ú»ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
        try
            laneChangingPotentialProcess=laneChangingPotential_003(lane,egoDisThreshold,egoTimeThreshold,frameRate);
        catch
            TestErrorTable2=';æå–è§„åˆ™-laneChangingPotential_003';
        end
        
        %---------ï¿½ï¿½È¡ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
        try
            if ~isempty(laneChangingBackwardTimeLeft)|~isempty(laneChangingBackwardTimeRight)
                [laneChangingLeftProcess,laneChangeingRightProcess] = laneChanging_004(laneChangingLeftProcess,laneChangeingRightProcess,setidStart,lane,rightStandard,...
                    leftStandard,rightStandard2,leftStandard2,laneChangingBackwardTimeLeft,laneChangingForwardTimeLeft,laneChangingBackwardTimeRight,laneChangingForwardTimeRight,frameRate);
            end
        catch
               TestErrorTable3=';æå–è§„åˆ™-laneChanging_004';
        end
        
        %---------Ä¿ï¿½ï¿½ï¿½ï¿½ï¿½Ð¶ï¿½
        if size(objectData,1)>1
            
            
            [CIPVDeleteProcess,CIPVProcess]=getCIPVProcess_003(objectData,frameRate);%CIPVï¿½ï¿½ï¿½ï¿½Ê¶ï¿½ï¿½
            %-------------ï¿½ï¿½ï¿½Î»ï¿½È¡CarFollowingï¿½ï¿½CutInï¿½ï¿½CutOutï¿½ï¿½Undefinedï¿½ï¿½ï¿½ï¿½
            if ~isempty(CIPVProcess)
                try
                [cutinProcess,cutoutProcess,carfollowingProcess,unDefinedProcess]=getCutInProcess(CIPVProcess,laneChangingPotentialProcess,cutinProcess,cutoutProcess,carfollowingProcess,unDefinedProcess,...
                    carData,objectData,setidStart,objectDisThreshold,cutinBackwardTime,cutinForwardTime,cutoutBackwardTime,cutoutForwardTime,carfollowingTimeLimit,frameLimit,frameRate);           
                catch
                    TestErrorTable4=';æå–è§„åˆ™-getCutInProcess';
                end
            end
            %-------------CIPVï¿½ï¿½ï¿½Ìµï¿½ï¿½ï¿½
            CIPVProcess=[CIPVProcess;CIPVDeleteProcess];
            %             %--------------CarFollowingï¿½ï¿½ï¿½CIPVDeleteProcessï¿½ï¿½ï¿½Ìµï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ã¿ï¿½ï¿½Ü´ï¿½ï¿½ÚµÄ¸ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?
            %             carfollowingProcess=adjustmentCarfollowingProcess(carfollowingProcess,CIPVDeleteProcess,objectData,objectElement,inputFile{iFile,1},carfollowingTimeLimit,frameRate);
            
        else
            CIPVProcess=[];
            
        end
        
        %-------------Ñ²ï¿½ß¹ï¿½ï¿½ï¿½ï¿½Ð¶ï¿½
        freeDrivingProcess=getFreeDrivingProcess(freeDrivingProcess,CIPVProcess,laneChangingPotentialProcess,setidStart,frameLimit);
        
        
        %----------È¥ï¿½ï¿½freedrivingï¿½ï¿½Ö¹ï¿½ï¿½ï¿½ï¿½
        
        %         freeDrivingProcess=deleteStatic(freeDrivingProcess,frameID,velocity);
        if size(freeDrivingProcess,1)>1
            try
            freeDrivingProcess=deleteSpecialFreeProcess(freeDrivingProcess,carData,...
                freeDrivingSpecialLimit,freeDrivingSpecialLimitType,freeDrivingSpecialLimitTime,freeDrivingSpecialLimitBackwardTime,freeDrivingSpecialLimitForwardTime,...
                frameRate,freedrivingTimeLimit);
            catch
                TestErrorTable5=';æå–è§„åˆ™-deleteSpecialFreeProcess';
            end
        end
        
        
        
        
        %------------È¥ï¿½ï¿½CarFollowingï¿½ï¿½Ö¹ï¿½ï¿½ï¿½ï¿½
        %         carfollowingProcess=deleteStatic(carfollowingProcess,frameID,velocity);
        if size(carfollowingProcess,1)>1
            carfollowingProcess=deleteSpecialFollowingProcess(carfollowingProcess,carData,0,'=',6,3,3,frameRate,carfollowingTimeLimit);
        end
        
        %----------------È¥ï¿½ï¿½carfollowingï¿½Ð³ï¿½ï¿½ï¿½à²»ï¿½ï¿½ï¿½ï¿½Òªï¿½ï¿½Ä¹ï¿½ï¿½ï¿½
        if size(carfollowingProcess,1)>1
            carfollowingProcess=limitDistanceCarfollowingProcess(carfollowingProcess,objectData,...
                carfollowingDistanceLimit,carfollowingDistanceLimitLevel,carfollowingTimeLimit,frameRate);
        end
        %--------------È¥ï¿½ï¿½carfollowingï¿½ï¿½THWï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Òªï¿½ï¿½Ä¹ï¿½ï¿½ï¿?
        
        if size(carfollowingProcess,1)>1
            carfollowingProcess=limitTHWCarfollowingProcess(carfollowingProcess,objectData,carData,...
                carfollowingTHWLimit,carfollowingTHWLimitLevel,carfollowingTimeLimit,frameRate);
        end
        %-----------È¥ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ì²ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Òªï¿½ï¿½Ä¹ï¿½ï¿½ï¿?
        %         cutinProcess={'DataName','BeginFrame','CutInFrame','OverFrame','Type','CutInObject','CutInDistance','CutInTHW','FrontObjectID'};
        if ~isempty(cutinDistanceLimit)
            if size(cutinProcess,1)>1
                cutinDistance=cell2mat(cutinProcess(2:end,7));
                idxDelete=find(cutinDistance>cutinDistanceLimit);
                if ~isempty(idxDelete)
                    cutinProcess(idxDelete+1,:)=[];
                    
                end
            end
            
        end
        %-----------È¥ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ì²ï¿½ï¿½ï¿½ï¿½ï¿½THWÒªï¿½ï¿½Ä¹ï¿½ï¿½ï¿?
        if ~isempty(cutinTHWLimit)
            if size(cutinProcess,1)>1
                cutinTHW=cell2mat(cutinProcess(2:end,8));
                idxDelete=find(cutinTHW>cutinTHWLimit);
                if ~isempty(idxDelete)
                    cutinProcess(idxDelete+1,:)=[];
                    
                end
            end
            
        end
        
        %-------------È¥ï¿½ï¿½ï¿½Ð³ï¿½ï¿½ï¿½ï¿½ï¿½Ç°ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Òªï¿½ï¿½Ä¹ï¿½ï¿½ï¿½
        %         cutoutProcess={'DataName','BeginFrame','CutOutFrame','OverFrame','Type','CutOutObject','CutOutDistance','CutOutTHW','ForeFrontObjectID','ForeFrontObjectDistance','ForeFrontObjectTHW'};
        
        if ~isempty(cutoutFODistanceLimit)
            if size(cutoutProcess,1)>1
                cutoutFODistance=cell2mat(cutoutProcess(2:end,7));
                idxDelete=find(cutoutFODistance>cutoutFODistanceLimit);
                if ~isempty(idxDelete)
                    cutoutProcess(idxDelete+1,:)=[];
                    
                end
            end
            
        end
        
        %-----------------È¥ï¿½ï¿½ï¿½Ð³ï¿½ï¿½ï¿½ï¿½ï¿½Ç°ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½THWÒªï¿½ï¿½Ä¹ï¿½ï¿½ï¿?
        if ~isempty(cutoutFOTHWLimit)
            if size(cutoutProcess,1)>1
                cutoutFOTHW=cell2mat(cutoutProcess(2:end,8));
                idxDelete=find(cutoutFOTHW>cutoutFOTHWLimit);
                if ~isempty(idxDelete)
                    cutoutProcess(idxDelete+1,:)=[];
                    
                end
            end
            
        end
        
        %----------------È¥ï¿½ï¿½ï¿½Ð³ï¿½ï¿½ï¿½ï¿½ï¿½Ç°Ç°ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Òªï¿½ï¿½Ä¹ï¿½ï¿½ï¿½
        
        if ~isempty(cutotuFFODistanceLimit)
            if size(cutoutProcess,1)>1
                cutotuFFODistance=cell2mat(cutoutProcess(2:end,10));
                idxDelete=find(cutotuFFODistance>cutotuFFODistanceLimit);
                if ~isempty(idxDelete)
                    cutoutProcess(idxDelete+1,:)=[];
                    
                end
            end
            
        end
        %--------------È¥ï¿½ï¿½ï¿½Ð³ï¿½ï¿½ï¿½ï¿½ï¿½Ç°Ç°ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½THWÒªï¿½ï¿½Ä¹ï¿½ï¿½ï¿?
        if ~isempty(cutoutFFOTHWLimit)
            if size(cutoutProcess,1)>1
                cutoutFFOTHW=cell2mat(cutoutProcess(2:end,10));
                idxDelete=find(cutoutFFOTHW>cutoutFFOTHWLimit);
                if ~isempty(idxDelete)
                    cutoutProcess(idxDelete+1,:)=[];
                    
                end
            end
            
        end
        
        
        %% ï¿½ï¿½È¡ï¿½ï¿½ï¿½ï¿½ï¿½Ó¼ï¿½ï¿½Ù¸ï¿½ï¿½ï¿½
        try
        if ~isempty(carfollowing_a1_duringtime)|~isempty(carfollowing_a2_duringtime) 
            [carfollowingProcess_speedup,carfollowingProcess_slowdown] = carfollowingProcess_speedup_slowdown(carfollowingProcess_speedup,carfollowingProcess_slowdown,carData,carfollowingProcess,frameRate,carfollowing_a1_duringtime,carfollowing_a2_duringtime,carfollowing_al1_Limit,carfollowing_al2_Limit);
        end
        catch
            TestErrorTable6=';æå–è§„åˆ™-carfollowingProcess_speedup_slowdown';
        end
            %% ï¿½ï¿½È¡ï¿½ï¿½ï¿½ï¿½
        try
        if ~isempty(OvertakingBackwardTimeLeft)|~isempty(OvertakingBackwardTimeRight) 
            [OvertakingLeftProcess,OvertakingRightProcess] = Overtaking(OvertakingLeftProcess,OvertakingRightProcess,objectData,frameRate,frameLimit, OvertakingForwardTimeLeft,OvertakingBackwardTimeLeft,OvertakingForwardTimeRight,OvertakingBackwardTimeRight,...
                 laneChangingLeftProcess,laneChangeingRightProcess,PositionXlimitLeft,PositionXlimitRight);
        end
         catch
            TestErrorTable7=';æå–è§„åˆ™-Overtaking';
        end
       
        %% ï¿½ï¿½È¡×ªï¿½ï¿½
        try
       if ~isempty(TurnForwardTimeLeft)|~isempty(TurnForwardTimeRight) |~isempty(TurnAroundForwardTimeLeft) 
           [TurnLeftProcess,TurnRightProcess,TurnAroundLeftProcess,TurnAroundRightProcess] = turn_left_right(TurnLeftProcess,TurnRightProcess,TurnAroundLeftProcess,TurnAroundRightProcess,carData,...
                frameRate,setidStart,SteerAngleLimitLeft,SteerAngleLimitRight,YawRateLimitLeft,YawRateLimitRight,SteerAngleLimit2,YawRateLimit2,TurnForwardTimeLeft,TurnBackwardTimeLeft,TurnForwardTimeRight,...
                TurnBackwardTimeRight,TurnAroundForwardTimeLeft,TurnAroundBackwardTimeLeft);
       end
       catch
            TestErrorTable8=';æå–è§„åˆ™-turn_left_right';
        end
       
        %----------ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?
        
        process(1).Infor=[process(1).Infor(1,:);cutinProcess(2:end,:)];
        
        process(2).Infor=[process(2).Infor(1,:);cutoutProcess(2:end,:)];
        
        process(3).Infor=[process(3).Infor(1,:);carfollowingProcess(2:end,:)];%CarFollowingï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(4).Infor=[process(4).Infor(1,:);freeDrivingProcess(2:end,:)];%Ñ²ï¿½ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(5).Infor=[process(5).Infor(1,:);laneChangingLeftProcess(2:end,:)];%ï¿½ó»»µï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(6).Infor=[process(6).Infor(1,:);laneChangeingRightProcess(2:end,:)];%ï¿½Ò»ï¿½ï¿½ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(7).Infor=[process(7).Infor(1,:);dangerProcess(2:end,:)];%ï¿½Ò»ï¿½ï¿½ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(8).Infor=[process(8).Infor(1,:);unDefinedProcess(2:end,:)];
        process(9).Infor=[process(9).Infor(1,:);carfollowingProcess_speedup(2:end,:)];%ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(10).Infor=[process(10).Infor(1,:);carfollowingProcess_slowdown(2:end,:)];%ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(11).Infor=[process(11).Infor(1,:);OvertakingLeftProcess(2:end,:)];%ï¿½ï¿½ï¿½ï¿½ï¿½ó³¬³ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(12).Infor=[process(12).Infor(1,:);OvertakingRightProcess(2:end,:)];%ï¿½ï¿½ï¿½ï¿½ï¿½Ò³ï¿½ï¿½ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(13).Infor=[process(13).Infor(1,:);TurnLeftProcess(2:end,:)];%ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½×ªï¿½ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(14).Infor=[process(14).Infor(1,:);TurnRightProcess(2:end,:)];%ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½×ªï¿½ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        process(15).Infor=[process(15).Infor(1,:);TurnAroundLeftProcess(2:end,:)];%ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í·ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿?
        process(16).Infor=[process(16).Infor(1,:);TurnAroundRightProcess(2:end,:)];%ï¿½ï¿½ï¿½ï¿½ï¿½Òµï¿½Í·ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½
        
        %-------------ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½È¡ï¿½ï¿½ï¿½ï¿½Ï¢ï¿½æ´¢
        
        infor=cutProcess(setidStart,process,infor);%
        
        
    end
        sence_type=struct('CarFollowing',1,'carfollowing_speedup',2,'carfollowing_slowdown', ...
                3,'CutIn',4,'CutOut',5,'FreeDriving',6,'unDefinedProcess',7,'Danger',8,'LaneChangeLeft',9, ...
                'LaneChangeRight',10,'OvertakingLeft',11,'OvertakingRight',12,'TurnLeft',13, ...
                'TurnRight',14,'TurnAroundLeft',15,'TurnAroundRight',16);
            
            
        for i = 1:length(infor)
            strtype = infor(i).('Type');
            celldata = infor(i).('Infor');
            if size(celldata,1)>1
            tb=cell2table(celldata(2:end,:));
            tb.Properties.VariableNames = celldata(1,:);
    %         T0=tb(:,{'FrameID','SteerAngle','YawRate','Velocity'});
            tb.Type=repmat(sence_type.(strtype), length(tb.Type), 1);%½«typeÀàÐÍÓÉÓ¢ÎÄ×ÖÄ¸±ä³É°¢À­²®×ÖÄ¸
            ts = table2struct(tb);
            for m=1:size(ts,1)                
                segments = [segments;ts(m)];
            end

            %ts = table2struct(tb);
           % segments = [segments;ts(1,:)];         
            end  
        end
            catch ErrorInfo
        ErrorFileNum = ErrorFileNum + 1;
        errorLogging{ErrorFileNum,1} = ErrorInfo.identifier;
        errorLogging{ErrorFileNum,2} = ErrorInfo.message;
        errorLogging{ErrorFileNum,3} = ErrorInfo.stack.name;
        errorLogging{ErrorFileNum,4} = ErrorInfo.stack.line;
    end
     if isempty(errorLogging)
        str_error_code = '';
        bool_yesorno=0;
    else
%         str_error_code = errorLogging;
        errs=string(errorLogging);
        str_error_code=strcat(errs(1),', ',errs(2),', ',errs(3),', line: ',errs(4));
        bool_yesorno=1;
     end
    str_error_code=strcat(str_error_code, TestErrorTable1, TestErrorTable2, TestErrorTable3, TestErrorTable4, ...
            TestErrorTable5, TestErrorTable6, TestErrorTable7, TestErrorTable8);
    rt='';
    if isempty(segments)
        rt='NONE';
    else
        rt='OK';
    end
    if bool_yesorno==1
        rt='FAIL';    
    end
    
    strcut=jsonencode(segments);
    js=sprintf('{"status":"%s","status_msg":"%s","data":%s}',rt,str_error_code,strcut);
    js = strrep(js,'BeginFrame','startFrame');
    js = strrep(js,'OverFrame','endFrame');
    js = strrep(js,'FrontObjectID','frontID');
    js = strrep(js,'Type','type');
    disp(js);

end




