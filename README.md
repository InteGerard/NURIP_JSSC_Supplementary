# NURIP: Neural Interface Processor

This is a public repository for a reduced software model of the application-specific integrated circuit presented in the following paper:
Gerard O'Leary, David M. Groppe, Taufik A. Valiante, Naveen Verma and Roman Genov, "NURIP: Neural Interface Processor for Brain-State Classification and Programmable-Waveform Neurostimulation," IEEE Journal of Solid-State Circuits, 2018. DOI: 10.1109/JSSC.2018.2869579

Note that the EU epilepsy database was used for performance analysis (subscripion required: http://epilepsy-database.eu/).
Ihle M, Feldwisch-Drentrup H, Teixeira CA, Witon A, Schelter B, Timmer J, Schulze-Bonhage A., "EPILEPSIAE - a European epilepsy database," Comput Methods Programs Biomed. 2012

Step 1: Feature Extraction. 
Based on feature selection experimentation it is generally the case that EDMSE features are most informative for classification purposes, and are considerably more straightforward to configure when compared to the PLV and CFC features. A matlab implementation of the EDMSE feature is provided. See:
G O'Leary, I Taras, DM Stuart, J Koerner, DM Groppe, TA Valiante, R. Genov, "GPU-Accelerated Parameter Selection for Neural Connectivity Analysis Devices," 2018 IEEE Biomedical Circuits and Systems Conference (BioCAS)
J Koerner, G O’Leary, TA Valiante, R Genov, "Neuromodulation Biomarker Selection using GPU-Parallelized Genetic Algorithms," 2019 IEEE Biomedical Circuits and Systems Conference (BioCAS)

Step 2: SVM Training. 
The SVM implementation within the Scikit-Learn python toolbox was used. An RBF kernel was utilized with nu and gamma hyperparameters selected on a per-patient basis. Typical values were 0.1 and 1e-6, respectively.
See: https://scikit-learn.org/stable/auto_examples/svm/plot_rbf_parameters.html

Step 3: Forward chaining validation. 
For EEG analysis is it critical to perform validation using forward chaining (as opposed to methods such as LOOCV) to avoid classifier bias and to avoid optimistic performance results which do not translate to real world online settings. 
See: https://towardsdatascience.com/time-series-nested-cross-validation-76adba623eb9 
Validation notes:
A 5 minute "cooloff period" is used when reporting the false positive rate. 
A moving average is taken of the raw SVM output which was determined on a per patient basis. The window length was calculated by taking the longest moving average which still resulted in a true positive for the first seizure. Note that there is a tradeoff between the length of this window, and the classifier latency (which was typically on the order of 10 seconds).

As a starting point, the run_edmse.m script must be set up to performs feature extraction on your EEG dataset. You will need to populate the LOAD_EEG() function to return a multi-channel EEG signal and corresponding metadata (e.g. seizure onsef and offsets). The output EDMSE_*.mat files will then serve as a training set for the classifier example provided in the python folder.
