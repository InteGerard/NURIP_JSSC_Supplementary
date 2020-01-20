function [edmse] = EDMSE( signal, a, band)
    
    Fs = 256;
    n_taps = 255;
    alpha = 1/2^a; % EDM coefficients
    
    % Construct Filter
    w = kaiser(n_taps+1,0.5);

    fclow = band(1);
    fchigh =  band(2);
    BPF=fir1(n_taps, [ fclow fchigh ]./(Fs/2), w');
    
    WRITE_CSV = 0;
    if (WRITE_CSV)
        filename  = sprintf('FIR_coef_%.1f_%.1f.csv', band(1), band(2));
        csvwrite(filename, BPF);
    end

    sig_filt = filter(BPF, 1, signal);
    sig_filt = abs(sig_filt);

    edmse = zeros(length(sig_filt),1);
    edm = 0;
    for i=1:length(edmse)
            edm = edm - alpha*(edm - sig_filt(i));
            
            edmse(i) = edm;
    end
    
    edmse = single(edmse);
end


        
        