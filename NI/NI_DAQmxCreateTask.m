function taskHandle = NI_DAQmxCreateTask(  )
%NI_DAQmxCreateTask Wrapper function for DAQmxCreateTask
% Using low level NI-DAQmx driver calls via the MEX "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver

[status, taskHandle] = daq.ni.NIDAQmx.DAQmxCreateTask(...
    char(0),...       % taskName
    uint64(0));       % taskHandle

daq.ni.utility.throwOrWarnOnStatus(status);
end

