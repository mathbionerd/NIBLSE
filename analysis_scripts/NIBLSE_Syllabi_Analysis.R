# Set the pathname: 
path <- "/Users/melissa/Desktop/NIBLSE_analysis/"

# EVERYTHING ELSE SHOULD RUN SO LONG AS YOU HAVE NOT EDITED THE NAME OF THE SURVEY DATA
# This will automatincally make the path to the survey data in tab-delimited format
# If you have edited the name of the survey data file on your computer, you will need to edit it below.

plots_dir <- paste(path,"plots",sep="")
dir.create(plots_dir) 

syllabi <- paste(path,"NIBLSE_Syllabi-Survey_summary_data.txt", sep="")
syllabi_data <- read.table(file=syllabi,header=TRUE, sep="\t",fill = TRUE)


syllabi_data$Skills.In.Syllabi.Percentage <- syllabi_data$Competencies.In.Syllabi/90
syllabi_data$MVE <- syllabi_data$Moderately.Important + syllabi_data$Very.Important + syllabi_data$Extremely.Important
syllabi_data$MVE.Percentage <- syllabi_data$MVE/syllabi_data$Total.Responses

syllabi_data$VE <- syllabi_data$Very.Important + syllabi_data$Extremely.Important
syllabi_data$VE.Percentage <- syllabi_data$VE/syllabi_data$Total.Responses


# Skill_comparison <- cbind(syllabi_data$MVE.Percentage,syllabi_data$Skills.In.Syllabi.Percentage)
# colnames(Skill_comparison) <- c("Survey","Syllabi")
# rownames(Skill_comparison) <- c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15")

Skill_comparison <- data.frame(cbind(syllabi_data$VE.Percentage,syllabi_data$Skills.In.Syllabi.Percentage))
colnames(Skill_comparison) <- c("Survey","Syllabi")

rownames(Skill_comparison) <- c("S1 - Role","S2 - Concepts","S3 - Statistics","S4 - Access genomic","S5 - Tools genomic","S6 - Access expression","S7 - Tools expression","S8 - Access proteomic","S9 - Tools proteomic","S10 - Access metabolic","S11 - Pathways","S12 - Metagenomics","S13 - Scripting","S14 - Software","S15 - Computational environment")
# rownames(Skill_comparison) <- c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15")

# labs <- c("S1 - Role","S2 - Concepts","S3 - Statistics","S4 - Access genomic","S5 - Tools genomic","S6 - Access expression","S7 - Tools expression","S8 - Access proteomic","S9 - Tools proteomic","S10 - Access metabolic","S11 - Pathways","S12 - Metagenomics","S13 - Scripting","S14 - Software","S15 - Computational environment")
# labs <- c("S1 (Role)","S2 (Concepts)","S3 (Statistics)","S4 (Access genomic)","S5 (Tools genomic)","S6 (Access expression)","S7 (Tools expression)","S8 (Access proteomic)","S9 (Tools proteomic)","S10 (Access metabolic)","S11 (Pathways)","S12 (Metagenomics)","S13(Scripting)","S14 (Software)","S15 (Computational environment)")
#labs <- c("S1 (Role)","S2 (Concepts)","S3 (Statistics)","S4 (Access genomic)","S5 (Tools genomic)","S6 (Access expression)","S7 (Tools expression)","S8 (Access proteomic)","S9 (Tools proteomic)","S10 (Access metabolic)","S11 (Pathways)","S12 (Metagenomics)","S13(Scripting)","S14 (Software)","S15 (Computational environment)")
#labs <- c("S4 (Access genomic)","S1 (Role)","S3 (Statistics)","S8 (Access proteomic)","S6 (Access expression)","S2 (Concepts)","S10 (Access metabolic)","S5 (Tools genomic)","S9 (Tools proteomic)","S14 (Software)","S15 (Computational environment)","S7 (Tools expression)","S11 (Pathways)","S12 (Metagenomics)","S13(Scripting)")


#ordered <- Skill_comparison[order(-Skill_comparison$Survey),]
ordered <- rbind(Skill_comparison[4,],Skill_comparison[1,],Skill_comparison[3,],Skill_comparison[8,],Skill_comparison[6,],Skill_comparison[2,],Skill_comparison[10,],Skill_comparison[5,],Skill_comparison[9,],Skill_comparison[14,],Skill_comparison[15,],Skill_comparison[7,],Skill_comparison[11,],Skill_comparison[12,],Skill_comparison[13,])


pdf(paste(plots_dir,'/Survey-Syllabi.pdf', sep=""),width=10,height=6)
par(mar=c(14,4.1,4.1,2.1))  #bottom, left, top, right
# barplot(t(ordered),beside=T,ylim=c(0,1),col=c("blue","grey"),legend=T,bty="n",las=3)
x <- barplot(t(ordered),beside=T,ylim=c(0,1),col=c("blue","grey"),xaxt="n")
#text(cex=1, x=x-0.5, y=-1.25, labs, xpd=TRUE, srt=45)
text(c("S4 (Access genomic)","S1 (Role)","S3 (Statistics)","S8 (Access proteomic)","S6 (Access expression)","S2 (Concepts)","S10 (Access metabolic)","S5 (Tools genomic)","S9 (Tools proteomic)","S14 (Software)","S15 (Computational environment)","S7 (Tools expression)","S11 (Pathways)","S12 (Metagenomics)","S13(Scripting)"), cex=1,x=colMeans(x)-.25,y=-0.1, xpd=NA, srt=60, adj=1)
mtext("Proportion", side=2, line=3,font=2)
mtext("Skill", side=1, line=12,font=2)
abline(v=21.5, lty=2)
dev.off()





# Number of Skills covered in each syllabi

test <- c(5,1,7,12,8,8,9,8,8,9,6,0,10,7,3,5,5,7,9,8,10,0,9,4,8,0,4,9,0,7,5,0,9,11,6,8,1,1,9,6,9,0,4,6,0,3,7,7,3,10,7,8,6,0,6,2,8,0,8,5,0,7,9,4,5,4,4,3,4,7,3,5,9,13,3,5,6,1,7,1,1,6,6,5,7,7,9,7,6,4)

# Now, plot the representation by demographics, calculated above
pdf(paste(plots_dir,'/Syllabi_histogram.pdf', sep=""),width=5,height=3)
hist(test, right=FALSE,xlim=c(0,15),breaks=14,col="blue", main="",xlab="Number of Skills",ylab="Number of Syllabi")
dev.off()

summary(test)

#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#  0.000   3.250   6.000   5.544   8.000  13.000 





