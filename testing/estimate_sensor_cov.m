%% Check if file exists
root_dir = matlab.project.rootProject().RootFolder;
data_fn = sprintf('%s\\data\\sensor_sample.csv', root_dir);

if ~exist(data_fn, 'file')
    % Ensure helicopter is still, run test to get sample
    outTest = sim('OpenLoopTest.slx');

    ttTest = outTest.tout;
    pitchTest = outTest.logsout.getElement('Pitch (deg)').Values.Data;
    elevTest = outTest.logsout.getElement('Elevation (deg)').Values.Data;
    travTest = outTest.logsout.getElement('Travel (deg)').Values.Data;
    
    % First few seconds of data seems to have different noise characteristics
    % -> get rid of first half
    
    pitchTest = pitchTest(round(length(pitchTest)/2)+1:end);
    elevTest = elevTest(round(length(elevTest)/2+1):end);
    travTest = travTest(round(length(travTest)/2+1):end);
    ttTest = ttTest(round(length(ttTest)/2+1):end);
    
    data = [ttTest pitchTest elevTest travTest];

    writematrix(data, data_fn);

else
    data = readmatrix(data_fn);
    ttTest = data(:, 1);
    pitchTest = data(:, 2);
    elevTest = data(:, 3);
    travTest = data(:, 4);
end


% figure;
% title('Output Logs')
% 
% subplot(3, 1, 1);
% plot(ttTest, pitchTest)
% % xlabel('Time (s)');
% ylabel('Pitch (deg)');
% 
% subplot(3, 1, 2);
% plot(ttTest, elevTest)
% % xlabel('Time (s)');
% ylabel('Elevation (deg)');
% 
% subplot(3, 1, 3);
% plot(ttTest, travTest)
% xlabel('Time (s)');
% ylabel('Travel (deg)');

s_const = [pitchTest elevTest travTest];

% Covariance and S.D.
R_raw = cov(s_const);
sigma = std(s_const);

% Remove bias
x_detr = s_const - mean(s_const); 
x_hp = detrend(s_const,0);  % remove constant bias

R_detr = cov(x_detr);

minVar = 1e-9; % Minimum variance for positive-definite R

R_kalman = blkdiag(R_detr, 0.1*R_detr(1:2, 1:2));
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

function R2 = enforceMinVariance(R, minVar)
% Ensure diagonal entries are at least minVar and R is symmetric
R2 = (R + R.')/2;
d = diag(R2);
d_new = max(d, minVar);
R2(1:size(R,1)+1:end) = d_new;
end
