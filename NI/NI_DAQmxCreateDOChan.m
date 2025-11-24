function NI_DAQmxCreateDOChan( taskHandle, lines )
%NI_DAQmxCreateDOChan Wrapper function for DAQmxCreateDOChan
% Using low level NI-DAQmx driver calls via the MEX "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver

[status] = daq.ni.NIDAQmx.DAQmxCreateDOChan(...
    taskHandle,...                                % task handle
    lines,...                                     % lines
    char(0),...                                   % nameToAssignToLines
    daq.ni.NIDAQmx.DAQmx_Val_ChanForAllLines);    % lineGrouping

daq.ni.utility.throwOrWarnOnStatus(status);
end

