
function [Stim_meta] = get_photostim_info(metadata)

Stim_meta.Start_Index = str2num(metadata.get('Global Experiment|AcquisitionBlock|BleachingSetup|StartIndex #2'));
Stim_meta.Iterations = str2num(metadata.get('Global Experiment|AcquisitionBlock|BleachingSetup|Iterations #2'));
Stim_meta.Repetitions = str2num(metadata.get('Global Experiment|AcquisitionBlock|BleachingSetup|Repetition #2'));
end

