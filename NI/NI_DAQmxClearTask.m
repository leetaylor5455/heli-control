function NI_DAQmxClearTaskorig( taskHandle )
%NI_DAQmxClearTask Wrapper function for DAQmxClearTask
% Using low level NI-DAQmx driver calls via the MEX "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver

[status] = daq.ni.NIDAQmx.DAQmxClearTask(...
    taskHandle);      % task handle


daq.ni.utility.throwOrWarnOnStatus(status);
end

