clear all;

dataPosition = '../../Data/stats/temp/';
filename = 'tempAnal';

g = 9.80665;

rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

temps = rawData(:, 1);
Gs = rawData(:, 2);
sigmaG = rawData(:, 3);
accXs = rawData(:, 4);
stdXs = rawData(:, 5);
accYs = rawData(:, 6);
stdYs = rawData(:, 7);
accZs = rawData(:, 8);
stdZs = rawData(:, 9);

colors = ["#0027bd", "#0077aa", "#ff0000"];


t = tiledlayout(2, 2, "TileSpacing","tight", "Padding","tight");
axs = [];


axs = [axs, nexttile([1 1])];
for i = 1:3
    errorbar(temps(i), Gs(i), sigmaG(i), 'Color', colors(i));
    if i == 1
        hold on
    end    
end
hold off
grid on
grid minor
axs = [axs, nexttile([1 1])];
for i = 1:3
    errorbar(temps(i), accXs(i), stdZs(i), 'Color', colors(i));
    if i == 1
        hold on
    end    
end
hold off
grid on
grid minor
axs = [axs, nexttile([1 1])];
for i = 1:3
    errorbar(temps(i), accYs(i), stdYs(i), 'Color', colors(i));
    if i == 1
        hold on
    end    
end
hold off
grid on
grid minor
axs = [axs, nexttile([1 1])];
for i = 1:3
    errorbar(temps(i), accZs(i), stdZs(i), 'Color', colors(i));
    if i == 1
        hold on
    end    
end
hold off
grid on
grid minor



title(t, 'Comparison of standard deviation and drift across axis and temperatures - static case', 'Interpreter', 'latex', 'fontsize', 18);

xlabel(axs(3), 'Temperature [C]', 'Interpreter', 'latex', 'fontsize', 14);
xlabel(axs(4), 'Temperature [C]', 'Interpreter', 'latex', 'fontsize', 14);
ylabel(axs, '$ m/s^2 $', 'Interpreter', 'latex', 'fontsize', 14);
%yticklabels(axs(2), []);
%yticklabels(axs(3), []);


title(axs(1), 'G', 'Interpreter', 'latex', 'fontsize', 14);
title(axs(2), 'X Axis', 'Interpreter', 'latex', 'fontsize', 14);
title(axs(3), 'Y Axis', 'Interpreter', 'latex', 'fontsize', 14);
title(axs(4), 'Z Axis', 'Interpreter', 'latex', 'fontsize', 14);


xlim(axs, [15 65]);
linkaxes(axs, 'x');
%linkaxes(axs, 'y');

%legend(axs(3), 'ASF = 0', 'ASF = 1', 'ASF = 2', 'ASF = 3', 'Location', 'ne', 'interpreter', 'latex', 'fontsize', 14);
%fontsize(t, 14, "points");
