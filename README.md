# Investigating Contextual Cues in Stack Overflow Answers

This is the online artifact page/repository for the SANER '20 submission titled "Investigating Contextual Cues in Stack Overflow Answers".

## Repo Overview

* `SOAnalysisCode/`: contains all the code we used to extract sentences using the four evaluated techniques: wordpatterns, lexrank, simpleif, and condinsights. The folder contains a ReadMe file on how to run the code. 
* `SurveyAnalysisCode/`: contains a snapshot of all the data collected from our survey, which ended in May 2019, and the scripts we use to extract relevant data from the survey database and analyze it to produce the figures in the paper. The folder contains a ReadMe file that describes its contents.



## Survey Data

* `SurveyDBDump/` contains a dump of the database that recorded all the responses during the survey. You can import this database locally by running `mysql -u <username> -p <password> db < FinalSurveyDump.sql`. Note that the sentences table contains the information about the sentences used in the DB. Since some sentences were detected by multiple techniques, we used numbers to denote the combinations such that each sentece is stored (and displayed to participants) only once. The file `techniques.txt` describes those numbers.
* `SurveyAnalysis/` folder contains the scripts for analyzing the data:
	* This folder contains python and R scripts for producing plots and analyzing the data. The `run_all.sh` script will first run the python script that read sdata from the database (assuming you already created it from the dump above) and extracts certain information from it that it will save as csv files in the `data/` folder. It then runs the R scripts that analyze this data and create the plots in the `figures` folder. Note that we did not end up using all figures in the paper.
	* `data/` folder contains: 
		* `ids.txt` is a file containing the participant ids that we consider in our results. This is basically the ids of participants that we paid (they satisfied our criteria as in the paper), whether they passed our quality gate thread or not. This quality-gate filtering happens in the analysis scripts.
		* this folder will also be the target location for extracting data from the database during the survey results analysis. We currently include the results we have in that folder (which would get overridden when you run things and you should get the same files aanyways)	
* `lexrank-results/` contains the lexrank results for the final selected 20 threads.
* `QualitativeAnalysis/` contains a zip file of our open-coding for the various survey questions used to answer RQ2 and RQ3.


## Extra Notes

* If you want to see the sentences that received a median scoring greater than a given threshold (i.e., see the ground truth for that sentence), you will find various csv files in the `data` folder above that contain this information. For example, for question 10 (which is SR3 in the paper since questions were simply numbered in order in our DB), and threshold 4, you would check `q10_posvalues_threshold_4.csv`



