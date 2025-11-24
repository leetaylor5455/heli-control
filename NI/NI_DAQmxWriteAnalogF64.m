function NI_DAQmxWriteAnalogF64( taskHandle, data )
%NI_DAQmxWriteAnalogF64 Wrapper function for DAQmxWriteAnalogF64
% Using low level NI-DAQmx driver calls via the MEX "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver


% Process and validate inputs
numScans = size(data, 1);
numChannelsInData = size(data, 2);

numChannels = NI_DAQmxGetWriteNumChans(taskHandle);
if ~(numChannelsInData==numChannels)
    error('Expected data to be of size Nx%d, but it is of size %dx%d', ...
        numChannels, size(data,1),size(data,2));
end

data = data(:);

[status, ~, ~] = daq.ni.NIDAQmx.DAQmxWriteAnalogF64(...
    taskHandle, ...                                          % taskHandle
    int32(numScans), ...                                     % numSampsPerChan
    uint32(0), ...                                           % autoStart
    10, ...                                                  % timeout
    uint32(daq.ni.NIDAQmx.DAQmx_Val_GroupByChannel), ...     % dataLayout
    data, ...                                                % writeArray
    int32(0),...                                             % sampsPerChanWritten
    uint32(0));                                              % reserved

daq.ni.utility.throwOrWarnOnStatus(status);
end

