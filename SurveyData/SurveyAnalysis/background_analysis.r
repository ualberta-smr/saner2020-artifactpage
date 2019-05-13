####q1_data
#Is SW development part of your daily job?
q1_data <- read.csv('data/q1.csv')
num_participants <- nrow(q1_data)

c <- ggplot(q1_data, aes(factor(q1_data$Response, levels=c("Yes", "No"), ordered=TRUE)))

plot_bar_chart(c, "figures/swdev.pdf", num_participants)

####q2_data
#What is your job title?
q2_data <- read.csv('data/q2.csv')
num_participants <- nrow(q2_data)

#manually aggregate occupations
## managerial roles
levels(q2_data$Response)[match("manager",levels(q2_data$Response))] <- "Mangerial"
levels(q2_data$Response)[match("Director",levels(q2_data$Response))] <- "Mangerial"
levels(q2_data$Response)[match("Project Manager",levels(q2_data$Response))] <- "Mangerial"
levels(q2_data$Response)[match("Tech Lead",levels(q2_data$Response))] <- "Mangerial"
levels(q2_data$Response)[match("project manager",levels(q2_data$Response))] <- "Mangerial"
levels(q2_data$Response)[match("Chief Product Officer",levels(q2_data$Response))] <- "Mangerial"
levels(q2_data$Response)[match("Manager",levels(q2_data$Response))] <- "Mangerial"


## development roles
levels(q2_data$Response)[match("software developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Software Developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Software developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Mobile Developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("programmer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Front-End Web Developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("automation dev",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Full Stack Developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("python developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Web Application Developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Application Developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Sr.  Software Developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Web developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Web Developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("web developer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("programer",levels(q2_data$Response))] <- "Developer"
levels(q2_data$Response)[match("Senior Software Engineer",levels(q2_data$Response))] <- "Developer"

## Tech analyst
levels(q2_data$Response)[match("Product owner analyst",levels(q2_data$Response))] <- "Analyst"
levels(q2_data$Response)[match("security analyst",levels(q2_data$Response))] <- "Analyst"
levels(q2_data$Response)[match("Computer Systems Analyst",levels(q2_data$Response))] <- "Analyst"
levels(q2_data$Response)[match("Quality analyzt",levels(q2_data$Response))] <- "Analyst"
levels(q2_data$Response)[match("Analyst",levels(q2_data$Response))] <- "Analyst"
levels(q2_data$Response)[match("Software analyst",levels(q2_data$Response))] <- "Analyst"

## software enginer
levels(q2_data$Response)[match("software engineer",levels(q2_data$Response))] <- "Software Engineer"
levels(q2_data$Response)[match("Software Engineer",levels(q2_data$Response))] <- "Software Engineer"
levels(q2_data$Response)[match("Senior Software Engineer",levels(q2_data$Response))] <- "Software Engineer"
levels(q2_data$Response)[match("Senior Software engineer",levels(q2_data$Response))] <- "Software Engineer"
levels(q2_data$Response)[match("Senior software engineer",levels(q2_data$Response))] <- "Software Engineer"
levels(q2_data$Response)[match("Lead software engineer",levels(q2_data$Response))] <- "Software Engineer"
levels(q2_data$Response)[match("Software engineer",levels(q2_data$Response))] <- "Software Engineer"
levels(q2_data$Response)[match("Applications Engineer",levels(q2_data$Response))] <- "Software Engineer"

## tech/it support roles
levels(q2_data$Response)[match("IT Support ",levels(q2_data$Response))] <- "IT Support"
levels(q2_data$Response)[match("Tech support",levels(q2_data$Response))] <- "IT Support"
levels(q2_data$Response)[match("Tech Support",levels(q2_data$Response))] <- "IT Support"
levels(q2_data$Response)[match("Network and System Administrator",levels(q2_data$Response))] <- "IT Support"
levels(q2_data$Response)[match("Tech Support",levels(q2_data$Response))] <- "IT Support"
levels(q2_data$Response)[match("IT support",levels(q2_data$Response))] <- "IT Support"
levels(q2_data$Response)[match("Lead Computer Network Engineer",levels(q2_data$Response))] <- "IT Support"
levels(q2_data$Response)[match("Lab Tech",levels(q2_data$Response))] <- "IT Support"
levels(q2_data$Response)[match("tech",levels(q2_data$Response))] <- "IT Support"


levels(q2_data$Response)[match("admin assistant",levels(q2_data$Response))] <- "Other"
levels(q2_data$Response)[match("QA/Designer",levels(q2_data$Response))] <- "Other"
levels(q2_data$Response)[match("Production Planner",levels(q2_data$Response))] <- "Other"
levels(q2_data$Response)[match("Functional Bug Tester",levels(q2_data$Response))] <- "Other"

# end aggregate occupations


c <- ggplot(q2_data, aes(factor(q2_data$Response, levels=c("Mangerial", "Developer", "Software Engineer", "IT Support", "Analyst", "Other"), ordered=TRUE)))

plot_bar_chart(c, "figures/jobtitle.pdf", num_participants)

####q3_data
#For how many years have you been developing software?
q3_data <- read.csv('data/q3.csv')
num_participants <- nrow(q3_data)

## divide years into buckets

#create new column
q3_data$year_cat <- rep(NA, nrow(q3_data))
q3_data[q3_data$Response <= 1,][,"year_cat"] <- "<=1"
q3_data[(q3_data$Response >1 & q3_data$Response <=3) ,][,"year_cat"] <- "1-3"
q3_data[(q3_data$Response >3 & q3_data$Response <=5) ,][,"year_cat"] <- "3-5"
q3_data[(q3_data$Response > 5 & q3_data$Response <=10) ,][,"year_cat"] <- "5-10"
q3_data[(q3_data$Response > 10 & q3_data$Response <=20) ,][,"year_cat"] <- "10-20"
q3_data[q3_data$Response >20,][,"year_cat"] <- "20+"


c <- ggplot(q2_data, aes(factor(q3_data$year_cat,
levels=c("<=1", "1-3", "3-5", "5-10", "10-20", "20+"), ordered=TRUE)))

plot_bar_chart(c, "figures/dev_years.pdf", num_participants)
#ggsave("../figures/dev_years.pdf", width=11.5, height=2.25, dpi=300)

####q4_data
#What is your area of SW Development?
q4_data <- read.csv('data/q4.csv')
num_participants <- nrow(q4_data)


#aggregate areas
#So far:"na","Web Development","JAVA","none","web"
levels(q4_data$Response)[match("na",levels(q4_data$Response))] <- "N/A"
levels(q4_data$Response)[match("none",levels(q4_data$Response))] <- "N/A"
levels(q4_data$Response)[match("Web Development",levels(q4_data$Response))] <- "web"
levels(q4_data$Response)[match("web",levels(q4_data$Response))] <- "web"
levels(q4_data$Response)[match("JAVA",levels(q4_data$Response))] <- "Java"

c <- ggplot(q4_data, aes(factor(q4_data$Response, levels=c("N/A", "web", "Java"), ordered=TRUE)))

plot_bar_chart(c, "figures/sw-area.pdf", num_participants)


####q5_data
#How would you rate your json expertise?
q5_data <- read.csv('data/q5.csv')
num_participants <- nrow(q5_data)

levels(q5_data$Response)[match("No experience at all using json",levels(q5_data$Response))] <- "No Experience"

c <- ggplot(q5_data, aes(factor(q5_data$Response, levels=c("No Experience", "Beginner", "Intermediate", "Expert"), ordered=TRUE)))

plot_bar_chart(c, "figures/json_exp.pdf", num_participants)


####q6_data
#Have you used StackOverflow to search for information before?
q6_data <- read.csv('data/q6.csv')
num_participants <- nrow(q6_data)

c <- ggplot(q6_data, aes(factor(q6_data$Response, levels=c("Yes", "No"), ordered=TRUE)))

plot_bar_chart(c, "figures/so_use.pdf", num_participants)


####q7_data
#Have you used StackOverflow to search for information before?
q7_data <- read.csv('data/q7.csv')
num_participants <- nrow(q7_data)

c <- ggplot(q7_data, aes(factor(q7_data$Response, levels=c("Yes", "No"), ordered=TRUE)))

plot_bar_chart(c, "figures/so_contr.pdf", num_participants)


