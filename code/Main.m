clear;
params.topic='drugdrug';

params.models='..\\model\\';
params.results='..\\results\\';
params.queryfile='test';

disp ('GenerateDrugDrugFeatureMatrix.pl...');
strcmd = sprintf('perl GenerateDrugDrugFeatureMatrix.pl %s',params.queryfile);
eval(strcmd);  
disp ('predicting drug-drug interactions...');
PredictMain(params);
disp ('GetPredictResults.pl...');
strcmd = sprintf('perl GetPredictResults.pl %s',params.queryfile);
eval(strcmd); 

disp('finished!');
