clear all;

dataPosition = '../../Data/stats/temp/';
filename = 'rawTemp';

sigmaAcc = 1/16384 * 9.80665;

lowerBound = 0;
upperBound = 60;
%lowerBound = [0, 70, 140];
%upperBound = [60, 130, 200];




t = tiledlayout(2, 2, "TileSpacing","tight", "Padding","tight");

ax1 = nexttile([1 2]);
%errorbar(tt, accX, repelem(sigmaAcc, length(accX)), 'o', Color = "#001111");
%hold on
%errorbar(tt, accY, repelem(sigmaAcc, length(accY)), 'o', Color = "#110000");
%errorbar(tt, accZ, repelem(sigmaAcc, length(accZ)), 'o', Color = "#001100");
%hold off
grid on
grid minor

ax2 = nexttile([1 2]);
for specific = 1:3

    rawData = readmatrix(strcat(dataPosition, filename, int2str(specific), '.txt'));
    tt = rawData(:, 1);
    accX = rawData(:, 2);
    accY = rawData(:, 3);
    accZ = rawData(:, 4);


    initIndex = find(tt > lowerBound, 1);
    endIndex = find(tt < upperBound, 1, "last");

    T = table(tt(initIndex:endIndex), accX(initIndex:endIndex), accY(initIndex:endIndex), accZ(initIndex:endIndex), 'VariableNames', {'Time', 'accX', 'accY', 'accZ'});
    writetable(T, strcat(dataPosition, 'tempData', int2str(specific), '.txt'));





    errorbar(tt(initIndex:endIndex), accX(initIndex:endIndex), repelem(sigmaAcc, endIndex-initIndex+1), 'o', Color = "#0027bd");
    if( specific == 1)
        hold on
    end
    errorbar(tt(initIndex:endIndex), accY(initIndex:endIndex), repelem(sigmaAcc, endIndex-initIndex+1), 'o', Color = "#ff0000");
    errorbar(tt(initIndex:endIndex), accZ(initIndex:endIndex), repelem(sigmaAcc, endIndex-initIndex+1), 'o', Color = "#00ff00");

end
hold off
grid on
grid minor



legend(ax2, 'X', 'Y', 'Z', Location= 'ne')

linkaxes([ax1, ax2], 'x');
linkaxes([ax1, ax2], 'y');

hold off
fontsize(14, "points");

title(t, strcat('Measured data on all 3 axis - ASF =   ', int2str(ASF)), 'FontSize', 18, 'Interpreter', 'latex');