clear all; %#ok<*CLALL>

dataPosition = '../../Data/tiltMeasure/';
filename = 'data4';

% data import and creation of variance array
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

temp = rawData(:, 1)/340 + 36.53;
accX = rawData(:, 2)/16384 * 9.80665;
accY = rawData(:, 3)/16384 * 9.80665;
accZ = rawData(:, 4)/16384 * 9.80665;
gyrX = rawData(:, 5)/32768;
gyrY = rawData(:, 6)/32768;
gyrZ = rawData(:, 7)/32768;


ranges = [16384, 8192, 4096, 2048];
sigmaAcc = 1/16384 * 9.80665;

tt = 1:length(temp);





%s_data = repelem(0.0015, length(data));
%s_vo = repelem(0.0015, length(vo));

%sequ = readmatrix("../NumericalSim/python/sequences.txt", "OutputType", "char");
%sequ = sequ(:, 2);





%{
lowerBound = [14, 80, 150];
upperBound = [74, 140, 210];

if ASF ~= 0
    lowerBound = [0, 70, 140];
    upperBound = [60, 130, 200];
end

%}







t = tiledlayout(2, 2, "TileSpacing","tight", "Padding","tight");

ax1 = nexttile([1 2]);
axs = [ax1];
errorbar(tt, accX, repelem(sigmaAcc, length(accX)), 'o', Color = "#ff0000");
hold on
errorbar(tt, accY, repelem(sigmaAcc, length(accY)), 'o', Color = "#00ff00");
errorbar(tt, accZ, repelem(sigmaAcc, length(accZ)), 'o', Color = "#0027bd");
hold off
grid on
grid minor

ax2 = nexttile([1 2]);
axs = [axs, ax2];
errorbar(tt, gyrX, repelem(0.0015, length(gyrX)), 'o', Color = "#ff8da1");
hold on
errorbar(tt, gyrY, repelem(0.0015, length(gyrY)), 'o', Color = "#bab86c");
errorbar(tt, gyrZ, repelem(0.0015, length(gyrZ)), 'o', Color = "#00ffff");
hold off
grid on
grid minor



legend(ax1, 'acc X', 'acc Y', 'acc Z', 'Location', 'ne', 'Interpreter', 'latex', 'fontsize', 14)
legend(ax2, 'gyr X', 'gyr Y', 'gyr Z', 'Location', 'ne', 'Interpreter', 'latex', 'fontsize', 14)

xlabel(ax2, 'Sampling', 'Interpreter', 'latex', 'fontsize', 14);
ylabel(ax1, 'Acceleration [ $ m/s^2 $ ]', 'Interpreter', 'latex', 'fontsize', 14);
ylabel(ax2, 'Angular velocity [rad/s]', 'Interpreter', 'latex', 'fontsize', 14);

linkaxes(axs, 'x');
%linkaxes([ax1, ax2], 'y');

hold off
fontsize(14, "points");

title(t, strcat('Measured data on all 6 axis - simple visualization '), 'FontSize', 18, 'Interpreter', 'latex');