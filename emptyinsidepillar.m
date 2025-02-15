function map = emptyinsidepillar(map)

% Removes the data of floor rate map from the inside of pillars where there should be no data
% at all

% For floors with 40x40 bin only. Other bin sizes will not work since this
% is hardcoded. 

% Check if map is linear or grid
if any(size(map)==1600)
    linear = true;
else
    linear = false;
    if ~size(map,1)==40 
        error('grid map is not of expected size');
    else
        % reshape to linear
        map = gridtolinear({map},'place',[40 40]);
    end
end

pillarcoords = [331:338,... % Bottom left
                371:378,...
                411:418,...
                451:458,...
                491:498,...
                531:538,...
                571:578,...
                611:618,...
                347:354,... % Bottom right
                387:394,...
                427:434,...
                467:474,...
                507:514,...
                547:554,...
                587:594,...
                627:634,...
                971:978,... % Top left
                1011:1018,...
                1051:1058,...
                1091:1098,...
                1131:1138,...
                1171:1178,...
                1211:1218,...
                1251:1258,...
                987:994,... % Top right
                1027:1034,...
                1067:1074,...
                1107:1114,...
                1147:1154,...
                1187:1194,...
                1227:1234,...
                1267:1274
                ];

map(pillarcoords,:) = nan;
if ~linear
    map = lineartogrid(map,'place',[40 40]);
    map = map{1};
end