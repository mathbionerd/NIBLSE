# Set the pathname: 
path <- "/Users/melissa/Desktop/NIBLSE_analysis/"

# EVERYTHING ELSE SHOULD RUN SO LONG AS YOU HAVE NOT EDITED THE NAME OF THE SURVEY DATA
# This will automatincally make the path to the survey data in tab-delimited format
# If you have edited the name of the survey data file on your computer, you will need to edit it below.

plots_dir <- paste(path,"plots",sep="")
dir.create(plots_dir) 

syllabi <- paste(path,"NIBLSE_Syllabi-Survey_summary_data.txt", sep="")
syllabi_data <- read.table(file=syllabi,header=TRUE, sep="\t",fill = TRUE)


syllabi_data$Competencies.In.Syllabi.Percentage <- syllabi_data$Competencies.In.Syllabi/90
syllabi_data$MVE <- syllabi_data$Moderately.Important + syllabi_data$Very.Important + syllabi_data$Extremely.Important
syllabi_data$MVE.Percentage <- syllabi_data$MVE/syllabi_data$Total.Responses

syllabi_data$VE <- syllabi_data$Very.Important + syllabi_data$Extremely.Important
syllabi_data$VE.Percentage <- syllabi_data$VE/syllabi_data$Total.Responses


# competency_comparison <- cbind(syllabi_data$MVE.Percentage,syllabi_data$Competencies.In.Syllabi.Percentage)
# colnames(competency_comparison) <- c("Survey","Syllabi")
# rownames(competency_comparison) <- c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15")

competency_comparison <- data.frame(cbind(syllabi_data$VE.Percentage,syllabi_data$Competencies.In.Syllabi.Percentage))
colnames(competency_comparison) <- c("Survey","Syllabi")
rownames(competency_comparison) <- c("C1 - Role","C2 - Concepts","C3 - Statistics","C4 - Access genomic","C5 - Tools genomic","C6 - Access expression","C7 - Tools expression","C8 - Access proteomic","C9 - Tools proteomic","C10 - Access metabolic","C11 - Pathways","C12 - Metagenomics","C13 - Scripting","C14 - Software","C15 - Computational environment")
# rownames(competency_comparison) <- c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15")

#ordered <- competency_comparison[order(-competency_comparison$Survey),]
ordered <- rbind(competency_comparison[4,],competency_comparison[1,],competency_comparison[3,],competency_comparison[8,],competency_comparison[6,],competency_comparison[2,],competency_comparison[10,],competency_comparison[5,],competency_comparison[9,],competency_comparison[14,],competency_comparison[15,],competency_comparison[7,],competency_comparison[11,],competency_comparison[12,],competency_comparison[13,])


pdf(paste(plots_dir,'/Survey-Syllabi.pdf', sep=""),width=10,height=6)
par(mar=c(14,4.1,4.1,2.1))  #bottom, left, top, right
barplot(t(ordered),beside=T,ylim=c(0,1),col=c("blue","grey"),legend=T,bty="n",las=3)
mtext("Proportion", side=2, line=3,font=2)
mtext("Competency", side=1, line=12,font=2)
abline(v=21.5, lty=2)
dev.off()

# Number of competencies covered in each syllabi

test <- c(5,1,7,12,8,8,9,8,8,9,6,0,10,7,3,5,5,7,9,8,10,0,9,4,8,0,4,9,0,7,5,0,9,11,6,8,1,1,9,6,9,0,4,6,0,3,7,7,3,10,7,8,6,0,6,2,8,0,8,5,0,7,9,4,5,4,4,3,4,7,3,5,9,13,3,5,6,1,7,1,1,6,6,5,7,7,9,7,6,4)

# Now, plot the representation by demographics, calculated above
pdf(paste(plots_dir,'/Syllabi_histogram.pdf', sep=""),width=5,height=3)
hist(test, right=FALSE,xlim=c(0,15),breaks=14,col="blue", main="Competencies",xlab="Number of Competencies")
dev.off()

summary(test)

#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#  0.000   3.250   6.000   5.544   8.000  13.000 





