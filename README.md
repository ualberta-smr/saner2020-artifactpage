# Investigating Contextual Cues in Stack Overflow Answers

This is the online artifact page/repository for the SANER '20 submission titled "Investigating Contextual Cues in Stack Overflow Answers".

## Repo Overview

* `SOAnalysisCode/`: contains all the code we used to extract sentences using the four evaluated techniques: wordpatterns, lexrank, simpleif, and condinsights. The folder contains a ReadMe file on how to run the code. 
* `SurveyAnalysisCode/`: contains a snapshot of all the data collected from our survey, which ended in May 2019, and the scripts we use to extract relevant data from the survey database and analyze it to produce the figures in the paper. The folder contains a ReadMe file that describes its contents.






## Extra Notes

* If you want to see the sentences that received a median scoring greater than a given threshold (i.e., see the ground truth for that sentence), you will find various csv files in the `data` folder above that contain this information. For example, for question 10 (which is SR3 in the paper since questions were simply numbered in order in our DB), and threshold 4, you would check `q10_posvalues_threshold_4.csv`



