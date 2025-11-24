function NI_DAQmxCreateAOVoltageChan( taskHandle, physicalChannel )
%NI_DAQmxCreateAOVoltageChan Wrapper function for DAQmxCreateAOVoltageChan
% Using low level NI-DAQmx driver calls via the MEX "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver

[status] = daq.ni.NIDAQmx.DAQmxCreateAOVoltageChan(...
            taskHandle,...                          % task handle
            physicalChannel,...                     % physicalChannel
            char(0),...                             % nameToAssignToChannel
            -10,...                                 % minVal
            10,...                                  % maxVal
            daq.ni.NIDAQmx.DAQmx_Val_Volts,...      % units
            char(0));                               % customScaleName

daq.ni.utility.throwOrWarnOnStatus(status);
end

