%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exponentially Decaying Memory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edm_output = edm(varargin)
   %% output = edm(input, alphas, init_edm)
    input = varargin{1};
    alphas = varargin{2};

    if (length(varargin) > 2)
        init_edm = varargin{3};
    else   
        init_edm = 0.5;
    end

    n_alpha = length(alphas);
    edm_output = zeros(n_alpha,length(input));

    for n = 1:n_alpha
        alpha = 1/2^alphas(n); % EDM coefficients
        edm = init_edm;
        for i=1:length(input)
                edm = edm - alpha*(edm - input(i));
                edm_output(n,i) = edm;
        end
    end
end