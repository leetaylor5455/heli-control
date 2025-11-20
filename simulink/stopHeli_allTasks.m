
% Clean up NI-DAQmx CI and AI tasks
NI_DAQmxStopTask(taskHandleCI)
NI_DAQmxClearTask(taskHandleCI)
NI_DAQmxStopTask(taskHandleAI)
NI_DAQmxClearTask(taskHandleAI)
NI_DAQmxStopTask(taskHandleDO)
NI_DAQmxClearTask(taskHandleDO)
NI_DAQmxStopTask(taskHandleAO)
NI_DAQmxClearTask(taskHandleAO)
% Write those outputs to 0 to stop the fans
d = daq("ni");
addoutput(d,"myDAQ1","ao0","Voltage");
addoutput(d,"myDAQ1","ao1","Voltage");
write(d,[0,0]);
clear d 
% clear d_do
