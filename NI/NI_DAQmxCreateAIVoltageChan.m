function NI_DAQmxCreateAIVoltageChan( taskHandle, physicalChannel, terminalConfig, rangeMin, rangeMax )
%NI_DAQmxCreateAIVoltageChan Wrapper function for DAQmxCreateAIVoltageChan
% Using low level NI-DAQmx driver calls via the MEX "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver

[status] = daq.ni.NIDAQmx.DAQmxCreateAIVoltageChan(...
            taskHandle,...                          % task handle
            physicalChannel,...                     % physicalChannel
            char(0),...                             % nameToAssignToChannel
            terminalConfig,...                      % terminalConfig
            rangeMin,...                            % minVal
            rangeMax,...                            % maxVal
            daq.ni.NIDAQmx.DAQmx_Val_Volts,...      % units
            char(0));                               % customScaleName

daq.ni.utility.throwOrWarnOnStatus(status);
end

