clc

Matrice_input('Hook_1498.mat', 'Hook_1498.txt');
fprintf('Hook_1498 \n');

Matrice_input('bundle_adj.mat', 'bundle_adj.txt');
fprintf('bundle_adj \n');

Matrice_input('G3_circuit.mat', 'G3_circuit.txt');
fprintf('G3_circuit \n');

Matrice_input('GT01R.mat', 'GT01R.txt');
fprintf('GT01R \n');

Matrice_input('ifiss_mat.mat', 'ifiss_mat.txt');
fprintf('ifiss_mat \n');

Matrice_input('nd24k.mat', 'nd24k.txt');
fprintf('nd24k \n');

Matrice_input('ns3Da.mat', 'ns3Da.txt');
fprintf('ns3Da \n');

Matrice_input('TSC_OPF_1047.mat', 'TSC_OPF_1047.txt');
fprintf('TSC_OPF_1047 \n');

% Profiler References
% https://it.mathworks.com/help/matlab/matlab_prog/profiling-for-improving-performance.html
% https://it.mathworks.com/help/matlab/ref/profile.html
% https://undocumentedmatlab.com/articles/undocumented-profiler-options/
% https://undocumentedmatlab.com/articles/viewing-saved-profiling-results

function res = Matrice_input(name_matrix, name_save_file)
    profile clear
    tic;
    load(name_matrix);
    time_load = toc;
    A = Problem.A;
    xe = ones(size(A,1),1);
    b = A*xe;
    profile -memory -history on
    tic;
    xe_approx = A\b;
    time = toc;
    % Uncomment to show what variables can be saved from the profiler
    % profile('info').FunctionTable()
    peak_ram = profile('info').FunctionTable().PeakMem; % peak in Kb
    profile off
    err = norm(xe - xe_approx)/ norm(xe);
    res = [time_load, time, err, peak_ram];
    file = fopen( name_save_file, 'wt' );
    writematrix(res,name_save_file);
    fclose(file);
    file_approx = strcat(name_save_file(1:strlength(name_save_file)-4), '_approx.txt');
    file = fopen( file_approx , 'wt' );
    writematrix([xe_approx], file_approx);
    fclose(file);
end