function [value] = NI_DAQmxReadCounterScalarF64( taskHandle )
%NI_DAQmxReadCounterScalarF64 Wrapper function for DAQmxReadCounterScalarF64
% Using low level NI-DAQmx driver calls via the MEX "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver

timeout = 10;
[status, value, ~] =...
    daq.ni.NIDAQmx.DAQmxReadCounterScalarF64(...
    taskHandle,...                                      % task handle
    double(timeout),...                                 % timeout in seconds
    0,...                                               % value
    uint32(0));                                         % reserved

daq.ni.utility.throwOrWarnOnStatus(status);
end

