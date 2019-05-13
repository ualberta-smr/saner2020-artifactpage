# Identifying Navigation Cues in Stack Overflow Answers

This is the online artifact page/repository for the ASE '19 submission titled "Identifying Navigation Cues in Stack Overflow Answers".

## Repo Overview

* `SOAnalysisCode`: contains all the code we used to extract sentences using the four evaluated techniques: wordpatterns, lexrank, simpleif, and condinsights. 
* `SurveyAnalysisCode`: contains a snapshot of all the data collected from our survey, which ended in May 2019, and the scripts we use to extract relevant data from the survey database and analyze it to produce the figures in the paper.

## Extracting Navigation Cues Using the Four Techniques

All the instructions in this section are based on running from the `SOAnalysisCode` directory.

### Prerequisites

* This code uses `python3`. Make sure you have python > 3.0 installed
* The list of python packages used can be found in `requirements.txt`. You can individually install them or do `pip install -r requirements.txt`

### How to Run

1. Create an StackExchange application key to be able to use the higher query limit at [https://stackapps.com/apps/oauth/register](StackExchange). In `SOAnalysisCode/src/main.py`, update the line `SITE = StackAPI('stackoverflow', key='ADD YOUR KEY HERE')` with your key.

2. Run Stanford CoreNLP server running. This can be done by downloading the Stanford Core NLP [lib files](https://stanfordnlp.github.io/CoreNLP/download.html) first. The one we downloaded was `stanford-corenlp-full-2018-02-27.zip`. After unzipping and changing to the unzipped folder, run:
`java -mx4g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port 9000 -timeout 15000` 

3. Run `python3 src/main.py > output`. This will extract sentences by simpleif, wordpatterns, an condinsight. Format of output file is described below. Note that the patterns we use for the wordpatterns technique are available in the `patterns.txt` file. Also, note that this will produce a `stats.txt` file that contains statistics about number of paragraphs, sentences etc processed

4. Getting lexrank sentences:

	* Put the ids of your target threads in `lexrank/question_ids.txt`  
	* To extract processed paragraphs (no html tags, links removed, and lemmatized words in the sentences) to be used with the lexrank approach, run `python3 src/lexrank.py`. This script reads the target question ids from the `question_ids.txt` file and then outputs the paragraph text of each thread from there in a `lexrank` directory. Each thread has a corresponding text file.
	* For each thread, simply concatenate the text in that file, and follow the instructions in the lexrank implementaiton we use at [https://github.com/linanqiu/lexrank](https://github.com/linanqiu/lexrank). 

**IMPORTANT:** The SO query in our current code is hard-coded to the scope of our evaluation (json threads with score > 0 and asked between March 29, 2018 to March 29, 2019. If you want to run this for different data, make sure to update the query in `src/main.py`. The following line is what you are looking for `questions = SITE.fetch('questions', fromdate=datetime(2018,3,29), todate=datetime(2019,3,29), min=0, sort='votes', tagged='json', filter='!-*jbN-o8P3E5')`

### Interpreting the Output format

The output file will contain a `|`-separated output that matches the following header order 
`IsInsightFulIf|QuestionID|AnswerID|ParagraphIndex|SentenceIndex|Sentence|IsTruePositive|Condition|TagsInCondition|NFReqs|Nouns|Interrogative?|IsFirstPerson?|IsUnsurePhrase?|HasGrammarDep?`
You can change the delimter used in `src/main.py`.

Note that the `IsInsightFulIf` column will be `False` if the sentence is a simpleif sentence, will be `True` if the sentence is a condinsight sentence, and will be `WordPatternBaseline` if the sentence is a wordpattern sentence. 

For the wordpattern technique, only the first 6 columns make sense. The remaining columns simply show information relevant to conditional sentences to help analyze the output.

Please note that the `IsTruePositive` only makes sense in the context of benchmarking below. Ignore it when running normally.

### Tests

The `src/test.py` file has some unit tests for the individual heuristics to make sure they work correctly.


### Benchmarks 

We have a benchmark of 118 manually labelled sentences that we used to test various heuristics while developing the condinsight technique. The data for the benchmark is in the `benchmark` folder. `json_question_ids.txt` contains the Thread/Question ids of the threads involved in the benchmark and `benchmark_json_questions.csv` contains the ground truth.

To run the benchmark, run `python3 src/run_benchmark.py`. The combination of heuristics is documented in the file. This calculates and outputs the precision and recall of each heuristic combination against the benchmark.
The sentences detected by each combination of heuristics will be saved in the `benchmark/results` folder.

**IMPORTANT:** Take these numbers with a grain of salt, since the benchmark is not based on looking at *all* sentences in the threads. Thus, the relative performance of heuristics is what counts here.

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



