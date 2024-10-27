function [output] = para_extra(inputData)
%%
output =[];
%输入data是个1*n的cell  n个车道保持片段 每个片段里数据格式：
%"
%"纵向速度1","纵向加速度2",车道中心线偏移量3"与前车车距4,前车速度5,"横向左车距6","横向右车距7","车道宽度8,车辆宽度9，横向速度10，横向加速度11
for fragment = 1:size(inputData,2)
    thw = inputData{fragment}(:,4)./abs(inputData{fragment}(:,1));
    %THW均值
    meanThw  = nanmean(thw);

    % 风险率
    % 找存在前车的场景
    followFragment = [];
    followFragment = inputData{fragment}( inputData{fragment}(:,4)~=0,:);
    numofFrame  = size(followFragment);
    a_maxBrake = 0.5*9.8;% 风险率参数
    tr = 1;
    dangerRate = 0;
    dangerframe = 0;
    dangerLevel = 0;
    totalArea = 0;
    actualArea = 0;
    if numofFrame(1)>1
        for frame = 1: numofFrame(1)
            dmin= (followFragment(frame,1) *tr + 0.5*followFragment(frame,2)* tr^2 + ...
                ((followFragment(frame,1)+followFragment(frame,2)* tr )^2)/(2*a_maxBrake) - followFragment(frame,5)^2/(2*a_maxBrake));
            if followFragment(frame,4) < dmin
                dangerframe = dangerframe+1;
                totalArea = totalArea + dmin;
                actualArea =  actualArea +  dmin - followFragment(frame,4)  ;
            end
        end
        if dangerframe~=0
            dangerRate = dangerframe/numofFrame(1);
            dangerLevel = actualArea/totalArea;
        else
            dangerRate = 0;
            dangerLevel = 0;
        end
    end
    %THW标准差
    stdThw = nanstd(thw);

    %DHW标准差
    stdDhw = nanstd(inputData{fragment}(:,4));

    %速度标准差
    stdspeed = std(inputData{fragment}(:,1));

    %jia速度标准差
    stdacc = std(inputData{fragment}(:,2));

    %车道中心线偏移最大值
    maxoffside = max(abs(inputData{fragment}(:,3)));

    % TLC最小值
    data = [];
    lanewidth = inputData{fragment}(1,8);
    vehicelwidth = inputData{fragment}(1,9);
    data(:,1) = (1:size(inputData{fragment}, 1))';
    data(:,2) = inputData{fragment}(:,3);
    data(:,3) = inputData{fragment}(:,10);
    data(:,4) = inputData{fragment}(:,11);
    %UNTITLED2 calculate TLC using lateral position divided by lateral velocity
    %plus lateral acceleration
    % filter v and a
    t=data(:,1);
    y=data(:,2);
    v=data(:,3);
    a=data(:,4);
    h=length(t);
    for i=1:h
        boundary1=(lanewidth-vehicelwidth)/2;
        boundary2=-(lanewidth-vehicelwidth)/2;
        if y(i)>boundary2 && y(i)<boundary1
            tlc1=(-v(i)+(v(i)^2-2*a(i)*(y(i)-boundary1))^0.5)/a(i);
            tlc2=(-v(i)-(v(i)^2-2*a(i)*(y(i)-boundary1))^0.5)/a(i);
            tlc3=(-v(i)+(v(i)^2-2*a(i)*(y(i)-boundary2))^0.5)/a(i);
            tlc4=(-v(i)-(v(i)^2-2*a(i)*(y(i)-boundary2))^0.5)/a(i);
            tlc=[];
            if isreal(tlc1)
                tlc=[tlc, tlc1];
            end
            if isreal(tlc2)
                tlc=[tlc, tlc2];
            end
            if isreal(tlc3)
                tlc=[tlc, tlc3];
            end
            if isreal(tlc4)
                tlc=[tlc, tlc4];
            end
            pz=find(tlc>0);
            if ~isempty(pz)
                mintlc = min(tlc(pz));
                TLC(i)=mintlc(1);
            else
                TLC(i) = NaN;
            end
        else if y(i)>=boundary1
                if (i>1) && (y(i-1)>= boundary1)
                    TLC(i)=TLC(i-1)+t(i-1)-t(i);
                else
                    TLC(i)=0;
                end
        else if y(i)<=boundary2
                if (y(i-1)<=boundary2) && (i>1)
                    TLC(i)=TLC(i-1)+t(i-1)-t(i);
                else
                    TLC(i)=0;
                end
        end
        end
        end
    end
    minTLC = min(TLC);

    %横向左右车距最小值
    minleft= min(inputData{fragment}(:,6));
    minright= min(inputData{fragment}(:,7));
    minlatDistance = min(minleft,minright);
    %横向位置标准差
    stdoffside = std(inputData{fragment}(:,3));

    output = [output;meanThw,dangerRate,stdThw,stdDhw, stdspeed,stdacc,maxoffside,minTLC,minlatDistance,stdoffside];

end
end