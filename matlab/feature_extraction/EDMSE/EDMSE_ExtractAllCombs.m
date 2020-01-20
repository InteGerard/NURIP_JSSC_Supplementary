function [se_concat, means, sds] = EDMSE_ExtractAll( signal, se_bands, se_alphas, channels )
    
    DEBUG = 0;
    if(DEBUG)
        se_alphas = [2 4 6 8 10 12 14 16];

        se_bands = [ 0.5 4;
                    4 8;
                    8 12;
                    12 25;
                    25 45  ];
                            
        %load CHB_data_example.mat
    end
    
    %% Process EDM-SE
    n_channels = length(channels);
    n_se_bands = length(se_bands);
    n_alpha = length(se_alphas);
    n_samp = size(signal,1);
    
 
    fv_dim = (n_channels*n_se_bands*n_alpha);
    se_concat =  zeros(n_samp, fv_dim, 'single');
    
    means = zeros(fv_dim,1);
    sds = zeros(fv_dim,1);
    
    for c = 1:length(channels)
        for b = 1:n_se_bands
            for a = 1:n_alpha 
                
                c_edmse = EDMSE( signal(:,c), se_alphas(a), se_bands(b,:) );
                row = ((c-1)*n_se_bands*n_alpha)+((b-1)*n_alpha)+a;
                
                means(row) = mean(c_edmse);
                sds(row) = std(c_edmse);
                
                se_concat(:,row) = c_edmse;                
            end
        end    
        
    end
    
    WRITE_PARAMS = 0;
    if (WRITE_PARAMS)
        csvwrite('Feature_means.csv', mu);
        csvwrite('Feature_invstd.csv', 1./sigma);
    end
    
    fprintf('Done');

        
end
