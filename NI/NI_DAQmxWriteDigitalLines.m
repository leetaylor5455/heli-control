function sampsPerChanWritten = NI_DAQmxWriteDigitalLines( taskHandle, data )
%NI_DAQmxWriteDigitalLines Wrapper function for DAQmxWriteDigitalLines
% Using low level NI-DAQmx driver calls via the MEX "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver
% 
% data is expected to be a 2D matrix numScans x numChannels (one column per channel)

numScans = size(data, 1);

% Reshape data to 1D array
data = data(:);

% Timeout (s)
timeout = 10;

[status, sampsPerChanWritten, ~] =...
    daq.ni.NIDAQmx.DAQmxWriteDigitalLines(...
    taskHandle,...                                          % taskHandle
    int32(numScans),...                                     % numSampsPerChan
    uint32(false),...                                       % autoStart
    double(timeout),...                                     % timeout
    uint32(daq.ni.NIDAQmx.DAQmx_Val_GroupByChannel),...     % dataLayout
    uint8(data),...                                         % writeArray
    int32(0),...                                            % sampsPerChanWritten
    uint32(0));                                             % reserved
    
daq.ni.utility.throwOrWarnOnStatus(status);

end