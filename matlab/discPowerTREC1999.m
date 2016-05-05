samples = 50;
stem = listSystems('stem');
grams = listSystems('grams');


serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1996/ap_AH_MONO_EN_TREC1996.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1996/p10_AH_MONO_EN_TREC1996.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1996/rbp_AH_MONO_EN_TREC1996.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1996/ndcg_AH_MONO_EN_TREC1996.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1996/err_AH_MONO_EN_TREC1996.mat')

fprintf('\nGrams\n');

[~, dp_grams_TREC1996, ~] = discriminativePower(ap_AH_MONO_EN_TREC1996(:, grams), p10_AH_MONO_EN_TREC1996(:, grams), ...
    rbp_AH_MONO_EN_TREC1996(:, grams), ndcg_AH_MONO_EN_TREC1996(:, grams), ...
    err_AH_MONO_EN_TREC1996(:, grams), 'Method', 'PairedBootstrapTest', 'Samples', samples);

dp_grams_TREC1996 = sortrows(dp_grams_TREC1996, -1);

fprintf('\nStem\n');

[~, dp_stem_TREC1996, ~] = discriminativePower(ap_AH_MONO_EN_TREC1996(:, stem), p10_AH_MONO_EN_TREC1996(:, stem), ...
    rbp_AH_MONO_EN_TREC1996(:, stem), ndcg_AH_MONO_EN_TREC1996(:, stem), ...
    err_AH_MONO_EN_TREC1996(:, stem), 'Method', 'PairedBootstrapTest', 'Samples', samples);


sersave('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/analysis/AH_MONO_EN_TREC1996/dp_AH_MONO_EN_TREC1996.mat', ...
    dp_grams_TREC1996, dp_stem_TREC1996);

dp_stem_TREC1996 = sortrows(dp_stem_TREC1996, -1);

clear ap_AH_MONO_EN_TREC1996 p10_AH_MONO_EN_TREC1996 rbp_AH_MONO_EN_TREC1996 ndcg_AH_MONO_EN_TREC1996 err_AH_MONO_EN_TREC1996;

serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1997/ap_AH_MONO_EN_TREC1997.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1997/p10_AH_MONO_EN_TREC1997.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1997/rbp_AH_MONO_EN_TREC1997.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1997/ndcg_AH_MONO_EN_TREC1997.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1997/err_AH_MONO_EN_TREC1997.mat')

fprintf('\nGrams\n');

[~, dp_grams_TREC1997, ~] = discriminativePower(ap_AH_MONO_EN_TREC1997(:, grams), p10_AH_MONO_EN_TREC1997(:, grams), ...
    rbp_AH_MONO_EN_TREC1997(:, grams), ndcg_AH_MONO_EN_TREC1997(:, grams), ...
    err_AH_MONO_EN_TREC1997(:, grams), 'Method', 'PairedBootstrapTest', 'Samples', samples);

dp_grams_TREC1997 = sortrows(dp_grams_TREC1997, -1);

fprintf('\nStem\n');

[~, dp_stem_TREC1997, ~] = discriminativePower(ap_AH_MONO_EN_TREC1997(:, stem), p10_AH_MONO_EN_TREC1997(:, stem), ...
    rbp_AH_MONO_EN_TREC1997(:, stem), ndcg_AH_MONO_EN_TREC1997(:, stem), ...
    err_AH_MONO_EN_TREC1997(:, stem), 'Method', 'PairedBootstrapTest', 'Samples', samples);


sersave('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/analysis/AH_MONO_EN_TREC1997/dp_AH_MONO_EN_TREC1997.mat', ...
    dp_grams_TREC1997, dp_stem_TREC1997);

dp_stem_TREC1997 = sortrows(dp_stem_TREC1997, -1);

clear ap_AH_MONO_EN_TREC1997 p10_AH_MONO_EN_TREC1997 rbp_AH_MONO_EN_TREC1997 ndcg_AH_MONO_EN_TREC1997 err_AH_MONO_EN_TREC1997;


serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1998/ap_AH_MONO_EN_TREC1998.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1998/p10_AH_MONO_EN_TREC1998.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1998/rbp_AH_MONO_EN_TREC1998.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1998/ndcg_AH_MONO_EN_TREC1998.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1998/err_AH_MONO_EN_TREC1998.mat')

fprintf('\nGrams\n');

[~, dp_grams_TREC1998, ~] = discriminativePower(ap_AH_MONO_EN_TREC1998(:, grams), p10_AH_MONO_EN_TREC1998(:, grams), ...
    rbp_AH_MONO_EN_TREC1998(:, grams), ndcg_AH_MONO_EN_TREC1998(:, grams), ...
    err_AH_MONO_EN_TREC1998(:, grams), 'Method', 'PairedBootstrapTest', 'Samples', samples);

dp_grams_TREC1998 = sortrows(dp_grams_TREC1998, -1);

fprintf('\nStem\n');

[~, dp_stem_TREC1998, ~] = discriminativePower(ap_AH_MONO_EN_TREC1998(:, stem), p10_AH_MONO_EN_TREC1998(:, stem), ...
    rbp_AH_MONO_EN_TREC1998(:, stem), ndcg_AH_MONO_EN_TREC1998(:, stem), ...
    err_AH_MONO_EN_TREC1998(:, stem), 'Method', 'PairedBootstrapTest', 'Samples', samples);


sersave('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/analysis/AH_MONO_EN_TREC1998/dp_AH_MONO_EN_TREC1998.mat', ...
    dp_grams_TREC1998, dp_stem_TREC1998);

dp_stem_TREC1998 = sortrows(dp_stem_TREC1998, -1);

clear ap_AH_MONO_EN_TREC1998 p10_AH_MONO_EN_TREC1998 rbp_AH_MONO_EN_TREC1998 ndcg_AH_MONO_EN_TREC1998 err_AH_MONO_EN_TREC1998;

serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1999/ap_AH_MONO_EN_TREC1999.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1999/p10_AH_MONO_EN_TREC1999.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1999/rbp_AH_MONO_EN_TREC1999.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1999/ndcg_AH_MONO_EN_TREC1999.mat')
serload('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/measure/AH_MONO_EN_TREC1999/err_AH_MONO_EN_TREC1999.mat')

fprintf('\nGrams\n');

[~, dp_grams_TREC1999, ~] = discriminativePower(ap_AH_MONO_EN_TREC1999(:, grams), p10_AH_MONO_EN_TREC1999(:, grams), ...
    rbp_AH_MONO_EN_TREC1999(:, grams), ndcg_AH_MONO_EN_TREC1999(:, grams), ...
    err_AH_MONO_EN_TREC1999(:, grams), 'Method', 'PairedBootstrapTest', 'Samples', samples);

dp_grams_TREC1999 = sortrows(dp_grams_TREC1999, -1);

fprintf('\nStem\n');

[~, dp_stem_TREC1999, ~] = discriminativePower(ap_AH_MONO_EN_TREC1999(:, stem), p10_AH_MONO_EN_TREC1999(:, stem), ...
    rbp_AH_MONO_EN_TREC1999(:, stem), ndcg_AH_MONO_EN_TREC1999(:, stem), ...
    err_AH_MONO_EN_TREC1999(:, stem), 'Method', 'PairedBootstrapTest', 'Samples', samples);


sersave('/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/analysis/AH_MONO_EN_TREC1999/dp_AH_MONO_EN_TREC1999.mat', ...
    dp_grams_TREC1999, dp_stem_TREC1999);

dp_stem_TREC1999 = sortrows(dp_stem_TREC1999, -1);

clear ap_AH_MONO_EN_TREC1999 p10_AH_MONO_EN_TREC1999 rbp_AH_MONO_EN_TREC1999 ndcg_AH_MONO_EN_TREC1999 err_AH_MONO_EN_TREC1999;