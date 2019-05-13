#Source https://www.tutorialspoint.com/r/r_mean_median_mode.htm
getmode <- function(v) {
    uniqv <- unique(v)
    uniqv[which.max(tabulate(match(v, uniqv)))]
}

calc_recall_prec <- function(question, highlimit, lowlimit){
    data <- read.csv(paste("data/", question, ".csv", sep=""))
    
    if(question == "q8"){
        data <- replace_and_convert_q8_values(data)
        limits <- c(1,2,3)
    }else{
        data <- replace_and_convert_likert_scale(data)
        limits <- c(1,2,3,4,5)
    }
    
    #to avoid a wrong total num of sentences, remove duplicates caused
    #by expanding sentences detected by the same technique
    #column 1 is sentence id, column 4 is user id
    non_dup_data <- data[!duplicated(data[c(1,4)]),]
    non_dup_stats <- summaryBy( Response ~ SentenceID+SentenceText, data= non_dup_data, FUN = list(median))
    
    full_stats <- summaryBy(Response ~ SentenceID+Technique+SentenceText, data=data, FUN=list(median))
    
    for (highlimit in limits) {
        
        question_data_pos <- data.frame("SentenceID"=character(), "Response.median"=double(), "Technique"=double(), "SentenceText" = character(), stringsAsFactors=FALSE)
        question_data_neg <- data.frame("SentenceID"=character(), "Response.median"=double(), "Technique"=double(), "SentenceText" = character(), stringsAsFactors=FALSE)
        
        lowlimit <- highlimit - 1
        ground_truth <- non_dup_stats[which(non_dup_stats$Response.median >= highlimit),]
        ground_truth_size <- nrow(ground_truth)
        cat(sprintf("\\pgfkeyssetvalue{ground_truth_size_%s_limit_%d}{%.0f}\n", question,highlimit, ground_truth_size,sep=''))
        cat(sprintf("\\pgfkeyssetvalue{neg_ground_truth_size_%s_limit_%d}{%.0f}\n", question,highlimit, nrow(non_dup_stats[which(non_dup_stats$Response.median <= lowlimit),]),sep=''))
        
        for (technique in c(1,2,3,6)){
            temp_data <- data[which(data$Technique == technique),]
            stats <- summaryBy( Response ~ SentenceID+SentenceText, data= temp_data, FUN = list(median))
            total_by_tech <- nrow(stats)
            
            avg_rating <- mean(stats$Response.median)
            
            pos_values <- stats[which(stats$Response.median >= highlimit),]
            neg_values <- stats[which(stats$Response.median <= lowlimit),]
            
        cat(sprintf("\\pgfkeyssetvalue{total_pos_tech%d_%s_threshold_%d}{%.0f}\n", technique, question,highlimit, nrow(pos_values),'',sep=''))
        cat(sprintf("\\pgfkeyssetvalue{total_neg_tech%d_%s_threshold_%d}{%.0f}\n", technique, question,lowlimit, nrow(neg_values),'',sep=''))
        
        cat(sprintf("\\pgfkeyssetvalue{mean_sentence_rating_tech%d_%s}{%.0f}\n", technique, question,avg_rating,'',sep=''))
        
            intersection <- merge(ground_truth,stats)
            precision = round(nrow(intersection)/total_by_tech, digits=2)
            recall = round(nrow(intersection)/ground_truth_size, digits=2)
            
            cat(sprintf("\\pgfkeyssetvalue{precision_tech%d_%s_threshold_%d}{%.2f}\n", technique, question,highlimit, precision,sep=''))
            cat(sprintf("\\pgfkeyssetvalue{recall_tech%d_%s_threshold_%d}{%.2f}\n", technique, question,highlimit,recall,sep=''))
            
            
            pos_values$Technique <- rep(technique,nrow(pos_values))
            neg_values$Technique <- rep(technique,nrow(neg_values))
            #stats$Technique <- rep(technique, nrow(stats))
            
            
            question_data_pos <- rbind(question_data_pos, pos_values, stringsAsFactors = FALSE)
            question_data_neg <- rbind(question_data_neg, neg_values, stringsAsFactors = FALSE)
        }
        
        write.csv(question_data_pos, paste("data/",question, "_posvalues_threshold_", highlimit,".csv", sep=""))
        write.csv(question_data_neg, paste("data/",question, "_negvalues_threshold_",highlimit, ".csv", sep=""))
    }
    
    write.csv(full_stats, paste("data/",question, "_allvals.csv", sep=""))
}


compare_distributions <- function(data, question){
    
    #get all unique pairs
    tech_pairs <- expand.grid(tech1=techniques, tech2=techniques)
    tech_pairs <- tech_pairs[!duplicated(t(apply(tech_pairs, 1, sort))),]
    
    wilcox_data <- data.frame("Pair"=character(), "pvalue"=double(), "EffSize"=double(), "Diff"=double(), stringsAsFactors=FALSE)
    
    two.sided.p.values = c()
    two.sided.p.values.adjusted = c()
    count <- 1
    
    for (i in 1:dim(tech_pairs)[1]){
        tech1_name = tech_pairs[i ,][1]$tech1
        tech2_name = tech_pairs[i ,][2]$tech2
        #only do this for pairs of different technqiues
        if (tech1_name != tech2_name){
            tech1_data <- data[data$Technique == tech1_name,]
            head(tech1_data)
            tech2_data <- data[data$Technique == tech2_name,]
            head(tech2_data)
            test_result = wilcox.test(tech1_data$Response, tech2_data$Response,paired = FALSE, conf.int=TRUE)
            r = rFromWilcox(test_result, nrow(tech1_data) * 2)
            two.sided.p.values = c(two.sided.p.values, test_result$p.value)
            two.sided.p.values.adjusted = p.adjust(two.sided.p.values, "BH")
            test_summary <- list(paste(tech1_name, tech2_name,sep="-"), round(two.sided.p.values.adjusted[count], 3), round(r, 3), round(test_result$estimate, 3))
            names(test_summary) <- c("Pair", "pvalue", "EffSize", "Diff")
            wilcox_data <- rbind(wilcox_data, test_summary, stringsAsFactors = FALSE)
            count <- count + 1
        }
    }
    
    different_techs = wilcox_data[wilcox_data$pvalue < 0.05,]
    write.csv(wilcox_data, paste("data/",question, "_all_stats.csv", sep=""))
    write.csv(different_techs, paste("data/",question, "_diff_tech_stats.csv", sep=""))
}

plot_violin <- function(data, ylabel, filename){
    
    ggplot(data, aes(x=SentenceID, y=Response))+
    geom_violin() +
    geom_boxplot(width=0.1)+
    theme(axis.text.x=element_text(angle=45, size=12))+
    scale_x_discrete(limits=sentence_labels)+
    ylab(ylabel)
    
    ggsave(filename, dpi=300, width=22, height=3)
}

plot_all_q_per_tech <- function(data){
    #palette <- c("#999999", "#0072B2", "#D55E00")
    palette <- c("#f0f0f0", "#bdbdbd", "#636363")
    for (i in c(1,2,3,6)){
        temp_data <- data[which(data$Technique == i),]
        ggplot(temp_data, aes(x=SentenceID, y=Response))+
        #geom_violin(aes(color=Question), position = position_dodge(0.5))+
        #   stat_summary(fun.y=median, geom="point", size=2, color="red") +
            geom_boxplot(aes(color=Question, fill=Question), position = position_dodge(0.9), alpha=0.7, color = "black") +
            scale_fill_manual(values=palette) +
            theme_minimal() +
            theme(legend.position="top", legend.title=element_blank(),
                legend.text = element_text(size=14,
            face="bold"),
                axis.text.x=element_text(angle=45, size=12),
                axis.title=element_text(size=14,face="bold"),
                legend.key.size = unit(1, "cm")) +
            ylab("Rating")
            
            
            
        ggsave(paste("figures/all_q_ratings_tech", i, ".pdf", sep=""), dpi=300, width=22, height=3)
    }
}

#Plot boxplots for each technique
plot_violin_per_tech <- function(data, question){
    if (question == "q8"){
        data <- replace_and_convert_q8_values(data)
    }else{
        data <- replace_and_convert_likert_scale(data)
    }

    for (i in c(1,2,3,6)){
       temp_data <- data[which(data$Technique == i),]
       plot_violin(temp_data,"Rating", paste("figures/", question, "_ratings_tech", i, ".pdf", sep=""))
    }
}

#converts sentencce ids to string to allow discrete x-axis
#converts response to numeric to allow boxplots
convert_data_for_plots <- function(data){
    data$SentenceID <- as.character(data$SentenceID)
    data$Response<-as.numeric(as.character(data$Response))
    
    return (data)
}

replace_and_convert_q8_values <- function(q8_data){
    #To enable box plots, we'll change to 0 - 2, with 0 being not meaningful and 2 is what we want
    levels(q8_data$Response)[match("The sentence does not make sense to me.",levels(q8_data$Response))] <- 1
    
    levels(q8_data$Response)[match("The sentence is meaningful, but does not provide any important/useful information to correctly accomplish the task in question",levels(q8_data$Response))] <- 2
    
    levels(q8_data$Response)[match("The sentence is meaningful and provides important/useful information needed to correctly accomplish the task in question",levels(q8_data$Response))] <- 3
    
    q8_data <- convert_data_for_plots(q8_data)
    return (q8_data)
}

replace_and_convert_likert_scale <- function(input_data){
    levels(input_data$Response)[match("Strongly disagree",levels(input_data$Response))] <- 1
    levels(input_data$Response)[match("Disagree",levels(input_data$Response))] <- 2
    levels(input_data$Response)[match("Neither agree or disagree",levels(input_data$Response))] <- 3
    levels(input_data$Response)[match("Agree",levels(input_data$Response))] <- 4
    levels(input_data$Response)[match("Strongly agree",levels(input_data$Response))] <- 5
    
    input_data <- convert_data_for_plots(input_data)
    
    return (input_data)
}


create_q8_stacked_chart <- function(q8_data){
    q8_data <- chg_tech_to_string(q8_data) #Replace technique numbers with their names
    
    #Replace longer answers with shorter ones for figure
    levels(q8_data$Response)[match("The sentence is meaningful and provides important/useful information needed to correctly accomplish the task in question",levels(q8_data$Response))] <- "Useful"
    levels(q8_data$Response)[match("The sentence does not make sense to me.",levels(q8_data$Response))] <- "Not meaningful"
    levels(q8_data$Response)[match("The sentence is meaningful, but does not provide any important/useful information to correctly accomplish the task in question",levels(q8_data$Response))] <- "Not Useful"
    
    # creates table with technique, response, Freq
    dat <- data.frame(with(q8_data, table(Technique,Response)))
    
    #Plotting labels in midpoint= https://stackoverflow.com/questions/6644997/showing-data-values-on-stacked-bar-chart-in-ggplot2
    ggplot(dat, aes(x = Technique, y=Freq, fill = Response, label=Freq)) +
    geom_bar(stat = "identity") +
    #geom_bar(width=0.4,aes(y = (..count..)/37)) +
    theme_classic() +
    theme(legend.position="top",
    legend.direction="horizontal",
    legend.title=element_blank(),
    legend.text = element_text(size=8),
    axis.title.x=element_blank(),
    axis.text.x=element_text(size=10),
    panel.grid.minor = element_line(colour = "grey", linetype="dashed",size = 0.25)) +
    scale_y_continuous(expand = c(0,0)) +
    scale_x_discrete(labels = c("simpleif" = str_wrap("simpleif",width=10),
    "ConditionalInsight" = str_wrap("ConditionalInsight",width=10),
    "wordpattern" = str_wrap("wordpattern",width=10),
    "lexrank" = str_wrap("lexrank",width=10))) +
    geom_text(size = 3, position = position_stack(vjust = 0.5)) +
    scale_fill_grey(start = 0.2, end = .8) +
    ylab("Evaluation of usefulness of sentences per technique")
    ggsave("figures/sentence_value.pdf", width=9, height=4.5, dpi=300)

}

create_stacked_bar_chart <- function(input_data, question){
    #Replace technique numbers with their names
    input_data$Technique <- mapvalues(input_data$Technique, from = c(1,2,3,6), to=c("simpleif", "condinsight", "wordpattern", "lexrank"))
    
    levels=c("Strongly disagree", "Disagree",
    "Neither agree or disagree", "Agree","Strongly Agree")
    
    dat <- data.frame(with(input_data, table(Technique,Response)))
    
    dat$Response <- factor(dat$Response, levels = c("Strongly disagree", "Disagree",
    "Neither agree or disagree", "Agree","Strongly agree"), ordered = TRUE)
    
    ggplot(dat, aes(x = Technique, fill = Response, y=Freq, label=Freq)) +
    geom_bar(stat = "identity") +
    theme_classic() +
    theme(legend.position="top",
    legend.direction="horizontal",
    legend.title=element_blank(),
    legend.text = element_text(size=8),
    axis.title.x=element_blank(),
    axis.text.x=element_text(size=10),
    panel.grid.minor = element_line(colour = "grey", linetype="dashed",size = 0.25)) +
    scale_y_continuous(expand = c(0,0)) +
    scale_x_discrete(labels = c("simpleif" = str_wrap("simpleif",width=10),
    "ConditionalInsight" = str_wrap("ConditionalInsight",width=10),
    "wordpattern" = str_wrap("wordpattern",width=10),
    "lexrank" = str_wrap("lexrank",width=10))) +
    geom_text(size = 3, position = position_stack(vjust = 0.5)) +
    ylab("Number of Responses")
    ggsave(paste("figures/", question, "_stacked.pdf", sep=","), width=9, height=4.5, dpi=300)

}

# https://rdrr.io/github/Frostarella/DSUR.noof/man/rFromWilcox.html#heading-5
#Author: Andy Field
rFromWilcox<-function(wilcoxModel,N)
{
    z <- qnorm(wilcoxModel$p.value/2)
    r <- abs(z)/sqrt(N)
    return (r)
    #cat(wilcoxModel$data.name,"Effect Size, r=",r)
}

chg_tech_to_string <- function(data){
    data$Technique <- mapvalues(data$Technique, from = c(1,2,3,6), to=c("simpleif", "condinsight", "wordpattern", "lexrank"))
    
    return (data)
}

group_midpoints <- function(g) {
    cumsums = c(0, cumsum(g$Freq))
    diffs = diff(cumsums)
    pos = head(cumsums, -1) + (0.5 * diffs)
    return(data.frame(Technique=g$Technique, pos=pos, Freq=g$Freq))
}

chi_squared_multiple_test <- function(vector_one, vector_two, fileName){
    combs <- expand.grid(vector_one,vector_two)
    combs <- data.frame(lapply(combs, as.character), stringsAsFactors=FALSE)
    results = data.frame( Row=rep(0, dim(combs)[1]),
    Column=rep(0,dim(combs)[1]),
    Chi.Square=rep(0,dim(combs)[1]),
    df=rep(0,dim(combs)[1]),
    p.value=rep(0,dim(combs)[1]))
    
    for (i in 1:dim(combs)[1]){
        test <- chisq.test( data[[combs[[1]][i]]], data[[combs[[2]][i]]])
        
        results[i, ] = c(combs[[1]][i]
        , combs[[2]][i]
        , round(test$statistic,7)
        ,  test$parameter
        ,  round(test$p.value, 7)
        )
    }
    
    results$p.value <- as.numeric(results$p.value)
    adjusted<-p.adjust(results$p.value,method="bonferroni") #adjust using conservative bonferroni method (Holm's used by Robillard)
    results$p.value<-adjusted
    
    for (i in 1: dim(results)[1]){
        if (results[i,]$p.value < 0.05){
            cat(sprintf("\\pgfkeyssetvalue{%s_%s_p_value}{%0.4f}\n",
            combs[[1]][i],
            combs[[2]][i],
            results[i,]$p.value,
            '',
            sep='')
            )
        }
    }
    write.csv(results, fileName)
}

plot_bar_chart <- function(plot, fileName,denom,width=11.5, height=2.25, dpi=300){
    plot <-    plot +
    theme_classic() +
    geom_bar(width=0.4, fill="#808080",position=position_dodge(0.9)) +
    theme(axis.title.x=element_blank(),
    axis.title.y=element_blank(),
    axis.ticks.y=element_blank(),
    axis.text.y=element_blank(),
    axis.line.y=element_blank(),
    axis.text.x=element_text(size=26)) +
    scale_y_continuous(expand = c(0,0), limits=c(0,num_participants)) +
    #ylim(0,num_participants) +
    scale_x_discrete(drop=FALSE, labels = function(x) str_wrap(x, width = 10))
    plot + geom_text(aes(y = (..count..),
    label = paste(round((..count..)/denom*100),sep="", "%")),
    stat="count",colour="black",size=8,vjust=-0.5)
    
    ggsave(fileName, width=width, height=height, dpi=dpi)
}

