## Survey Data & Analysis

This folder contains all the data related to our survey as well as the scripts we use to analyze it. Note that this study has received ethics clearance, and the folder also contains a copy of the information document participants could read.

* `SurveyDBDump/` contains a dump of the database that recorded all the responses during the survey. You can import this database locally by running `mysql -u <username> -p <password> db < FinalSurveyDump.sql`. Note that the sentences table contains the information about the sentences used in the survey. Since some sentences were detected by multiple techniques, we used numbers to denote the combinations such that each sentence is stored (and displayed to participants) only once. The file `techniques.txt` describes those numbers.

* `SurveyAnalysis/` folder contains the scripts for analyzing the data:
	* This folder contains python and R scripts for producing plots and analyzing the data. The `run_all.sh` script will first run the python script that reads the data from the database (assuming you already created it from the dump above) and extracts certain information from it that it will save as csv files in the `data/` folder. It then runs the R scripts that analyze this data and creates the plots in the `figures` folder. Note that we did not end up using all figures in the paper.
	* `data/` folder contains: 
		* `ids.txt` is a file containing the participant ids that we consider in our results. To consider a participant's results, they must satisfy the criteria we describe in the paper and pass our quality gate thread. This quality-gate filtering happens in the analysis scripts.
		* this folder will also be the target location for extracting data from the database during the survey results analysis. We currently include the results we have in that folder (which would get overridden when you run things but you should get the same files aanyways)	

* `QualitativeAnalysis/` contains a zip file of our open-coding for the various survey questions used to answer RQ2 and RQ3.

* `Snapshots/` contains snapshots of the survey
