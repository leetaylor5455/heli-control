function [data, sampsPerChanRead] = NI_DAQmxReadAnalogF64( taskHandle, numScans, numChannels )
% Wrapper function for DAQmxReadAnalogF64
% Using low level NI-DAQmx driver calls via the MEX "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver

fillMode = daq.ni.NIDAQmx.DAQmx_Val_GroupByChannel;

timeout = 10;
totalSamples = uint32(numScans) * numChannels;

[status, data, sampsPerChanRead, ~] =...
    daq.ni.NIDAQmx.DAQmxReadAnalogF64(...
    taskHandle,...                                      % task handle
    int32(numScans),...                                 % numSampsPerChan 
    double(timeout),...                                 % timeout in seconds
    uint32(fillMode),...                                % fillMode
    zeros(1,totalSamples),...                           % readArray
    uint32(totalSamples),...                            % arraySizeInSamps
    int32(0),...                                        % sampsPerChanRead
    uint32(0));                                         % reserved

% Data is grouped by channel in 1D array, reshape data array to 2D numScans x numChannels matrix
data = reshape(data, [], numChannels);

daq.ni.utility.throwOrWarnOnStatus(status);
end

