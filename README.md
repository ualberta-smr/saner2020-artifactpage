# Essential Sentences for Navigating Stack Overflow Answers

This is the online artifact page for the SANER '20 paper "Essential Sentences for Navigating Stack Overflow Answers" by [Sarah Nadi](https://www.sarahnadi.org) and [Christoph Treude](http://ctreude.ca/). Please contact Sarah Nadi if you have any questions. If you use any of the data or code in this artifact page, you can cite its DOI [https://doi.org/10.6084/m9.figshare.10005515](https://doi.org/10.6084/m9.figshare.10005515).

## Repo Overview

* `StackOverflowNavCues/`: contains all the code we used to extract sentences using the four evaluated techniques: wordpatterns, lexrank, simpleif, and condinsights. The folder contains a ReadMe file on how to run the code. Note that this is a git submodule pointing to this repo [https://github.com/ualberta-smr/StackOverflowNavCues](https://github.com/ualberta-smr/StackOverflowNavCues). When cloning this artifact repo, make sure to use `git clone --recurse-submodules`. It should point to the `saner2020` tag of that repo.
* `Data/`: contains the raw data from running the above code on `json` Stack Overflow threads between March 29, 2018 to March 29, 2019.  This folder also contains the statistics about the selected sentences for evaluation. The folder contains a ReadMe describing the files.
* `Survey/`: contains the database dump from our survey, scripts to analyze the data in the database, as well as our qualititative analysis (card sorting) data.





