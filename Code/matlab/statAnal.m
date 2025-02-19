% to be used AFTER dataUnpack.m

clear all;

loc = 'Pisa';
dataPosition = strcat('../../Data/stats/drift&cali/', loc, '/');
filename = 'data';


g = 9.80665;
ranges = [16384, 8192, 4096, 2048];


Gs = [];
sigGs = [];

accXs = [];
accYs = [];
accZs = [];

stdXs = [];
stdYs = [];
stdZs = [];

verbose = false;

for ASF = 0:3
%    Gs = [];
%    stdXs = [];
%    stdYs = [];
%    stdZs = [];
    for n = 1:3
        % data import and creation of variance array
        rawData = readmatrix(strcat(dataPosition, filename, int2str(ASF), int2str(n), '.txt'));

        tt = rawData(:, 1);
        accX = rawData(:, 2);
        accY = rawData(:, 3);
        accZ = rawData(:, 4);
        sigmaAcc = 1/ranges(ASF+1) * g;



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



        avgX = mean(accX);
        avgY = mean(accY);
        avgZ = mean(accZ);

        stdX = std(accX);
        stdY = std(accY);
        stdZ = std(accZ);

        percentX = stdX/avgX * 100;
        percentY = stdY/avgY * 100;
        percentZ = stdZ/avgZ * 100;

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

        %accXs = [accXs, avgX];
        %accYs = [accYs, avgY];
        %accZs = [accZs, avgZ];
        g_abs = sqrt(avgX^2 + avgY^2 + avgZ^2);
        Gs = [Gs, g_abs];

        stdXs = [stdXs, mean(stdX)];
        stdYs = [stdYs, mean(stdY)];
        stdZs = [stdZs, mean(stdZ)];

%        sigG = sqrt(stdX^2 + stdY^2 + stdZ^2);
        sigG = sqrt( ( (avgX^2*mean(stdX))/(2*g_abs) )^2 + ( (avgY^2*mean(stdY))/(2*g_abs) )^2 + ( (avgZ^2*mean(stdZ))/(2*g_abs) )^2 );
        sigGs = [sigGs, sigG];

    end

    % present the average standard deviations both in m/s^2 and in units of g

    fprintf('ASF: %d\n', ASF);

    fprintf('Approximate value of g mostly aligned on axis 1 %f m/s^2 or %f g\n', Gs(ASF+1), Gs(ASF+1)/g);
    fprintf('Approximate value of g mostly aligned on axis 2 %f m/s^2 or %f g\n', Gs(ASF+2), Gs(ASF+2)/g);
    fprintf('Approximate value of g mostly aligned on axis 3 %f m/s^2 or %f g\n', Gs(ASF+3), Gs(ASF+3)/g);
    %fprintf('Averge acceration accX: %f m/s^2 or %f g\n', mean(accXs), mean(accXs)/g);
    %fprintf('Averge acceration accY: %f m/s^2 or %f g\n', mean(accYs), mean(accYs)/g);
    %fprintf('Averge acceration accZ: %f m/s^2 or %f g\n\n', mean(accZs), mean(accZs)/g);

    fprintf('Average standard deviation accX: %f m/s^2 or %f g\n', stdXs(ASF+1), stdXs(ASF+1)/g);
    fprintf('Average standard deviation accY: %f m/s^2 or %f g\n', stdYs(ASF+2), stdYs(ASF+2)/g);
    fprintf('Average standard deviation accZ: %f m/s^2 or %f g\n', stdZs(ASF+3), stdZs(ASF+3)/g);

    fprintf('Sensor sensitivity: %f m/s^2 or %f g\n\n', sigmaAcc, sigmaAcc/g);


%    fileID = fopen(strcat(dataPosition, 'statsAnal', '.txt'), 'a');
%    fprintf(fileID, 'ASF: %d\n', ASF);
%    fprintf()

    

end


T = table([0 0 0 1 1 1 2 2 2 3 3 3]', Gs', sigGs', 'VariableNames', {'ASF', 'g', 'sigmaG'});
writetable(T, strcat(dataPosition, 'statsAnal', '.txt'), 'WriteVariableNames', true);


