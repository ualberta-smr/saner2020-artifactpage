#!/bin/bash

#run data extraction
cd scripts

python3 extract_db_data.py > ../../sections/survey_data.tex

cd ..

#run R script
Rscript survey_analysis.r
