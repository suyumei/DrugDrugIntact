1. Prerequisite for the software
   -matlab
   -activeperl 5.24.1

2. Supported platforms 
   -MS Windows 32-bit/64-bit

3. Subdirectories
   -data: query file;
   -code: source code (matlab and perl script);
   -model: feature index, drug-target file and model file;   
   -results: prediction results;  

4. Workflows:
   (1) test data: prepare the query file (drug-drug pairs using drug ids from DrugBank) and place the files into the subdirectory 'data'.       
   (2) Run script Main.m in the subdirectory 'code', and the results can be found in the subdirectory 'results' .   

5. Demo 
   -Run codes as specified in the workflows given the examples in the file test.

6. Applicability
   -Users only need to replace the content of file test in the subdirectory 'data' for new applications.