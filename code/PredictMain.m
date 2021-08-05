function PredictMain(params)    
    disp ('predicting...');
    Predict(params); 
    
%     disp ('GetPredictResults.pl...');
%     strcmd = sprintf('perl GetPredictResults.pl %s',params.queryfile);
%     eval(strcmd);
    disp ('finished!');
    
    function Predict(params)        
        modelfile=sprintf('%s%s.train.multi.labels.model',params.models,params.topic);              
        predictdatafile=sprintf('%s%s.feature.vector.txt',params.results,params.queryfile);         
        cmdstr=sprintf('predict.exe -b 1 %s %s %s.predict_labels',predictdatafile,modelfile,predictdatafile);             
        system(cmdstr);   
                
        outfile=sprintf('%s.predict_labels',predictdatafile);
        fid=fopen(outfile,'r');
        cycle=true;
        counter=0; 
        predictlabels=[];
        while cycle==true
            counter=counter+1;
            currentLine=fgets(fid);                
            if currentLine==-1%remove header of predict file
                break;
            end
            if counter>1
                t=str2num(currentLine); 
                if t(1)==1
                    predictlabels=[predictlabels;t(t(1)+1)];
                else
                    predictlabels=[predictlabels;-t(t(1)+1)];
                end
             end     
        end   
        fclose(fid);
                
        %output
        predict_values=[];
        predictinfofile=sprintf('%s%s.feature.vector.txt.predict.info',params.results,params.queryfile);
        predictinfo=load(predictinfofile);
        index=0;
        for j=1:size(predictinfo,1)
            t=predictinfo(j,:);  
            index=index+1;
            if t(2)==0 
                predict_values=[predict_values;0];
            else  
                predict_values=[predict_values;predictlabels(j)];
            end
         end               
         finalpredictdatafile=sprintf('%s%s.predict.final.decvalues',params.results,params.queryfile); 
         dlmwrite(finalpredictdatafile,predict_values,' ');   
            
        
    
            
          
        
        
        
        
        