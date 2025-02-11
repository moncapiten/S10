clear all;

dataPosition = '../../Data/stats/';
filename = 'statAnal_raw';
ASF = 2;

% data import and creation of variance array
rawData = readmatrix(strcat(dataPosition, filename, int2str(ASF), '.txt'));

tt = rawData(:, 1);
accX = rawData(:, 3);
accY = rawData(:, 4);
accZ = rawData(:, 5);
gyrX = rawData(:, 6);
gyrY = rawData(:, 7);
gyrZ = rawData(:, 8);


ranges = [16384, 8192, 4096, 2048];
sigmaAcc = 1/ranges(ASF+1) * 9.80665;
%s_data = repelem(0.0015, length(data));
%s_vo = repelem(0.0015, length(vo));

%sequ = readmatrix("../NumericalSim/python/sequences.txt", "OutputType", "char");
%sequ = sequ(:, 2);






lowerBound = [14, 80, 150];
upperBound = [74, 140, 210];

if ASF ~= 0
    lowerBound = [0, 70, 140];
    upperBound = [60, 130, 200];
end









t = tiledlayout(2, 2, "TileSpacing","tight", "Padding","tight");

ax1 = nexttile([1 2]);
errorbar(tt, accX, repelem(sigmaAcc, length(accX)), 'o', Color = "#001111");
hold on
errorbar(tt, accY, repelem(sigmaAcc, length(accY)), 'o', Color = "#110000");
errorbar(tt, accZ, repelem(sigmaAcc, length(accZ)), 'o', Color = "#001100");
hold off
grid on
grid minor

ax2 = nexttile([1 2]);
%hold on
for i = 1:3
    initIndex = find(tt > lowerBound(i), 1);
    endIndex = find(tt < upperBound(i), 1, "last");

    T = table(tt(initIndex:endIndex), accX(initIndex:endIndex), accY(initIndex:endIndex), accZ(initIndex:endIndex), 'VariableNames', {'Time', 'accX', 'accY', 'accZ'});
%    writetable(T, strcat(dataPosition, 'data', int2str(ASF), int2str(i), '.txt'));





    errorbar(tt(initIndex:endIndex), accX(initIndex:endIndex), repelem(sigmaAcc, endIndex-initIndex+1), 'o', Color = "#0027bd");
    if( i == 1)
        hold on
    end
%    hold on
    errorbar(tt(initIndex:endIndex), accY(initIndex:endIndex), repelem(sigmaAcc, endIndex-initIndex+1), 'o', Color = "#ff0000");
    errorbar(tt(initIndex:endIndex), accZ(initIndex:endIndex), repelem(sigmaAcc, endIndex-initIndex+1), 'o', Color = "#00ff00");
    









end
hold off
grid on
grid minor



% 14-74 ; 80-140 ; 150-210


%legend(ax1, 'Clock', 'Data', 'Clock Transisions', 'Data at Clock Transition', Location= 'ne')
%legend(ax1, 'Clock', 'Data', 'Data at Clock Transition', 'Location', 'ne', 'Interpreter', 'latex')
%ylabel(ax1, 'Voltage [V]', 'Interpreter', 'latex')
%xlabel(ax1, 'Time [s]', 'Interpreter', 'latex')

legend(ax2, 'X', 'Y', 'Z', Location= 'ne')
%ylabel(ax2, 'Simulated Voltage [V]', 'Interpreter', 'latex')
%xlabel(ax2, 'Time [s]', 'Interpreter', 'latex')

linkaxes([ax1, ax2], 'x');
linkaxes([ax1, ax2], 'y');

hold off
fontsize(14, "points");

title(t, strcat('Measured data on all 3 axis - ASF =   ', int2str(ASF)), 'FontSize', 18, 'Interpreter', 'latex');