%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Template file for EDMSE feature extraction
% Gerard O'Leary - University of Toronto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wait for x seconds before executing
% pause(7200);
% profile -memory on;
% setpref('profiler','showJitLines',1);
% profile viewer

addpath('EDMSE','-end');

%% Define list of records to process
output_dir = './EDMSE/OUTPUT/non_normalized/';
mkdir(output_dir);

patient_id = 'chb14';

channels = [1,2,3,4,6,7,8,9,11,12,14,15,16,17,19,20,21,22];
record_priority = [26,27,29,30,32,37,39,42];

image_dir = [output_dir, patient_id, '/images/'];
mkdir(image_dir);

spec_image_dir = [image_dir, '/spectrogram'];
mkdir(spec_image_dir);

edmse_image_dir = [image_dir, '/edmse'];
mkdir(edmse_image_dir);

%% Begin Extraction
output_dir = [output_dir, patient_id];
mkdir(output_dir);

se_alphas = [2 4 8 12 16];

se_bands = [ 0.5 4;
            4 8;
            8 12;
            12 25;
            25 45  ];


for record_idx = record_priority
    
    [signal,Fs,siginfo,sample_sz_onset,sample_sz_end] = LOAD_EEG(patient_id, record_idx, channels);
    

    img_fname = sprintf( '%s/spec_%s_%i.bmp', spec_image_dir, patient_id, record_idx );

    tstart = datestr(now);
    
    [se_concat, means, sds] =EDMSE_ExtractAllCombs( signal, se_bands, se_alphas, channels);
    
    img_fname = sprintf( '%s/edmse_%s_%i.bmp', edmse_image_dir, patient_id, record_idx );

    tend = datestr(now);

    fprintf('\nFinished Extracting index: %i \n', record_idx);
    fprintf('Start: %s\n',tstart);
    fprintf('End: %s\n',tend);
    
    fname = [ output_dir, '/EDMSE_ideal_', patient_id , '_', num2str(record_idx), '.mat'];
    save(fname, ...
        'patient_id', ...
        'record_idx', ...
        'Fs', ...
        'means', ...
        'sds', ...
        'sample_sz_onset', ...
        'sample_sz_end', ...
        'signal',...
        'se_concat', ...
        'se_bands', ...
        'se_alphas', ...    
        'tstart', ...
        'tend', ...
        '-v7.3' ) % Use when filename is stored in a variable

end
