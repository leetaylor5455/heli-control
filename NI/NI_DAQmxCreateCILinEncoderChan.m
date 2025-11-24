function NI_DAQmxCreateCILinEncoderChan( taskHandle, physicalChannel, decodingType, units, distPerPulse)
%NI_DAQmxCreateCILinEncoderChan Wrapper function for DAQmxCreateCILinEncoderChan
% Using low level NI-DAQmx driver calls via the MEX "projection layer"
% Refer to "NI-DAQmx C Reference Help" file installed with the NI-DAQmx driver

[status] = daq.ni.NIDAQmx.DAQmxCreateCILinEncoderChan(...
            taskHandle,...                          % task handle
            physicalChannel,...                     % physicalChannel
            char(0),...                             % nameToAssignToChannel
            decodingType,...                        % decodingType
            uint32(0),...                           % ZidxEnable
            0,...                                   % ZidxValue
            daq.ni.NIDAQmx.DAQmx_Val_AHighBHigh,... % ZidxPhase
            units,...                               % units
            distPerPulse,...                     % distPerPulse
            0,...                                   % initialPosition
            char(0));                               % customScaleName

daq.ni.utility.throwOrWarnOnStatus(status);
end

