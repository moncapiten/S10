clear all; %#ok<*CLALL>

% 0 : AD2
% 1 : custom board
dataOrigin = 1;

dataPosition = '../../Data/tiltMeasure/';
filename = 'data7';

% data import and creation of variance array
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

temp = rawData(:, 1)/340 + 36.53;
accX = rawData(:, 2)/16384 * 9.80665;
accY = rawData(:, 3)/16384 * 9.80665;
accZ = rawData(:, 4)/16384 * 9.80665;
gyrX = rawData(:, 5)/32768;
gyrY = rawData(:, 6)/32768;
gyrZ = rawData(:, 7)/32768;

tt = 1:length(temp);

g = 9.80665;
sigmaAcc = 1/16384 * g;







avgX = mean(accX);
avgY = mean(accY);
avgZ = mean(accZ);
stdX = std(accX);
stdY = std(accY);
stdZ = std(accZ);


overallAcc = sqrt(accX.^2 + accY.^2 + accZ.^2);
sigOverall = sqrt( ( (avgX^2*stdX)/(2*mean(overallAcc)) )^2 + ( (avgY^2*stdY)/(2*mean(overallAcc)) )^2 + ( (avgZ^2*stdZ)/(2*mean(overallAcc)) )^2 );



% directions 0 meaning face up, 1 face down, 2 left, 3 right, 4 up, 5 down, -1 unknown
direction = zeros(length(overallAcc), 1);

thr = [0.8 * g, 1.2*g, 0.8 * g];

if dataOrigin == 0
    for i = 1:length(overallAcc)
        if overallAcc(i) < thr(1) || overallAcc(i) > thr(2)
            direction(i) = -1;
        elseif accX(i) > thr(3)
            direction(i) = 4;
        elseif accX(i) < -thr(3)
            direction(i) = 5;
        elseif accY(i) > thr(3)
            direction(i) = 2;
        elseif accY(i) < -thr(3)
            direction(i) = 3;
        elseif accZ(i) > thr(3)
            direction(i) = 0;
        elseif accZ(i) < -thr(3)
            direction(i) = 1;
        end
    end
elseif dataOrigin == 1
    for i = 1:length(overallAcc)
        if overallAcc(i) < thr(1) || overallAcc(i) > thr(2)
            direction(i) = -1;
        elseif accX(i) > thr(3)
            direction(i) = 0;
        elseif accX(i) < -thr(3)
            direction(i) = 1;
        elseif accY(i) > thr(3)
            direction(i) = 5;
        elseif accY(i) < -thr(3)
            direction(i) = 4;
        elseif accZ(i) > thr(3)
            direction(i) = 2;
        elseif accZ(i) < -thr(3)
            direction(i) = 3;
        end
    end
end



t = tiledlayout(2, 2, "TileSpacing","tight", "Padding","tight");

ax1 = nexttile([1 2]);
axs = [ax1];
errorbar(tt, accX, repelem(sigmaAcc, length(accX)), 'o', Color = "#ff0000");
hold on
errorbar(tt, accY, repelem(sigmaAcc, length(accY)), 'o', Color = "#00ff00");
errorbar(tt, accZ, repelem(sigmaAcc, length(accZ)), 'o', Color = "#0027bd");

%errorbar(tt, overallAcc, repelem(sigOverall, length(overallAcc)), 'o', Color = "magenta");
plot(tt, overallAcc, 'magenta');
hold off
grid on
grid minor

ax2 = nexttile([1 2]);
axs = [axs, ax2];
%errorbar(tt, gyrX, repelem(0.0015, length(gyrX)), 'o', Color = "#ff8da1");
%hold on
%errorbar(tt, gyrY, repelem(0.0015, length(gyrY)), 'o', Color = "#bab86c");
%errorbar(tt, gyrZ, repelem(0.0015, length(gyrZ)), 'o', Color = "#00ffff");
%hold off
plot(tt, direction, 'ok');
grid on
grid minor

yticks(ax2, [-1, 0, 1, 2, 3, 4, 5]);
yticklabels(ax2, {'unknown', 'face up', 'face down', 'left', 'right', 'up', 'down'});

legend(ax1, 'acc X', 'acc Y', 'acc Z', 'Location', 'ne', 'Interpreter', 'latex', 'fontsize', 14)
%legend(ax2, '', 'gyr Y', 'gyr Z', 'Location', 'ne', 'Interpreter', 'latex', 'fontsize', 14)

xlabel(ax2, 'Sampling', 'Interpreter', 'latex', 'fontsize', 14);
ylabel(ax1, 'Acceleration [ $ m/s^2 $ ]', 'Interpreter', 'latex', 'fontsize', 14);
ylabel(ax2, 'Tilt orientation', 'Interpreter', 'latex', 'fontsize', 14);

linkaxes(axs, 'x');
%linkaxes([ax1, ax2], 'y');

hold off
fontsize(14, "points");

title(t, strcat('Tilt orientation from raw data'), 'FontSize', 18, 'Interpreter', 'latex');