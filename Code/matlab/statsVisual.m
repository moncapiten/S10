clear all;

dataPosition = '../../Data/stats/';
filename = 'statsAnal';

g = 9.80665;
ranges = [16384, 8192, 4096, 2048];



rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

ASF = rawData(:, 1);
Gs = rawData(:, 2);
sigmaG = rawData(:, 3);


colors = ["#0027bd", "#ff0000", "#00ff00", "#0077aa"];


%{
for i = 1:length(ASF)


    errorbar(i, Gs(i), sigGs(i));
    if i == 1
        hold on
    end
    i




end
%}

%order is  Z Y X
%{
3 6 9 12
2 5 8 11
1 4 7 10

%}


t = tiledlayout(1, 3, "TileSpacing","tight", "Padding","tight");
axs = []


indexes = [3 6 9 12 2 5 8 11 1 4 7 10];



for j = 0:2;
    axs = [axs, nexttile([1 1])];
    for i = 1:4
        index = indexes(i + 4*j)
        errorbar(i, Gs(index), sigmaG(index), 'Color', colors(i));
        if i == 1
            hold on
        end
    end
    grid on
    grid minor
end

title(t, 'Comparison of standard deviation and drift across axis and AFSs - static case', 'Interpreter', 'latex');

xlabel(axs, 'Arbitrary', 'Interpreter', 'latex');
ylabel(axs(1), '$ m/s^2 $', 'Interpreter', 'latex');
%yticklabels(axs(2), []);
%yticklabels(axs(3), []);


title(axs(1), 'X Axis', 'Interpreter', 'latex');
title(axs(2), 'Y Axis', 'Interpreter', 'latex');
title(axs(3), 'Z Axis', 'Interpreter', 'latex');

xlim(axs, [0 5]);
linkaxes(axs, 'y');

legend(axs(3), 'ASF = 0', 'ASF = 1', 'ASF = 2', 'ASF = 3', 'Location', 'ne', 'interpreter', 'latex');

