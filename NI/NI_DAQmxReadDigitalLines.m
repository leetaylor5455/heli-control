function [data, sampsPerChanRead, numBytesPerChannel] = NI_DAQmxReadDigitalLines(taskHandle, numScans, numChannels)
%NI_DAQmxReadDigitalLines Wrapper function for DAQmxReadDigitalLines
% Using low level NI-DAQmx calls via the so-called "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver
%

fillMode = daq.ni.NIDAQmx.DAQmx_Val_GroupByChannel;

timeout = 10;
totalSamples = uint32(numScans) * numChannels;

[status,data,sampsPerChanRead,numBytesPerChannel,~] =...
                    daq.ni.NIDAQmx.DAQmxReadDigitalLines(...
                    taskHandle,...                                                  % taskHandle
                    int32(numScans),...                                             % number of samples per channel
                    double(timeout),...                                             % timeout
                    uint32(fillMode),...                                            % fillMode
                    uint8(zeros(1,totalSamples)),...                                % readArray
                    uint32(totalSamples),...                                        % arraySizeInSamps
                    int32(0),...                                                    % sampsPerChanRead
                    int32(0),...                                                    % numBytesPerChannel
                    uint32(0));                                                     % reserved

% Data is grouped by channel in 1D array, reshape data array to 2D numScans x numChannels matrix
data = reshape(data, [], numChannels);

daq.ni.utility.throwOrWarnOnStatus(status);
end