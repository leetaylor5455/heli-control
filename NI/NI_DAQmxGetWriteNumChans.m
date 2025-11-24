function [numChans] = NI_DAQmxGetWriteNumChans( taskHandle )
%NI_DAQmxGetWriteNumChans Wrapper function for DAQmxGetWriteNumChans
% Using low level NI-DAQmx calls via the so-called "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver

[status, numChans] =...
    daq.ni.NIDAQmx.DAQmxGetWriteNumChans(...
    taskHandle,...   % task handle
    uint32(0));      % numChans

daq.ni.utility.throwOrWarnOnStatus(status);
end

