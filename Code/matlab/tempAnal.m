clear all;

dataPosition = '../../Data/stats/temp/';
filename = 'tempData';

g = 9.80665;
ranges = [16384, 8192, 4096, 2048];
temps = [19.4, 40.2, 60.3];


Gs = [];
sigGs = [];

accXs = [];
accYs = [];
accZs = [];

stdXs = [];
stdYs = [];
stdZs = [];

verbose = false;


for specific = 1:3
    % data import and creation of variance array
    rawData = readmatrix(strcat(dataPosition, filename, int2str(specific), '.txt'));

    tt = rawData(:, 1);
    accX = rawData(:, 2);
    accY = rawData(:, 3);
    accZ = rawData(:, 4);
    sigmaAcc = 1/ranges(specific+1) * g;



    errorbar(tt, accX, repelem(sigmaAcc, length(accX)), 'o', Color = "#0027bd");
    hold on
    errorbar(tt, accY, repelem(sigmaAcc, length(accY)), 'o', Color = "#ff0000");
    errorbar(tt, accZ, repelem(sigmaAcc, length(accZ)), 'o', Color = "#00ff00");
    hold off
    grid on
    grid minor

    legend('accX', 'accY', 'accZ', 'Location', 'ne', 'Interpreter', 'latex')


    ylabel('Acceleration [m/s^2]', 'Interpreter', 'latex')
    xlabel('Time [s]', 'Interpreter', 'latex')

    if verbose
        fprintf('Average accX: %f\n', avgX);
        fprintf('Standard deviation accX: %f\n', stdX);
        fprintf('Percentage accX: %f\n\n', percentX);

        fprintf('Average accY: %f\n', avgY);
        fprintf('Standard deviation accY: %f\n', stdY);
        fprintf('Percentage accY: %f\n\n', percentY);


        fprintf('Average accZ: %f\n', avgZ);
        fprintf('Standard deviation accZ: %f\n', stdZ);
        fprintf('Percentage accZ: %f\n\n', percentZ);
    end

    
    avgX = mean(accX);
    avgY = mean(accY);
    avgZ = mean(accZ);

    stdX = std(accX);
    stdY = std(accY);
    stdZ = std(accZ);


    g_abs = sqrt(avgX^2 + avgY^2 + avgZ^2);
    
    sigG = sqrt( ( (avgX^2*mean(stdX))/(2*g_abs) )^2 + ( (avgY^2*mean(stdY))/(2*g_abs) )^2 + ( (avgZ^2*mean(stdZ))/(2*g_abs) )^2 );



    accXs = [accXs, avgX];
    accYs = [accYs, avgY];
    accZs = [accZs, avgZ];

    stdXs = [stdXs, mean(stdX)];
    stdYs = [stdYs, mean(stdY)];
    stdZs = [stdZs, mean(stdZ)];


    Gs = [Gs, g_abs];

    sigGs = [sigGs, sigG];




    fprintf('Temperature: %d\n', temps(specific));

    fprintf('Approximate value of g %f m/s^2 or %f g\n', Gs(specific), Gs(specific)/g);

    fprintf('Average value accX: %f m/s^2 or %f g\n', accXs(specific), accXs(specific)/g);
    fprintf('Average value accY: %f m/s^2 or %f g\n', accYs(specific), accYs(specific)/g);
    fprintf('Average value accZ: %f m/s^2 or %f g\n\n', accZs(specific), accZs(specific)/g);

    fprintf('Average standard deviation accX: %f m/s^2 or %f g\n', stdXs(specific), stdXs(specific)/g);
    fprintf('Average standard deviation accY: %f m/s^2 or %f g\n', stdYs(specific), stdYs(specific)/g);
    fprintf('Average standard deviation accZ: %f m/s^2 or %f g\n\n', stdZs(specific), stdZs(specific)/g);

end


T = table(temps', Gs', sigGs', accXs', stdXs', accYs', stdYs', accZs', stdZs', 'VariableNames', {'Temperature', 'g', 'sigmaG', 'accX', 'stdX', 'accY', 'stdY', 'accZ', 'stdZ'});



writetable(T, strcat(dataPosition, 'tempAnal', '.txt'), 'WriteVariableNames', true);


