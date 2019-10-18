library(ggplot2)
library(grid)
library(stringr)
library(reshape)
library(scales)
library(stringi)
library(plyr)
require(gdata)
library(doBy)

###################################Common Data Vectors############################
sentence_labels=c('173', '175', '177', '178', '179', '180', '181', '183', '184', '189', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '217','218', '219', '220', '221', '222','223','224','225','227', '228', '229', '230', '231', '232','233','234', '235', '236', '237','238', '239', '240', '241','242', '243','245','246','247', '248', '249', '250', '251', '252', '253', '254', '255', '257', '258', '262', '263', '264')

### common technique vector
techniques=c(
"wordpattern",
"lexrank",
"condinsight",
"simpleif")
#####################################################################################

#########################################Helper Functions############################
source('helper_functions.r')
#####################################################################################


#########################################Background Plots############################
source('background_analysis.r')
#####################################################################################


#################Number of ratings per sentence per technique#######################

rating_sentences <- read.csv('data/rating_per_sentence_per_technique.csv')

#Replace technique numbers with their names
rating_sentences <- chg_tech_to_string(rating_sentences)

ggplot(rating_sentences, aes(x=Technique, y=Count))+
geom_violin(width=0.3) +
geom_boxplot(width=0.1)+
ylim(0, 10)+
ylab("Num. of Ratings Per Sentence") +
theme_minimal() +
theme(axis.text=element_text(size=20), axis.title=element_text(size=20))


ggsave("figures/num_rating_per_tech.pdf", width=9, height=4.5, dpi=300)
#####################################################################################

###########################Number of ratings per thread##############################

rating_thread <- read.csv('data/rating_per_thread.csv')

rating_median <- median(rating_thread$Count)
rating_min <- min(rating_thread$Count)
rating_max <- max(rating_thread$Count)
rating_mode <- getmode(rating_thread$Count)

sink("../sections/survey_data.tex", append=TRUE)
cat(sprintf("\\pgfkeyssetvalue{rating_per_thread_min}{%.0f}\n",rating_min,sep=''))
cat(sprintf("\\pgfkeyssetvalue{rating_per_thread_max}{%.0f}\n",rating_max,sep=''))
cat(sprintf("\\pgfkeyssetvalue{rating_per_thread_median}{%.0f}\n",rating_median,sep=''))
cat(sprintf("\\pgfkeyssetvalue{rating_per_thread_mode}{%.0f}\n",rating_mode,sep=''))
sink()

ggplot(rating_thread, aes(x="", y=Count))+
geom_violin() +
geom_boxplot(width=0.1)+
ylab("Num. of Ratings Per Thread") +
xlab("") +
theme_classic()

ggsave("figures/rating_per_thread.pdf")
#####################################################################################

###################################Q8 Analysis (SR1)####################################

q8_data <- read.csv('data/q8.csv')

########Stacked Bar Chart (not currently used in paper)
#create_q8_stacked_chart(q8_data)
### End Stacked Bar Chart (not currently used in paper)

########Create violin plots for each sentence for each tech
plot_violin_per_tech(q8_data, "q8")
########End violin plots

########Overall violin plot for Q8

#To enable box plots, we'll change to 1 - 3, with 1 being not meaningful and 3 is what we want
q8_data <- replace_and_convert_q8_values(q8_data)
q8_data <- chg_tech_to_string(q8_data)

ggplot(q8_data, aes(x=Technique, y=Response))+
geom_violin() +
scale_y_continuous(limits=c(1,3))+
geom_boxplot(width=0.1)

ggsave("figures/q8_overall_bytech.pdf", width=9, height=4.5, dpi=300)
### End Overall violin for Q8
###################################END Q8 Analysis (SR1)####################################

###################################Q9 Analysis (SR2)####################################

q9_data <- read.csv('data/q9.csv')

########Stacked Bar Chart (not currently used in paper)
#create_stacked_bar_chart(q9_data, "q9")
### End Stacked Bar Chart (not currently used in paper)

########Create violin plots for each sentence for each tech
plot_violin_per_tech(q9_data, "q9")
########End violin plots

########Overall violin plot for Q9
q9_data <- replace_and_convert_likert_scale(q9_data)
q9_data <- chg_tech_to_string(q9_data)

ggplot(q9_data, aes(x=Technique, y=Response))+
geom_violin() +
geom_boxplot(width=0.1)

ggsave("figures/q9_overall_bytech.pdf", width=9, height=4.5, dpi=300)
########End Overall violin plot for Q9
##############################END Q9 Analysis (SR2)####################################



###################################Q10 Analysis (SR3)####################################

q10_data <- read.csv('data/q10.csv')

########Stacked Bar Chart (not currently used in paper)
#create_stacked_bar_chart(q10_data, "q10")
### End Stacked Bar Chart (not currently used in paper)

########Create violin plots for each sentence for each tech
plot_violin_per_tech(q10_data, "q10")
########End violin plots

########Overall violin plot for Q10
q10_data <- replace_and_convert_likert_scale(q10_data)
q10_data <- chg_tech_to_string(q10_data)

ggplot(q10_data, aes(x=Technique, y=Response))+
geom_violin() +
geom_boxplot(width=0.1)

ggsave("figures/q10_overall_bytech.pdf", width=9, height=4.5, dpi=300)
########End Overall violin plot for Q10
##############################END Q10 Analysis (SR3)####################################

################Combining overall plots for Q9 (SR2) and Q10(SR3)#######################

q9_data <- read.csv('data/q9.csv')
q9_data$Question <- rep("(SR2)",nrow(q9_data))

q10_data <- read.csv('data/q10.csv')
q10_data$Question <- rep("(SR3)",nrow(q10_data))


all_data <- rbind(q9_data, q10_data)

#Replace technique numbers with their names
all_data <- chg_tech_to_string(all_data)
#Replace levels by numbers
all_data <- replace_and_convert_likert_scale(all_data)

ggplot(all_data, aes(x=Technique, y=Response))+
geom_violin(aes(color=Question), position = position_dodge(0.9))+
geom_boxplot(aes(color=Question), width=0.1, position = position_dodge(0.9))+
scale_color_brewer(palette="Dark2")+ theme_minimal()

ggsave("figures/q9_q10_overall_bytech.pdf", width=9, height=4.5, dpi=300)

############END Combining overall plots for Q9 (SR2) and Q10(SR3)#######################

###########Combining overall plots for Q8 (SR1), Q9 (SR2) and Q10(SR3)####################

q8_data <- read.csv('data/q8.csv')
q8_data$Question <- rep("(SR1)",nrow(q8_data))
q8_data <- replace_and_convert_q8_values(q8_data)

q9_data <- read.csv('data/q9.csv')
q9_data$Question <- rep("(SR2)",nrow(q9_data))

q10_data <- read.csv('data/q10.csv')
q10_data$Question <- rep("(SR3)",nrow(q10_data))


all_data <- rbind(q9_data, q10_data)
all_data <- replace_and_convert_likert_scale(all_data)

all_data <- rbind(all_data, q8_data)

#Replace technique numbers with their names
all_data <- chg_tech_to_string(all_data)

#reorder techniques to match paper
all_data$Technique<- factor(all_data$Technique, levels = techniques)

ggplot(all_data, aes(x=Technique, y=Response))+
geom_violin(aes(color=Question), position = position_dodge(0.6),alpha=0.2)+
geom_boxplot(aes(color=Question), width=0.1, position = position_dodge(0.6),alpha=0.2)+
scale_fill_brewer(palette="BuPu") +
theme_minimal()+
theme(axis.text=element_text(size=20), axis.title=element_text(size=20),legend.position = "top")

ggsave("figures/allq_overall_bytech.pdf", width=9, height=4.5, dpi=300)

############END Combining overall plots for Q9 (SR2) and Q10(SR3)#######################

#######Combining ind sentence plots for Q8 (SR1), Q9 (SR2) and Q10(SR3)#################
q8_data <- read.csv('data/q8.csv')
q8_data$Question <- rep("(SR1)",nrow(q8_data))
q8_data <- replace_and_convert_q8_values(q8_data)

q9_data <- read.csv('data/q9.csv')
q9_data$Question <- rep("(SR2)",nrow(q9_data))

q10_data <- read.csv('data/q10.csv')
q10_data$Question <- rep("(SR3)",nrow(q10_data))

all_data <- rbind(q9_data, q10_data)
all_data <- replace_and_convert_likert_scale(all_data)

all_data <- rbind(all_data, q8_data)


plot_all_q_per_tech(all_data)

###############################Stats Tests#######################################
#compare distribution of each pair of techniques for each question

q8_data <- read.csv('data/q8.csv')
q9_data <- read.csv('data/q9.csv')
q10_data <- read.csv('data/q10.csv')

#Replace technique numbers with their names
#Replace levels by numbers
q8_data <- replace_and_convert_q8_values(q8_data)
q8_data <- chg_tech_to_string(q8_data)
q9_data <- chg_tech_to_string(q9_data)
q9_data <- replace_and_convert_likert_scale(q9_data)
q10_data <- chg_tech_to_string(q10_data)
q10_data <- replace_and_convert_likert_scale(q10_data)

compare_distributions(q8_data, "q8")
compare_distributions(q9_data, "q9")
compare_distributions(q10_data, "q10")

###########################End Stats Tests#######################################
sink("../sections/survey_data.tex", append=TRUE)
calc_recall_prec("q8")
calc_recall_prec("q9")
calc_recall_prec("q10")
sink()

