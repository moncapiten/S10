% data import and organization
%rawData1 = readmatrix('./Data/data006.txt');
%rawData2 = readmatrix('./Data/data007.txt');

loc = 'Pisa';
dataPosition = strcat('../../Data/stats/drift&cali/', loc, '/');
atRest = true;

t = tiledlayout(1, 3, "TileSpacing","tight", "Padding","tight");
axs = []
colors = ["#0027bd", "#ff0000", "#00ff00", "#ffff00", "#00ffff", "magenta", "#808000", "#ffa500"];


ax1 = nexttile([1 1]);
%assi X
for ASF = 0:3
    if atRest
        filename = strcat('data', num2str(ASF), '1');
    else
        filename = strcat('data', num2str(ASF), '3');
    end
    rawData = readmatrix(strcat(dataPosition, filename, '.txt'));
    accx = rawData( :, 2);

    if ASF == 0
        ha0 = histfit(accx, 20);
        ha0(1).FaceColor = colors(ASF+1);
        ha0(2).Color = colors(2*(ASF+1));
        hold on
    elseif ASF == 1
        ha1 = histfit(accx, 20);
        ha1(1).FaceColor = colors((ASF+1));
        ha1(2).Color = colors(2*(ASF+1));
    elseif ASF == 2
        ha2 = histfit(accx, 20);
        ha2(1).FaceColor = colors((ASF+1));
        ha2(2).Color = colors(2*(ASF+1));
    elseif ASF == 3
        ha3 = histfit(accx, 20);
        ha3(1).FaceColor = colors((ASF+1));
        ha3(2).Color = colors(2*(ASF+1));
        hold off;
    end
end
grid on
grid minor

ax2 = nexttile([1 1]);
%assi Y
for ASF = 0:3
    if atRest
        filename = strcat('data', num2str(ASF), '1');
    else
        filename = strcat('data', num2str(ASF), '2');
    end
    rawData = readmatrix(strcat(dataPosition, filename, '.txt'));
    accy = rawData( :, 3);

    if ASF == 0
        hb0 = histfit(accy, 20);
        hb0(1).FaceColor = colors((ASF+1));
        hb0(2).Color = colors(2*(ASF+1));
        hold on
    elseif ASF == 1
        hb1 = histfit(accy, 20);
        hb1(1).FaceColor = colors((ASF+1));
        hb1(2).Color = colors(2*(ASF+1));
    elseif ASF == 2
        hb2 = histfit(accy, 20);
        hb2(1).FaceColor = colors((ASF+1));
        hb2(2).Color = colors(2*(ASF+1));
    elseif ASF == 3
        hb3 = histfit(accy, 20);
        hb3(1).FaceColor = colors((ASF+1));
        hb3(2).Color = colors(2*(ASF+1));
        hold off;
    end
end
grid on
grid minor

ax3 = nexttile([1 1]);
%assi Z
for ASF = 0:3
    if atRest
        filename = strcat('data', num2str(ASF), '3');
    else
        filename = strcat('data', num2str(ASF), '1');
    end
    rawData = readmatrix(strcat(dataPosition, filename, '.txt'));
    accz = rawData( :, 4);

    if ASF == 0
        hc0 = histfit(accz, 20);
        hc0(1).FaceColor = colors((ASF+1));
        hc0(2).Color = colors(2*(ASF+1));
        hold on
    elseif ASF == 1
        hc1 = histfit(accz, 20);
        hc1(1).FaceColor = colors((ASF+1));
        hc1(2).Color = colors(2*(ASF+1));
    elseif ASF == 2
        hc2 = histfit(accz, 20);
        hc2(1).FaceColor = colors((ASF+1));
        hc2(2).Color = colors(2*(ASF+1));
    elseif ASF == 3
        hc3 = histfit(accz, 20);
        hc3(1).FaceColor = colors((ASF+1));
        hc3(2).Color = colors(2*(ASF+1));
        hold off;
    end
end
grid on
grid minor


axs = [ax1, ax2, ax3];

if atRest
    title(t, 'Histograms of acceleration across axis and ASFs - at rest', 'Interpreter', 'latex', 'fontsize', 18);
else
    title(t, 'Histograms of acceleration across axis and ASFs - under g', 'Interpreter', 'latex', 'fontsize', 18);
end

xlabel(axs, 'Acceleration $ [m/s^2] $', 'Interpreter', 'latex', 'fontsize', 14);
ylabel(axs(1), 'Counts ( 20 bins)', 'Interpreter', 'latex', 'fontsize', 14);

title(axs(1), 'X Axis', 'Interpreter', 'latex', 'fontsize', 14);
title(axs(2), 'Y Axis', 'Interpreter', 'latex', 'fontsize', 14);
title(axs(3), 'Z Axis', 'Interpreter', 'latex', 'fontsize', 14);

legend(ax3, 'ASF = 0', '', 'ASF = 1', '', 'ASF = 2', '', 'ASF = 3', 'Location', 'ne', 'interpreter', 'latex', 'fontsize', 14);




% plot of x axis != 0 with all ASFs
