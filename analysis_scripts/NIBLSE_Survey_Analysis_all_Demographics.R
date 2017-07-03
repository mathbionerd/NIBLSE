## First make sure you have ggplot and Lock5Data
# install.packages("ggplot2")
# install.packages("Lock5Data")

library(ggplot2)
library(Lock5Data)
library(MASS)
library(RColorBrewer)

###
# YOU NEED TO EDIT THIS SECTION FOR THE CODE TO RUN
# Give the pathnames on your computer
###

# EDIT THE PATH TO WHERE THE SURVEY DATA IS: 
# path <- "/Users/melissa/Dropbox (Personal)/NIBLSE/Survey_Data/"
# path <- "/Users/mwilsons/Dropbox/NIBLSE/Survey_Data/"
path <- "/Users/melissa/Desktop/NIBLSE_analysis/"

# EVERYTHING ELSE SHOULD RUN SO LONG AS YOU HAVE NOT EDITED THE NAME OF THE SURVEY DATA

# This will automatincally make the path to the survey data in tab-delimited format
# If you have edited the name of the survey data file on your computer, you will need to edit it below.
survey <- paste(path,"NIBLSE_survey_data.txt", sep="")
# These will make a directory for printing plots
# Later in the program, it will generate additional directories in this one
# to help keep similar plots together.
plots_dir <- paste(path,"plots",sep="")
dir.create(plots_dir) 

# Read in the data (92x1258 - 1259 including the header; 1258 excluding the header)
survey_data <- read.table(file=survey,header=TRUE, sep="\t",fill = TRUE)

dim(survey_data)
nrow(survey_data)
ncol(survey_data)

### Mapping headers to questions - Header_mapping.tab

### Now for some analysis!

### First let's see the output of the questions about the 15 core competencies we asked aobut
### without being concered about breaking down by category

# Q13_1	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Understand the role of computation and data mining in hypothesis-driven processes within the life sciences?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_2	In your opinion, how important is it for undergraduates majoring in life sciences or closely rela...-Understand computational concepts used in bioinformatics, e.g., meaning of algorithm, bioinformatics file formats?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_3	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Know statistical concepts used in bioinformatics, e.g., E-value, z-scores, t-test?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_4	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . .  Know how to access genomic data, e.g., in NCBI nucleotide databases?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_5	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . .  Be able to use bioinformatics tools to analyze genomic data, e.g., BLASTN, genome browser?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_6	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Know how to access gene expression data, e.g., in UniGene, GEO, SRA?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_7	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Be able to use bioinformatics tools to analyze gene expression data, e.g., GeneSifter, David, ORF Finder?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_8	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Know how to access proteomic data, e.g., in NCBI protein databases?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_9	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Be able to use bioinformatics tools to examine protein structure and function, e.g., BLASTP, Cn3D, PyMol?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_10	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Know how to access metabolomic and systems biology data, e.g., in the Human Metabolome Database?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_11	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Be able to use bioinformatics tools to examine the flow of molecules within pathways/networks, e.g., Gene Ontology, KEGG?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_12	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Be able to use bioinformatics tools to examine metagenomics data, e.g., MEGA, MUSCLE?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_13	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Know how to write short computer programs as part of the scientific discovery process, e.g., write a  script to analyze sequence data?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_14	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Be able to use software packages to manipulate and analyze bioinformatics data, e.g., Geneious, Vector NTI Express, spreadsheets?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
# Q13_15	In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Operate in a variety of computational environments to manipulate and analyze bioinformatics data, e.g., Mac OS, Windows, web- or cloud-based, Unix/Linux command line?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion

# Q50	If there are bioinformatics competencies you feel are missing in the above, please describe them here.

# compute how many responses were given for each competency
count_Q <- cbind(length(na.omit(survey_data$Q13_1)), length(na.omit(survey_data$Q13_2)), length(na.omit(survey_data$Q13_3)), length(na.omit(survey_data$Q13_4)), length(na.omit(survey_data$Q13_5)), length(na.omit(survey_data$Q13_6)), length(na.omit(survey_data$Q13_7)), length(na.omit(survey_data$Q13_8)), length(na.omit(survey_data$Q13_9)), length(na.omit(survey_data$Q13_10)), length(na.omit(survey_data$Q13_11)), length(na.omit(survey_data$Q13_12)), length(na.omit(survey_data$Q13_13)), length(na.omit(survey_data$Q13_14)), length(na.omit(survey_data$Q13_15)))
colnames(count_Q) <- c("Q1","Q2","Q3","Q4","Q5","Q6","Q7","Q8","Q9","Q10","Q11","Q12","Q13","Q14","Q15")
t(count_Q) 


### Here are the classifications, by column
# Q14	Sex	Female	Male	Rather not say
# Q15	Race	American Indian or Alaska Native	Asian	Black or African American	Native Hawaiian or Other Pacific Islander	White	Rather not say
# Q16	Ethnicity	Hispanic or Latino	Not Hispanic or Latino	Rather not say
# Q17	Highest earned degree. If "other," please explain.	B.S. (or equivalent)	M.S. (or equivalent)	Professional degree (e.g., M.D.)	Ph.D. (or equivalent)
# Q17_TEXT	Highest earned degree. If "other," please explain.- TEXT
# Q18	Year of highest earned degree.	2016	2015	2014	2013	2012	2011	2010	2009	2008	2007	2006	2005	2004	2003	2002	2001	2000	1999	1998	1997	1996	1995	1994	1993	1992	1991	1990	1989	1988	1987	1986	1985	1984	1983	1982	1981	1980	1979	1978	1977	1976	1975	1974	1973	1972	1971	1970	1969	1968	1967	1966	1965	1964	1963	1962	1961	1960	1959	1958	1957	1956	1955	1954	1953	1952	1951	1950	Rather not say
# Q3	Which of the following best describes your level of bioinformatics training?	No training/experience	No formal training (self-taught)	Short workshop/bootcamp	Some undergraduate courses	Undergraduate certificate	Undergraduate degree	Post-graduate certificate	Graduate course	Graduate degree
# Q20	ABOUT YOUR INSTITUTION
# Q21	What is the Carnegie classification of your institution?	Associate's College	Baccalaureate College	Master's (Small, Medium, Large)	Doctoral University (High, Higher, Highest Research Activity)	Don't know
# Q22	Is your institution classified as minority-serving?	Yes	No	Don't know
# Q23	What is the total number of students (undergraduate and graduate) at your institution?	< 5,000 students	5,000 - 15,000 students	> 15,000 students	Don't know
# Q24	What is the total number of undergraduate students at your institution?	< 5,000 students	5,000 - 15,000 students	> 15,000 students	Don't know
# Q25	What is the name of your department/unit (e.g., Department of Biology, Biochemistry Department, School of Interdisciplinary Informatics)?
# Q26	How many full-time faculty are in your department/unit? (Do not include part-time faculty or adjuncts.)	< 10	10 - 20	21 - 30	31 - 40	41 - 50	> 50	Don't know
# Q27	How many undergraduate students are in your department/unit (all majors)?	< 50	51 - 100	101 - 500	501 - 2000	> 2000	Don't know
                                                                                                         
# First we want to only consider categorical variables that were answered (e.g., exclude "Prefer not to answer")
# And, let's see how much data we have by different demographic categories

#Q14	Gender (Asked as sex) 
# 1: Female
# 2: Male	
# 3: Rather not say
gender <- survey_data$Q14
# gender[gender==3] <- NA

num_gender <- with(survey_data, table(gender,Q13_1))
rownames(num_gender) <- c("Female","Male","Unreported")
rep_gender <- rowSums(num_gender,dims=1)

#Q15	Race	
# 1: American Indian or Alaska Native	
# 2: Asian	
# 3: Black or African American	
# 4: Native Hawaiian or Other Pacific Islander	
# 5: White	
# 6: Rather not say
race <- survey_data$Q15
#race[race==6] <- NA

num_race <- with(survey_data, table(race,Q13_1))
rownames(num_race) <- c("AmIn_Alaska","Asian","Black_AfAm","NatHa_Pac","White")
rep_race <- rowSums(num_race,dims=1)

## Not very many POC, so limit to just POC and white
race <- survey_data$Q15
race[race==1] <- 1
race[race==2] <- 1
race[race==3] <- 1
race[race==4] <- 1
race[race==5] <- 2
#race[race==6] <- NA

num_race <- with(survey_data, table(race,Q13_1))
rownames(num_race) <- c("POC","White","Unreported")
rep_race <- rowSums(num_race,dims=1)


#Q16	Ethnicity	
# 1: Hispanic or Latino	 
# 2: Not Hispanic or Latino	
# 3: Rather not say
ethnicity <- survey_data$Q16
# ethnicity[ethnicity==3] <- NA

num_ethnicity <- with(survey_data, table(ethnicity,Q13_1))
rownames(num_ethnicity) <- c("His & Lat","Non","Unreported")
rep_ethnicity <- rowSums(num_ethnicity,dims=1)

# Q17	Highest earned degree. If "other," please explain.
# 1: B.S. (or equivalent)
# 2: M.S. (or equivalent)
# 3: Professional degree (e.g., M.D.)
# 4: Ph.D. (or equivalent)
highest_degree <- survey_data$Q17
# highest_degree[highest_degree==5] <- NA

num_highest_degree <- with(survey_data, table(highest_degree,Q13_1))
rownames(num_highest_degree) <- c("BS","MS","Prof","PhD","Unreported")
rep_highest_degree <- rowSums(num_highest_degree,dims=1)

## Only 7 with BS and 7 with Prof, so only analyze MS and PhD
# highest_degree <- survey_data$Q17
# highest_degree[highest_degree==1] <- NA
# highest_degree[highest_degree==3] <- NA
# highest_degree[highest_degree==5] <- NA

# num_highest_degree <- with(survey_data, table(highest_degree,Q13_1))
# rownames(num_highest_degree) <- c("MS","PhD")
# rep_highest_degree <- rowSums(num_highest_degree,dims=1)


# Q18	Year of highest earned degree.	2016	2015	2014	2013	2012	2011	2010	2009	2008	2007	2006	2005	2004	2003	2002	2001	2000	1999	1998	1997	1996	1995	1994	1993	1992	1991	1990	1989	1988	1987	1986	1985	1984	1983	1982	1981	1980	1979	1978	1977	1976	1975	1974	1973	1972	1971	1970	1969	1968	1967	1966	1965	1964	1963	1962	1961	1960	1959	1958	1957	1956	1955	1954	1953	1952	1951	1950	Rather not say
##### 
# Reassign Year of PhD
##
survey_data$Q18[survey_data$Q18==1] <- 2010
survey_data$Q18[survey_data$Q18==2] <- 2010
survey_data$Q18[survey_data$Q18==3] <- 2010
survey_data$Q18[survey_data$Q18==4] <- 2010
survey_data$Q18[survey_data$Q18==5] <- 2010
survey_data$Q18[survey_data$Q18==6] <- 2010
survey_data$Q18[survey_data$Q18==7] <- 2010

survey_data$Q18[survey_data$Q18==8] <- 2000
survey_data$Q18[survey_data$Q18==9] <- 2000
survey_data$Q18[survey_data$Q18==10] <- 2000
survey_data$Q18[survey_data$Q18==11] <- 2000
survey_data$Q18[survey_data$Q18==12] <- 2000
survey_data$Q18[survey_data$Q18==13] <- 2000
survey_data$Q18[survey_data$Q18==14] <- 2000
survey_data$Q18[survey_data$Q18==15] <- 2000
survey_data$Q18[survey_data$Q18==16] <- 2000
survey_data$Q18[survey_data$Q18==17] <- 2000

survey_data$Q18[survey_data$Q18==18] <- 1990
survey_data$Q18[survey_data$Q18==19] <- 1990
survey_data$Q18[survey_data$Q18==20] <- 1990
survey_data$Q18[survey_data$Q18==21] <- 1990
survey_data$Q18[survey_data$Q18==22] <- 1990
survey_data$Q18[survey_data$Q18==23] <- 1990
survey_data$Q18[survey_data$Q18==24] <- 1990
survey_data$Q18[survey_data$Q18==25] <- 1990
survey_data$Q18[survey_data$Q18==26] <- 1990
survey_data$Q18[survey_data$Q18==27] <- 1990

survey_data$Q18[survey_data$Q18==28] <- 1980
survey_data$Q18[survey_data$Q18==29] <- 1980
survey_data$Q18[survey_data$Q18==30] <- 1980
survey_data$Q18[survey_data$Q18==31] <- 1980
survey_data$Q18[survey_data$Q18==32] <- 1980
survey_data$Q18[survey_data$Q18==33] <- 1980
survey_data$Q18[survey_data$Q18==34] <- 1980
survey_data$Q18[survey_data$Q18==35] <- 1980
survey_data$Q18[survey_data$Q18==36] <- 1980
survey_data$Q18[survey_data$Q18==37] <- 1980

survey_data$Q18[survey_data$Q18==38] <- 1970
survey_data$Q18[survey_data$Q18==39] <- 1970
survey_data$Q18[survey_data$Q18==40] <- 1970
survey_data$Q18[survey_data$Q18==41] <- 1970
survey_data$Q18[survey_data$Q18==42] <- 1970
survey_data$Q18[survey_data$Q18==43] <- 1970
survey_data$Q18[survey_data$Q18==44] <- 1970
survey_data$Q18[survey_data$Q18==45] <- 1970
survey_data$Q18[survey_data$Q18==46] <- 1970
survey_data$Q18[survey_data$Q18==47] <- 1970

survey_data$Q18[survey_data$Q18==48] <- 1960
survey_data$Q18[survey_data$Q18==49] <- 1960
survey_data$Q18[survey_data$Q18==50] <- 1960
survey_data$Q18[survey_data$Q18==51] <- 1960
survey_data$Q18[survey_data$Q18==52] <- 1960
survey_data$Q18[survey_data$Q18==53] <- 1960
survey_data$Q18[survey_data$Q18==54] <- 1960
survey_data$Q18[survey_data$Q18==55] <- 1960
survey_data$Q18[survey_data$Q18==56] <- 1960
survey_data$Q18[survey_data$Q18==57] <- 1960

survey_data$Q18[survey_data$Q18==58] <- 1950
survey_data$Q18[survey_data$Q18==59] <- 1950
survey_data$Q18[survey_data$Q18==60] <- 1950
survey_data$Q18[survey_data$Q18==61] <- 1950
survey_data$Q18[survey_data$Q18==62] <- 1950
survey_data$Q18[survey_data$Q18==63] <- 1950
survey_data$Q18[survey_data$Q18==64] <- 1950
survey_data$Q18[survey_data$Q18==65] <- 1950
survey_data$Q18[survey_data$Q18==66] <- 1950
survey_data$Q18[survey_data$Q18==67] <- 1950

# earned <- survey_data$Q18
# earned[earned==68] <- NA

# num_earned <- with(survey_data, table(earned,Q13_1))
# rownames(num_earned) <- c("1950","1960","1970","1980","1990","2000","2010")
# rep_earned <- rowSums(num_earned,dims=1)

# And we see that rep_earned shows very few participants in the young years, so we will merge 1950, 1960 and 1970
survey_data$Q18[survey_data$Q18==1950] <- 1970
survey_data$Q18[survey_data$Q18==1960] <- 1970

earned <- survey_data$Q18
earned[earned==68] <- 6000

num_earned <- with(survey_data, table(earned,Q13_1))
#rownames(num_earned) <- c("1970","1980","1990","2000","2010","Unreported")
rownames(num_earned) <- c("Before 1980","1980-1989","1990-1999","2000-2009","After 2009","Unreported")
rep_earned <- rowSums(num_earned,dims=1)


# Q3	Which of the following best describes your level of bioinformatics training?
# 1: No training/experience
# 2: No formal training (self-taught)
# 3: Short workshop/bootcamp	
# 4: Some undergraduate courses
# 5: Undergraduate certificate -----> No one had this, so delete
# 6: Undergraduate degree
# 7: Post-graduate certificate
# 8: Graduate course
# 9: Graduate degree


## Not many, so merge: 
# 4: Some undergraduate courses
# 5: Undergraduate certificate -----> No one had this, so delete
# 6: Undergraduate degree ----------> 5 people had this
# 7: Post-graduate certificate -----> 12 people had this
bx_training <- survey_data$Q3
bx_training[bx_training==5] <- 4
bx_training[bx_training==6] <- 4
bx_training[bx_training==7] <- 4
#bx_training[bx_training==10] <- NA

num_bx_training <- with(survey_data, table(bx_training,Q13_1))
rownames(num_bx_training) <- c("None","Self","Short","Undergrad","Grad class","Grad deg")
rep_bx_training <- rowSums(num_bx_training,dims=1)


# Q21	What is the Carnegie classification of your institution?	
# 1: Associate's College	
# 2: Baccalaureate College	
# 3: Master's (Small, Medium, Large)	
# 4: Doctoral University (High, Higher, Highest Research Activity)	
# 5: Don't know
carnegie <- survey_data$Q21
# carnegie[carnegie==5] <- NA

num_carnegie <- with(survey_data, table(carnegie,Q13_1))
rownames(num_carnegie) <- c("Assc","BS","MS","PhD","Unknown")
rep_carnegie <- rowSums(num_carnegie,dims=1)

# Q22	Is your institution classified as minority-serving?	
# 1: Yes	
# 2: No	
# 3: Don't know
minority_serving <- survey_data$Q22
# minority_serving[minority_serving==3] <- NA

num_minority_serving <- with(survey_data, table(minority_serving,Q13_1))
rownames(num_minority_serving) <- c("Minority","Non","Unknown")
rep_minority_serving <- rowSums(num_minority_serving,dims=1)


# Q23	What is the total number of students (undergraduate and graduate) at your institution?	
# 1: < 5,000 students
# 2: 5,000 - 15,000 students
# 3: > 15,000 students	
# 4: Don't know
total_students <- survey_data$Q23
# total_students[total_students==4] <- NA

num_total_students <- with(survey_data, table(total_students,Q13_1))
rownames(num_total_students) <- c("<5k","5-15k",">15k","Unknown")
rep_total_students <- rowSums(num_total_students,dims=1)


#Q24	What is the total number of undergraduate students at your institution?
# 1: < 5,000 students
# 2: 5,000 - 15,000 students
# 3: > 15,000 students	
# 4: Don't know
total_undergrads <- survey_data$Q24
# total_undergrads[total_undergrads==4] <- NA

num_total_undergrads <- with(survey_data, table(total_undergrads,Q13_1))
rownames(num_total_undergrads) <- c("<5k","5-15k",">15k","Unknown")
rep_total_undergrads <- rowSums(num_total_undergrads,dims=1)


#Q26	How many full-time faculty are in your department/unit? (Do not include part-time faculty or adjuncts.)
# 1: < 10	
# 2: 10 - 20	
# 3: 21 - 30	
# 4: 31 - 40	
# 5: 41 - 50	
# 6: > 50	
# 7: Don't know

# faculty <- survey_data$Q26
# faculty[faculty==7] <- NA
# num_faculty <- with(survey_data, table(faculty,Q13_1))
# rownames(num_faculty) <- c("10","10-20","21-30","31-40","41-50","50")
# rep_faculty <- rowSums(num_faculty,dims=1)

## There aren't many in the 41-50 and >50 group, so merge
faculty <- survey_data$Q26
faculty[faculty==5] <- 4
faculty[faculty==6] <- 4
# faculty[faculty==7] <- NA

num_faculty <- with(survey_data, table(faculty,Q13_1))
rownames(num_faculty) <- c("<10","10-20","21-30",">31","Unknown")
rep_faculty <- rowSums(num_faculty,dims=1)


#Q27	How many undergraduate students are in your department/unit (all majors)?	
# 1: < 50	
# 2: 51 - 100	
# 3: 101 - 500	
# 4: 501 - 2000	
# 5: > 2000	
# 6: Don't know
undergrad_majors <- survey_data$Q27
undergrad_majors[undergrad_majors==1] <- 2
undergrad_majors[undergrad_majors==5] <- 4
#undergrad_majors[undergrad_majors==6] <- NA

num_undergrad_majors <- with(survey_data, table(undergrad_majors,Q13_1))
#rownames(num_undergrad_majors) <- c("50","51-100","101-500","501-2000",">2000")
rownames(num_undergrad_majors) <- c("<101","101-500",">501","Unknown")
rep_undergrad_majors <- rowSums(num_undergrad_majors,dims=1)

library(RColorBrewer)
numdata <- length()
blues <- brewer.pal(numdata, "Blues")

# Now, plot the representation by demographics, calculated above
pdf(paste(plots_dir,'/Figure1_Demographics_all.pdf', sep=""))
par(mfrow=c(3,4))
numdata <- length(rep_gender)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_gender, col=blues,ylim=c(0,1000),las=3,main="Gender")
numdata <- length(rep_race)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_race, col=blues,ylim=c(0,1000),las=3,main="Race")
numdata <- length(rep_ethnicity)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_ethnicity, col=blues,ylim=c(0,1000),las=3,main="Ethnicity")
numdata <- length(rep_minority_serving)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_minority_serving, col=blues,ylim=c(0,600),las=3,main="Minority Serving")
numdata <- length(rep_highest_degree)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_highest_degree, col=blues,ylim=c(0,1000),las=3,main="Highest Degree")
numdata <- length(rep_earned)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_earned, col=blues,ylim=c(0,600),las=3,main="Year Earned")
numdata <- length(rep_bx_training)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_bx_training, col=blues,ylim=c(0,600),las=3,main="Training")
numdata <- length(rep_carnegie)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_carnegie, col=blues,ylim=c(0,600),las=3,main="Carnegie")
numdata <- length(rep_total_students)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_total_students, col=blues,ylim=c(0,600),las=3,main="Total Students")
numdata <- length(rep_total_undergrads)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_total_undergrads, col=blues,ylim=c(0,600),las=3,main="Total Undergrads")
numdata <- length(rep_undergrad_majors)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_undergrad_majors, col=blues,ylim=c(0,600),las=3,main="Undergrad Majors")
numdata <- length(rep_faculty)
blues <- brewer.pal(numdata, "Blues")
barplot(rep_faculty, col=blues,ylim=c(0,600),las=3,main="Faculty")
dev.off()

rep_gender
rep_race
rep_ethnicity
rep_highest_degree
rep_earned
rep_bx_training
rep_carnegie
rep_minority_serving
rep_total_students
rep_total_undergrads
rep_undergrad_majors


