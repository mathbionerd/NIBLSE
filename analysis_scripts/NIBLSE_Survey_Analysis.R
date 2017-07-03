## First make sure you have ggplot and Lock5Data
# install.packages("ggplot2")
# install.packages("Lock5Data")

library(ggplot2)
library(Lock5Data)
library(MASS)

###
# YOU NEED TO EDIT THIS SECTION FOR THE CODE TO RUN
# Give the pathnames on your computer
###

# EDIT THE PATH TO WHERE THE SURVEY DATA IS: 
path <- "/Users/melissa/Desktop/NIBLSE_analysis/" #For Example

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

### First let's see the output of the questions about the 15 skills we asked aobut
### without being concered about breaking down by category

# Q13_1  In your opinion, how important is it for undergraduates majoring in life sciences or closely related discplines to. . . Understand the role of computation and data mining in hypothesis-driven processes within the life sciences?	Not at all important	Slightly important	Moderately important	Very important	Extremely important	No opionion
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

# compute how many responses were given for each skill
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
gender[gender==3] <- NA

num_gender <- with(survey_data, table(gender,Q13_1))
rownames(num_gender) <- c("Female","Male")
rep_gender <- rowSums(num_gender,dims=1)

#Q15	Race	
# 1: American Indian or Alaska Native	
# 2: Asian	
# 3: Black or African American	
# 4: Native Hawaiian or Other Pacific Islander	
# 5: White	
# 6: Rather not say
race <- survey_data$Q15
race[race==6] <- NA

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
race[race==6] <- NA

num_race <- with(survey_data, table(race,Q13_1))
rownames(num_race) <- c("POC","White")
rep_race <- rowSums(num_race,dims=1)


#Q16	Ethnicity	
# 1: Hispanic or Latino	 
# 2: Not Hispanic or Latino	
# 3: Rather not say
ethnicity <- survey_data$Q16
ethnicity[ethnicity==3] <- NA

num_ethnicity <- with(survey_data, table(ethnicity,Q13_1))
rownames(num_ethnicity) <- c("His_Lat","Non")
rep_ethnicity <- rowSums(num_ethnicity,dims=1)

# Q17	Highest earned degree. If "other," please explain.
# 1: B.S. (or equivalent)
# 2: M.S. (or equivalent)
# 3: Professional degree (e.g., M.D.)
# 4: Ph.D. (or equivalent)
highest_degree <- survey_data$Q17
highest_degree[highest_degree==5] <- NA

num_highest_degree <- with(survey_data, table(highest_degree,Q13_1))
rownames(num_highest_degree) <- c("BS","MS","Prof","PhD")
rep_highest_degree <- rowSums(num_highest_degree,dims=1)

## Only 7 with BS and 7 with Prof, so only analyze MS and PhD
highest_degree <- survey_data$Q17
highest_degree[highest_degree==1] <- NA
highest_degree[highest_degree==3] <- NA
highest_degree[highest_degree==5] <- NA

num_highest_degree <- with(survey_data, table(highest_degree,Q13_1))
rownames(num_highest_degree) <- c("MS","PhD")
rep_highest_degree <- rowSums(num_highest_degree,dims=1)


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
earned[earned==68] <- NA

num_earned <- with(survey_data, table(earned,Q13_1))
# rownames(num_earned) <- c("1970","1980","1990","2000","2010")
rownames(num_earned) <- c("Before 1980","1980-1989","1990-1999","2000-2009","After 2009")
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
# 6: Undergraduate degree
# 7: Post-graduate certificate
bx_training <- survey_data$Q3
bx_training[bx_training==6] <- 4
bx_training[bx_training==7] <- 4
bx_training[bx_training==10] <- NA

num_bx_training <- with(survey_data, table(bx_training,Q13_1))
rownames(num_bx_training) <- c("None","No_form","Short","Under","Grad class","Grad deg")
rep_bx_training <- rowSums(num_bx_training,dims=1)


# Q21	What is the Carnegie classification of your institution?	
# 1: Associate's College	
# 2: Baccalaureate College	
# 3: Master's (Small, Medium, Large)	
# 4: Doctoral University (High, Higher, Highest Research Activity)	
# 5: Don't know
carnegie <- survey_data$Q21
carnegie[carnegie==5] <- NA

num_carnegie <- with(survey_data, table(carnegie,Q13_1))
rownames(num_carnegie) <- c("Assc","BS","MS","PhD")
rep_carnegie <- rowSums(num_carnegie,dims=1)

# Q22	Is your institution classified as minority-serving?	
# 1: Yes	
# 2: No	
# 3: Don't know
minority_serving <- survey_data$Q22
minority_serving[minority_serving==3] <- NA

num_minority_serving <- with(survey_data, table(minority_serving,Q13_1))
rownames(num_minority_serving) <- c("Minority","Non")
rep_minority_serving <- rowSums(num_minority_serving,dims=1)


# Q23	What is the total number of students (undergraduate and graduate) at your institution?	
# 1: < 5,000 students
# 2: 5,000 - 15,000 students
# 3: > 15,000 students	
# 4: Don't know
total_students <- survey_data$Q23
total_students[total_students==4] <- NA

num_total_students <- with(survey_data, table(total_students,Q13_1))
rownames(num_total_students) <- c("<5k","5-15k",">15k")
rep_total_students <- rowSums(num_total_students,dims=1)


#Q24	What is the total number of undergraduate students at your institution?
# 1: < 5,000 students
# 2: 5,000 - 15,000 students
# 3: > 15,000 students	
# 4: Don't know
total_undergrads <- survey_data$Q24
total_undergrads[total_undergrads==4] <- NA

num_total_undergrads <- with(survey_data, table(total_undergrads,Q13_1))
rownames(num_total_undergrads) <- c("<5k","5-15k",">15k")
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
faculty[faculty==7] <- NA

num_faculty <- with(survey_data, table(faculty,Q13_1))
rownames(num_faculty) <- c("<10","10-20","21-30",">31")
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
undergrad_majors[undergrad_majors==6] <- NA

num_undergrad_majors <- with(survey_data, table(undergrad_majors,Q13_1))
#rownames(num_undergrad_majors) <- c("50","51-100","101-500","501-2000",">2000")
rownames(num_undergrad_majors) <- c("<101","101-500",">500")
rep_undergrad_majors <- rowSums(num_undergrad_majors,dims=1)



# You can also print out the number of samples in each of the 
# demographic groups collected above, here just to the screen: 
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

# Calculate sum of people who responded within any given demographic category
# This number does not include people who declined to respond to that category

sum(rep_gender)
sum(rep_race)
sum(rep_ethnicity)
sum(rep_highest_degree)
sum(rep_earned)
sum(rep_bx_training)
sum(rep_carnegie)
sum(rep_minority_serving)
sum(rep_total_students)
sum(rep_total_undergrads)
sum(rep_undergrad_majors)


# Second we want to exclude from our analysis rankings of 6 (which as "NA", and will otherwise artificially inflate means & medians)
Q1 <- survey_data$Q13_1
Q1[Q1==6] <- NA
Q2 <- survey_data$Q13_2
Q2[Q2==6] <- NA
Q3 <- survey_data$Q13_3
Q3[Q3==6] <- NA
Q4 <- survey_data$Q13_4
Q4[Q4==6] <- NA
Q5 <- survey_data$Q13_5
Q5[Q5==6] <- NA
Q6 <- survey_data$Q13_6
Q6[Q6==6] <- NA
Q7 <- survey_data$Q13_7
Q7[Q7==6] <- NA
Q8 <- survey_data$Q13_8
Q8[Q8==6] <- NA
Q9 <- survey_data$Q13_9
Q9[Q9==6] <- NA
Q10 <- survey_data$Q13_10
Q10[Q10==6] <- NA
Q11 <- survey_data$Q13_11
Q11[Q11==6] <- NA
Q12 <- survey_data$Q13_12
Q12[Q12==6] <- NA
Q13 <- survey_data$Q13_13
Q13[Q13==6] <- NA
Q14 <- survey_data$Q13_14
Q14[Q14==6] <- NA
Q15 <- survey_data$Q13_15
Q15[Q15==6] <- NA


# Q_by_gender <- cbind(summary(table(gender,Q1)),summary(table(gender,Q2)),summary(table(gender,Q3)),summary(table(gender,Q4)),summary(table(gender,Q5)),summary(table(gender,Q6)),summary(table(gender,Q7)),summary(table(gender,Q8)),summary(table(gender,Q9)),summary(table(gender,Q10)),summary(table(gender,Q11)),summary(table(gender,Q12)),summary(table(gender,Q13)),summary(table(gender,Q14)),summary(table(gender,Q15)))
# colnames(Q_by_gender) <- c("Q1","Q2","Q3","Q4","Q5","Q6","Q7","Q8","Q9","Q10","Q11","Q12","Q13","Q14","Q15")

genderQ1 <- t(table(gender,Q1))
genderQ2 <- t(table(gender,Q2))
genderQ3 <- t(table(gender,Q3))
genderQ4 <- t(table(gender,Q4))
genderQ5 <- t(table(gender,Q5))
genderQ6 <- t(table(gender,Q6))
genderQ7 <- t(table(gender,Q7))
genderQ8 <- t(table(gender,Q8))
genderQ9 <- t(table(gender,Q9))
genderQ10 <- t(table(gender,Q10))
genderQ11 <- t(table(gender,Q11))
genderQ12 <- t(table(gender,Q12))
genderQ13 <- t(table(gender,Q13))
genderQ14 <- t(table(gender,Q14))
genderQ15 <- t(table(gender,Q15))

colnames(genderQ1) <- c("female","male")
colnames(genderQ2) <- c("female","male")
colnames(genderQ3) <- c("female","male")
colnames(genderQ4) <- c("female","male")
colnames(genderQ5) <- c("female","male")
colnames(genderQ6) <- c("female","male")
colnames(genderQ7) <- c("female","male")
colnames(genderQ8) <- c("female","male")
colnames(genderQ9) <- c("female","male")
colnames(genderQ10) <- c("female","male")
colnames(genderQ11) <- c("female","male")
colnames(genderQ12) <- c("female","male")
colnames(genderQ13) <- c("female","male")
colnames(genderQ14) <- c("female","male")
colnames(genderQ15) <- c("female","male")

# make a new directory for the sets of plots by demographics
plots_by_demographic <- paste(plots_dir,"/by_demographic", sep="")
dir.create(plots_by_demographic) 

pdf(paste(plots_by_demographic,'/Skills_by_gender.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(genderQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,275))
barplot(genderQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,275))
barplot(genderQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,275))
barplot(genderQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,275))
barplot(genderQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,275))
barplot(genderQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,275))
barplot(genderQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,275))
barplot(genderQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,275))
barplot(genderQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,275))
barplot(genderQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,275))
barplot(genderQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,275))
barplot(genderQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,275))
barplot(genderQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,275))
barplot(genderQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,275))
barplot(genderQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,275))
dev.off()


###
# plots by race

raceQ1 <- t(table(race,Q1))
raceQ2 <- t(table(race,Q2))
raceQ3 <- t(table(race,Q3))
raceQ4 <- t(table(race,Q4))
raceQ5 <- t(table(race,Q5))
raceQ6 <- t(table(race,Q6))
raceQ7 <- t(table(race,Q7))
raceQ8 <- t(table(race,Q8))
raceQ9 <- t(table(race,Q9))
raceQ10 <- t(table(race,Q10))
raceQ11 <- t(table(race,Q11))
raceQ12 <- t(table(race,Q12))
raceQ13 <- t(table(race,Q13))
raceQ14 <- t(table(race,Q14))
raceQ15 <- t(table(race,Q15))

colnames(raceQ1) <- c("POC","White")
colnames(raceQ2) <- c("POC","White")
colnames(raceQ3) <- c("POC","White")
colnames(raceQ4) <- c("POC","White")
colnames(raceQ5) <- c("POC","White")
colnames(raceQ6) <- c("POC","White")
colnames(raceQ7) <- c("POC","White")
colnames(raceQ8) <- c("POC","White")
colnames(raceQ9) <- c("POC","White")
colnames(raceQ10) <- c("POC","White")
colnames(raceQ11) <- c("POC","White")
colnames(raceQ12) <- c("POC","White")
colnames(raceQ13) <- c("POC","White")
colnames(raceQ14) <- c("POC","White")
colnames(raceQ15) <- c("POC","White")

pdf(paste(plots_by_demographic,'/Skills_by_race.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(raceQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,350))
barplot(raceQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,350))
barplot(raceQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,350))
barplot(raceQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,350))
barplot(raceQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,350))
barplot(raceQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,350))
barplot(raceQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,350))
barplot(raceQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,350))
barplot(raceQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,350))
barplot(raceQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,350))
barplot(raceQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,350))
barplot(raceQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,350))
barplot(raceQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,350))
barplot(raceQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,350))
barplot(raceQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,350))
dev.off()


###
# plots by ethnicity

ethnicityQ1 <- t(table(ethnicity,Q1))
ethnicityQ2 <- t(table(ethnicity,Q2))
ethnicityQ3 <- t(table(ethnicity,Q3))
ethnicityQ4 <- t(table(ethnicity,Q4))
ethnicityQ5 <- t(table(ethnicity,Q5))
ethnicityQ6 <- t(table(ethnicity,Q6))
ethnicityQ7 <- t(table(ethnicity,Q7))
ethnicityQ8 <- t(table(ethnicity,Q8))
ethnicityQ9 <- t(table(ethnicity,Q9))
ethnicityQ10 <- t(table(ethnicity,Q10))
ethnicityQ11 <- t(table(ethnicity,Q11))
ethnicityQ12 <- t(table(ethnicity,Q12))
ethnicityQ13 <- t(table(ethnicity,Q13))
ethnicityQ14 <- t(table(ethnicity,Q14))
ethnicityQ15 <- t(table(ethnicity,Q15))

colnames(ethnicityQ1) <- c("His/Lat", "Non")
colnames(ethnicityQ2) <- c("His/Lat", "Non")
colnames(ethnicityQ3) <- c("His/Lat", "Non")
colnames(ethnicityQ4) <- c("His/Lat", "Non")
colnames(ethnicityQ5) <- c("His/Lat", "Non")
colnames(ethnicityQ6) <- c("His/Lat", "Non")
colnames(ethnicityQ7) <- c("His/Lat", "Non")
colnames(ethnicityQ8) <- c("His/Lat", "Non")
colnames(ethnicityQ9) <- c("His/Lat", "Non")
colnames(ethnicityQ10) <- c("His/Lat", "Non")
colnames(ethnicityQ11) <- c("His/Lat", "Non")
colnames(ethnicityQ12) <- c("His/Lat", "Non")
colnames(ethnicityQ13) <- c("His/Lat", "Non")
colnames(ethnicityQ14) <- c("His/Lat", "Non")
colnames(ethnicityQ15) <- c("His/Lat", "Non")

pdf(paste(plots_by_demographic,'/Skills_by_ethnicity.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(ethnicityQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,375))
barplot(ethnicityQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,375))
barplot(ethnicityQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,375))
barplot(ethnicityQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,375))
barplot(ethnicityQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,375))
barplot(ethnicityQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,375))
barplot(ethnicityQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,375))
barplot(ethnicityQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,375))
barplot(ethnicityQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,375))
barplot(ethnicityQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,375))
barplot(ethnicityQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,375))
barplot(ethnicityQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,375))
barplot(ethnicityQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,375))
barplot(ethnicityQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,375))
barplot(ethnicityQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,375))
dev.off()


###
# plots by highest_degree

highest_degreeQ1 <- t(table(highest_degree,Q1))
highest_degreeQ2 <- t(table(highest_degree,Q2))
highest_degreeQ3 <- t(table(highest_degree,Q3))
highest_degreeQ4 <- t(table(highest_degree,Q4))
highest_degreeQ5 <- t(table(highest_degree,Q5))
highest_degreeQ6 <- t(table(highest_degree,Q6))
highest_degreeQ7 <- t(table(highest_degree,Q7))
highest_degreeQ8 <- t(table(highest_degree,Q8))
highest_degreeQ9 <- t(table(highest_degree,Q9))
highest_degreeQ10 <- t(table(highest_degree,Q10))
highest_degreeQ11 <- t(table(highest_degree,Q11))
highest_degreeQ12 <- t(table(highest_degree,Q12))
highest_degreeQ13 <- t(table(highest_degree,Q13))
highest_degreeQ14 <- t(table(highest_degree,Q14))
highest_degreeQ15 <- t(table(highest_degree,Q15))

colnames(highest_degreeQ1) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ2) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ3) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ4) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ5) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ6) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ7) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ8) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ9) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ10) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ11) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ12) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ13) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ14) <- c("M.S.","Ph.D.")
colnames(highest_degreeQ15) <- c("M.S.","Ph.D.")

pdf(paste(plots_by_demographic,'/Skills_by_highest_degree.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(highest_degreeQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,400))
barplot(highest_degreeQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,400))
barplot(highest_degreeQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,400))
barplot(highest_degreeQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,400))
barplot(highest_degreeQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,400))
barplot(highest_degreeQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,400))
barplot(highest_degreeQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,400))
barplot(highest_degreeQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,400))
barplot(highest_degreeQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,400))
barplot(highest_degreeQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,400))
barplot(highest_degreeQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,400))
barplot(highest_degreeQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,400))
barplot(highest_degreeQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,400))
barplot(highest_degreeQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,400))
barplot(highest_degreeQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,400))
dev.off()

###
# plots by earned

# Q18	Year of highest earned degree.	2016	2015	2014	2013	2012	2011	2010	2009	2008	2007	2006	2005	2004	2003	2002	2001	2000	1999	1998	1997	1996	1995	1994	1993	1992	1991	1990	1989	1988	1987	1986	1985	1984	1983	1982	1981	1980	1979	1978	1977	1976	1975	1974	1973	1972	1971	1970	1969	1968	1967	1966	1965	1964	1963	1962	1961	1960	1959	1958	1957	1956	1955	1954	1953	1952	1951	1950	Rather not say
earnedQ1 <- t(table(earned,Q1))
earnedQ2 <- t(table(earned,Q2))
earnedQ3 <- t(table(earned,Q3))
earnedQ4 <- t(table(earned,Q4))
earnedQ5 <- t(table(earned,Q5))
earnedQ6 <- t(table(earned,Q6))
earnedQ7 <- t(table(earned,Q7))
earnedQ8 <- t(table(earned,Q8))
earnedQ9 <- t(table(earned,Q9))
earnedQ10 <- t(table(earned,Q10))
earnedQ11 <- t(table(earned,Q11))
earnedQ12 <- t(table(earned,Q12))
earnedQ13 <- t(table(earned,Q13))
earnedQ14 <- t(table(earned,Q14))
earnedQ15 <- t(table(earned,Q15))

pdf(paste(plots_by_demographic,'/Skills_by_earned.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(earnedQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,150))
barplot(earnedQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,150))
barplot(earnedQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,150))
barplot(earnedQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,150))
barplot(earnedQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,150))
barplot(earnedQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,150))
barplot(earnedQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,150))
barplot(earnedQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,150))
barplot(earnedQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,150))
barplot(earnedQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,150))
barplot(earnedQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,150))
barplot(earnedQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,150))
barplot(earnedQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,150))
barplot(earnedQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,150))
barplot(earnedQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,150))
dev.off()

###
# plots by bx_training

bx_trainingQ1 <- t(table(bx_training,Q1))
bx_trainingQ2 <- t(table(bx_training,Q2))
bx_trainingQ3 <- t(table(bx_training,Q3))
bx_trainingQ4 <- t(table(bx_training,Q4))
bx_trainingQ5 <- t(table(bx_training,Q5))
bx_trainingQ6 <- t(table(bx_training,Q6))
bx_trainingQ7 <- t(table(bx_training,Q7))
bx_trainingQ8 <- t(table(bx_training,Q8))
bx_trainingQ9 <- t(table(bx_training,Q9))
bx_trainingQ10 <- t(table(bx_training,Q10))
bx_trainingQ11 <- t(table(bx_training,Q11))
bx_trainingQ12 <- t(table(bx_training,Q12))
bx_trainingQ13 <- t(table(bx_training,Q13))
bx_trainingQ14 <- t(table(bx_training,Q14))
bx_trainingQ15 <- t(table(bx_training,Q15))

colnames(bx_trainingQ1) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ2) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ3) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ4) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ5) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ6) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ7) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ8) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ9) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ10) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ11) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ12) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ13) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ14) <- c("None","Self","Short","Undergrad","G_cla","G_deg")
colnames(bx_trainingQ15) <- c("None","Self","Short","Undergrad","G_cla","G_deg")

pdf(paste(plots_by_demographic,'/Skills_by_bx_training.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(bx_trainingQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,225))
barplot(bx_trainingQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,225))
barplot(bx_trainingQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,225))
barplot(bx_trainingQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,225))
barplot(bx_trainingQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,225))
barplot(bx_trainingQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,225))
barplot(bx_trainingQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,225))
barplot(bx_trainingQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,225))
barplot(bx_trainingQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,225))
barplot(bx_trainingQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,225))
barplot(bx_trainingQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,225))
barplot(bx_trainingQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,225))
barplot(bx_trainingQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,225))
barplot(bx_trainingQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,225))
barplot(bx_trainingQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,225))
dev.off()

###
# plots by carnegie

carnegieQ1 <- t(table(carnegie,Q1))
carnegieQ2 <- t(table(carnegie,Q2))
carnegieQ3 <- t(table(carnegie,Q3))
carnegieQ4 <- t(table(carnegie,Q4))
carnegieQ5 <- t(table(carnegie,Q5))
carnegieQ6 <- t(table(carnegie,Q6))
carnegieQ7 <- t(table(carnegie,Q7))
carnegieQ8 <- t(table(carnegie,Q8))
carnegieQ9 <- t(table(carnegie,Q9))
carnegieQ10 <- t(table(carnegie,Q10))
carnegieQ11 <- t(table(carnegie,Q11))
carnegieQ12 <- t(table(carnegie,Q12))
carnegieQ13 <- t(table(carnegie,Q13))
carnegieQ14 <- t(table(carnegie,Q14))
carnegieQ15 <- t(table(carnegie,Q15))

colnames(carnegieQ1) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ2) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ3) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ4) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ5) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ6) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ7) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ8) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ9) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ10) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ11) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ12) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ13) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ14) <- c("Assoc","Bacc","M.S.","Ph.D.")
colnames(carnegieQ15) <- c("Assoc","Bacc","M.S.","Ph.D.")

pdf(paste(plots_by_demographic,'/Skills_by_carnegie.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(carnegieQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,175))
barplot(carnegieQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,175))
barplot(carnegieQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,175))
barplot(carnegieQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,175))
barplot(carnegieQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,175))
barplot(carnegieQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,175))
barplot(carnegieQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,175))
barplot(carnegieQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,175))
barplot(carnegieQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,175))
barplot(carnegieQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,175))
barplot(carnegieQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,175))
barplot(carnegieQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,175))
barplot(carnegieQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,175))
barplot(carnegieQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,175))
barplot(carnegieQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,175))
dev.off()

###
# plots by minority_serving

minority_servingQ1 <- t(table(minority_serving,Q1))
minority_servingQ2 <- t(table(minority_serving,Q2))
minority_servingQ3 <- t(table(minority_serving,Q3))
minority_servingQ4 <- t(table(minority_serving,Q4))
minority_servingQ5 <- t(table(minority_serving,Q5))
minority_servingQ6 <- t(table(minority_serving,Q6))
minority_servingQ7 <- t(table(minority_serving,Q7))
minority_servingQ8 <- t(table(minority_serving,Q8))
minority_servingQ9 <- t(table(minority_serving,Q9))
minority_servingQ10 <- t(table(minority_serving,Q10))
minority_servingQ11 <- t(table(minority_serving,Q11))
minority_servingQ12 <- t(table(minority_serving,Q12))
minority_servingQ13 <- t(table(minority_serving,Q13))
minority_servingQ14 <- t(table(minority_serving,Q14))
minority_servingQ15 <- t(table(minority_serving,Q15))

colnames(minority_servingQ1) <- c("Minority","Non")
colnames(minority_servingQ2) <- c("Minority","Non")
colnames(minority_servingQ3) <- c("Minority","Non")
colnames(minority_servingQ4) <- c("Minority","Non")
colnames(minority_servingQ5) <- c("Minority","Non")
colnames(minority_servingQ6) <- c("Minority","Non")
colnames(minority_servingQ7) <- c("Minority","Non")
colnames(minority_servingQ8) <- c("Minority","Non")
colnames(minority_servingQ9) <- c("Minority","Non")
colnames(minority_servingQ10) <- c("Minority","Non")
colnames(minority_servingQ11) <- c("Minority","Non")
colnames(minority_servingQ12) <- c("Minority","Non")
colnames(minority_servingQ13) <- c("Minority","Non")
colnames(minority_servingQ14) <- c("Minority","Non")
colnames(minority_servingQ15) <- c("Minority","Non")

pdf(paste(plots_by_demographic,'/Skills_by_minority_serving.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(minority_servingQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,225))
barplot(minority_servingQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,225))
barplot(minority_servingQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,225))
barplot(minority_servingQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,225))
barplot(minority_servingQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,225))
barplot(minority_servingQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,225))
barplot(minority_servingQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,225))
barplot(minority_servingQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,225))
barplot(minority_servingQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,225))
barplot(minority_servingQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,225))
barplot(minority_servingQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,225))
barplot(minority_servingQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,225))
barplot(minority_servingQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,225))
barplot(minority_servingQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,225))
barplot(minority_servingQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,225))
dev.off()

###
# plots by total_students

total_studentsQ1 <- t(table(total_students,Q1))
total_studentsQ2 <- t(table(total_students,Q2))
total_studentsQ3 <- t(table(total_students,Q3))
total_studentsQ4 <- t(table(total_students,Q4))
total_studentsQ5 <- t(table(total_students,Q5))
total_studentsQ6 <- t(table(total_students,Q6))
total_studentsQ7 <- t(table(total_students,Q7))
total_studentsQ8 <- t(table(total_students,Q8))
total_studentsQ9 <- t(table(total_students,Q9))
total_studentsQ10 <- t(table(total_students,Q10))
total_studentsQ11 <- t(table(total_students,Q11))
total_studentsQ12 <- t(table(total_students,Q12))
total_studentsQ13 <- t(table(total_students,Q13))
total_studentsQ14 <- t(table(total_students,Q14))
total_studentsQ15 <- t(table(total_students,Q15))

colnames(total_studentsQ1) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ2) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ3) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ4) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ5) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ6) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ7) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ8) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ9) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ10) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ11) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ12) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ13) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ14) <- c("<5k","5_15k",">15k")
colnames(total_studentsQ15) <- c("<5k","5_15k",">15k")

pdf(paste(plots_by_demographic,'/Skills_by_total_students.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(total_studentsQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,175))
barplot(total_studentsQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,175))
barplot(total_studentsQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,175))
barplot(total_studentsQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,175))
barplot(total_studentsQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,175))
barplot(total_studentsQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,175))
barplot(total_studentsQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,175))
barplot(total_studentsQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,175))
barplot(total_studentsQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,175))
barplot(total_studentsQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,175))
barplot(total_studentsQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,175))
barplot(total_studentsQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,175))
barplot(total_studentsQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,175))
barplot(total_studentsQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,175))
barplot(total_studentsQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,175))
dev.off()

###
# plots by total_undergrads

total_undergradsQ1 <- t(table(total_undergrads,Q1))
total_undergradsQ2 <- t(table(total_undergrads,Q2))
total_undergradsQ3 <- t(table(total_undergrads,Q3))
total_undergradsQ4 <- t(table(total_undergrads,Q4))
total_undergradsQ5 <- t(table(total_undergrads,Q5))
total_undergradsQ6 <- t(table(total_undergrads,Q6))
total_undergradsQ7 <- t(table(total_undergrads,Q7))
total_undergradsQ8 <- t(table(total_undergrads,Q8))
total_undergradsQ9 <- t(table(total_undergrads,Q9))
total_undergradsQ10 <- t(table(total_undergrads,Q10))
total_undergradsQ11 <- t(table(total_undergrads,Q11))
total_undergradsQ12 <- t(table(total_undergrads,Q12))
total_undergradsQ13 <- t(table(total_undergrads,Q13))
total_undergradsQ14 <- t(table(total_undergrads,Q14))
total_undergradsQ15 <- t(table(total_undergrads,Q15))

colnames(total_undergradsQ1) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ2) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ3) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ4) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ5) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ6) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ7) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ8) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ9) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ10) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ11) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ12) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ13) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ14) <- c("<5k","5_15k",">15k")
colnames(total_undergradsQ15) <- c("<5k","5_15k",">15k")

pdf(paste(plots_by_demographic,'/Skills_by_total_undergrads.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(total_undergradsQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,200))
barplot(total_undergradsQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,200))
barplot(total_undergradsQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,200))
barplot(total_undergradsQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,200))
barplot(total_undergradsQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,200))
barplot(total_undergradsQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,200))
barplot(total_undergradsQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,200))
barplot(total_undergradsQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,200))
barplot(total_undergradsQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,200))
barplot(total_undergradsQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,200))
barplot(total_undergradsQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,200))
barplot(total_undergradsQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,200))
barplot(total_undergradsQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,200))
barplot(total_undergradsQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,200))
barplot(total_undergradsQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,200))
dev.off()

###
# plots by faculty

facultyQ1 <- t(table(faculty,Q1))
facultyQ2 <- t(table(faculty,Q2))
facultyQ3 <- t(table(faculty,Q3))
facultyQ4 <- t(table(faculty,Q4))
facultyQ5 <- t(table(faculty,Q5))
facultyQ6 <- t(table(faculty,Q6))
facultyQ7 <- t(table(faculty,Q7))
facultyQ8 <- t(table(faculty,Q8))
facultyQ9 <- t(table(faculty,Q9))
facultyQ10 <- t(table(faculty,Q10))
facultyQ11 <- t(table(faculty,Q11))
facultyQ12 <- t(table(faculty,Q12))
facultyQ13 <- t(table(faculty,Q13))
facultyQ14 <- t(table(faculty,Q14))
facultyQ15 <- t(table(faculty,Q15))

colnames(facultyQ1) <- c("<10","10-20","21-30","31+")
colnames(facultyQ2) <- c("<10","10-20","21-30","31+")
colnames(facultyQ3) <- c("<10","10-20","21-30","31+")
colnames(facultyQ4) <- c("<10","10-20","21-30","31+")
colnames(facultyQ5) <- c("<10","10-20","21-30","31+")
colnames(facultyQ6) <- c("<10","10-20","21-30","31+")
colnames(facultyQ7) <- c("<10","10-20","21-30","31+")
colnames(facultyQ8) <- c("<10","10-20","21-30","31+")
colnames(facultyQ9) <- c("<10","10-20","21-30","31+")
colnames(facultyQ10) <- c("<10","10-20","21-30","31+")
colnames(facultyQ11) <- c("<10","10-20","21-30","31+")
colnames(facultyQ12) <- c("<10","10-20","21-30","31+")
colnames(facultyQ13) <- c("<10","10-20","21-30","31+")
colnames(facultyQ14) <- c("<10","10-20","21-30","31+")
colnames(facultyQ15) <- c("<10","10-20","21-30","31+")

pdf(paste(plots_by_demographic,'/Skills_by_faculty.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(facultyQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,225))
barplot(facultyQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,225))
barplot(facultyQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,225))
barplot(facultyQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,225))
barplot(facultyQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,225))
barplot(facultyQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,225))
barplot(facultyQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,225))
barplot(facultyQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,225))
barplot(facultyQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,225))
barplot(facultyQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,225))
barplot(facultyQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,225))
barplot(facultyQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,225))
barplot(facultyQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,225))
barplot(facultyQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,225))
barplot(facultyQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,225))
dev.off()

###
# plots by undergrad_majors

undergrad_majorsQ1 <- t(table(undergrad_majors,Q1))
undergrad_majorsQ2 <- t(table(undergrad_majors,Q2))
undergrad_majorsQ3 <- t(table(undergrad_majors,Q3))
undergrad_majorsQ4 <- t(table(undergrad_majors,Q4))
undergrad_majorsQ5 <- t(table(undergrad_majors,Q5))
undergrad_majorsQ6 <- t(table(undergrad_majors,Q6))
undergrad_majorsQ7 <- t(table(undergrad_majors,Q7))
undergrad_majorsQ8 <- t(table(undergrad_majors,Q8))
undergrad_majorsQ9 <- t(table(undergrad_majors,Q9))
undergrad_majorsQ10 <- t(table(undergrad_majors,Q10))
undergrad_majorsQ11 <- t(table(undergrad_majors,Q11))
undergrad_majorsQ12 <- t(table(undergrad_majors,Q12))
undergrad_majorsQ13 <- t(table(undergrad_majors,Q13))
undergrad_majorsQ14 <- t(table(undergrad_majors,Q14))
undergrad_majorsQ15 <- t(table(undergrad_majors,Q15))

colnames(undergrad_majorsQ1) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ2) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ3) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ4) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ5) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ6) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ7) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ8) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ9) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ10) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ11) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ12) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ13) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ14) <- c("<101","101-500",">500")
colnames(undergrad_majorsQ15) <- c("<101","101-500",">500")

pdf(paste(plots_by_demographic,'/Skills_by_undergrad_majors.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5))
barplot(undergrad_majorsQ1,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S1",ylim=c(0,200))
barplot(undergrad_majorsQ2,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S2",ylim=c(0,200))
barplot(undergrad_majorsQ3,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S3",ylim=c(0,200))
barplot(undergrad_majorsQ4,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S4",ylim=c(0,200))
barplot(undergrad_majorsQ5,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S5",ylim=c(0,200))
barplot(undergrad_majorsQ6,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S6",ylim=c(0,200))
barplot(undergrad_majorsQ7,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S7",ylim=c(0,200))
barplot(undergrad_majorsQ8,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S8",ylim=c(0,200))
barplot(undergrad_majorsQ9,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S9",ylim=c(0,200))
barplot(undergrad_majorsQ10,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S10",ylim=c(0,200))
barplot(undergrad_majorsQ11,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S11",ylim=c(0,200))
barplot(undergrad_majorsQ12,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S12",ylim=c(0,200))
barplot(undergrad_majorsQ13,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S13",ylim=c(0,200))
barplot(undergrad_majorsQ14,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S14",ylim=c(0,200))
barplot(undergrad_majorsQ15,beside=T, col=c("darkred", "red", "yellow", "green", "dark green"),las=3,main="S15",ylim=c(0,200))
dev.off()

#Plot by all categories combined
allQ1 <- t(table(Q1))
allQ2 <- t(table(Q2))
allQ3 <- t(table(Q3))
allQ4 <- t(table(Q4))
allQ5 <- t(table(Q5))
allQ6 <- t(table(Q6))
allQ7 <- t(table(Q7))
allQ8 <- t(table(Q8))
allQ9 <- t(table(Q9))
allQ10 <- t(table(Q10))
allQ11 <- t(table(Q11))
allQ12 <- t(table(Q12))
allQ13 <- t(table(Q13))
allQ14 <- t(table(Q14))
allQ15 <- t(table(Q15))

library(RColorBrewer)
numdata <- length(allQ1)
blues <- brewer.pal(numdata, "Blues")


pdf(paste(plots_by_demographic,'/Figure2_Skills_by_all.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5), mai = c(0.3, 0.5, 0.5, 0.2))
# barplot(allQ1, beside=T, col=blues, main=substitute(paste(bold('S1'))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ1, beside=T, col=blues, main=substitute(paste(bold("S1 ("), bolditalic('Role'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ2, beside=T, col=blues, main=substitute(paste(bold("S2 ("), bolditalic('Concepts'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ3, beside=T, col=blues, main=substitute(paste(bold("S3 ("), bolditalic('Statistics'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ4, beside=T, col=blues, main=substitute(paste(bold("S4 ("), bolditalic('Access genomic'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ5, beside=T, col=blues, main=substitute(paste(bold("S5 ("), bolditalic('Tools genomic'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ6, beside=T, col=blues, main=substitute(paste(bold("S6 ("), bolditalic('Access expression'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ7, beside=T, col=blues, main=substitute(paste(bold("S7 ("), bolditalic('Tools expression'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ8, beside=T, col=blues, main=substitute(paste(bold("S8 ("), bolditalic('Access proteomic'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ9, beside=T, col=blues, main=substitute(paste(bold("S9 ("), bolditalic('Tools proteomic'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ10, beside=T, col=blues, main=substitute(paste(bold("S10 ("), bolditalic('Access metabolomic'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ11, beside=T, col=blues, main=substitute(paste(bold("S11 ("), bolditalic('Pathways'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ12, beside=T, col=blues, main=substitute(paste(bold("S12 ("), bolditalic('Metagenomics'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ13, beside=T, col=blues, main=substitute(paste(bold("S13 ("), bolditalic('Scripting'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ14, beside=T, col=blues, main=substitute(paste(bold("S14 ("), bolditalic('Software'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ15, beside=T, col=blues, main=substitute(paste(bold("S15 ("), bolditalic('Comp Environment'),bold(")"))),ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
dev.off()

# Plots by demographic in order of knowing/doing skills: 
# Knowing skills; S1 – S4, S6, S8, and S10)
# Skills requiring direct engagement (practicing); S5, S7, S9, S11 – S15
                                                                                          
pdf(paste(plots_by_demographic,'/Skills_by_all.pdf', sep=""),width=10,height=5)
par(mfrow=c(3,5), mai = c(0.3, 0.5, 0.5, 0.2))
barplot(allQ1, beside=T, col=blues, main="S1 - Role",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ2, beside=T, col=blues, main="S2 - Concepts",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ3, beside=T, col=blues, main="S3 - Statistics",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ4, beside=T, col=blues, main="S4 - Access genomic",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ6, beside=T, col=blues, main="S6 - Access expression",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ8, beside=T, col=blues, main="S8 - Access proteomic",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ10, beside=T, col=blues, main="S10 - Access metabolomic",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ5, beside=T, col=blues, main="S5 - Tools genomic",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ7, beside=T, col=blues, main="S7 - Tools expression",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ9, beside=T, col=blues, main="S9 - Tools proteomic",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ11, beside=T, col=blues, main="S11 - Pathways",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ12, beside=T, col=blues, main="S12 - Metagenomics",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ13, beside=T, col=blues, main="S13 - Scripting",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ14, beside=T, col=blues, main="S14 - Software",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
barplot(allQ15, beside=T, col=blues, main="S15 - Comp environment",ylim=c(0,500), space=c(0,0,0,0,0),cex.main=1.1)
dev.off()





##############################
## TESTING FOR DIFFERENCES
##############################
#
# And we need to set all not applicable (option 6) to NA to be ignored:
survey_data$Q13_1[survey_data$Q13_1==6] <- NA
survey_data$Q13_2[survey_data$Q13_2==6] <- NA
survey_data$Q13_3[survey_data$Q13_3==6] <- NA
survey_data$Q13_4[survey_data$Q13_4==6] <- NA
survey_data$Q13_5[survey_data$Q13_5==6] <- NA
survey_data$Q13_6[survey_data$Q13_6==6] <- NA
survey_data$Q13_7[survey_data$Q13_7==6] <- NA
survey_data$Q13_8[survey_data$Q13_8==6] <- NA
survey_data$Q13_9[survey_data$Q13_9==6] <- NA
survey_data$Q13_10[survey_data$Q13_10==6] <- NA
survey_data$Q13_11[survey_data$Q13_11==6] <- NA
survey_data$Q13_12[survey_data$Q13_12==6] <- NA
survey_data$Q13_13[survey_data$Q13_13==6] <- NA
survey_data$Q13_14[survey_data$Q13_14==6] <- NA
survey_data$Q13_15[survey_data$Q13_15==6] <- NA


###
#Test for difference between female and male
###


Q1_female <- survey_data$Q13_1[survey_data$Q14=="1"]
Q1_male <- survey_data$Q13_1[survey_data$Q14=="2"]

Q2_female <- survey_data$Q13_2[survey_data$Q14=="1"]
Q2_male <- survey_data$Q13_2[survey_data$Q14=="2"]

Q3_female <- survey_data$Q13_3[survey_data$Q14=="1"]
Q3_male <- survey_data$Q13_3[survey_data$Q14=="2"]

Q4_female <- survey_data$Q13_4[survey_data$Q14=="1"]
Q4_male <- survey_data$Q13_4[survey_data$Q14=="2"]

Q5_female <- survey_data$Q13_5[survey_data$Q14=="1"]
Q5_male <- survey_data$Q13_5[survey_data$Q14=="2"]

Q6_female <- survey_data$Q13_6[survey_data$Q14=="1"]
Q6_male <- survey_data$Q13_6[survey_data$Q14=="2"]

Q7_female <- survey_data$Q13_7[survey_data$Q14=="1"]
Q7_male <- survey_data$Q13_7[survey_data$Q14=="2"]

Q8_female <- survey_data$Q13_8[survey_data$Q14=="1"]
Q8_male <- survey_data$Q13_8[survey_data$Q14=="2"]

Q9_female <- survey_data$Q13_9[survey_data$Q14=="1"]
Q9_male <- survey_data$Q13_9[survey_data$Q14=="2"]

Q10_female <- survey_data$Q13_10[survey_data$Q14=="1"]
Q10_male <- survey_data$Q13_10[survey_data$Q14=="2"]

Q11_female <- survey_data$Q13_11[survey_data$Q14=="1"]
Q11_male <- survey_data$Q13_11[survey_data$Q14=="2"]

Q12_female <- survey_data$Q13_12[survey_data$Q14=="1"]
Q12_male <- survey_data$Q13_12[survey_data$Q14=="2"]

Q13_female <- survey_data$Q13_13[survey_data$Q14=="1"]
Q13_male <- survey_data$Q13_13[survey_data$Q14=="2"]

Q14_female <- survey_data$Q13_14[survey_data$Q14=="1"]
Q14_male <- survey_data$Q13_14[survey_data$Q14=="2"]

Q15_female <- survey_data$Q13_15[survey_data$Q14=="1"]
Q15_male <- survey_data$Q13_15[survey_data$Q14=="2"]


ks_gender <- list()
ks_gender[[1]] <- ks.test(Q1_female, Q1_male)
ks_gender[[2]] <- ks.test(Q2_female, Q2_male)
ks_gender[[3]] <- ks.test(Q3_female, Q3_male)
ks_gender[[4]] <- ks.test(Q4_female, Q4_male)
ks_gender[[5]] <- ks.test(Q5_female, Q5_male)

ks_gender[[6]] <- ks.test(Q6_female, Q6_male)
ks_gender[[7]] <- ks.test(Q7_female, Q7_male)
ks_gender[[8]] <- ks.test(Q8_female, Q8_male)
ks_gender[[9]] <- ks.test(Q9_female, Q9_male)
ks_gender[[10]] <- ks.test(Q10_female, Q10_male)

ks_gender[[11]] <- ks.test(Q11_female, Q11_male)
ks_gender[[12]] <- ks.test(Q12_female, Q12_male)
ks_gender[[13]] <- ks.test(Q13_female, Q13_male)
ks_gender[[14]] <- ks.test(Q14_female, Q14_male)
ks_gender[[15]] <- ks.test(Q15_female, Q15_male)

test_ks_gender <- sapply(ks_gender, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_gender) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_female_male <- test_ks_gender[2,]

# Get means
stats_gender_female <- cbind(summary(Q1_female),summary(Q2_female),summary(Q3_female),summary(Q4_female),summary(Q5_female),summary(Q6_female),summary(Q7_female),summary(Q8_female),summary(Q9_female),summary(Q10_female),summary(Q11_female),summary(Q12_female),summary(Q13_female),summary(Q14_female),summary(Q15_female))
colnames(stats_gender_female) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_gender_male <- cbind(summary(Q1_male),summary(Q2_male),summary(Q3_male),summary(Q4_male),summary(Q5_male),summary(Q6_male),summary(Q7_male),summary(Q8_male),summary(Q9_male),summary(Q10_male),summary(Q11_male),summary(Q12_male),summary(Q13_male),summary(Q14_male),summary(Q15_male))
colnames(stats_gender_male) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_gender <- cbind(stats_gender_female[4,],stats_gender_male[4,])
colnames(mean_gender) <- c("Female", "Male")
mean_gender_plots <- t(mean_gender)
mean_gender <- cbind(mean_gender,P_female_male)

myfile <- paste(path,"mean_test_ks_gender.txt", sep="")
write.table(mean_gender, file = myfile, sep = "\t")

###
#Test for difference between HisLat and Non
###

Q1_HisLat <- survey_data$Q13_1[survey_data$Q16=="1"]
Q1_Non <- survey_data$Q13_1[survey_data$Q16=="2"]

Q2_HisLat <- survey_data$Q13_2[survey_data$Q16=="1"]
Q2_Non <- survey_data$Q13_2[survey_data$Q16=="2"]

Q3_HisLat <- survey_data$Q13_3[survey_data$Q16=="1"]
Q3_Non <- survey_data$Q13_3[survey_data$Q16=="2"]

Q4_HisLat <- survey_data$Q13_4[survey_data$Q16=="1"]
Q4_Non <- survey_data$Q13_4[survey_data$Q16=="2"]

Q5_HisLat <- survey_data$Q13_5[survey_data$Q16=="1"]
Q5_Non <- survey_data$Q13_5[survey_data$Q16=="2"]

Q6_HisLat <- survey_data$Q13_6[survey_data$Q16=="1"]
Q6_Non <- survey_data$Q13_6[survey_data$Q16=="2"]

Q7_HisLat <- survey_data$Q13_7[survey_data$Q16=="1"]
Q7_Non <- survey_data$Q13_7[survey_data$Q16=="2"]

Q8_HisLat <- survey_data$Q13_8[survey_data$Q16=="1"]
Q8_Non <- survey_data$Q13_8[survey_data$Q16=="2"]

Q9_HisLat <- survey_data$Q13_9[survey_data$Q16=="1"]
Q9_Non <- survey_data$Q13_9[survey_data$Q16=="2"]

Q10_HisLat <- survey_data$Q13_10[survey_data$Q16=="1"]
Q10_Non <- survey_data$Q13_10[survey_data$Q16=="2"]

Q11_HisLat <- survey_data$Q13_11[survey_data$Q16=="1"]
Q11_Non <- survey_data$Q13_11[survey_data$Q16=="2"]

Q12_HisLat <- survey_data$Q13_12[survey_data$Q16=="1"]
Q12_Non <- survey_data$Q13_12[survey_data$Q16=="2"]

Q13_HisLat <- survey_data$Q13_13[survey_data$Q16=="1"]
Q13_Non <- survey_data$Q13_13[survey_data$Q16=="2"]

Q14_HisLat <- survey_data$Q13_14[survey_data$Q16=="1"]
Q14_Non <- survey_data$Q13_14[survey_data$Q16=="2"]

Q15_HisLat <- survey_data$Q13_15[survey_data$Q16=="1"]
Q15_Non <- survey_data$Q13_15[survey_data$Q16=="2"]


ks_ethnicity <- list()
ks_ethnicity[[1]] <- ks.test(Q1_HisLat, Q1_Non)
ks_ethnicity[[2]] <- ks.test(Q2_HisLat, Q2_Non)
ks_ethnicity[[3]] <- ks.test(Q3_HisLat, Q3_Non)
ks_ethnicity[[4]] <- ks.test(Q4_HisLat, Q4_Non)
ks_ethnicity[[5]] <- ks.test(Q5_HisLat, Q5_Non)

ks_ethnicity[[6]] <- ks.test(Q6_HisLat, Q6_Non)
ks_ethnicity[[7]] <- ks.test(Q7_HisLat, Q7_Non)
ks_ethnicity[[8]] <- ks.test(Q8_HisLat, Q8_Non)
ks_ethnicity[[9]] <- ks.test(Q9_HisLat, Q9_Non)
ks_ethnicity[[10]] <- ks.test(Q10_HisLat, Q10_Non)

ks_ethnicity[[11]] <- ks.test(Q11_HisLat, Q11_Non)
ks_ethnicity[[12]] <- ks.test(Q12_HisLat, Q12_Non)
ks_ethnicity[[13]] <- ks.test(Q13_HisLat, Q13_Non)
ks_ethnicity[[14]] <- ks.test(Q14_HisLat, Q14_Non)
ks_ethnicity[[15]] <- ks.test(Q15_HisLat, Q15_Non)

test_ks_ethnicity <- sapply(ks_ethnicity, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_ethnicity) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_HisLat_Non <- test_ks_ethnicity[2,]

# Get means
stats_ethnicity_HisLat <- cbind(summary(Q1_HisLat),summary(Q2_HisLat),summary(Q3_HisLat),summary(Q4_HisLat),summary(Q5_HisLat),summary(Q6_HisLat),summary(Q7_HisLat),summary(Q8_HisLat),summary(Q9_HisLat),summary(Q10_HisLat),summary(Q11_HisLat),summary(Q12_HisLat),summary(Q13_HisLat),summary(Q14_HisLat),summary(Q15_HisLat))
colnames(stats_ethnicity_HisLat) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_ethnicity_Non <- cbind(summary(Q1_Non),summary(Q2_Non),summary(Q3_Non),summary(Q4_Non),summary(Q5_Non),summary(Q6_Non),summary(Q7_Non),summary(Q8_Non),summary(Q9_Non),summary(Q10_Non),summary(Q11_Non),summary(Q12_Non),summary(Q13_Non),summary(Q14_Non),summary(Q15_Non))
colnames(stats_ethnicity_Non) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_ethnicity <- cbind(stats_ethnicity_HisLat[4,],stats_ethnicity_Non[4,])
colnames(mean_ethnicity) <- c("His/Lat", "Non")
mean_ethnicity_plots <- t(mean_ethnicity)
mean_ethnicity <- cbind(mean_ethnicity,P_HisLat_Non)

myfile <- paste(path,"mean_test_ks_ethnicity.txt", sep="")
write.table(mean_ethnicity, file = myfile, sep = "\t")

###
#Test for difference between MS and PhD (BS and Prof had 7 observations each so are)
###

Q1_MS <- survey_data$Q13_1[survey_data$Q17=="2"]
Q1_PhD <- survey_data$Q13_1[survey_data$Q17=="4"]

Q2_MS <- survey_data$Q13_2[survey_data$Q17=="2"]
Q2_PhD <- survey_data$Q13_2[survey_data$Q17=="4"]

Q3_MS <- survey_data$Q13_3[survey_data$Q17=="2"]
Q3_PhD <- survey_data$Q13_3[survey_data$Q17=="4"]

Q4_MS <- survey_data$Q13_4[survey_data$Q17=="2"]
Q4_PhD <- survey_data$Q13_4[survey_data$Q17=="4"]

Q5_MS <- survey_data$Q13_5[survey_data$Q17=="2"]
Q5_PhD <- survey_data$Q13_5[survey_data$Q17=="4"]

Q6_MS <- survey_data$Q13_6[survey_data$Q17=="2"]
Q6_PhD <- survey_data$Q13_6[survey_data$Q17=="4"]

Q7_MS <- survey_data$Q13_7[survey_data$Q17=="2"]
Q7_PhD <- survey_data$Q13_7[survey_data$Q17=="4"]

Q8_MS <- survey_data$Q13_8[survey_data$Q17=="2"]
Q8_PhD <- survey_data$Q13_8[survey_data$Q17=="4"]

Q9_MS <- survey_data$Q13_9[survey_data$Q17=="2"]
Q9_PhD <- survey_data$Q13_9[survey_data$Q17=="4"]

Q10_MS <- survey_data$Q13_10[survey_data$Q17=="2"]
Q10_PhD <- survey_data$Q13_10[survey_data$Q17=="4"]

Q11_MS <- survey_data$Q13_11[survey_data$Q17=="2"]
Q11_PhD <- survey_data$Q13_11[survey_data$Q17=="4"]

Q12_MS <- survey_data$Q13_12[survey_data$Q17=="2"]
Q12_PhD <- survey_data$Q13_12[survey_data$Q17=="4"]

Q13_MS <- survey_data$Q13_13[survey_data$Q17=="2"]
Q13_PhD <- survey_data$Q13_13[survey_data$Q17=="4"]

Q14_MS <- survey_data$Q13_14[survey_data$Q17=="2"]
Q14_PhD <- survey_data$Q13_14[survey_data$Q17=="4"]

Q15_MS <- survey_data$Q13_15[survey_data$Q17=="2"]
Q15_PhD <- survey_data$Q13_15[survey_data$Q17=="4"]

#Test for MS-PhD
ks_highest_degree <- list()
ks_highest_degree[[1]] <- ks.test(Q1_MS, Q1_PhD)
ks_highest_degree[[2]] <- ks.test(Q2_MS, Q2_PhD)
ks_highest_degree[[3]] <- ks.test(Q3_MS, Q3_PhD)
ks_highest_degree[[4]] <- ks.test(Q4_MS, Q4_PhD)
ks_highest_degree[[5]] <- ks.test(Q5_MS, Q5_PhD)

ks_highest_degree[[6]] <- ks.test(Q6_MS, Q6_PhD)
ks_highest_degree[[7]] <- ks.test(Q7_MS, Q7_PhD)
ks_highest_degree[[8]] <- ks.test(Q8_MS, Q8_PhD)
ks_highest_degree[[9]] <- ks.test(Q9_MS, Q9_PhD)
ks_highest_degree[[10]] <- ks.test(Q10_MS, Q10_PhD)

ks_highest_degree[[11]] <- ks.test(Q11_MS, Q11_PhD)
ks_highest_degree[[12]] <- ks.test(Q12_MS, Q12_PhD)
ks_highest_degree[[13]] <- ks.test(Q13_MS, Q13_PhD)
ks_highest_degree[[14]] <- ks.test(Q14_MS, Q14_PhD)
ks_highest_degree[[15]] <- ks.test(Q15_MS, Q15_PhD)

test_ks_highest_degree <- sapply(ks_highest_degree, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_highest_degree) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_MS_PhD <- test_ks_highest_degree[2,]

# Get means
stats_highest_degree_MS <- cbind(summary(Q1_MS),summary(Q2_MS),summary(Q3_MS),summary(Q4_MS),summary(Q5_MS),summary(Q6_MS),summary(Q7_MS),summary(Q8_MS),summary(Q9_MS),summary(Q10_MS),summary(Q11_MS),summary(Q12_MS),summary(Q13_MS),summary(Q14_MS),summary(Q15_MS))
colnames(stats_highest_degree_MS) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_highest_degree_PhD <- cbind(summary(Q1_PhD),summary(Q2_PhD),summary(Q3_PhD),summary(Q4_PhD),summary(Q5_PhD),summary(Q6_PhD),summary(Q7_PhD),summary(Q8_PhD),summary(Q9_PhD),summary(Q10_PhD),summary(Q11_PhD),summary(Q12_PhD),summary(Q13_PhD),summary(Q14_PhD),summary(Q15_PhD))
colnames(stats_highest_degree_PhD) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_highest_degree <- cbind(stats_highest_degree_MS[4,],stats_highest_degree_PhD[4,])
colnames(mean_highest_degree) <- c("MS", "PhD")
mean_highest_degree_plots <- t(mean_highest_degree)
mean_highest_degree <- cbind(mean_highest_degree, P_MS_PhD)

myfile <- paste(path,"mean_test_ks_highest_degree.txt", sep="")
write.table(mean_highest_degree, file = myfile, sep = "\t")


###
# test for differences by year of degree earned
###

Q1_2010 <- survey_data$Q13_1[survey_data$Q18=="2010"]
Q1_2000 <- survey_data$Q13_1[survey_data$Q18=="2000"]
Q1_1990 <- survey_data$Q13_1[survey_data$Q18=="1990"]
Q1_1980 <- survey_data$Q13_1[survey_data$Q18=="1980"]
Q1_1970 <- survey_data$Q13_1[survey_data$Q18=="1970"]

Q2_2010 <- survey_data$Q13_2[survey_data$Q18=="2010"]
Q2_2000 <- survey_data$Q13_2[survey_data$Q18=="2000"]
Q2_1990 <- survey_data$Q13_2[survey_data$Q18=="1990"]
Q2_1980 <- survey_data$Q13_2[survey_data$Q18=="1980"]
Q2_1970 <- survey_data$Q13_2[survey_data$Q18=="1970"]

Q3_2010 <- survey_data$Q13_3[survey_data$Q18=="2010"]
Q3_2000 <- survey_data$Q13_3[survey_data$Q18=="2000"]
Q3_1990 <- survey_data$Q13_3[survey_data$Q18=="1990"]
Q3_1980 <- survey_data$Q13_3[survey_data$Q18=="1980"]
Q3_1970 <- survey_data$Q13_3[survey_data$Q18=="1970"]

Q4_2010 <- survey_data$Q13_4[survey_data$Q18=="2010"]
Q4_2000 <- survey_data$Q13_4[survey_data$Q18=="2000"]
Q4_1990 <- survey_data$Q13_4[survey_data$Q18=="1990"]
Q4_1980 <- survey_data$Q13_4[survey_data$Q18=="1980"]
Q4_1970 <- survey_data$Q13_4[survey_data$Q18=="1970"]

Q5_2010 <- survey_data$Q13_5[survey_data$Q18=="2010"]
Q5_2000 <- survey_data$Q13_5[survey_data$Q18=="2000"]
Q5_1990 <- survey_data$Q13_5[survey_data$Q18=="1990"]
Q5_1980 <- survey_data$Q13_5[survey_data$Q18=="1980"]
Q5_1970 <- survey_data$Q13_5[survey_data$Q18=="1970"]

Q6_2010 <- survey_data$Q13_6[survey_data$Q18=="2010"]
Q6_2000 <- survey_data$Q13_6[survey_data$Q18=="2000"]
Q6_1990 <- survey_data$Q13_6[survey_data$Q18=="1990"]
Q6_1980 <- survey_data$Q13_6[survey_data$Q18=="1980"]
Q6_1970 <- survey_data$Q13_6[survey_data$Q18=="1970"]

Q7_2010 <- survey_data$Q13_7[survey_data$Q18=="2010"]
Q7_2000 <- survey_data$Q13_7[survey_data$Q18=="2000"]
Q7_1990 <- survey_data$Q13_7[survey_data$Q18=="1990"]
Q7_1980 <- survey_data$Q13_7[survey_data$Q18=="1980"]
Q7_1970 <- survey_data$Q13_7[survey_data$Q18=="1970"]

Q8_2010 <- survey_data$Q13_8[survey_data$Q18=="2010"]
Q8_2000 <- survey_data$Q13_8[survey_data$Q18=="2000"]
Q8_1990 <- survey_data$Q13_8[survey_data$Q18=="1990"]
Q8_1980 <- survey_data$Q13_8[survey_data$Q18=="1980"]
Q8_1970 <- survey_data$Q13_8[survey_data$Q18=="1970"]

Q9_2010 <- survey_data$Q13_9[survey_data$Q18=="2010"]
Q9_2000 <- survey_data$Q13_9[survey_data$Q18=="2000"]
Q9_1990 <- survey_data$Q13_9[survey_data$Q18=="1990"]
Q9_1980 <- survey_data$Q13_9[survey_data$Q18=="1980"]
Q9_1970 <- survey_data$Q13_9[survey_data$Q18=="1970"]

Q10_2010 <- survey_data$Q13_10[survey_data$Q18=="2010"]
Q10_2000 <- survey_data$Q13_10[survey_data$Q18=="2000"]
Q10_1990 <- survey_data$Q13_10[survey_data$Q18=="1990"]
Q10_1980 <- survey_data$Q13_10[survey_data$Q18=="1980"]
Q10_1970 <- survey_data$Q13_10[survey_data$Q18=="1970"]

Q11_2010 <- survey_data$Q13_11[survey_data$Q18=="2010"]
Q11_2000 <- survey_data$Q13_11[survey_data$Q18=="2000"]
Q11_1990 <- survey_data$Q13_11[survey_data$Q18=="1990"]
Q11_1980 <- survey_data$Q13_11[survey_data$Q18=="1980"]
Q11_1970 <- survey_data$Q13_11[survey_data$Q18=="1970"]

Q12_2010 <- survey_data$Q13_12[survey_data$Q18=="2010"]
Q12_2000 <- survey_data$Q13_12[survey_data$Q18=="2000"]
Q12_1990 <- survey_data$Q13_12[survey_data$Q18=="1990"]
Q12_1980 <- survey_data$Q13_12[survey_data$Q18=="1980"]
Q12_1970 <- survey_data$Q13_12[survey_data$Q18=="1970"]

Q13_2010 <- survey_data$Q13_13[survey_data$Q18=="2010"]
Q13_2000 <- survey_data$Q13_13[survey_data$Q18=="2000"]
Q13_1990 <- survey_data$Q13_13[survey_data$Q18=="1990"]
Q13_1980 <- survey_data$Q13_13[survey_data$Q18=="1980"]
Q13_1970 <- survey_data$Q13_13[survey_data$Q18=="1970"]

Q14_2010 <- survey_data$Q13_14[survey_data$Q18=="2010"]
Q14_2000 <- survey_data$Q13_14[survey_data$Q18=="2000"]
Q14_1990 <- survey_data$Q13_14[survey_data$Q18=="1990"]
Q14_1980 <- survey_data$Q13_14[survey_data$Q18=="1980"]
Q14_1970 <- survey_data$Q13_14[survey_data$Q18=="1970"]

Q15_2010 <- survey_data$Q13_15[survey_data$Q18=="2010"]
Q15_2000 <- survey_data$Q13_15[survey_data$Q18=="2000"]
Q15_1990 <- survey_data$Q13_15[survey_data$Q18=="1990"]
Q15_1980 <- survey_data$Q13_15[survey_data$Q18=="1980"]
Q15_1970 <- survey_data$Q13_15[survey_data$Q18=="1970"]

#First for 2010-2000
ks_earned <- list()
ks_earned[[1]] <- ks.test(Q1_2010, Q1_2000)
ks_earned[[2]] <- ks.test(Q2_2010, Q2_2000)
ks_earned[[3]] <- ks.test(Q3_2010, Q3_2000)
ks_earned[[4]] <- ks.test(Q4_2010, Q4_2000)
ks_earned[[5]] <- ks.test(Q5_2010, Q5_2000)

ks_earned[[6]] <- ks.test(Q6_2010, Q6_2000)
ks_earned[[7]] <- ks.test(Q7_2010, Q7_2000)
ks_earned[[8]] <- ks.test(Q8_2010, Q8_2000)
ks_earned[[9]] <- ks.test(Q9_2010, Q9_2000)
ks_earned[[10]] <- ks.test(Q10_2010, Q10_2000)

ks_earned[[11]] <- ks.test(Q11_2010, Q11_2000)
ks_earned[[12]] <- ks.test(Q12_2010, Q12_2000)
ks_earned[[13]] <- ks.test(Q13_2010, Q13_2000)
ks_earned[[14]] <- ks.test(Q14_2010, Q14_2000)
ks_earned[[15]] <- ks.test(Q15_2010, Q15_2000)

test_ks_earned <- sapply(ks_earned, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_earned) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_2010_2000 <- test_ks_earned[2,]

#Next for 2010-1990
ks_earned <- list()
ks_earned[[1]] <- ks.test(Q1_2010, Q1_1990)
ks_earned[[2]] <- ks.test(Q2_2010, Q2_1990)
ks_earned[[3]] <- ks.test(Q3_2010, Q3_1990)
ks_earned[[4]] <- ks.test(Q4_2010, Q4_1990)
ks_earned[[5]] <- ks.test(Q5_2010, Q5_1990)

ks_earned[[6]] <- ks.test(Q6_2010, Q6_1990)
ks_earned[[7]] <- ks.test(Q7_2010, Q7_1990)
ks_earned[[8]] <- ks.test(Q8_2010, Q8_1990)
ks_earned[[9]] <- ks.test(Q9_2010, Q9_1990)
ks_earned[[10]] <- ks.test(Q10_2010, Q10_1990)

ks_earned[[11]] <- ks.test(Q11_2010, Q11_1990)
ks_earned[[12]] <- ks.test(Q12_2010, Q12_1990)
ks_earned[[13]] <- ks.test(Q13_2010, Q13_1990)
ks_earned[[14]] <- ks.test(Q14_2010, Q14_1990)
ks_earned[[15]] <- ks.test(Q15_2010, Q15_1990)

test_ks_earned <- sapply(ks_earned, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_earned) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_2010_1990 <- test_ks_earned[2,]

#Next for 2010-1980
ks_earned <- list()
ks_earned[[1]] <- ks.test(Q1_2010, Q1_1980)
ks_earned[[2]] <- ks.test(Q2_2010, Q2_1980)
ks_earned[[3]] <- ks.test(Q3_2010, Q3_1980)
ks_earned[[4]] <- ks.test(Q4_2010, Q4_1980)
ks_earned[[5]] <- ks.test(Q5_2010, Q5_1980)

ks_earned[[6]] <- ks.test(Q6_2010, Q6_1980)
ks_earned[[7]] <- ks.test(Q7_2010, Q7_1980)
ks_earned[[8]] <- ks.test(Q8_2010, Q8_1980)
ks_earned[[9]] <- ks.test(Q9_2010, Q9_1980)
ks_earned[[10]] <- ks.test(Q10_2010, Q10_1980)

ks_earned[[11]] <- ks.test(Q11_2010, Q11_1980)
ks_earned[[12]] <- ks.test(Q12_2010, Q12_1980)
ks_earned[[13]] <- ks.test(Q13_2010, Q13_1980)
ks_earned[[14]] <- ks.test(Q14_2010, Q14_1980)
ks_earned[[15]] <- ks.test(Q15_2010, Q15_1980)

test_ks_earned <- sapply(ks_earned, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_earned) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_2010_1980 <- test_ks_earned[2,]

#Next for 2010-1970
ks_earned <- list()
ks_earned[[1]] <- ks.test(Q1_2010, Q1_1970)
ks_earned[[2]] <- ks.test(Q2_2010, Q2_1970)
ks_earned[[3]] <- ks.test(Q3_2010, Q3_1970)
ks_earned[[4]] <- ks.test(Q4_2010, Q4_1970)
ks_earned[[5]] <- ks.test(Q5_2010, Q5_1970)

ks_earned[[6]] <- ks.test(Q6_2010, Q6_1970)
ks_earned[[7]] <- ks.test(Q7_2010, Q7_1970)
ks_earned[[8]] <- ks.test(Q8_2010, Q8_1970)
ks_earned[[9]] <- ks.test(Q9_2010, Q9_1970)
ks_earned[[10]] <- ks.test(Q10_2010, Q10_1970)

ks_earned[[11]] <- ks.test(Q11_2010, Q11_1970)
ks_earned[[12]] <- ks.test(Q12_2010, Q12_1970)
ks_earned[[13]] <- ks.test(Q13_2010, Q13_1970)
ks_earned[[14]] <- ks.test(Q14_2010, Q14_1970)
ks_earned[[15]] <- ks.test(Q15_2010, Q15_1970)

test_ks_earned <- sapply(ks_earned, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_earned) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_2010_1970 <- test_ks_earned[2,]


#Next for 2000-1990

ks_earned <- list()
ks_earned[[1]] <- ks.test(Q1_2000, Q1_1990)
ks_earned[[2]] <- ks.test(Q2_2000, Q2_1990)
ks_earned[[3]] <- ks.test(Q3_2000, Q3_1990)
ks_earned[[4]] <- ks.test(Q4_2000, Q4_1990)
ks_earned[[5]] <- ks.test(Q5_2000, Q5_1990)

ks_earned[[6]] <- ks.test(Q6_2000, Q6_1990)
ks_earned[[7]] <- ks.test(Q7_2000, Q7_1990)
ks_earned[[8]] <- ks.test(Q8_2000, Q8_1990)
ks_earned[[9]] <- ks.test(Q9_2000, Q9_1990)
ks_earned[[10]] <- ks.test(Q10_2000, Q10_1990)

ks_earned[[11]] <- ks.test(Q11_2000, Q11_1990)
ks_earned[[12]] <- ks.test(Q12_2000, Q12_1990)
ks_earned[[13]] <- ks.test(Q13_2000, Q13_1990)
ks_earned[[14]] <- ks.test(Q14_2000, Q14_1990)
ks_earned[[15]] <- ks.test(Q15_2000, Q15_1990)

test_ks_earned <- sapply(ks_earned, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_earned) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_2000_1990 <- test_ks_earned[2,]

#Next for 2000-1980

ks_earned <- list()
ks_earned[[1]] <- ks.test(Q1_2000, Q1_1980)
ks_earned[[2]] <- ks.test(Q2_2000, Q2_1980)
ks_earned[[3]] <- ks.test(Q3_2000, Q3_1980)
ks_earned[[4]] <- ks.test(Q4_2000, Q4_1980)
ks_earned[[5]] <- ks.test(Q5_2000, Q5_1980)

ks_earned[[6]] <- ks.test(Q6_2000, Q6_1980)
ks_earned[[7]] <- ks.test(Q7_2000, Q7_1980)
ks_earned[[8]] <- ks.test(Q8_2000, Q8_1980)
ks_earned[[9]] <- ks.test(Q9_2000, Q9_1980)
ks_earned[[10]] <- ks.test(Q10_2000, Q10_1980)

ks_earned[[11]] <- ks.test(Q11_2000, Q11_1980)
ks_earned[[12]] <- ks.test(Q12_2000, Q12_1980)
ks_earned[[13]] <- ks.test(Q13_2000, Q13_1980)
ks_earned[[14]] <- ks.test(Q14_2000, Q14_1980)
ks_earned[[15]] <- ks.test(Q15_2000, Q15_1980)

test_ks_earned <- sapply(ks_earned, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_earned) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_2000_1980 <- test_ks_earned[2,]

#Next for 2000-1970

ks_earned <- list()
ks_earned[[1]] <- ks.test(Q1_2000, Q1_1970)
ks_earned[[2]] <- ks.test(Q2_2000, Q2_1970)
ks_earned[[3]] <- ks.test(Q3_2000, Q3_1970)
ks_earned[[4]] <- ks.test(Q4_2000, Q4_1970)
ks_earned[[5]] <- ks.test(Q5_2000, Q5_1970)

ks_earned[[6]] <- ks.test(Q6_2000, Q6_1970)
ks_earned[[7]] <- ks.test(Q7_2000, Q7_1970)
ks_earned[[8]] <- ks.test(Q8_2000, Q8_1970)
ks_earned[[9]] <- ks.test(Q9_2000, Q9_1970)
ks_earned[[10]] <- ks.test(Q10_2000, Q10_1970)

ks_earned[[11]] <- ks.test(Q11_2000, Q11_1970)
ks_earned[[12]] <- ks.test(Q12_2000, Q12_1970)
ks_earned[[13]] <- ks.test(Q13_2000, Q13_1970)
ks_earned[[14]] <- ks.test(Q14_2000, Q14_1970)
ks_earned[[15]] <- ks.test(Q15_2000, Q15_1970)

test_ks_earned <- sapply(ks_earned, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_earned) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_2000_1970 <- test_ks_earned[2,]

#Next for 1990-1980
ks_earned <- list()
ks_earned[[1]] <- ks.test(Q1_1990, Q1_1980)
ks_earned[[2]] <- ks.test(Q2_1990, Q2_1980)
ks_earned[[3]] <- ks.test(Q3_1990, Q3_1980)
ks_earned[[4]] <- ks.test(Q4_1990, Q4_1980)
ks_earned[[5]] <- ks.test(Q5_1990, Q5_1980)

ks_earned[[6]] <- ks.test(Q6_1990, Q6_1980)
ks_earned[[7]] <- ks.test(Q7_1990, Q7_1980)
ks_earned[[8]] <- ks.test(Q8_1990, Q8_1980)
ks_earned[[9]] <- ks.test(Q9_1990, Q9_1980)
ks_earned[[10]] <- ks.test(Q10_1990, Q10_1980)

ks_earned[[11]] <- ks.test(Q11_1990, Q11_1980)
ks_earned[[12]] <- ks.test(Q12_1990, Q12_1980)
ks_earned[[13]] <- ks.test(Q13_1990, Q13_1980)
ks_earned[[14]] <- ks.test(Q14_1990, Q14_1980)
ks_earned[[15]] <- ks.test(Q15_1990, Q15_1980)

test_ks_earned <- sapply(ks_earned, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_earned) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_1990_1980 <- test_ks_earned[2,]

#Next for 1990-1970
ks_earned <- list()
ks_earned[[1]] <- ks.test(Q1_1990, Q1_1970)
ks_earned[[2]] <- ks.test(Q2_1990, Q2_1970)
ks_earned[[3]] <- ks.test(Q3_1990, Q3_1970)
ks_earned[[4]] <- ks.test(Q4_1990, Q4_1970)
ks_earned[[5]] <- ks.test(Q5_1990, Q5_1970)

ks_earned[[6]] <- ks.test(Q6_1990, Q6_1970)
ks_earned[[7]] <- ks.test(Q7_1990, Q7_1970)
ks_earned[[8]] <- ks.test(Q8_1990, Q8_1970)
ks_earned[[9]] <- ks.test(Q9_1990, Q9_1970)
ks_earned[[10]] <- ks.test(Q10_1990, Q10_1970)

ks_earned[[11]] <- ks.test(Q11_1990, Q11_1970)
ks_earned[[12]] <- ks.test(Q12_1990, Q12_1970)
ks_earned[[13]] <- ks.test(Q13_1990, Q13_1970)
ks_earned[[14]] <- ks.test(Q14_1990, Q14_1970)
ks_earned[[15]] <- ks.test(Q15_1990, Q15_1970)

test_ks_earned <- sapply(ks_earned, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_earned) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_1990_1970 <- test_ks_earned[2,]

#Next for 1980-1970
ks_earned <- list()
ks_earned[[1]] <- ks.test(Q1_1980, Q1_1970)
ks_earned[[2]] <- ks.test(Q2_1980, Q2_1970)
ks_earned[[3]] <- ks.test(Q3_1980, Q3_1970)
ks_earned[[4]] <- ks.test(Q4_1980, Q4_1970)
ks_earned[[5]] <- ks.test(Q5_1980, Q5_1970)

ks_earned[[6]] <- ks.test(Q6_1980, Q6_1970)
ks_earned[[7]] <- ks.test(Q7_1980, Q7_1970)
ks_earned[[8]] <- ks.test(Q8_1980, Q8_1970)
ks_earned[[9]] <- ks.test(Q9_1980, Q9_1970)
ks_earned[[10]] <- ks.test(Q10_1980, Q10_1970)

ks_earned[[11]] <- ks.test(Q11_1980, Q11_1970)
ks_earned[[12]] <- ks.test(Q12_1980, Q12_1970)
ks_earned[[13]] <- ks.test(Q13_1980, Q13_1970)
ks_earned[[14]] <- ks.test(Q14_1980, Q14_1970)
ks_earned[[15]] <- ks.test(Q15_1980, Q15_1970)

test_ks_earned <- sapply(ks_earned, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_earned) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_1980_1970 <- test_ks_earned[2,]


# Get means
stats_earned_2010 <- cbind(summary(Q1_2010),summary(Q2_2010),summary(Q3_2010),summary(Q4_2010),summary(Q5_2010),summary(Q6_2010),summary(Q7_2010),summary(Q8_2010),summary(Q9_2010),summary(Q10_2010),summary(Q11_2010),summary(Q12_2010),summary(Q13_2010),summary(Q14_2010),summary(Q15_2010))
colnames(stats_earned_2010) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_earned_2000 <- cbind(summary(Q1_2000),summary(Q2_2000),summary(Q3_2000),summary(Q4_2000),summary(Q5_2000),summary(Q6_2000),summary(Q7_2000),summary(Q8_2000),summary(Q9_2000),summary(Q10_2000),summary(Q11_2000),summary(Q12_2000),summary(Q13_2000),summary(Q14_2000),summary(Q15_2000))
colnames(stats_earned_2000) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_earned_1990 <- cbind(summary(Q1_1990),summary(Q2_1990),summary(Q3_1990),summary(Q4_1990),summary(Q5_1990),summary(Q6_1990),summary(Q7_1990),summary(Q8_1990),summary(Q9_1990),summary(Q10_1990),summary(Q11_1990),summary(Q12_1990),summary(Q13_1990),summary(Q14_1990),summary(Q15_1990))
colnames(stats_earned_1990) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_earned_1980 <- cbind(summary(Q1_1980),summary(Q2_1980),summary(Q3_1980),summary(Q4_1980),summary(Q5_1980),summary(Q6_1980),summary(Q7_1980),summary(Q8_1980),summary(Q9_1980),summary(Q10_1980),summary(Q11_1980),summary(Q12_1980),summary(Q13_1980),summary(Q14_1980),summary(Q15_1980))
colnames(stats_earned_1980) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_earned_1970 <- cbind(summary(Q1_1970),summary(Q2_1970),summary(Q3_1970),summary(Q4_1970),summary(Q5_1970),summary(Q6_1970),summary(Q7_1970),summary(Q8_1970),summary(Q9_1970),summary(Q10_1970),summary(Q11_1970),summary(Q12_1970),summary(Q13_1970),summary(Q14_1970),summary(Q15_1970))
colnames(stats_earned_1970) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")


mean_earned <- cbind(stats_earned_1970[4,],stats_earned_1980[4,],stats_earned_1990[4,],stats_earned_2000[4,],stats_earned_2010[4,])
# colnames(mean_earned) <- c("1970","1980","1990","2000","2010")
colnames(mean_earned) <- c("Before 1980","1980-1989","1990-1999","2000-2009","After 2009")
mean_earned_plots <- t(mean_earned)
mean_earned <- cbind(mean_earned, P_1980_1970, P_1990_1970, P_1990_1980, P_2000_1970, P_2000_1980, P_2000_1990, P_2010_1970, P_2010_1980, P_2010_1990, P_2010_2000)

myfile <- paste(path,"mean_test_ks_earned.txt", sep="")
write.table(mean_earned, file = myfile, sep = "\t")


###
# test for differences by bioinformatics training
###


Q1_no <- survey_data$Q13_1[survey_data$Q3=="1"]
Q1_self <- survey_data$Q13_1[survey_data$Q3=="2"]
Q1_short <- survey_data$Q13_1[survey_data$Q3=="3"]
Q1_U <- survey_data$Q13_1[survey_data$Q3=="4"]
Q1_U <- survey_data$Q13_1[survey_data$Q3=="6"]
Q1_U <- survey_data$Q13_1[survey_data$Q3=="7"]
Q1_G_cla <- survey_data$Q13_1[survey_data$Q3=="8"]
Q1_G_deg <- survey_data$Q13_1[survey_data$Q3=="9"]

Q2_no <- survey_data$Q13_2[survey_data$Q3=="1"]
Q2_self <- survey_data$Q13_2[survey_data$Q3=="2"]
Q2_short <- survey_data$Q13_2[survey_data$Q3=="3"]
Q2_U <- survey_data$Q13_2[survey_data$Q3=="4"]
Q2_U <- survey_data$Q13_2[survey_data$Q3=="6"]
Q2_U <- survey_data$Q13_2[survey_data$Q3=="7"]
Q2_G_cla <- survey_data$Q13_2[survey_data$Q3=="8"]
Q2_G_deg <- survey_data$Q13_2[survey_data$Q3=="9"]

Q3_no <- survey_data$Q13_3[survey_data$Q3=="1"]
Q3_self <- survey_data$Q13_3[survey_data$Q3=="2"]
Q3_short <- survey_data$Q13_3[survey_data$Q3=="3"]
Q3_U <- survey_data$Q13_3[survey_data$Q3=="4"]
Q3_U <- survey_data$Q13_3[survey_data$Q3=="6"]
Q3_U <- survey_data$Q13_3[survey_data$Q3=="7"]
Q3_G_cla <- survey_data$Q13_3[survey_data$Q3=="8"]
Q3_G_deg <- survey_data$Q13_3[survey_data$Q3=="9"]

Q4_no <- survey_data$Q13_4[survey_data$Q3=="1"]
Q4_self <- survey_data$Q13_4[survey_data$Q3=="2"]
Q4_short <- survey_data$Q13_4[survey_data$Q3=="3"]
Q4_U <- survey_data$Q13_4[survey_data$Q3=="4"]
Q4_U <- survey_data$Q13_4[survey_data$Q3=="6"]
Q4_U <- survey_data$Q13_4[survey_data$Q3=="7"]
Q4_G_cla <- survey_data$Q13_4[survey_data$Q3=="8"]
Q4_G_deg <- survey_data$Q13_4[survey_data$Q3=="9"]

Q5_no <- survey_data$Q13_5[survey_data$Q3=="1"]
Q5_self <- survey_data$Q13_5[survey_data$Q3=="2"]
Q5_short <- survey_data$Q13_5[survey_data$Q3=="3"]
Q5_U <- survey_data$Q13_5[survey_data$Q3=="4"]
Q5_U <- survey_data$Q13_5[survey_data$Q3=="6"]
Q5_U <- survey_data$Q13_5[survey_data$Q3=="7"]
Q5_G_cla <- survey_data$Q13_5[survey_data$Q3=="8"]
Q5_G_deg <- survey_data$Q13_5[survey_data$Q3=="9"]

Q6_no <- survey_data$Q13_6[survey_data$Q3=="1"]
Q6_self <- survey_data$Q13_6[survey_data$Q3=="2"]
Q6_short <- survey_data$Q13_6[survey_data$Q3=="3"]
Q6_U <- survey_data$Q13_6[survey_data$Q3=="4"]
Q6_U <- survey_data$Q13_6[survey_data$Q3=="6"]
Q6_U <- survey_data$Q13_6[survey_data$Q3=="7"]
Q6_G_cla <- survey_data$Q13_6[survey_data$Q3=="8"]
Q6_G_deg <- survey_data$Q13_6[survey_data$Q3=="9"]

Q7_no <- survey_data$Q13_7[survey_data$Q3=="1"]
Q7_self <- survey_data$Q13_7[survey_data$Q3=="2"]
Q7_short <- survey_data$Q13_7[survey_data$Q3=="3"]
Q7_U <- survey_data$Q13_7[survey_data$Q3=="4"]
Q7_U <- survey_data$Q13_7[survey_data$Q3=="6"]
Q7_U <- survey_data$Q13_7[survey_data$Q3=="7"]
Q7_G_cla <- survey_data$Q13_7[survey_data$Q3=="8"]
Q7_G_deg <- survey_data$Q13_7[survey_data$Q3=="9"]

Q8_no <- survey_data$Q13_8[survey_data$Q3=="1"]
Q8_self <- survey_data$Q13_8[survey_data$Q3=="2"]
Q8_short <- survey_data$Q13_8[survey_data$Q3=="3"]
Q8_U <- survey_data$Q13_8[survey_data$Q3=="4"]
Q8_U <- survey_data$Q13_8[survey_data$Q3=="6"]
Q8_U <- survey_data$Q13_8[survey_data$Q3=="7"]
Q8_G_cla <- survey_data$Q13_8[survey_data$Q3=="8"]
Q8_G_deg <- survey_data$Q13_8[survey_data$Q3=="9"]

Q9_no <- survey_data$Q13_9[survey_data$Q3=="1"]
Q9_self <- survey_data$Q13_9[survey_data$Q3=="2"]
Q9_short <- survey_data$Q13_9[survey_data$Q3=="3"]
Q9_U <- survey_data$Q13_9[survey_data$Q3=="4"]
Q9_U <- survey_data$Q13_9[survey_data$Q3=="6"]
Q9_U <- survey_data$Q13_9[survey_data$Q3=="7"]
Q9_G_cla <- survey_data$Q13_9[survey_data$Q3=="8"]
Q9_G_deg <- survey_data$Q13_9[survey_data$Q3=="9"]

Q10_no <- survey_data$Q13_10[survey_data$Q3=="1"]
Q10_self <- survey_data$Q13_10[survey_data$Q3=="2"]
Q10_short <- survey_data$Q13_10[survey_data$Q3=="3"]
Q10_U <- survey_data$Q13_10[survey_data$Q3=="4"]
Q10_U <- survey_data$Q13_10[survey_data$Q3=="6"]
Q10_U <- survey_data$Q13_10[survey_data$Q3=="7"]
Q10_G_cla <- survey_data$Q13_10[survey_data$Q3=="8"]
Q10_G_deg <- survey_data$Q13_10[survey_data$Q3=="9"]

Q11_no <- survey_data$Q13_11[survey_data$Q3=="1"]
Q11_self <- survey_data$Q13_11[survey_data$Q3=="2"]
Q11_short <- survey_data$Q13_11[survey_data$Q3=="3"]
Q11_U <- survey_data$Q13_11[survey_data$Q3=="4"]
Q11_U <- survey_data$Q13_11[survey_data$Q3=="6"]
Q11_U <- survey_data$Q13_11[survey_data$Q3=="7"]
Q11_G_cla <- survey_data$Q13_11[survey_data$Q3=="8"]
Q11_G_deg <- survey_data$Q13_11[survey_data$Q3=="9"]

Q12_no <- survey_data$Q13_12[survey_data$Q3=="1"]
Q12_self <- survey_data$Q13_12[survey_data$Q3=="2"]
Q12_short <- survey_data$Q13_12[survey_data$Q3=="3"]
Q12_U <- survey_data$Q13_12[survey_data$Q3=="4"]
Q12_U <- survey_data$Q13_12[survey_data$Q3=="6"]
Q12_U <- survey_data$Q13_12[survey_data$Q3=="7"]
Q12_G_cla <- survey_data$Q13_12[survey_data$Q3=="8"]
Q12_G_deg <- survey_data$Q13_12[survey_data$Q3=="9"]

Q13_no <- survey_data$Q13_13[survey_data$Q3=="1"]
Q13_self <- survey_data$Q13_13[survey_data$Q3=="2"]
Q13_short <- survey_data$Q13_13[survey_data$Q3=="3"]
Q13_U <- survey_data$Q13_13[survey_data$Q3=="4"]
Q13_U <- survey_data$Q13_13[survey_data$Q3=="6"]
Q13_U <- survey_data$Q13_13[survey_data$Q3=="7"]
Q13_G_cla <- survey_data$Q13_13[survey_data$Q3=="8"]
Q13_G_deg <- survey_data$Q13_13[survey_data$Q3=="9"]

Q14_no <- survey_data$Q13_14[survey_data$Q3=="1"]
Q14_self <- survey_data$Q13_14[survey_data$Q3=="2"]
Q14_short <- survey_data$Q13_14[survey_data$Q3=="3"]
Q14_U <- survey_data$Q13_14[survey_data$Q3=="4"]
Q14_U <- survey_data$Q13_14[survey_data$Q3=="6"]
Q14_U <- survey_data$Q13_14[survey_data$Q3=="7"]
Q14_G_cla <- survey_data$Q13_14[survey_data$Q3=="8"]
Q14_G_deg <- survey_data$Q13_14[survey_data$Q3=="9"]

Q15_no <- survey_data$Q13_15[survey_data$Q3=="1"]
Q15_self <- survey_data$Q13_15[survey_data$Q3=="2"]
Q15_short <- survey_data$Q13_15[survey_data$Q3=="3"]
Q15_U <- survey_data$Q13_15[survey_data$Q3=="4"]
Q15_U <- survey_data$Q13_15[survey_data$Q3=="6"]
Q15_U <- survey_data$Q13_15[survey_data$Q3=="7"]
Q15_G_cla <- survey_data$Q13_15[survey_data$Q3=="8"]
Q15_G_deg <- survey_data$Q13_15[survey_data$Q3=="9"]

#First for no-self
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_no, Q1_self)
ks_bx_training[[2]] <- ks.test(Q2_no, Q2_self)
ks_bx_training[[3]] <- ks.test(Q3_no, Q3_self)
ks_bx_training[[4]] <- ks.test(Q4_no, Q4_self)
ks_bx_training[[5]] <- ks.test(Q5_no, Q5_self)

ks_bx_training[[6]] <- ks.test(Q6_no, Q6_self)
ks_bx_training[[7]] <- ks.test(Q7_no, Q7_self)
ks_bx_training[[8]] <- ks.test(Q8_no, Q8_self)
ks_bx_training[[9]] <- ks.test(Q9_no, Q9_self)
ks_bx_training[[10]] <- ks.test(Q10_no, Q10_self)

ks_bx_training[[11]] <- ks.test(Q11_no, Q11_self)
ks_bx_training[[12]] <- ks.test(Q12_no, Q12_self)
ks_bx_training[[13]] <- ks.test(Q13_no, Q13_self)
ks_bx_training[[14]] <- ks.test(Q14_no, Q14_self)
ks_bx_training[[15]] <- ks.test(Q15_no, Q15_self)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_no_self <- test_ks_bx_training[2,]

#Next for no-short
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_no, Q1_short)
ks_bx_training[[2]] <- ks.test(Q2_no, Q2_short)
ks_bx_training[[3]] <- ks.test(Q3_no, Q3_short)
ks_bx_training[[4]] <- ks.test(Q4_no, Q4_short)
ks_bx_training[[5]] <- ks.test(Q5_no, Q5_short)

ks_bx_training[[6]] <- ks.test(Q6_no, Q6_short)
ks_bx_training[[7]] <- ks.test(Q7_no, Q7_short)
ks_bx_training[[8]] <- ks.test(Q8_no, Q8_short)
ks_bx_training[[9]] <- ks.test(Q9_no, Q9_short)
ks_bx_training[[10]] <- ks.test(Q10_no, Q10_short)

ks_bx_training[[11]] <- ks.test(Q11_no, Q11_short)
ks_bx_training[[12]] <- ks.test(Q12_no, Q12_short)
ks_bx_training[[13]] <- ks.test(Q13_no, Q13_short)
ks_bx_training[[14]] <- ks.test(Q14_no, Q14_short)
ks_bx_training[[15]] <- ks.test(Q15_no, Q15_short)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_no_short <- test_ks_bx_training[2,]

#Next for no-U

ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_no, Q1_U)
ks_bx_training[[2]] <- ks.test(Q2_no, Q2_U)
ks_bx_training[[3]] <- ks.test(Q3_no, Q3_U)
ks_bx_training[[4]] <- ks.test(Q4_no, Q4_U)
ks_bx_training[[5]] <- ks.test(Q5_no, Q5_U)

ks_bx_training[[6]] <- ks.test(Q6_no, Q6_U)
ks_bx_training[[7]] <- ks.test(Q7_no, Q7_U)
ks_bx_training[[8]] <- ks.test(Q8_no, Q8_U)
ks_bx_training[[9]] <- ks.test(Q9_no, Q9_U)
ks_bx_training[[10]] <- ks.test(Q10_no, Q10_U)

ks_bx_training[[11]] <- ks.test(Q11_no, Q11_U)
ks_bx_training[[12]] <- ks.test(Q12_no, Q12_U)
ks_bx_training[[13]] <- ks.test(Q13_no, Q13_U)
ks_bx_training[[14]] <- ks.test(Q14_no, Q14_U)
ks_bx_training[[15]] <- ks.test(Q15_no, Q15_U)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_no_U <- test_ks_bx_training[2,]

#Next for no-G_cla
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_no, Q1_G_cla)
ks_bx_training[[2]] <- ks.test(Q2_no, Q2_G_cla)
ks_bx_training[[3]] <- ks.test(Q3_no, Q3_G_cla)
ks_bx_training[[4]] <- ks.test(Q4_no, Q4_G_cla)
ks_bx_training[[5]] <- ks.test(Q5_no, Q5_G_cla)

ks_bx_training[[6]] <- ks.test(Q6_no, Q6_G_cla)
ks_bx_training[[7]] <- ks.test(Q7_no, Q7_G_cla)
ks_bx_training[[8]] <- ks.test(Q8_no, Q8_G_cla)
ks_bx_training[[9]] <- ks.test(Q9_no, Q9_G_cla)
ks_bx_training[[10]] <- ks.test(Q10_no, Q10_G_cla)

ks_bx_training[[11]] <- ks.test(Q11_no, Q11_G_cla)
ks_bx_training[[12]] <- ks.test(Q12_no, Q12_G_cla)
ks_bx_training[[13]] <- ks.test(Q13_no, Q13_G_cla)
ks_bx_training[[14]] <- ks.test(Q14_no, Q14_G_cla)
ks_bx_training[[15]] <- ks.test(Q15_no, Q15_U_cla)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_no_G_cla <- test_ks_bx_training[2,]

#Next for no-G_deg
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_no, Q1_G_deg)
ks_bx_training[[2]] <- ks.test(Q2_no, Q2_G_deg)
ks_bx_training[[3]] <- ks.test(Q3_no, Q3_G_deg)
ks_bx_training[[4]] <- ks.test(Q4_no, Q4_G_deg)
ks_bx_training[[5]] <- ks.test(Q5_no, Q5_G_deg)

ks_bx_training[[6]] <- ks.test(Q6_no, Q6_G_deg)
ks_bx_training[[7]] <- ks.test(Q7_no, Q7_G_deg)
ks_bx_training[[8]] <- ks.test(Q8_no, Q8_G_deg)
ks_bx_training[[9]] <- ks.test(Q9_no, Q9_G_deg)
ks_bx_training[[10]] <- ks.test(Q10_no, Q10_G_deg)

ks_bx_training[[11]] <- ks.test(Q11_no, Q11_G_deg)
ks_bx_training[[12]] <- ks.test(Q12_no, Q12_G_deg)
ks_bx_training[[13]] <- ks.test(Q13_no, Q13_G_deg)
ks_bx_training[[14]] <- ks.test(Q14_no, Q14_G_deg)
ks_bx_training[[15]] <- ks.test(Q15_no, Q15_U_cla)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_no_G_deg <- test_ks_bx_training[2,]

#Next for self-short
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_self, Q1_short)
ks_bx_training[[2]] <- ks.test(Q2_self, Q2_short)
ks_bx_training[[3]] <- ks.test(Q3_self, Q3_short)
ks_bx_training[[4]] <- ks.test(Q4_self, Q4_short)
ks_bx_training[[5]] <- ks.test(Q5_self, Q5_short)

ks_bx_training[[6]] <- ks.test(Q6_self, Q6_short)
ks_bx_training[[7]] <- ks.test(Q7_self, Q7_short)
ks_bx_training[[8]] <- ks.test(Q8_self, Q8_short)
ks_bx_training[[9]] <- ks.test(Q9_self, Q9_short)
ks_bx_training[[10]] <- ks.test(Q10_self, Q10_short)

ks_bx_training[[11]] <- ks.test(Q11_self, Q11_short)
ks_bx_training[[12]] <- ks.test(Q12_self, Q12_short)
ks_bx_training[[13]] <- ks.test(Q13_self, Q13_short)
ks_bx_training[[14]] <- ks.test(Q14_self, Q14_short)
ks_bx_training[[15]] <- ks.test(Q15_self, Q15_short)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_self_short <- test_ks_bx_training[2,]

#Next for self-U
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_self, Q1_U)
ks_bx_training[[2]] <- ks.test(Q2_self, Q2_U)
ks_bx_training[[3]] <- ks.test(Q3_self, Q3_U)
ks_bx_training[[4]] <- ks.test(Q4_self, Q4_U)
ks_bx_training[[5]] <- ks.test(Q5_self, Q5_U)

ks_bx_training[[6]] <- ks.test(Q6_self, Q6_U)
ks_bx_training[[7]] <- ks.test(Q7_self, Q7_U)
ks_bx_training[[8]] <- ks.test(Q8_self, Q8_U)
ks_bx_training[[9]] <- ks.test(Q9_self, Q9_U)
ks_bx_training[[10]] <- ks.test(Q10_self, Q10_U)

ks_bx_training[[11]] <- ks.test(Q11_self, Q11_U)
ks_bx_training[[12]] <- ks.test(Q12_self, Q12_U)
ks_bx_training[[13]] <- ks.test(Q13_self, Q13_U)
ks_bx_training[[14]] <- ks.test(Q14_self, Q14_U)
ks_bx_training[[15]] <- ks.test(Q15_self, Q15_U)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_self_U <- test_ks_bx_training[2,]

#Next for self-G_cla
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_self, Q1_G_cla)
ks_bx_training[[2]] <- ks.test(Q2_self, Q2_G_cla)
ks_bx_training[[3]] <- ks.test(Q3_self, Q3_G_cla)
ks_bx_training[[4]] <- ks.test(Q4_self, Q4_G_cla)
ks_bx_training[[5]] <- ks.test(Q5_self, Q5_G_cla)

ks_bx_training[[6]] <- ks.test(Q6_self, Q6_G_cla)
ks_bx_training[[7]] <- ks.test(Q7_self, Q7_G_cla)
ks_bx_training[[8]] <- ks.test(Q8_self, Q8_G_cla)
ks_bx_training[[9]] <- ks.test(Q9_self, Q9_G_cla)
ks_bx_training[[10]] <- ks.test(Q10_self, Q10_G_cla)

ks_bx_training[[11]] <- ks.test(Q11_self, Q11_G_cla)
ks_bx_training[[12]] <- ks.test(Q12_self, Q12_G_cla)
ks_bx_training[[13]] <- ks.test(Q13_self, Q13_G_cla)
ks_bx_training[[14]] <- ks.test(Q14_self, Q14_G_cla)
ks_bx_training[[15]] <- ks.test(Q15_self, Q15_G_cla)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_self_G_cla <- test_ks_bx_training[2,]

#Next for self-G_deg
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_self, Q1_G_deg)
ks_bx_training[[2]] <- ks.test(Q2_self, Q2_G_deg)
ks_bx_training[[3]] <- ks.test(Q3_self, Q3_G_deg)
ks_bx_training[[4]] <- ks.test(Q4_self, Q4_G_deg)
ks_bx_training[[5]] <- ks.test(Q5_self, Q5_G_deg)

ks_bx_training[[6]] <- ks.test(Q6_self, Q6_G_deg)
ks_bx_training[[7]] <- ks.test(Q7_self, Q7_G_deg)
ks_bx_training[[8]] <- ks.test(Q8_self, Q8_G_deg)
ks_bx_training[[9]] <- ks.test(Q9_self, Q9_G_deg)
ks_bx_training[[10]] <- ks.test(Q10_self, Q10_G_deg)

ks_bx_training[[11]] <- ks.test(Q11_self, Q11_G_deg)
ks_bx_training[[12]] <- ks.test(Q12_self, Q12_G_deg)
ks_bx_training[[13]] <- ks.test(Q13_self, Q13_G_deg)
ks_bx_training[[14]] <- ks.test(Q14_self, Q14_G_deg)
ks_bx_training[[15]] <- ks.test(Q15_self, Q15_G_deg)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_self_G_deg <- test_ks_bx_training[2,]

#Next for short-U
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_short, Q1_U)
ks_bx_training[[2]] <- ks.test(Q2_short, Q2_U)
ks_bx_training[[3]] <- ks.test(Q3_short, Q3_U)
ks_bx_training[[4]] <- ks.test(Q4_short, Q4_U)
ks_bx_training[[5]] <- ks.test(Q5_short, Q5_U)
ks_bx_training[[6]] <- ks.test(Q6_short, Q6_U)
ks_bx_training[[7]] <- ks.test(Q7_short, Q7_U)
ks_bx_training[[8]] <- ks.test(Q8_short, Q8_U)
ks_bx_training[[9]] <- ks.test(Q9_short, Q9_U)
ks_bx_training[[10]] <- ks.test(Q10_short, Q10_U)

ks_bx_training[[11]] <- ks.test(Q11_short, Q11_U)
ks_bx_training[[12]] <- ks.test(Q12_short, Q12_U)
ks_bx_training[[13]] <- ks.test(Q13_short, Q13_U)
ks_bx_training[[14]] <- ks.test(Q14_short, Q14_U)
ks_bx_training[[15]] <- ks.test(Q15_short, Q15_U)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_short_U <- test_ks_bx_training[2,]

#Next for short-G_cla
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_short, Q1_G_cla)
ks_bx_training[[2]] <- ks.test(Q2_short, Q2_G_cla)
ks_bx_training[[3]] <- ks.test(Q3_short, Q3_G_cla)
ks_bx_training[[4]] <- ks.test(Q4_short, Q4_G_cla)
ks_bx_training[[5]] <- ks.test(Q5_short, Q5_G_cla)

ks_bx_training[[6]] <- ks.test(Q6_short, Q6_G_cla)
ks_bx_training[[7]] <- ks.test(Q7_short, Q7_G_cla)
ks_bx_training[[8]] <- ks.test(Q8_short, Q8_G_cla)
ks_bx_training[[9]] <- ks.test(Q9_short, Q9_G_cla)
ks_bx_training[[10]] <- ks.test(Q10_short, Q10_G_cla)

ks_bx_training[[11]] <- ks.test(Q11_short, Q11_G_cla)
ks_bx_training[[12]] <- ks.test(Q12_short, Q12_G_cla)
ks_bx_training[[13]] <- ks.test(Q13_short, Q13_G_cla)
ks_bx_training[[14]] <- ks.test(Q14_short, Q14_G_cla)
ks_bx_training[[15]] <- ks.test(Q15_short, Q15_G_cla)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_short_G_cla <- test_ks_bx_training[2,]

#Next for short-G_deg
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_short, Q1_G_deg)
ks_bx_training[[2]] <- ks.test(Q2_short, Q2_G_deg)
ks_bx_training[[3]] <- ks.test(Q3_short, Q3_G_deg)
ks_bx_training[[4]] <- ks.test(Q4_short, Q4_G_deg)
ks_bx_training[[5]] <- ks.test(Q5_short, Q5_G_deg)

ks_bx_training[[6]] <- ks.test(Q6_short, Q6_G_deg)
ks_bx_training[[7]] <- ks.test(Q7_short, Q7_G_deg)
ks_bx_training[[8]] <- ks.test(Q8_short, Q8_G_deg)
ks_bx_training[[9]] <- ks.test(Q9_short, Q9_G_deg)
ks_bx_training[[10]] <- ks.test(Q10_short, Q10_G_deg)

ks_bx_training[[11]] <- ks.test(Q11_short, Q11_G_deg)
ks_bx_training[[12]] <- ks.test(Q12_short, Q12_G_deg)
ks_bx_training[[13]] <- ks.test(Q13_short, Q13_G_deg)
ks_bx_training[[14]] <- ks.test(Q14_short, Q14_G_deg)
ks_bx_training[[15]] <- ks.test(Q15_short, Q15_G_deg)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_short_G_deg <- test_ks_bx_training[2,]

#Next for U-G_cla
myfile <- paste(path,"test_ks_bx_training-U-G_cla.txt", sep="")

ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_U, Q1_G_cla)
ks_bx_training[[2]] <- ks.test(Q2_U, Q2_G_cla)
ks_bx_training[[3]] <- ks.test(Q3_U, Q3_G_cla)
ks_bx_training[[4]] <- ks.test(Q4_U, Q4_G_cla)
ks_bx_training[[5]] <- ks.test(Q5_U, Q5_G_cla)

ks_bx_training[[6]] <- ks.test(Q6_U, Q6_G_cla)
ks_bx_training[[7]] <- ks.test(Q7_U, Q7_G_cla)
ks_bx_training[[8]] <- ks.test(Q8_U, Q8_G_cla)
ks_bx_training[[9]] <- ks.test(Q9_U, Q9_G_cla)
ks_bx_training[[10]] <- ks.test(Q10_U, Q10_G_cla)

ks_bx_training[[11]] <- ks.test(Q11_U, Q11_G_cla)
ks_bx_training[[12]] <- ks.test(Q12_U, Q12_G_cla)
ks_bx_training[[13]] <- ks.test(Q13_U, Q13_G_cla)
ks_bx_training[[14]] <- ks.test(Q14_U, Q14_G_cla)
ks_bx_training[[15]] <- ks.test(Q15_U, Q15_G_cla)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_U_G_cla <- test_ks_bx_training[2,]

#Next for U-G_deg
myfile <- paste(path,"test_ks_bx_training-U-G_deg.txt", sep="")

ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_U, Q1_G_deg)
ks_bx_training[[2]] <- ks.test(Q2_U, Q2_G_deg)
ks_bx_training[[3]] <- ks.test(Q3_U, Q3_G_deg)
ks_bx_training[[4]] <- ks.test(Q4_U, Q4_G_deg)
ks_bx_training[[5]] <- ks.test(Q5_U, Q5_G_deg)

ks_bx_training[[6]] <- ks.test(Q6_U, Q6_G_deg)
ks_bx_training[[7]] <- ks.test(Q7_U, Q7_G_deg)
ks_bx_training[[8]] <- ks.test(Q8_U, Q8_G_deg)
ks_bx_training[[9]] <- ks.test(Q9_U, Q9_G_deg)
ks_bx_training[[10]] <- ks.test(Q10_U, Q10_G_deg)

ks_bx_training[[11]] <- ks.test(Q11_U, Q11_G_deg)
ks_bx_training[[12]] <- ks.test(Q12_U, Q12_G_deg)
ks_bx_training[[13]] <- ks.test(Q13_U, Q13_G_deg)
ks_bx_training[[14]] <- ks.test(Q14_U, Q14_G_deg)
ks_bx_training[[15]] <- ks.test(Q15_U, Q15_G_deg)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_U_G_deg <- test_ks_bx_training[2,]

#Next for G_cla-G_deg
ks_bx_training <- list()
ks_bx_training[[1]] <- ks.test(Q1_G_cla, Q1_G_deg)
ks_bx_training[[2]] <- ks.test(Q2_G_cla, Q2_G_deg)
ks_bx_training[[3]] <- ks.test(Q3_G_cla, Q3_G_deg)
ks_bx_training[[4]] <- ks.test(Q4_G_cla, Q4_G_deg)
ks_bx_training[[5]] <- ks.test(Q5_G_cla, Q5_G_deg)

ks_bx_training[[6]] <- ks.test(Q6_G_cla, Q6_G_deg)
ks_bx_training[[7]] <- ks.test(Q7_G_cla, Q7_G_deg)
ks_bx_training[[8]] <- ks.test(Q8_G_cla, Q8_G_deg)
ks_bx_training[[9]] <- ks.test(Q9_G_cla, Q9_G_deg)
ks_bx_training[[10]] <- ks.test(Q10_G_cla, Q10_G_deg)

ks_bx_training[[11]] <- ks.test(Q11_G_cla, Q11_G_deg)
ks_bx_training[[12]] <- ks.test(Q12_G_cla, Q12_G_deg)
ks_bx_training[[13]] <- ks.test(Q13_G_cla, Q13_G_deg)
ks_bx_training[[14]] <- ks.test(Q14_G_cla, Q14_G_deg)
ks_bx_training[[15]] <- ks.test(Q15_G_cla, Q15_G_deg)

test_ks_bx_training <- sapply(ks_bx_training, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_bx_training) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_G_cla_G_deg <- test_ks_bx_training[2,]

# Get means
stats_bx_training_no <- cbind(summary(Q1_no),summary(Q2_no),summary(Q3_no),summary(Q4_no),summary(Q5_no),summary(Q6_no),summary(Q7_no),summary(Q8_no),summary(Q9_no),summary(Q10_no),summary(Q11_no),summary(Q12_no),summary(Q13_no),summary(Q14_no),summary(Q15_no))
colnames(stats_bx_training_no) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_bx_training_self <- cbind(summary(Q1_self),summary(Q2_self),summary(Q3_self),summary(Q4_self),summary(Q5_self),summary(Q6_self),summary(Q7_self),summary(Q8_self),summary(Q9_self),summary(Q10_self),summary(Q11_self),summary(Q12_self),summary(Q13_self),summary(Q14_self),summary(Q15_self))
colnames(stats_bx_training_self) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_bx_training_short <- cbind(summary(Q1_short),summary(Q2_short),summary(Q3_short),summary(Q4_short),summary(Q5_short),summary(Q6_short),summary(Q7_short),summary(Q8_short),summary(Q9_short),summary(Q10_short),summary(Q11_short),summary(Q12_short),summary(Q13_short),summary(Q14_short),summary(Q15_short))
colnames(stats_bx_training_short) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_bx_training_U <- cbind(summary(Q1_U),summary(Q2_U),summary(Q3_U),summary(Q4_U),summary(Q5_U),summary(Q6_U),summary(Q7_U),summary(Q8_U),summary(Q9_U),summary(Q10_U),summary(Q11_U),summary(Q12_U),summary(Q13_U),summary(Q14_U),summary(Q15_U))
colnames(stats_bx_training_U) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_bx_training_G_cla <- cbind(summary(Q1_G_cla),summary(Q2_G_cla),summary(Q3_G_cla),summary(Q4_G_cla),summary(Q5_G_cla),summary(Q6_G_cla),summary(Q7_G_cla),summary(Q8_G_cla),summary(Q9_G_cla),summary(Q10_G_cla),summary(Q11_G_cla),summary(Q12_G_cla),summary(Q13_G_cla),summary(Q14_G_cla),summary(Q15_G_cla))
colnames(stats_bx_training_G_cla) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_bx_training_G_deg <- cbind(summary(Q1_G_deg),summary(Q2_G_deg),summary(Q3_G_deg),summary(Q4_G_deg),summary(Q5_G_deg),summary(Q6_G_deg),summary(Q7_G_deg),summary(Q8_G_deg),summary(Q9_G_deg),summary(Q10_G_deg),summary(Q11_G_deg),summary(Q12_G_deg),summary(Q13_G_deg),summary(Q14_G_deg),summary(Q15_G_deg))
colnames(stats_bx_training_G_deg) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_bx_training <- cbind(stats_bx_training_no[4,],stats_bx_training_self[4,],stats_bx_training_short[4,],stats_bx_training_U[4,],stats_bx_training_G_cla[4,],stats_bx_training_G_deg[4,])
colnames(mean_bx_training) <- c("None", "Self", "Short","Undergrad","Grad class","Grad deg")
mean_bx_training_plots <- t(mean_bx_training)
mean_bx_training <- cbind(mean_bx_training, P_no_self, P_no_short, P_no_U, P_no_G_cla, P_no_G_deg, P_self_short, P_self_U, P_self_G_cla, P_self_G_deg, P_short_U, P_short_G_cla, P_short_G_deg, P_U_G_cla, P_U_G_deg, P_G_cla_G_deg)

myfile <- paste(path,"mean_test_ks_bx_training.txt", sep="")
write.table(mean_bx_training, file = myfile, sep = "\t")

###
#Test for difference between Carnegie - Assc, BS,MS, PhD institution
###

Q1_Assc <- survey_data$Q13_1[survey_data$Q21=="1"]
Q1_BS <- survey_data$Q13_1[survey_data$Q21=="2"]
Q1_MS <- survey_data$Q13_1[survey_data$Q21=="3"]
Q1_PhD <- survey_data$Q13_1[survey_data$Q21=="4"]

Q2_Assc <- survey_data$Q13_2[survey_data$Q21=="1"]
Q2_BS <- survey_data$Q13_2[survey_data$Q21=="2"]
Q2_MS <- survey_data$Q13_2[survey_data$Q21=="3"]
Q2_PhD <- survey_data$Q13_2[survey_data$Q21=="4"]

Q3_Assc <- survey_data$Q13_3[survey_data$Q21=="1"]
Q3_BS <- survey_data$Q13_3[survey_data$Q21=="2"]
Q3_MS <- survey_data$Q13_3[survey_data$Q21=="3"]
Q3_PhD <- survey_data$Q13_3[survey_data$Q21=="4"]

Q4_Assc <- survey_data$Q13_4[survey_data$Q21=="1"]
Q4_BS <- survey_data$Q13_4[survey_data$Q21=="2"]
Q4_MS <- survey_data$Q13_4[survey_data$Q21=="3"]
Q4_PhD <- survey_data$Q13_4[survey_data$Q21=="4"]

Q5_Assc <- survey_data$Q13_5[survey_data$Q21=="1"]
Q5_BS <- survey_data$Q13_5[survey_data$Q21=="2"]
Q5_MS <- survey_data$Q13_5[survey_data$Q21=="3"]
Q5_PhD <- survey_data$Q13_5[survey_data$Q21=="4"]

Q6_Assc <- survey_data$Q13_6[survey_data$Q21=="1"]
Q6_BS <- survey_data$Q13_6[survey_data$Q21=="2"]
Q6_MS <- survey_data$Q13_6[survey_data$Q21=="3"]
Q6_PhD <- survey_data$Q13_6[survey_data$Q21=="4"]

Q7_Assc <- survey_data$Q13_7[survey_data$Q21=="1"]
Q7_BS <- survey_data$Q13_7[survey_data$Q21=="2"]
Q7_MS <- survey_data$Q13_7[survey_data$Q21=="3"]
Q7_PhD <- survey_data$Q13_7[survey_data$Q21=="4"]

Q8_Assc <- survey_data$Q13_8[survey_data$Q21=="1"]
Q8_BS <- survey_data$Q13_8[survey_data$Q21=="2"]
Q8_MS <- survey_data$Q13_8[survey_data$Q21=="3"]
Q8_PhD <- survey_data$Q13_8[survey_data$Q21=="4"]

Q9_Assc <- survey_data$Q13_9[survey_data$Q21=="1"]
Q9_BS <- survey_data$Q13_9[survey_data$Q21=="2"]
Q9_MS <- survey_data$Q13_9[survey_data$Q21=="3"]
Q9_PhD <- survey_data$Q13_9[survey_data$Q21=="4"]

Q10_Assc <- survey_data$Q13_10[survey_data$Q21=="1"]
Q10_BS <- survey_data$Q13_10[survey_data$Q21=="2"]
Q10_MS <- survey_data$Q13_10[survey_data$Q21=="3"]
Q10_PhD <- survey_data$Q13_10[survey_data$Q21=="4"]

Q11_Assc <- survey_data$Q13_11[survey_data$Q21=="1"]
Q11_BS <- survey_data$Q13_11[survey_data$Q21=="2"]
Q11_MS <- survey_data$Q13_11[survey_data$Q21=="3"]
Q11_PhD <- survey_data$Q13_11[survey_data$Q21=="4"]

Q12_Assc <- survey_data$Q13_12[survey_data$Q21=="1"]
Q12_BS <- survey_data$Q13_12[survey_data$Q21=="2"]
Q12_MS <- survey_data$Q13_12[survey_data$Q21=="3"]
Q12_PhD <- survey_data$Q13_12[survey_data$Q21=="4"]

Q13_Assc <- survey_data$Q13_13[survey_data$Q21=="1"]
Q13_BS <- survey_data$Q13_13[survey_data$Q21=="2"]
Q13_MS <- survey_data$Q13_13[survey_data$Q21=="3"]
Q13_PhD <- survey_data$Q13_13[survey_data$Q21=="4"]

Q14_Assc <- survey_data$Q13_14[survey_data$Q21=="1"]
Q14_BS <- survey_data$Q13_14[survey_data$Q21=="2"]
Q14_MS <- survey_data$Q13_14[survey_data$Q21=="3"]
Q14_PhD <- survey_data$Q13_14[survey_data$Q21=="4"]

Q15_Assc <- survey_data$Q13_15[survey_data$Q21=="1"]
Q15_BS <- survey_data$Q13_15[survey_data$Q21=="2"]
Q15_MS <- survey_data$Q13_15[survey_data$Q21=="3"]
Q15_PhD <- survey_data$Q13_15[survey_data$Q21=="4"]

#First for Assc-BS
ks_carnegie <- list()
ks_carnegie[[1]] <- ks.test(Q1_Assc, Q1_BS)
ks_carnegie[[2]] <- ks.test(Q2_Assc, Q2_BS)
ks_carnegie[[3]] <- ks.test(Q3_Assc, Q3_BS)
ks_carnegie[[4]] <- ks.test(Q4_Assc, Q4_BS)
ks_carnegie[[5]] <- ks.test(Q5_Assc, Q5_BS)

ks_carnegie[[6]] <- ks.test(Q6_Assc, Q6_BS)
ks_carnegie[[7]] <- ks.test(Q7_Assc, Q7_BS)
ks_carnegie[[8]] <- ks.test(Q8_Assc, Q8_BS)
ks_carnegie[[9]] <- ks.test(Q9_Assc, Q9_BS)
ks_carnegie[[10]] <- ks.test(Q10_Assc, Q10_BS)

ks_carnegie[[11]] <- ks.test(Q11_Assc, Q11_BS)
ks_carnegie[[12]] <- ks.test(Q12_Assc, Q12_BS)
ks_carnegie[[13]] <- ks.test(Q13_Assc, Q13_BS)
ks_carnegie[[14]] <- ks.test(Q14_Assc, Q14_BS)
ks_carnegie[[15]] <- ks.test(Q15_Assc, Q15_BS)

test_ks_carnegie <- sapply(ks_carnegie, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_carnegie) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_Assc_BS <- test_ks_carnegie[2,]

#Next for Assc-MS
ks_carnegie <- list()
ks_carnegie[[1]] <- ks.test(Q1_Assc, Q1_MS)
ks_carnegie[[2]] <- ks.test(Q2_Assc, Q2_MS)
ks_carnegie[[3]] <- ks.test(Q3_Assc, Q3_MS)
ks_carnegie[[4]] <- ks.test(Q4_Assc, Q4_MS)
ks_carnegie[[5]] <- ks.test(Q5_Assc, Q5_MS)

ks_carnegie[[6]] <- ks.test(Q6_Assc, Q6_MS)
ks_carnegie[[7]] <- ks.test(Q7_Assc, Q7_MS)
ks_carnegie[[8]] <- ks.test(Q8_Assc, Q8_MS)
ks_carnegie[[9]] <- ks.test(Q9_Assc, Q9_MS)
ks_carnegie[[10]] <- ks.test(Q10_Assc, Q10_MS)

ks_carnegie[[11]] <- ks.test(Q11_Assc, Q11_MS)
ks_carnegie[[12]] <- ks.test(Q12_Assc, Q12_MS)
ks_carnegie[[13]] <- ks.test(Q13_Assc, Q13_MS)
ks_carnegie[[14]] <- ks.test(Q14_Assc, Q14_MS)
ks_carnegie[[15]] <- ks.test(Q15_Assc, Q15_MS)

test_ks_carnegie <- sapply(ks_carnegie, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_carnegie) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_Assc_MS <- test_ks_carnegie[2,]

#Next for Assc-PhD
ks_carnegie <- list()
ks_carnegie[[1]] <- ks.test(Q1_Assc, Q1_PhD)
ks_carnegie[[2]] <- ks.test(Q2_Assc, Q2_PhD)
ks_carnegie[[3]] <- ks.test(Q3_Assc, Q3_PhD)
ks_carnegie[[4]] <- ks.test(Q4_Assc, Q4_PhD)
ks_carnegie[[5]] <- ks.test(Q5_Assc, Q5_PhD)

ks_carnegie[[6]] <- ks.test(Q6_Assc, Q6_PhD)
ks_carnegie[[7]] <- ks.test(Q7_Assc, Q7_PhD)
ks_carnegie[[8]] <- ks.test(Q8_Assc, Q8_PhD)
ks_carnegie[[9]] <- ks.test(Q9_Assc, Q9_PhD)
ks_carnegie[[10]] <- ks.test(Q10_Assc, Q10_PhD)

ks_carnegie[[11]] <- ks.test(Q11_Assc, Q11_PhD)
ks_carnegie[[12]] <- ks.test(Q12_Assc, Q12_PhD)
ks_carnegie[[13]] <- ks.test(Q13_Assc, Q13_PhD)
ks_carnegie[[14]] <- ks.test(Q14_Assc, Q14_PhD)
ks_carnegie[[15]] <- ks.test(Q15_Assc, Q15_PhD)

test_ks_carnegie <- sapply(ks_carnegie, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_carnegie) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_Assc_PhD <- test_ks_carnegie[2,]

#Next for BS-MS
ks_carnegie <- list()
ks_carnegie[[1]] <- ks.test(Q1_BS, Q1_MS)
ks_carnegie[[2]] <- ks.test(Q2_BS, Q2_MS)
ks_carnegie[[3]] <- ks.test(Q3_BS, Q3_MS)
ks_carnegie[[4]] <- ks.test(Q4_BS, Q4_MS)
ks_carnegie[[5]] <- ks.test(Q5_BS, Q5_MS)

ks_carnegie[[6]] <- ks.test(Q6_BS, Q6_MS)
ks_carnegie[[7]] <- ks.test(Q7_BS, Q7_MS)
ks_carnegie[[8]] <- ks.test(Q8_BS, Q8_MS)
ks_carnegie[[9]] <- ks.test(Q9_BS, Q9_MS)
ks_carnegie[[10]] <- ks.test(Q10_BS, Q10_MS)

ks_carnegie[[11]] <- ks.test(Q11_BS, Q11_MS)
ks_carnegie[[12]] <- ks.test(Q12_BS, Q12_MS)
ks_carnegie[[13]] <- ks.test(Q13_BS, Q13_MS)
ks_carnegie[[14]] <- ks.test(Q14_BS, Q14_MS)
ks_carnegie[[15]] <- ks.test(Q15_BS, Q15_MS)

test_ks_carnegie <- sapply(ks_carnegie, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_carnegie) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_BS_MS <- test_ks_carnegie[2,]

#Next for BS-PhD
ks_carnegie <- list()
ks_carnegie[[1]] <- ks.test(Q1_BS, Q1_PhD)
ks_carnegie[[2]] <- ks.test(Q2_BS, Q2_PhD)
ks_carnegie[[3]] <- ks.test(Q3_BS, Q3_PhD)
ks_carnegie[[4]] <- ks.test(Q4_BS, Q4_PhD)
ks_carnegie[[5]] <- ks.test(Q5_BS, Q5_PhD)

ks_carnegie[[6]] <- ks.test(Q6_BS, Q6_PhD)
ks_carnegie[[7]] <- ks.test(Q7_BS, Q7_PhD)
ks_carnegie[[8]] <- ks.test(Q8_BS, Q8_PhD)
ks_carnegie[[9]] <- ks.test(Q9_BS, Q9_PhD)
ks_carnegie[[10]] <- ks.test(Q10_BS, Q10_PhD)

ks_carnegie[[11]] <- ks.test(Q11_BS, Q11_PhD)
ks_carnegie[[12]] <- ks.test(Q12_BS, Q12_PhD)
ks_carnegie[[13]] <- ks.test(Q13_BS, Q13_PhD)
ks_carnegie[[14]] <- ks.test(Q14_BS, Q14_PhD)
ks_carnegie[[15]] <- ks.test(Q15_BS, Q15_PhD)

test_ks_carnegie <- sapply(ks_carnegie, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_carnegie) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_BS_PhD <- test_ks_carnegie[2,]

#Next for MS-PhD
ks_carnegie <- list()
ks_carnegie[[1]] <- ks.test(Q1_MS, Q1_PhD)
ks_carnegie[[2]] <- ks.test(Q2_MS, Q2_PhD)
ks_carnegie[[3]] <- ks.test(Q3_MS, Q3_PhD)
ks_carnegie[[4]] <- ks.test(Q4_MS, Q4_PhD)
ks_carnegie[[5]] <- ks.test(Q5_MS, Q5_PhD)

ks_carnegie[[6]] <- ks.test(Q6_MS, Q6_PhD)
ks_carnegie[[7]] <- ks.test(Q7_MS, Q7_PhD)
ks_carnegie[[8]] <- ks.test(Q8_MS, Q8_PhD)
ks_carnegie[[9]] <- ks.test(Q9_MS, Q9_PhD)
ks_carnegie[[10]] <- ks.test(Q10_MS, Q10_PhD)

ks_carnegie[[11]] <- ks.test(Q11_MS, Q11_PhD)
ks_carnegie[[12]] <- ks.test(Q12_MS, Q12_PhD)
ks_carnegie[[13]] <- ks.test(Q13_MS, Q13_PhD)
ks_carnegie[[14]] <- ks.test(Q14_MS, Q14_PhD)
ks_carnegie[[15]] <- ks.test(Q15_MS, Q15_PhD)

test_ks_carnegie <- sapply(ks_carnegie, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_carnegie) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_MS_PhD <- test_ks_carnegie[2,]

# Get means
stats_carnegie_Assc <- cbind(summary(Q1_Assc),summary(Q2_Assc),summary(Q3_Assc),summary(Q4_Assc),summary(Q5_Assc),summary(Q6_Assc),summary(Q7_Assc),summary(Q8_Assc),summary(Q9_Assc),summary(Q10_Assc),summary(Q11_Assc),summary(Q12_Assc),summary(Q13_Assc),summary(Q14_Assc),summary(Q15_Assc))
colnames(stats_carnegie_Assc) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_carnegie_BS <- cbind(summary(Q1_BS),summary(Q2_BS),summary(Q3_BS),summary(Q4_BS),summary(Q5_BS),summary(Q6_BS),summary(Q7_BS),summary(Q8_BS),summary(Q9_BS),summary(Q10_BS),summary(Q11_BS),summary(Q12_BS),summary(Q13_BS),summary(Q14_BS),summary(Q15_BS))
colnames(stats_carnegie_BS) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_carnegie_MS <- cbind(summary(Q1_MS),summary(Q2_MS),summary(Q3_MS),summary(Q4_MS),summary(Q5_MS),summary(Q6_MS),summary(Q7_MS),summary(Q8_MS),summary(Q9_MS),summary(Q10_MS),summary(Q11_MS),summary(Q12_MS),summary(Q13_MS),summary(Q14_MS),summary(Q15_MS))
colnames(stats_carnegie_MS) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_carnegie_PhD <- cbind(summary(Q1_PhD),summary(Q2_PhD),summary(Q3_PhD),summary(Q4_PhD),summary(Q5_PhD),summary(Q6_PhD),summary(Q7_PhD),summary(Q8_PhD),summary(Q9_PhD),summary(Q10_PhD),summary(Q11_PhD),summary(Q12_PhD),summary(Q13_PhD),summary(Q14_PhD),summary(Q15_PhD))
colnames(stats_carnegie_PhD) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_carnegie <- cbind(stats_carnegie_Assc[4,],stats_carnegie_BS[4,],stats_carnegie_MS[4,],stats_carnegie_PhD[4,])
colnames(mean_carnegie) <- c("Assc", "BS", "MS","PhD")
mean_carnegie_plots <- t(mean_carnegie)
mean_carnegie <- cbind(mean_carnegie, P_Assc_BS, P_Assc_MS, P_Assc_PhD, P_BS_MS, P_BS_PhD, P_MS_PhD)

myfile <- paste(path,"mean_test_ks_carnegie.txt", sep="")
write.table(mean_carnegie, file = myfile, sep = "\t")


###
#Test for difference between minority and non
###

Q1_minority <- survey_data$Q13_1[survey_data$Q22=="1"]
Q1_non <- survey_data$Q13_1[survey_data$Q22=="2"]

Q2_minority <- survey_data$Q13_2[survey_data$Q22=="1"]
Q2_non <- survey_data$Q13_2[survey_data$Q22=="2"]

Q3_minority <- survey_data$Q13_3[survey_data$Q22=="1"]
Q3_non <- survey_data$Q13_3[survey_data$Q22=="2"]

Q4_minority <- survey_data$Q13_4[survey_data$Q22=="1"]
Q4_non <- survey_data$Q13_4[survey_data$Q22=="2"]

Q5_minority <- survey_data$Q13_5[survey_data$Q22=="1"]
Q5_non <- survey_data$Q13_5[survey_data$Q22=="2"]

Q6_minority <- survey_data$Q13_6[survey_data$Q22=="1"]
Q6_non <- survey_data$Q13_6[survey_data$Q22=="2"]

Q7_minority <- survey_data$Q13_7[survey_data$Q22=="1"]
Q7_non <- survey_data$Q13_7[survey_data$Q22=="2"]

Q8_minority <- survey_data$Q13_8[survey_data$Q22=="1"]
Q8_non <- survey_data$Q13_8[survey_data$Q22=="2"]

Q9_minority <- survey_data$Q13_9[survey_data$Q22=="1"]
Q9_non <- survey_data$Q13_9[survey_data$Q22=="2"]

Q10_minority <- survey_data$Q13_10[survey_data$Q22=="1"]
Q10_non <- survey_data$Q13_10[survey_data$Q22=="2"]

Q11_minority <- survey_data$Q13_11[survey_data$Q22=="1"]
Q11_non <- survey_data$Q13_11[survey_data$Q22=="2"]

Q12_minority <- survey_data$Q13_12[survey_data$Q22=="1"]
Q12_non <- survey_data$Q13_12[survey_data$Q22=="2"]

Q13_minority <- survey_data$Q13_13[survey_data$Q22=="1"]
Q13_non <- survey_data$Q13_13[survey_data$Q22=="2"]

Q14_minority <- survey_data$Q13_14[survey_data$Q22=="1"]
Q14_non <- survey_data$Q13_14[survey_data$Q22=="2"]

Q15_minority <- survey_data$Q13_15[survey_data$Q22=="1"]
Q15_non <- survey_data$Q13_15[survey_data$Q22=="2"]


ks_minority <- list()
ks_minority[[1]] <- ks.test(Q1_minority, Q1_non)
ks_minority[[2]] <- ks.test(Q2_minority, Q2_non)
ks_minority[[3]] <- ks.test(Q3_minority, Q3_non)
ks_minority[[4]] <- ks.test(Q4_minority, Q4_non)
ks_minority[[5]] <- ks.test(Q5_minority, Q5_non)

ks_minority[[6]] <- ks.test(Q6_minority, Q6_non)
ks_minority[[7]] <- ks.test(Q7_minority, Q7_non)
ks_minority[[8]] <- ks.test(Q8_minority, Q8_non)
ks_minority[[9]] <- ks.test(Q9_minority, Q9_non)
ks_minority[[10]] <- ks.test(Q10_minority, Q10_non)

ks_minority[[11]] <- ks.test(Q11_minority, Q11_non)
ks_minority[[12]] <- ks.test(Q12_minority, Q12_non)
ks_minority[[13]] <- ks.test(Q13_minority, Q13_non)
ks_minority[[14]] <- ks.test(Q14_minority, Q14_non)
ks_minority[[15]] <- ks.test(Q15_minority, Q15_non)

test_ks_minority <- sapply(ks_minority, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_minority) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_minority_non <- test_ks_minority[2,]

# Get means
stats_minority_minority <- cbind(summary(Q1_minority),summary(Q2_minority),summary(Q3_minority),summary(Q4_minority),summary(Q5_minority),summary(Q6_minority),summary(Q7_minority),summary(Q8_minority),summary(Q9_minority),summary(Q10_minority),summary(Q11_minority),summary(Q12_minority),summary(Q13_minority),summary(Q14_minority),summary(Q15_minority))
colnames(stats_minority_minority) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_minority_non <- cbind(summary(Q1_non),summary(Q2_non),summary(Q3_non),summary(Q4_non),summary(Q5_non),summary(Q6_non),summary(Q7_non),summary(Q8_non),summary(Q9_non),summary(Q10_non),summary(Q11_non),summary(Q12_non),summary(Q13_non),summary(Q14_non),summary(Q15_non))
colnames(stats_minority_non) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_minority <- cbind(stats_minority_minority[4,],stats_minority_non[4,])
colnames(mean_minority) <- c("Minority", "Non")
mean_minority_plots <- t(mean_minority)
mean_minority <- cbind(mean_minority,P_minority_non)

myfile <- paste(path,"mean_test_ks_minority.txt", sep="")
write.table(mean_minority, file = myfile, sep = "\t")

###
#Test for difference between POC and white
###

#Q15	Race	
# 1: American Indian or Alaska Native	
# 2: Asian	
# 3: Black or African American	
# 4: Native Hawaiian or Other Pacific Islander	
# 5: White	
# 6: Rather not say

survey_data$Q15[survey_data$Q15==1] <- 1
survey_data$Q15[survey_data$Q15==2] <- 1
survey_data$Q15[survey_data$Q15==3] <- 1
survey_data$Q15[survey_data$Q15==4] <- 1
survey_data$Q15[survey_data$Q15==5] <- 2
survey_data$Q15[survey_data$Q15==6] <- NA


Q1_POC <- survey_data$Q13_1[survey_data$Q15=="1"]
Q1_white <- survey_data$Q13_1[survey_data$Q15=="2"]

Q2_POC <- survey_data$Q13_2[survey_data$Q15=="1"]
Q2_white <- survey_data$Q13_2[survey_data$Q15=="2"]

Q3_POC <- survey_data$Q13_3[survey_data$Q15=="1"]
Q3_white <- survey_data$Q13_3[survey_data$Q15=="2"]

Q4_POC <- survey_data$Q13_4[survey_data$Q15=="1"]
Q4_white <- survey_data$Q13_4[survey_data$Q15=="2"]

Q5_POC <- survey_data$Q13_5[survey_data$Q15=="1"]
Q5_white <- survey_data$Q13_5[survey_data$Q15=="2"]

Q6_POC <- survey_data$Q13_6[survey_data$Q15=="1"]
Q6_white <- survey_data$Q13_6[survey_data$Q15=="2"]

Q7_POC <- survey_data$Q13_7[survey_data$Q15=="1"]
Q7_white <- survey_data$Q13_7[survey_data$Q15=="2"]

Q8_POC <- survey_data$Q13_8[survey_data$Q15=="1"]
Q8_white <- survey_data$Q13_8[survey_data$Q15=="2"]

Q9_POC <- survey_data$Q13_9[survey_data$Q15=="1"]
Q9_white <- survey_data$Q13_9[survey_data$Q15=="2"]

Q10_POC <- survey_data$Q13_10[survey_data$Q15=="1"]
Q10_white <- survey_data$Q13_10[survey_data$Q15=="2"]

Q11_POC <- survey_data$Q13_11[survey_data$Q15=="1"]
Q11_white <- survey_data$Q13_11[survey_data$Q15=="2"]

Q12_POC <- survey_data$Q13_12[survey_data$Q15=="1"]
Q12_white <- survey_data$Q13_12[survey_data$Q15=="2"]

Q13_POC <- survey_data$Q13_13[survey_data$Q15=="1"]
Q13_white <- survey_data$Q13_13[survey_data$Q15=="2"]

Q14_POC <- survey_data$Q13_14[survey_data$Q15=="1"]
Q14_white <- survey_data$Q13_14[survey_data$Q15=="2"]

Q15_POC <- survey_data$Q13_15[survey_data$Q15=="1"]
Q15_white <- survey_data$Q13_15[survey_data$Q15=="2"]


ks_race <- list()
ks_race[[1]] <- ks.test(Q1_POC, Q1_white)
ks_race[[2]] <- ks.test(Q2_POC, Q2_white)
ks_race[[3]] <- ks.test(Q3_POC, Q3_white)
ks_race[[4]] <- ks.test(Q4_POC, Q4_white)
ks_race[[5]] <- ks.test(Q5_POC, Q5_white)

ks_race[[6]] <- ks.test(Q6_POC, Q6_white)
ks_race[[7]] <- ks.test(Q7_POC, Q7_white)
ks_race[[8]] <- ks.test(Q8_POC, Q8_white)
ks_race[[9]] <- ks.test(Q9_POC, Q9_white)
ks_race[[10]] <- ks.test(Q10_POC, Q10_white)

ks_race[[11]] <- ks.test(Q11_POC, Q11_white)
ks_race[[12]] <- ks.test(Q12_POC, Q12_white)
ks_race[[13]] <- ks.test(Q13_POC, Q13_white)
ks_race[[14]] <- ks.test(Q14_POC, Q14_white)
ks_race[[15]] <- ks.test(Q15_POC, Q15_white)

test_ks_race <- sapply(ks_race, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_race) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_POC_white <- test_ks_race[2,]

# Get means
stats_race_POC <- cbind(summary(Q1_POC),summary(Q2_POC),summary(Q3_POC),summary(Q4_POC),summary(Q5_POC),summary(Q6_POC),summary(Q7_POC),summary(Q8_POC),summary(Q9_POC),summary(Q10_POC),summary(Q11_POC),summary(Q12_POC),summary(Q13_POC),summary(Q14_POC),summary(Q15_POC))
colnames(stats_race_POC) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_race_white <- cbind(summary(Q1_white),summary(Q2_white),summary(Q3_white),summary(Q4_white),summary(Q5_white),summary(Q6_white),summary(Q7_white),summary(Q8_white),summary(Q9_white),summary(Q10_white),summary(Q11_white),summary(Q12_white),summary(Q13_white),summary(Q14_white),summary(Q15_white))
colnames(stats_race_white) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_race <- cbind(stats_race_POC[4,],stats_race_white[4,])
colnames(mean_race) <- c("POC", "White")
mean_race_plots <- t(mean_race)
mean_race <- cbind(mean_race,P_POC_white)

myfile <- paste(path,"mean_test_ks_race.txt", sep="")
write.table(mean_race, file = myfile, sep = "\t")

###
#Test for difference between 5000, mid, 15000 - total students
###

Q1_5000 <- survey_data$Q13_1[survey_data$Q23=="1"]
Q1_mid <- survey_data$Q13_1[survey_data$Q23=="2"]
Q1_15000 <- survey_data$Q13_1[survey_data$Q23=="3"]

Q2_5000 <- survey_data$Q13_2[survey_data$Q23=="1"]
Q2_mid <- survey_data$Q13_2[survey_data$Q23=="2"]
Q2_15000 <- survey_data$Q13_2[survey_data$Q23=="3"]

Q3_5000 <- survey_data$Q13_3[survey_data$Q23=="1"]
Q3_mid <- survey_data$Q13_3[survey_data$Q23=="2"]
Q3_15000 <- survey_data$Q13_3[survey_data$Q23=="3"]

Q4_5000 <- survey_data$Q13_4[survey_data$Q23=="1"]
Q4_mid <- survey_data$Q13_4[survey_data$Q23=="2"]
Q4_15000 <- survey_data$Q13_4[survey_data$Q23=="3"]

Q5_5000 <- survey_data$Q13_5[survey_data$Q23=="1"]
Q5_mid <- survey_data$Q13_5[survey_data$Q23=="2"]
Q5_15000 <- survey_data$Q13_5[survey_data$Q23=="3"]

Q6_5000 <- survey_data$Q13_6[survey_data$Q23=="1"]
Q6_mid <- survey_data$Q13_6[survey_data$Q23=="2"]
Q6_15000 <- survey_data$Q13_6[survey_data$Q23=="3"]

Q7_5000 <- survey_data$Q13_7[survey_data$Q23=="1"]
Q7_mid <- survey_data$Q13_7[survey_data$Q23=="2"]
Q7_15000 <- survey_data$Q13_7[survey_data$Q23=="3"]

Q8_5000 <- survey_data$Q13_8[survey_data$Q23=="1"]
Q8_mid <- survey_data$Q13_8[survey_data$Q23=="2"]
Q8_15000 <- survey_data$Q13_8[survey_data$Q23=="3"]

Q9_5000 <- survey_data$Q13_9[survey_data$Q23=="1"]
Q9_mid <- survey_data$Q13_9[survey_data$Q23=="2"]
Q9_15000 <- survey_data$Q13_9[survey_data$Q23=="3"]

Q10_5000 <- survey_data$Q13_10[survey_data$Q23=="1"]
Q10_mid <- survey_data$Q13_10[survey_data$Q23=="2"]
Q10_15000 <- survey_data$Q13_10[survey_data$Q23=="3"]

Q11_5000 <- survey_data$Q13_11[survey_data$Q23=="1"]
Q11_mid <- survey_data$Q13_11[survey_data$Q23=="2"]
Q11_15000 <- survey_data$Q13_11[survey_data$Q23=="3"]

Q12_5000 <- survey_data$Q13_12[survey_data$Q23=="1"]
Q12_mid <- survey_data$Q13_12[survey_data$Q23=="2"]
Q12_15000 <- survey_data$Q13_12[survey_data$Q23=="3"]
Q12_PhD <- survey_data$Q13_12[survey_data$Q23=="4"]

Q13_5000 <- survey_data$Q13_13[survey_data$Q23=="1"]
Q13_mid <- survey_data$Q13_13[survey_data$Q23=="2"]
Q13_15000 <- survey_data$Q13_13[survey_data$Q23=="3"]

Q14_5000 <- survey_data$Q13_14[survey_data$Q23=="1"]
Q14_mid <- survey_data$Q13_14[survey_data$Q23=="2"]
Q14_15000 <- survey_data$Q13_14[survey_data$Q23=="3"]

Q15_5000 <- survey_data$Q13_15[survey_data$Q23=="1"]
Q15_mid <- survey_data$Q13_15[survey_data$Q23=="2"]
Q15_15000 <- survey_data$Q13_15[survey_data$Q23=="3"]


#First for 5000-mid
ks_total_students <- list()
ks_total_students[[1]] <- ks.test(Q1_5000, Q1_mid)
ks_total_students[[2]] <- ks.test(Q2_5000, Q2_mid)
ks_total_students[[3]] <- ks.test(Q3_5000, Q3_mid)
ks_total_students[[4]] <- ks.test(Q4_5000, Q4_mid)
ks_total_students[[5]] <- ks.test(Q5_5000, Q5_mid)

ks_total_students[[6]] <- ks.test(Q6_5000, Q6_mid)
ks_total_students[[7]] <- ks.test(Q7_5000, Q7_mid)
ks_total_students[[8]] <- ks.test(Q8_5000, Q8_mid)
ks_total_students[[9]] <- ks.test(Q9_5000, Q9_mid)
ks_total_students[[10]] <- ks.test(Q10_5000, Q10_mid)

ks_total_students[[11]] <- ks.test(Q11_5000, Q11_mid)
ks_total_students[[12]] <- ks.test(Q12_5000, Q12_mid)
ks_total_students[[13]] <- ks.test(Q13_5000, Q13_mid)
ks_total_students[[14]] <- ks.test(Q14_5000, Q14_mid)
ks_total_students[[15]] <- ks.test(Q15_5000, Q15_mid)

test_ks_total_students <- sapply(ks_total_students, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_total_students) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_5000_mid <- test_ks_total_students[2,]


#Next for 5000-15000
ks_total_students <- list()
ks_total_students[[1]] <- ks.test(Q1_5000, Q1_15000)
ks_total_students[[2]] <- ks.test(Q2_5000, Q2_15000)
ks_total_students[[3]] <- ks.test(Q3_5000, Q3_15000)
ks_total_students[[4]] <- ks.test(Q4_5000, Q4_15000)
ks_total_students[[5]] <- ks.test(Q5_5000, Q5_15000)

ks_total_students[[6]] <- ks.test(Q6_5000, Q6_15000)
ks_total_students[[7]] <- ks.test(Q7_5000, Q7_15000)
ks_total_students[[8]] <- ks.test(Q8_5000, Q8_15000)
ks_total_students[[9]] <- ks.test(Q9_5000, Q9_15000)
ks_total_students[[10]] <- ks.test(Q10_5000, Q10_15000)

ks_total_students[[11]] <- ks.test(Q11_5000, Q11_15000)
ks_total_students[[12]] <- ks.test(Q12_5000, Q12_15000)
ks_total_students[[13]] <- ks.test(Q13_5000, Q13_15000)
ks_total_students[[14]] <- ks.test(Q14_5000, Q14_15000)
ks_total_students[[15]] <- ks.test(Q15_5000, Q15_15000)

test_ks_total_students <- sapply(ks_total_students, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_total_students) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_5000_15000 <- test_ks_total_students[2,]


#Next for mid-15000
ks_total_students <- list()
ks_total_students[[1]] <- ks.test(Q1_mid, Q1_15000)
ks_total_students[[2]] <- ks.test(Q2_mid, Q2_15000)
ks_total_students[[3]] <- ks.test(Q3_mid, Q3_15000)
ks_total_students[[4]] <- ks.test(Q4_mid, Q4_15000)
ks_total_students[[5]] <- ks.test(Q5_mid, Q5_15000)

ks_total_students[[6]] <- ks.test(Q6_mid, Q6_15000)
ks_total_students[[7]] <- ks.test(Q7_mid, Q7_15000)
ks_total_students[[8]] <- ks.test(Q8_mid, Q8_15000)
ks_total_students[[9]] <- ks.test(Q9_mid, Q9_15000)
ks_total_students[[10]] <- ks.test(Q10_mid, Q10_15000)

ks_total_students[[11]] <- ks.test(Q11_mid, Q11_15000)
ks_total_students[[12]] <- ks.test(Q12_mid, Q12_15000)
ks_total_students[[13]] <- ks.test(Q13_mid, Q13_15000)
ks_total_students[[14]] <- ks.test(Q14_mid, Q14_15000)
ks_total_students[[15]] <- ks.test(Q15_mid, Q15_15000)

test_ks_total_students <- sapply(ks_total_students, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_total_students) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_mid_15000 <- test_ks_total_students[2,]

# Get means
stats_5000 <- cbind(summary(Q1_5000),summary(Q2_5000),summary(Q3_5000),summary(Q4_5000),summary(Q5_5000),summary(Q6_5000),summary(Q7_5000),summary(Q8_5000),summary(Q9_5000),summary(Q10_5000),summary(Q11_5000),summary(Q12_5000),summary(Q13_5000),summary(Q14_5000),summary(Q15_5000))
colnames(stats_5000) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_mid <- cbind(summary(Q1_mid),summary(Q2_mid),summary(Q3_mid),summary(Q4_mid),summary(Q5_mid),summary(Q6_mid),summary(Q7_mid),summary(Q8_mid),summary(Q9_mid),summary(Q10_mid),summary(Q11_mid),summary(Q12_mid),summary(Q13_mid),summary(Q14_mid),summary(Q15_mid))
colnames(stats_mid) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_15000 <- cbind(summary(Q1_15000),summary(Q2_15000),summary(Q3_15000),summary(Q4_15000),summary(Q5_15000),summary(Q6_15000),summary(Q7_15000),summary(Q8_15000),summary(Q9_15000),summary(Q10_15000),summary(Q11_15000),summary(Q12_15000),summary(Q13_15000),summary(Q14_15000),summary(Q15_15000))
colnames(stats_15000) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_total_students <- cbind(stats_5000[4,],stats_mid[4,],stats_15000[4,])
colnames(mean_total_students) <- c("<5000", "5000-15000", ">15000")
mean_total_students_plots <- t(mean_total_students)
mean_total_students <- cbind(mean_total_students, P_5000_mid, P_5000_15000, P_mid_15000)

myfile <- paste(path,"mean_test_ks_total_students.txt", sep="")
write.table(mean_total_students, file = myfile, sep = "\t")



###
#Test for difference between Total Undergrads 5000, mid, 15000
###
survey_data$Q24[survey_data$Q24==4] <- NA

Q1_5000 <- survey_data$Q13_1[survey_data$Q24=="1"]
Q1_mid <- survey_data$Q13_1[survey_data$Q24=="2"]
Q1_15000 <- survey_data$Q13_1[survey_data$Q24=="3"]

Q2_5000 <- survey_data$Q13_2[survey_data$Q24=="1"]
Q2_mid <- survey_data$Q13_2[survey_data$Q24=="2"]
Q2_15000 <- survey_data$Q13_2[survey_data$Q24=="3"]

Q3_5000 <- survey_data$Q13_3[survey_data$Q24=="1"]
Q3_mid <- survey_data$Q13_3[survey_data$Q24=="2"]
Q3_15000 <- survey_data$Q13_3[survey_data$Q24=="3"]

Q4_5000 <- survey_data$Q13_4[survey_data$Q24=="1"]
Q4_mid <- survey_data$Q13_4[survey_data$Q24=="2"]
Q4_15000 <- survey_data$Q13_4[survey_data$Q24=="3"]

Q5_5000 <- survey_data$Q13_5[survey_data$Q24=="1"]
Q5_mid <- survey_data$Q13_5[survey_data$Q24=="2"]
Q5_15000 <- survey_data$Q13_5[survey_data$Q24=="3"]

Q6_5000 <- survey_data$Q13_6[survey_data$Q24=="1"]
Q6_mid <- survey_data$Q13_6[survey_data$Q24=="2"]
Q6_15000 <- survey_data$Q13_6[survey_data$Q24=="3"]

Q7_5000 <- survey_data$Q13_7[survey_data$Q24=="1"]
Q7_mid <- survey_data$Q13_7[survey_data$Q24=="2"]
Q7_15000 <- survey_data$Q13_7[survey_data$Q24=="3"]

Q8_5000 <- survey_data$Q13_8[survey_data$Q24=="1"]
Q8_mid <- survey_data$Q13_8[survey_data$Q24=="2"]
Q8_15000 <- survey_data$Q13_8[survey_data$Q24=="3"]

Q9_5000 <- survey_data$Q13_9[survey_data$Q24=="1"]
Q9_mid <- survey_data$Q13_9[survey_data$Q24=="2"]
Q9_15000 <- survey_data$Q13_9[survey_data$Q24=="3"]

Q10_5000 <- survey_data$Q13_10[survey_data$Q24=="1"]
Q10_mid <- survey_data$Q13_10[survey_data$Q24=="2"]
Q10_15000 <- survey_data$Q13_10[survey_data$Q24=="3"]

Q11_5000 <- survey_data$Q13_11[survey_data$Q24=="1"]
Q11_mid <- survey_data$Q13_11[survey_data$Q24=="2"]
Q11_15000 <- survey_data$Q13_11[survey_data$Q24=="3"]

Q12_5000 <- survey_data$Q13_12[survey_data$Q24=="1"]
Q12_mid <- survey_data$Q13_12[survey_data$Q24=="2"]
Q12_15000 <- survey_data$Q13_12[survey_data$Q24=="3"]
Q12_PhD <- survey_data$Q13_12[survey_data$Q24=="4"]

Q13_5000 <- survey_data$Q13_13[survey_data$Q24=="1"]
Q13_mid <- survey_data$Q13_13[survey_data$Q24=="2"]
Q13_15000 <- survey_data$Q13_13[survey_data$Q24=="3"]

Q14_5000 <- survey_data$Q13_14[survey_data$Q24=="1"]
Q14_mid <- survey_data$Q13_14[survey_data$Q24=="2"]
Q14_15000 <- survey_data$Q13_14[survey_data$Q24=="3"]

Q15_5000 <- survey_data$Q13_15[survey_data$Q24=="1"]
Q15_mid <- survey_data$Q13_15[survey_data$Q24=="2"]
Q15_15000 <- survey_data$Q13_15[survey_data$Q24=="3"]

#First for 5000-mid
ks_total_undergrads <- list()
ks_total_undergrads[[1]] <- ks.test(Q1_5000, Q1_mid)
ks_total_undergrads[[2]] <- ks.test(Q2_5000, Q2_mid)
ks_total_undergrads[[3]] <- ks.test(Q3_5000, Q3_mid)
ks_total_undergrads[[4]] <- ks.test(Q4_5000, Q4_mid)
ks_total_undergrads[[5]] <- ks.test(Q5_5000, Q5_mid)

ks_total_undergrads[[6]] <- ks.test(Q6_5000, Q6_mid)
ks_total_undergrads[[7]] <- ks.test(Q7_5000, Q7_mid)
ks_total_undergrads[[8]] <- ks.test(Q8_5000, Q8_mid)
ks_total_undergrads[[9]] <- ks.test(Q9_5000, Q9_mid)
ks_total_undergrads[[10]] <- ks.test(Q10_5000, Q10_mid)

ks_total_undergrads[[11]] <- ks.test(Q11_5000, Q11_mid)
ks_total_undergrads[[12]] <- ks.test(Q12_5000, Q12_mid)
ks_total_undergrads[[13]] <- ks.test(Q13_5000, Q13_mid)
ks_total_undergrads[[14]] <- ks.test(Q14_5000, Q14_mid)
ks_total_undergrads[[15]] <- ks.test(Q15_5000, Q15_mid)

test_ks_total_undergrads <- sapply(ks_total_undergrads, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_total_undergrads) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_5000_mid <- test_ks_total_undergrads[2,]


#Next for 5000-15000
ks_total_undergrads <- list()
ks_total_undergrads[[1]] <- ks.test(Q1_5000, Q1_15000)
ks_total_undergrads[[2]] <- ks.test(Q2_5000, Q2_15000)
ks_total_undergrads[[3]] <- ks.test(Q3_5000, Q3_15000)
ks_total_undergrads[[4]] <- ks.test(Q4_5000, Q4_15000)
ks_total_undergrads[[5]] <- ks.test(Q5_5000, Q5_15000)

ks_total_undergrads[[6]] <- ks.test(Q6_5000, Q6_15000)
ks_total_undergrads[[7]] <- ks.test(Q7_5000, Q7_15000)
ks_total_undergrads[[8]] <- ks.test(Q8_5000, Q8_15000)
ks_total_undergrads[[9]] <- ks.test(Q9_5000, Q9_15000)
ks_total_undergrads[[10]] <- ks.test(Q10_5000, Q10_15000)

ks_total_undergrads[[11]] <- ks.test(Q11_5000, Q11_15000)
ks_total_undergrads[[12]] <- ks.test(Q12_5000, Q12_15000)
ks_total_undergrads[[13]] <- ks.test(Q13_5000, Q13_15000)
ks_total_undergrads[[14]] <- ks.test(Q14_5000, Q14_15000)
ks_total_undergrads[[15]] <- ks.test(Q15_5000, Q15_15000)

test_ks_total_undergrads <- sapply(ks_total_undergrads, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_total_undergrads) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_5000_15000 <- test_ks_total_undergrads[2,]


#Next for mid-15000
ks_total_undergrads <- list()
ks_total_undergrads[[1]] <- ks.test(Q1_mid, Q1_15000)
ks_total_undergrads[[2]] <- ks.test(Q2_mid, Q2_15000)
ks_total_undergrads[[3]] <- ks.test(Q3_mid, Q3_15000)
ks_total_undergrads[[4]] <- ks.test(Q4_mid, Q4_15000)
ks_total_undergrads[[5]] <- ks.test(Q5_mid, Q5_15000)

ks_total_undergrads[[6]] <- ks.test(Q6_mid, Q6_15000)
ks_total_undergrads[[7]] <- ks.test(Q7_mid, Q7_15000)
ks_total_undergrads[[8]] <- ks.test(Q8_mid, Q8_15000)
ks_total_undergrads[[9]] <- ks.test(Q9_mid, Q9_15000)
ks_total_undergrads[[10]] <- ks.test(Q10_mid, Q10_15000)

ks_total_undergrads[[11]] <- ks.test(Q11_mid, Q11_15000)
ks_total_undergrads[[12]] <- ks.test(Q12_mid, Q12_15000)
ks_total_undergrads[[13]] <- ks.test(Q13_mid, Q13_15000)
ks_total_undergrads[[14]] <- ks.test(Q14_mid, Q14_15000)
ks_total_undergrads[[15]] <- ks.test(Q15_mid, Q15_15000)

test_ks_total_undergrads <- sapply(ks_total_undergrads, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_total_undergrads) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_mid_15000 <- test_ks_total_undergrads[2,]

# Get means
stats_5000 <- cbind(summary(Q1_5000),summary(Q2_5000),summary(Q3_5000),summary(Q4_5000),summary(Q5_5000),summary(Q6_5000),summary(Q7_5000),summary(Q8_5000),summary(Q9_5000),summary(Q10_5000),summary(Q11_5000),summary(Q12_5000),summary(Q13_5000),summary(Q14_5000),summary(Q15_5000))
colnames(stats_5000) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_mid <- cbind(summary(Q1_mid),summary(Q2_mid),summary(Q3_mid),summary(Q4_mid),summary(Q5_mid),summary(Q6_mid),summary(Q7_mid),summary(Q8_mid),summary(Q9_mid),summary(Q10_mid),summary(Q11_mid),summary(Q12_mid),summary(Q13_mid),summary(Q14_mid),summary(Q15_mid))
colnames(stats_mid) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_15000 <- cbind(summary(Q1_15000),summary(Q2_15000),summary(Q3_15000),summary(Q4_15000),summary(Q5_15000),summary(Q6_15000),summary(Q7_15000),summary(Q8_15000),summary(Q9_15000),summary(Q10_15000),summary(Q11_15000),summary(Q12_15000),summary(Q13_15000),summary(Q14_15000),summary(Q15_15000))
colnames(stats_15000) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_total_undergrads <- cbind(stats_5000[4,],stats_mid[4,],stats_15000[4,])
colnames(mean_total_undergrads) <- c("<5000", "5000-15000", ">15000")
mean_total_undergrads_plots <- t(mean_total_undergrads)
mean_total_undergrads <- cbind(mean_total_undergrads, P_5000_mid, P_5000_15000, P_mid_15000)

myfile <- paste(path,"mean_test_ks_total_undergrads.txt", sep="")
write.table(mean_total_undergrads, file = myfile, sep = "\t")


###
# test for differences by number of faculty
###

# 1: < 10	
# 2: 10 - 20	
# 3: 21 - 30	
# 4: 31 - 40	
# 5: 41 - 50	
# 6: > 50	
# 7: Don't know

survey_data$Q26[survey_data$Q26==5] <- 4
survey_data$Q26[survey_data$Q26==6] <- 4
survey_data$Q26[survey_data$Q26==7] <- NA

Q1_10 <- survey_data$Q13_1[survey_data$Q26=="1"]
Q1_10_20 <- survey_data$Q13_1[survey_data$Q26=="2"]
Q1_21_30 <- survey_data$Q13_1[survey_data$Q26=="3"]
Q1_31 <- survey_data$Q13_1[survey_data$Q26=="4"]

Q2_10 <- survey_data$Q13_2[survey_data$Q26=="1"]
Q2_10_20 <- survey_data$Q13_2[survey_data$Q26=="2"]
Q2_21_30 <- survey_data$Q13_2[survey_data$Q26=="3"]
Q2_31 <- survey_data$Q13_2[survey_data$Q26=="4"]

Q3_10 <- survey_data$Q13_3[survey_data$Q26=="1"]
Q3_10_20 <- survey_data$Q13_3[survey_data$Q26=="2"]
Q3_21_30 <- survey_data$Q13_3[survey_data$Q26=="3"]
Q3_31 <- survey_data$Q13_3[survey_data$Q26=="4"]

Q4_10 <- survey_data$Q13_4[survey_data$Q26=="1"]
Q4_10_20 <- survey_data$Q13_4[survey_data$Q26=="2"]
Q4_21_30 <- survey_data$Q13_4[survey_data$Q26=="3"]
Q4_31 <- survey_data$Q13_4[survey_data$Q26=="4"]

Q5_10 <- survey_data$Q13_5[survey_data$Q26=="1"]
Q5_10_20 <- survey_data$Q13_5[survey_data$Q26=="2"]
Q5_21_30 <- survey_data$Q13_5[survey_data$Q26=="3"]
Q5_31 <- survey_data$Q13_5[survey_data$Q26=="4"]

Q6_10 <- survey_data$Q13_6[survey_data$Q26=="1"]
Q6_10_20 <- survey_data$Q13_6[survey_data$Q26=="2"]
Q6_21_30 <- survey_data$Q13_6[survey_data$Q26=="3"]
Q6_31 <- survey_data$Q13_6[survey_data$Q26=="4"]

Q7_10 <- survey_data$Q13_7[survey_data$Q26=="1"]
Q7_10_20 <- survey_data$Q13_7[survey_data$Q26=="2"]
Q7_21_30 <- survey_data$Q13_7[survey_data$Q26=="3"]
Q7_31 <- survey_data$Q13_7[survey_data$Q26=="4"]

Q8_10 <- survey_data$Q13_8[survey_data$Q26=="1"]
Q8_10_20 <- survey_data$Q13_8[survey_data$Q26=="2"]
Q8_21_30 <- survey_data$Q13_8[survey_data$Q26=="3"]
Q8_31 <- survey_data$Q13_8[survey_data$Q26=="4"]

Q9_10 <- survey_data$Q13_9[survey_data$Q26=="1"]
Q9_10_20 <- survey_data$Q13_9[survey_data$Q26=="2"]
Q9_21_30 <- survey_data$Q13_9[survey_data$Q26=="3"]
Q9_31 <- survey_data$Q13_9[survey_data$Q26=="4"]

Q10_10 <- survey_data$Q13_10[survey_data$Q26=="1"]
Q10_10_20 <- survey_data$Q13_10[survey_data$Q26=="2"]
Q10_21_30 <- survey_data$Q13_10[survey_data$Q26=="3"]
Q10_31 <- survey_data$Q13_10[survey_data$Q26=="4"]

Q11_10 <- survey_data$Q13_11[survey_data$Q26=="1"]
Q11_10_20 <- survey_data$Q13_11[survey_data$Q26=="2"]
Q11_21_30 <- survey_data$Q13_11[survey_data$Q26=="3"]
Q11_31 <- survey_data$Q13_11[survey_data$Q26=="4"]

Q12_10 <- survey_data$Q13_12[survey_data$Q26=="1"]
Q12_10_20 <- survey_data$Q13_12[survey_data$Q26=="2"]
Q12_21_30 <- survey_data$Q13_12[survey_data$Q26=="3"]
Q12_31 <- survey_data$Q13_12[survey_data$Q26=="4"]

Q13_10 <- survey_data$Q13_13[survey_data$Q26=="1"]
Q13_10_20 <- survey_data$Q13_13[survey_data$Q26=="2"]
Q13_21_30 <- survey_data$Q13_13[survey_data$Q26=="3"]
Q13_31 <- survey_data$Q13_13[survey_data$Q26=="4"]

Q14_10 <- survey_data$Q13_14[survey_data$Q26=="1"]
Q14_10_20 <- survey_data$Q13_14[survey_data$Q26=="2"]
Q14_21_30 <- survey_data$Q13_14[survey_data$Q26=="3"]
Q14_31 <- survey_data$Q13_14[survey_data$Q26=="4"]

Q15_10 <- survey_data$Q13_15[survey_data$Q26=="1"]
Q15_10_20 <- survey_data$Q13_15[survey_data$Q26=="2"]
Q15_21_30 <- survey_data$Q13_15[survey_data$Q26=="3"]
Q15_31 <- survey_data$Q13_15[survey_data$Q26=="4"]

#First for 10_10_20
ks_faculty <- list()
ks_faculty[[1]] <- ks.test(Q1_10, Q1_10_20)
ks_faculty[[2]] <- ks.test(Q2_10, Q2_10_20)
ks_faculty[[3]] <- ks.test(Q3_10, Q3_10_20)
ks_faculty[[4]] <- ks.test(Q4_10, Q4_10_20)
ks_faculty[[5]] <- ks.test(Q5_10, Q5_10_20)

ks_faculty[[6]] <- ks.test(Q6_10, Q6_10_20)
ks_faculty[[7]] <- ks.test(Q7_10, Q7_10_20)
ks_faculty[[8]] <- ks.test(Q8_10, Q8_10_20)
ks_faculty[[9]] <- ks.test(Q9_10, Q9_10_20)
ks_faculty[[10]] <- ks.test(Q10_10, Q10_10_20)

ks_faculty[[11]] <- ks.test(Q11_10, Q11_10_20)
ks_faculty[[12]] <- ks.test(Q12_10, Q12_10_20)
ks_faculty[[13]] <- ks.test(Q13_10, Q13_10_20)
ks_faculty[[14]] <- ks.test(Q14_10, Q14_10_20)
ks_faculty[[15]] <- ks.test(Q15_10, Q15_10_20)

test_ks_faculty <- sapply(ks_faculty, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_faculty) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_10_20 <- test_ks_faculty[2,]

#Next for 10_21_30
ks_faculty <- list()
ks_faculty[[1]] <- ks.test(Q1_10, Q1_21_30)
ks_faculty[[2]] <- ks.test(Q2_10, Q2_21_30)
ks_faculty[[3]] <- ks.test(Q3_10, Q3_21_30)
ks_faculty[[4]] <- ks.test(Q4_10, Q4_21_30)
ks_faculty[[5]] <- ks.test(Q5_10, Q5_21_30)

ks_faculty[[6]] <- ks.test(Q6_10, Q6_21_30)
ks_faculty[[7]] <- ks.test(Q7_10, Q7_21_30)
ks_faculty[[8]] <- ks.test(Q8_10, Q8_21_30)
ks_faculty[[9]] <- ks.test(Q9_10, Q9_21_30)
ks_faculty[[10]] <- ks.test(Q10_10, Q10_21_30)

ks_faculty[[11]] <- ks.test(Q11_10, Q11_21_30)
ks_faculty[[12]] <- ks.test(Q12_10, Q12_21_30)
ks_faculty[[13]] <- ks.test(Q13_10, Q13_21_30)
ks_faculty[[14]] <- ks.test(Q14_10, Q14_21_30)
ks_faculty[[15]] <- ks.test(Q15_10, Q15_21_30)

test_ks_faculty <- sapply(ks_faculty, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_faculty) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_10_30 <- test_ks_faculty[2,]

#Next for 10_31_40
ks_faculty <- list()
ks_faculty[[1]] <- ks.test(Q1_10, Q1_31)
ks_faculty[[2]] <- ks.test(Q2_10, Q2_31)
ks_faculty[[3]] <- ks.test(Q3_10, Q3_31)
ks_faculty[[4]] <- ks.test(Q4_10, Q4_31)
ks_faculty[[5]] <- ks.test(Q5_10, Q5_31)

ks_faculty[[6]] <- ks.test(Q6_10, Q6_31)
ks_faculty[[7]] <- ks.test(Q7_10, Q7_31)
ks_faculty[[8]] <- ks.test(Q8_10, Q8_31)
ks_faculty[[9]] <- ks.test(Q9_10, Q9_31)
ks_faculty[[10]] <- ks.test(Q10_10, Q10_31)

ks_faculty[[11]] <- ks.test(Q11_10, Q11_31)
ks_faculty[[12]] <- ks.test(Q12_10, Q12_31)
ks_faculty[[13]] <- ks.test(Q13_10, Q13_31)
ks_faculty[[14]] <- ks.test(Q14_10, Q14_31)
ks_faculty[[15]] <- ks.test(Q15_10, Q15_31)

test_ks_faculty <- sapply(ks_faculty, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_faculty) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_10_31 <- test_ks_faculty[2,]


#Next for 10_20_21_30
ks_faculty <- list()
ks_faculty[[1]] <- ks.test(Q1_10_20, Q1_21_30)
ks_faculty[[2]] <- ks.test(Q2_10_20, Q2_21_30)
ks_faculty[[3]] <- ks.test(Q3_10_20, Q3_21_30)
ks_faculty[[4]] <- ks.test(Q4_10_20, Q4_21_30)
ks_faculty[[5]] <- ks.test(Q5_10_20, Q5_21_30)

ks_faculty[[6]] <- ks.test(Q6_10_20, Q6_21_30)
ks_faculty[[7]] <- ks.test(Q7_10_20, Q7_21_30)
ks_faculty[[8]] <- ks.test(Q8_10_20, Q8_21_30)
ks_faculty[[9]] <- ks.test(Q9_10_20, Q9_21_30)
ks_faculty[[10]] <- ks.test(Q10_10_20, Q10_21_30)

ks_faculty[[11]] <- ks.test(Q11_10_20, Q11_21_30)
ks_faculty[[12]] <- ks.test(Q12_10_20, Q12_21_30)
ks_faculty[[13]] <- ks.test(Q13_10_20, Q13_21_30)
ks_faculty[[14]] <- ks.test(Q14_10_20, Q14_21_30)
ks_faculty[[15]] <- ks.test(Q15_10_20, Q15_21_30)

test_ks_faculty <- sapply(ks_faculty, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_faculty) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_10_20_21_30 <- test_ks_faculty[2,]


#Next for 10_20_31_40
ks_faculty <- list()
ks_faculty[[1]] <- ks.test(Q1_10_20, Q1_31)
ks_faculty[[2]] <- ks.test(Q2_10_20, Q2_31)
ks_faculty[[3]] <- ks.test(Q3_10_20, Q3_31)
ks_faculty[[4]] <- ks.test(Q4_10_20, Q4_31)
ks_faculty[[5]] <- ks.test(Q5_10_20, Q5_31)

ks_faculty[[6]] <- ks.test(Q6_10_20, Q6_31)
ks_faculty[[7]] <- ks.test(Q7_10_20, Q7_31)
ks_faculty[[8]] <- ks.test(Q8_10_20, Q8_31)
ks_faculty[[9]] <- ks.test(Q9_10_20, Q9_31)
ks_faculty[[10]] <- ks.test(Q10_10_20, Q10_31)

ks_faculty[[11]] <- ks.test(Q11_10_20, Q11_31)
ks_faculty[[12]] <- ks.test(Q12_10_20, Q12_31)
ks_faculty[[13]] <- ks.test(Q13_10_20, Q13_31)
ks_faculty[[14]] <- ks.test(Q14_10_20, Q14_31)
ks_faculty[[15]] <- ks.test(Q15_10_20, Q15_31)

test_ks_faculty <- sapply(ks_faculty, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_faculty) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_10_20_31 <- test_ks_faculty[2,]


#Next for 21_30_31
ks_faculty <- list()
ks_faculty[[1]] <- ks.test(Q1_21_30, Q1_31)
ks_faculty[[2]] <- ks.test(Q2_21_30, Q2_31)
ks_faculty[[3]] <- ks.test(Q3_21_30, Q3_31)
ks_faculty[[4]] <- ks.test(Q4_21_30, Q4_31)
ks_faculty[[5]] <- ks.test(Q5_21_30, Q5_31)

ks_faculty[[6]] <- ks.test(Q6_21_30, Q6_31)
ks_faculty[[7]] <- ks.test(Q7_21_30, Q7_31)
ks_faculty[[8]] <- ks.test(Q8_21_30, Q8_31)
ks_faculty[[9]] <- ks.test(Q9_21_30, Q9_31)
ks_faculty[[10]] <- ks.test(Q10_21_30, Q10_31)

ks_faculty[[11]] <- ks.test(Q11_21_30, Q11_31)
ks_faculty[[12]] <- ks.test(Q12_21_30, Q12_31)
ks_faculty[[13]] <- ks.test(Q13_21_30, Q13_31)
ks_faculty[[14]] <- ks.test(Q14_21_30, Q14_31)
ks_faculty[[15]] <- ks.test(Q15_21_30, Q15_31)

test_ks_faculty <- sapply(ks_faculty, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_faculty) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_21_30_31 <- test_ks_faculty[2,]


# Get means
stats_10 <- cbind(summary(Q1_10),summary(Q2_10),summary(Q3_10),summary(Q4_10),summary(Q5_10),summary(Q6_10),summary(Q7_10),summary(Q8_10),summary(Q9_10),summary(Q10_10),summary(Q11_10),summary(Q12_10),summary(Q13_10),summary(Q14_10),summary(Q15_10))
colnames(stats_10) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_10_20 <- cbind(summary(Q1_10_20),summary(Q2_10_20),summary(Q3_10_20),summary(Q4_10_20),summary(Q5_10_20),summary(Q6_10_20),summary(Q7_10_20),summary(Q8_10_20),summary(Q9_10_20),summary(Q10_10_20),summary(Q11_10_20),summary(Q12_10_20),summary(Q13_10_20),summary(Q14_10_20),summary(Q15_10_20))
colnames(stats_10_20) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_21_30 <- cbind(summary(Q1_21_30),summary(Q2_21_30),summary(Q3_21_30),summary(Q4_21_30),summary(Q5_21_30),summary(Q6_21_30),summary(Q7_21_30),summary(Q8_21_30),summary(Q9_21_30),summary(Q10_21_30),summary(Q11_21_30),summary(Q12_21_30),summary(Q13_21_30),summary(Q14_21_30),summary(Q15_21_30))
colnames(stats_21_30) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_31 <- cbind(summary(Q1_31),summary(Q2_31),summary(Q3_31),summary(Q4_31),summary(Q5_31),summary(Q6_31),summary(Q7_31),summary(Q8_31),summary(Q9_31),summary(Q10_31),summary(Q11_31),summary(Q12_31),summary(Q13_31),summary(Q14_31),summary(Q15_31))
colnames(stats_31) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_faculty <- cbind(stats_10[4,],stats_10_20[4,],stats_21_30[4,],stats_31[4,])
colnames(mean_faculty) <- c("<10", "10-20", "21-30",">31")
mean_faculty_plots <- t(mean_faculty)
mean_faculty <- cbind(mean_faculty, P_10_20, P_10_30, P_10_31, P_10_20_21_30, P_10_20_31, P_21_30_31)

myfile <- paste(path,"mean_test_ks_faculty.txt", sep="")
write.table(mean_faculty, file = myfile, sep = "\t")

##
# Undergrad majors
##
#Q27	How many undergraduate students are in your department/unit (all majors)?	
# 1: < 50	
# 2: 51 - 100	
# 3: 101 - 500	
# 4: 501 - 2000	
# 5: > 2000	
# 6: Don't know
#undergrad_majors <- survey_data$Q27
survey_data$Q27[survey_data$Q27==1] <- 1
survey_data$Q27[survey_data$Q27==2] <- 1
survey_data$Q27[survey_data$Q27==3] <- 2
survey_data$Q27[survey_data$Q27==4] <- 3
survey_data$Q27[survey_data$Q27==5] <- 3
survey_data$Q27[survey_data$Q27==6] <- NA


Q1_100 <- survey_data$Q13_1[survey_data$Q27=="1"]
Q1_101_500 <- survey_data$Q13_1[survey_data$Q27=="2"]
Q1_501 <- survey_data$Q13_1[survey_data$Q27=="3"]

Q2_100 <- survey_data$Q13_2[survey_data$Q27=="1"]
Q2_101_500 <- survey_data$Q13_2[survey_data$Q27=="2"]
Q2_501 <- survey_data$Q13_2[survey_data$Q27=="3"]

Q3_100 <- survey_data$Q13_3[survey_data$Q27=="1"]
Q3_101_500 <- survey_data$Q13_3[survey_data$Q27=="2"]
Q3_501 <- survey_data$Q13_3[survey_data$Q27=="3"]

Q4_100 <- survey_data$Q13_4[survey_data$Q27=="1"]
Q4_101_500 <- survey_data$Q13_4[survey_data$Q27=="2"]
Q4_501 <- survey_data$Q13_4[survey_data$Q27=="3"]

Q5_100 <- survey_data$Q13_5[survey_data$Q27=="1"]
Q5_101_500 <- survey_data$Q13_5[survey_data$Q27=="2"]
Q5_501 <- survey_data$Q13_5[survey_data$Q27=="3"]

Q6_100 <- survey_data$Q13_6[survey_data$Q27=="1"]
Q6_101_500 <- survey_data$Q13_6[survey_data$Q27=="2"]
Q6_501 <- survey_data$Q13_6[survey_data$Q27=="3"]

Q7_100 <- survey_data$Q13_7[survey_data$Q27=="1"]
Q7_101_500 <- survey_data$Q13_7[survey_data$Q27=="2"]
Q7_501 <- survey_data$Q13_7[survey_data$Q27=="3"]

Q8_100 <- survey_data$Q13_8[survey_data$Q27=="1"]
Q8_101_500 <- survey_data$Q13_8[survey_data$Q27=="2"]
Q8_501 <- survey_data$Q13_8[survey_data$Q27=="3"]

Q9_100 <- survey_data$Q13_9[survey_data$Q27=="1"]
Q9_101_500 <- survey_data$Q13_9[survey_data$Q27=="2"]
Q9_501 <- survey_data$Q13_9[survey_data$Q27=="3"]

Q10_100 <- survey_data$Q13_10[survey_data$Q27=="1"]
Q10_101_500 <- survey_data$Q13_10[survey_data$Q27=="2"]
Q10_501 <- survey_data$Q13_10[survey_data$Q27=="3"]

Q11_100 <- survey_data$Q13_11[survey_data$Q27=="1"]
Q11_101_500 <- survey_data$Q13_11[survey_data$Q27=="2"]
Q11_501 <- survey_data$Q13_11[survey_data$Q27=="3"]

Q12_100 <- survey_data$Q13_12[survey_data$Q27=="1"]
Q12_101_500 <- survey_data$Q13_12[survey_data$Q27=="2"]
Q12_501 <- survey_data$Q13_12[survey_data$Q27=="3"]
Q12_PhD <- survey_data$Q13_12[survey_data$Q27=="4"]

Q13_100 <- survey_data$Q13_13[survey_data$Q27=="1"]
Q13_101_500 <- survey_data$Q13_13[survey_data$Q27=="2"]
Q13_501 <- survey_data$Q13_13[survey_data$Q27=="3"]

Q14_100 <- survey_data$Q13_14[survey_data$Q27=="1"]
Q14_101_500 <- survey_data$Q13_14[survey_data$Q27=="2"]
Q14_501 <- survey_data$Q13_14[survey_data$Q27=="3"]

Q15_100 <- survey_data$Q13_15[survey_data$Q27=="1"]
Q15_101_500 <- survey_data$Q13_15[survey_data$Q27=="2"]
Q15_501 <- survey_data$Q13_15[survey_data$Q27=="3"]

#First for 100-101_500
ks_undergrad_majors <- list()
ks_undergrad_majors[[1]] <- ks.test(Q1_100, Q1_101_500)
ks_undergrad_majors[[2]] <- ks.test(Q2_100, Q2_101_500)
ks_undergrad_majors[[3]] <- ks.test(Q3_100, Q3_101_500)
ks_undergrad_majors[[4]] <- ks.test(Q4_100, Q4_101_500)
ks_undergrad_majors[[5]] <- ks.test(Q5_100, Q5_101_500)

ks_undergrad_majors[[6]] <- ks.test(Q6_100, Q6_101_500)
ks_undergrad_majors[[7]] <- ks.test(Q7_100, Q7_101_500)
ks_undergrad_majors[[8]] <- ks.test(Q8_100, Q8_101_500)
ks_undergrad_majors[[9]] <- ks.test(Q9_100, Q9_101_500)
ks_undergrad_majors[[10]] <- ks.test(Q10_100, Q10_101_500)

ks_undergrad_majors[[11]] <- ks.test(Q11_100, Q11_101_500)
ks_undergrad_majors[[12]] <- ks.test(Q12_100, Q12_101_500)
ks_undergrad_majors[[13]] <- ks.test(Q13_100, Q13_101_500)
ks_undergrad_majors[[14]] <- ks.test(Q14_100, Q14_101_500)
ks_undergrad_majors[[15]] <- ks.test(Q15_100, Q15_101_500)

test_ks_undergrad_majors <- sapply(ks_undergrad_majors, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_undergrad_majors) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_100_101_500 <- test_ks_undergrad_majors[2,]


#Next for 100-501
ks_undergrad_majors <- list()
ks_undergrad_majors[[1]] <- ks.test(Q1_100, Q1_501)
ks_undergrad_majors[[2]] <- ks.test(Q2_100, Q2_501)
ks_undergrad_majors[[3]] <- ks.test(Q3_100, Q3_501)
ks_undergrad_majors[[4]] <- ks.test(Q4_100, Q4_501)
ks_undergrad_majors[[5]] <- ks.test(Q5_100, Q5_501)

ks_undergrad_majors[[6]] <- ks.test(Q6_100, Q6_501)
ks_undergrad_majors[[7]] <- ks.test(Q7_100, Q7_501)
ks_undergrad_majors[[8]] <- ks.test(Q8_100, Q8_501)
ks_undergrad_majors[[9]] <- ks.test(Q9_100, Q9_501)
ks_undergrad_majors[[10]] <- ks.test(Q10_100, Q10_501)

ks_undergrad_majors[[11]] <- ks.test(Q11_100, Q11_501)
ks_undergrad_majors[[12]] <- ks.test(Q12_100, Q12_501)
ks_undergrad_majors[[13]] <- ks.test(Q13_100, Q13_501)
ks_undergrad_majors[[14]] <- ks.test(Q14_100, Q14_501)
ks_undergrad_majors[[15]] <- ks.test(Q15_100, Q15_501)

test_ks_undergrad_majors <- sapply(ks_undergrad_majors, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_undergrad_majors) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")
P_100_501 <- test_ks_undergrad_majors[2,]


#Next for 101_500-501
ks_undergrad_majors <- list()
ks_undergrad_majors[[1]] <- ks.test(Q1_101_500, Q1_501)
ks_undergrad_majors[[2]] <- ks.test(Q2_101_500, Q2_501)
ks_undergrad_majors[[3]] <- ks.test(Q3_101_500, Q3_501)
ks_undergrad_majors[[4]] <- ks.test(Q4_101_500, Q4_501)
ks_undergrad_majors[[5]] <- ks.test(Q5_101_500, Q5_501)

ks_undergrad_majors[[6]] <- ks.test(Q6_101_500, Q6_501)
ks_undergrad_majors[[7]] <- ks.test(Q7_101_500, Q7_501)
ks_undergrad_majors[[8]] <- ks.test(Q8_101_500, Q8_501)
ks_undergrad_majors[[9]] <- ks.test(Q9_101_500, Q9_501)
ks_undergrad_majors[[10]] <- ks.test(Q10_101_500, Q10_501)

ks_undergrad_majors[[11]] <- ks.test(Q11_101_500, Q11_501)
ks_undergrad_majors[[12]] <- ks.test(Q12_101_500, Q12_501)
ks_undergrad_majors[[13]] <- ks.test(Q13_101_500, Q13_501)
ks_undergrad_majors[[14]] <- ks.test(Q14_101_500, Q14_501)
ks_undergrad_majors[[15]] <- ks.test(Q15_101_500, Q15_501)

test_ks_undergrad_majors <- sapply(ks_undergrad_majors, function(x) {
  c(x$statistic,p.value=x$p.value)
})

colnames(test_ks_undergrad_majors) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

P_101_500_501 <- test_ks_undergrad_majors[2,]

# Get means
stats_100 <- cbind(summary(Q1_100),summary(Q2_100),summary(Q3_100),summary(Q4_100),summary(Q5_100),summary(Q6_100),summary(Q7_100),summary(Q8_100),summary(Q9_100),summary(Q10_100),summary(Q11_100),summary(Q12_100),summary(Q13_100),summary(Q14_100),summary(Q15_100))
colnames(stats_100) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_101_500 <- cbind(summary(Q1_101_500),summary(Q2_101_500),summary(Q3_101_500),summary(Q4_101_500),summary(Q5_101_500),summary(Q6_101_500),summary(Q7_101_500),summary(Q8_101_500),summary(Q9_101_500),summary(Q10_101_500),summary(Q11_101_500),summary(Q12_101_500),summary(Q13_101_500),summary(Q14_101_500),summary(Q15_101_500))
colnames(stats_101_500) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

stats_501 <- cbind(summary(Q1_501),summary(Q2_501),summary(Q3_501),summary(Q4_501),summary(Q5_501),summary(Q6_501),summary(Q7_501),summary(Q8_501),summary(Q9_501),summary(Q10_501),summary(Q11_501),summary(Q12_501),summary(Q13_501),summary(Q14_501),summary(Q15_501))
colnames(stats_501) <- c("S1", "S2", "S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15")

mean_undergrad_majors <- cbind(stats_100[4,],stats_101_500[4,],stats_501[4,])
colnames(mean_undergrad_majors) <- c("<101", "101-500", ">500")
mean_undergrad_majors_plots <- t(mean_undergrad_majors)
mean_undergrad_majors <- cbind(mean_undergrad_majors, P_100_101_500, P_100_501, P_101_500_501)

myfile <- paste(path,"mean_test_ks_undergrad_majors.txt", sep="")
write.table(mean_undergrad_majors, file = myfile, sep = "\t")

###
# Now, make some barplots of the means
###

plots_dir_means <- paste(plots_dir,"/means", sep="")
dir.create(plots_dir_means) 

pdf(paste(plots_dir_means,'/mean_gender.pdf', sep=""),width=6,height=3)
barplot(mean_gender_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_gender_plots)*3+6), main="Gender",legend.text=rownames(mean_gender_plots),args.legend=list(x=ncol(mean_gender_plots)*3+12, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_ethnicity.pdf', sep=""),width=6,height=3)
barplot(mean_ethnicity_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_ethnicity_plots)*3+6), main="Ethnicity",legend.text=rownames(mean_ethnicity_plots),args.legend=list(x=ncol(mean_ethnicity_plots)*3+12, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_highest_degree.pdf', sep=""),width=6,height=3)
barplot(mean_highest_degree_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_highest_degree_plots)*3+6), main="Highest Degree",legend.text=rownames(mean_highest_degree_plots),args.legend=list(x=ncol(mean_highest_degree_plots)*3+10, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_earned.pdf', sep=""),width=6,height=3)
barplot(mean_earned_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_earned_plots)*6+6), main="Year Degree Earned",legend.text=rownames(mean_earned_plots),args.legend=list(x=ncol(mean_earned_plots)*6+18, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_bx_training.pdf', sep=""),width=6,height=3)
barplot(mean_bx_training_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_bx_training_plots)*8+6), main="Bioinformatics Training",legend.text=rownames(mean_bx_training_plots),args.legend=list(x=ncol(mean_bx_training_plots)*8+22, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_minority_serving.pdf', sep=""),width=6,height=3)
barplot(mean_minority_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_minority_plots)*3+6), main="Minority Serving",legend.text=rownames(mean_minority_plots),args.legend=list(x=ncol(mean_minority_plots)*3+12, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_race.pdf', sep=""),width=6,height=3)
barplot(mean_race_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_race_plots)*3+6), main="Race",legend.text=rownames(mean_race_plots),args.legend=list(x=ncol(mean_race_plots)*3+12, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_total_students.pdf', sep=""),width=6,height=3)
barplot(mean_total_students_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_total_students_plots)*5), main="Total Students",legend.text=rownames(mean_total_students_plots),args.legend=list(x=ncol(mean_total_students_plots)*5+9, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_total_undergrads.pdf', sep=""),width=6,height=3)
barplot(mean_total_undergrads_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_total_undergrads_plots)*5), main="Total Undergrads",legend.text=rownames(mean_total_undergrads_plots),args.legend=list(x=ncol(mean_total_undergrads_plots)*5+9, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_faculty.pdf', sep=""),width=6,height=3)
barplot(mean_faculty_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_faculty_plots)*5+10), main="Faculty",legend.text=rownames(mean_faculty_plots),args.legend=list(x=ncol(mean_faculty_plots)*5+18, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_carnegie.pdf', sep=""),width=6,height=3)
barplot(mean_carnegie_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_carnegie_plots)*5+10), main="Carnegie",legend.text=rownames(mean_carnegie_plots),args.legend=list(x=ncol(mean_carnegie_plots)*5+16, y=max(5),bty = "n"))
dev.off()

pdf(paste(plots_dir_means,'/mean_undergrad_majors.pdf', sep=""),width=6,height=3)
barplot(mean_undergrad_majors_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_undergrad_majors_plots)*4+8), main="Undergrad Majors",legend.text=rownames(mean_undergrad_majors_plots),args.legend=list(x=ncol(mean_undergrad_majors_plots)*4+17, y=max(5),bty = "n"))
dev.off()


########
# Additional figure of three competencies
########
# pdf(paste(plots_dir,'/Figure3.pdf', sep=""),width=5,height=7)
# par(mfrow=c(3,1))
# barplot(mean_carnegie_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_carnegie_plots)*5+8), main="Carnegie",legend.text=rownames(mean_carnegie_plots),args.legend=list(x=ncol(mean_carnegie_plots)*5+14, y=max(5),bty = "n"))
# barplot(mean_earned_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_earned_plots)*6+10), main="Year Degree Earned",legend.text=rownames(mean_earned_plots),args.legend=list(x=ncol(mean_earned_plots)*6+16, y=max(5),bty = "n"))
# barplot(mean_bx_training_plots, beside=T, las=3, ylim=c(0,5), xlim=c(0,ncol(mean_bx_training_plots)*8), main="Bioinformatics Training",legend.text=rownames(mean_bx_training_plots),args.legend=list(x=ncol(mean_bx_training_plots)*8+14, y=max(5),bty = "n"))
# dev.off()

# Figure in Greyscale
# pdf(paste(plots_dir,'/Figure3_S13.pdf', sep=""),width=4,height=5)
# par(mfrow=c(2,3),mar=c(6.5,4.1,4.1,1),oma=c(0,0,3,0))
# barplot(mean_carnegie_plots[,3], ylim=c(0,5), las=3, col=c("white","gray66","gray33","black"), space=0, main="Carnegie", ylab="Mean Likert")
# barplot(mean_earned_plots[,3], ylim=c(0,5), las=3, col=c("white","gray75","gray50","gray25","black"), space=0, main="Earned", ylab="Mean Likert")
# barplot(mean_bx_training_plots[,3], ylim=c(0,5), las=3, col=c("white","gray80","gray60","gray40","gray20","black"), space=0, main="Training", ylab="Mean Likert")
# barplot(mean_carnegie_plots[,13], ylim=c(0,5), las=3, col=c("white","gray66","gray33","black"), space=0, main="Carnegie", ylab="Mean Likert")
# barplot(mean_earned_plots[,13], ylim=c(0,5), las=3, col=c("white","gray75","gray50","gray25","black"), space=0, main="Earned", ylab="Mean Likert")
# barplot(mean_bx_training_plots[,13], ylim=c(0,5), las=3, col=c("white","gray80","gray60","gray40","gray20","black"), space=0, main="Training", ylab="Mean Likert")
# mtext("Skill 3 - Statistics", outer = TRUE)
# mtext("Skill 13 - Scripting", side = 3, outer = TRUE, line = -18)
# dev.off()

library(RColorBrewer)
numdata <- length()
blues <- brewer.pal(numdata, "Blues")


pdf(paste(plots_dir,'/Figure3_S13.pdf', sep=""),width=4,height=5)
par(mfrow=c(2,3),mar=c(7,4.1,4.1,1),oma=c(0,0,3,0))
numdata <- length(mean_carnegie_plots[,3])
blues <- brewer.pal(numdata, "Blues")
barplot(mean_carnegie_plots[,3], ylim=c(0,5), las=3, col=blues, space=0, main="Carnegie", ylab="Mean Likert")

numdata <- length(mean_earned_plots[,3])
blues <- brewer.pal(numdata, "Blues")
barplot(mean_earned_plots[,3], ylim=c(0,5), las=3, col=blues, space=0, main="Year Earned", ylab="Mean Likert")

numdata <- length(mean_bx_training_plots[,3])
blues <- brewer.pal(numdata, "Blues")
barplot(mean_bx_training_plots[,3], ylim=c(0,5), las=3, col=blues, space=0, main="Training", ylab="Mean Likert")

numdata <- length(mean_carnegie_plots[,13])
blues <- brewer.pal(numdata, "Blues")
barplot(mean_carnegie_plots[,13], ylim=c(0,5), las=3, col=blues, space=0, main="Carnegie", ylab="Mean Likert")

numdata <- length(mean_earned_plots[,13])
blues <- brewer.pal(numdata, "Blues")
barplot(mean_earned_plots[,13], ylim=c(0,5), las=3, col=blues, space=0, main="Year Earned", ylab="Mean Likert")

numdata <- length(mean_bx_training_plots[,13])
blues <- brewer.pal(numdata, "Blues")
barplot(mean_bx_training_plots[,13], ylim=c(0,5), las=3, col=blues, space=0, main="Training", ylab="Mean Likert")

#mtext("Skill 3 - Statistics", outer = TRUE)
#mtext("Skill 13 - Scripting", side = 3, outer = TRUE, line = -18)
mtext(substitute(paste(bold("S3 ("), bolditalic('Statistics'),bold(")"))), outer = TRUE)
mtext(substitute(paste(bold("S13 ("), bolditalic('Scripting'),bold(")"))), side = 3, outer = TRUE, line = -18)
dev.off()


