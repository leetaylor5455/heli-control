%% Check if file exists
root_dir = matlab.project.rootProject().RootFolder;
data_fn = sprintf('%s\\data\\sensor_sample.csv', root_dir);

if ~exist(data_fn, 'file')
    % Ensure helicopter is still, run test to get sample
    outTest = sim('OpenLoopTest.slx');

    ttTest = outTest.tout;
    
    elevTest = outTest.logsout.getElement('Elevation (deg)').Values.Data;
    pitchTest = outTest.logsout.getElement('Pitch (deg)').Values.Data;
    travTest = outTest.logsout.getElement('Travel (deg)').Values.Data;
    % 
    eiTest = outTest.logsout.getElement('Ei').Values.Data;
    piTest = outTest.logsout.getElement('Pi').Values.Data;
    tiTest = outTest.logsout.getElement('Ti').Values.Data;

    % eiTest = cumtrapz(elevTest);
    % piTest = cumtrapz(pitchTest);
    % tiTest = cumtrapz(travTest);
    
    % First few seconds of data seems to have different noise characteristics
    % -> get rid of first half
    
    idxTest = round(length(ttTest)/2+1);

    elevTest = elevTest(idxTest:end);
    pitchTest = pitchTest(idxTest:end);
    travTest = travTest(idxTest:end);
    
    eiTest = eiTest(idxTest:end);
    piTest = piTest(idxTest:end);
    tiTest = tiTest(idxTest:end);

    ttTest = ttTest(idxTest:end);
    
    data = [ttTest elevTest pitchTest travTest eiTest piTest tiTest];

    writematrix(data, data_fn);

else
    data = readmatrix(data_fn);
    ttTest = data(:, 1);
    elevTest = data(:, 2);
    pitchTest = data(:, 3);
    travTest = data(:, 4);
    eiTest = data(:, 5);
    piTest = data(:, 6);
    tiTest = data(:, 7);
end

s_const = [elevTest pitchTest travTest];
% s_const = [elevTest pitchTest travTest eiTest piTest tiTest];

% Covariance and S.D.
R_raw = cov(s_const)
sigma = std(s_const)

% Remove bias
x_detr = s_const - mean(s_const); 
x_hp = detrend(s_const,0);  % remove constant bias

R_detr = cov(x_detr);

minVar = 1e-9; % Minimum variance for positive-definite R

R_kalman = blkdiag(R_detr, 0.01*[R_detr(1:1) 0; 0 R_detr(3:3)]);
R_kalman = enforceMinVariance(R_kalman, minVar);

% figure;
% Fs = 1/Ts; % sampling frequency
% pwelch(x_detr,[],[],[],Fs);
% title('Sensor Noise PSD');

% figure; 
% histogram(x_detr,100,'Normalization','pdf');
% hold on;
% xline(mean(x_detr),'r','LineWidth',2); % Optional

% [h,p] = kstest((x_detr-mean(x_detr))/std(x_detr))  % Kolmogorov-Smirnov test

% figure;
% title('Output Logs')
% 
% subplot(3, 1, 1);
% plot(ttTest, elevTest)
% % xlabel('Time (s)');
% ylabel('Elevation (deg)');
% 
% subplot(3, 1, 2);
% plot(ttTest, pitchTest)
% % xlabel('Time (s)');
% ylabel('Pitch (deg)');
% 
% subplot(3, 1, 3);
% plot(ttTest, travTest)
% xlabel('Time (s)');
% ylabel('Travel (deg)');
% 
% figure;
% 
% title('Output Integrals')
% 
% subplot(3, 1, 1);
% plot(ttTest, eiTest)
% % xlabel('Time (s)');
% ylabel('Elevation (deg)');
% 
% subplot(3, 1, 2);
% plot(ttTest, piTest)
% % xlabel('Time (s)');
% ylabel('Pitch (deg)');
% 
% subplot(3, 1, 3);
% plot(ttTest, tiTest)
% xlabel('Time (s)');
% ylabel('Travel (deg)');

function R2 = enforceMinVariance(R, minVar)
% Ensure diagonal entries are at least minVar and R is symmetric
R2 = (R + R.')/2;
d = diag(R2);
d_new = max(d, minVar);
R2(1:size(R,1)+1:end) = d_new;
end
