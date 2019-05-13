#!/bin/bash

#run data extraction
cd scripts

#note this will output a bunch of pgfkeys that saves the values of certain variables and that we use in our latex paper
python3 extract_db_data.py

cd ..

#run R script
Rscript survey_analysis.r
