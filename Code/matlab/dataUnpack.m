clear all;

dataPosition = '../../Data/stats/';
filename = 'statAnal_raw';
ASF = 0;

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




t = tiledlayout(2, 2, "TileSpacing","tight", "Padding","tight");

ax1 = nexttile([1 2]);
errorbar(tt, accX, repelem(sigmaAcc, length(accX)), 'o', Color = "#0027bd");
hold on
errorbar(tt, accY, repelem(sigmaAcc, length(accY)), 'o', Color = "#ff0000");
errorbar(tt, accZ, repelem(sigmaAcc, length(accZ)), 'o', Color = "#00ff00");
hold off
grid on
grid minor


ax2 = nexttile([1 2]);
%plot(tt, sim_vo, Color = "magenta");
ylim([-1, 6]);
grid on
grid minor

% 14-74 ; 80-140 ; 150-210


%legend(ax1, 'Clock', 'Data', 'Clock Transisions', 'Data at Clock Transition', Location= 'ne')
legend(ax1, 'Clock', 'Data', 'Data at Clock Transition', 'Location', 'ne', 'Interpreter', 'latex')
ylabel(ax1, 'Voltage [V]', 'Interpreter', 'latex')
%xlabel(ax1, 'Time [s]', 'Interpreter', 'latex')

legend(ax2, 'Simulated Data', Location= 'ne')
ylabel(ax2, 'Simulated Voltage [V]', 'Interpreter', 'latex')
xlabel(ax2, 'Time [s]', 'Interpreter', 'latex')

linkaxes([ax1, ax2], 'x');
linkaxes([ax1, ax2], 'y');

hold off
fontsize(14, "points");

%title(t, strcat('Measured and Simulated LFSR cycles - n =   ', int2str(n)), 'FontSize', 18, 'Interpreter', 'latex');

lowerBound = [14, 80, 150];
upperBound = [74, 140, 210];

lowerBound = [0, 70, 140];
upperBound = [60, 130, 200];



for i = 1:3
    initIndex = find(tt > lowerBound(i), 1);
    endIndex = find(tt < upperBound(i), 1, "last");

    T = table(tt(initIndex:endIndex), accX(initIndex:endIndex), accY(initIndex:endIndex), accZ(initIndex:endIndex), 'VariableNames', {'Time', 'accX', 'accY', 'accZ'});
    writetable(T, strcat(dataPosition, 'data', int2str(i), '.txt'));
end

