#     set the working directory to where data files are
#     Have to work on test and train data separately and merge the two after the activity names
#     and subject information is added to each data set.
#     Read the file 'features' into a dataframe:
  featurelist <- read.table ("./features.txt", header=FALSE, sep=" ")

#     Collect feature numbers corresponding to the variables where'mean' or 'std' at the end of the word.
#     For this process  those columns that have headings that include the string 'meanFreq' are excluded.
#     The same process can be followed even if they are included.    
  feat.nbrs <-grep("mean\\(\\)|std\\(\\)",featurelist$V2)

#     Collect feature names corresponding to the numbers in feat.nbrs. 
#     Order in this dataframe matches the order in feat.nbrs
  feat.names <- grep("mean\\(\\)|std\\(\\)",featurelist$V2, value = TRUE)

#     Read the file X_test in test directory to a dataframe
  testX <- read.csv("./test/x_test.txt", header = FALSE, sep= "")
#     Test Data
#     Create dataframe testdata by including only the columns with in feat.nbrs and 
#     verify using dim() on the dataframes test and testdata:
  testdata <- testX[,feat.nbrs]
  names(testdata) <- feat.names

#     Change the id in activities column (y_test) to descriptive
#     labels (factor variable) and append the column on the left of  
#     testdata and call the modified dataframe as testdata.
  act_id <- c(1, 2, 3, 4, 5, 6)
  act_names <- c("WALKING", "WALKING UPSTAIRS", "WALKING DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
  testY <- read.table("./test/y_test.txt", header=FALSE,sep="")
  names(testY) <- c("ACTIVITY")
  testY$ACTIVITY <- factor(testY$ACTIVITY, levels = act_id, labels = act_names)
  testdata <-cbind(testY,testdata)

#     Read the file subject_test into a dtaframe and append the  
#     heading 'SUBJECT' to it. Then append it as the first column to
#     the dataframe testdata
  subj_table <- read.table("./test/subject_test.txt", header=FALSE, sep = "")
  names(subj_table) <- c("SUBJECT")
  testdata <- cbind(subj_table,testdata)

#    Train Data 


#     Read the file X_train in the train directory to a dataframe:
  trainX <- read.csv("./train/x_train.txt", header = FALSE, sep= "")

#     Create dataframe traidata by including only the columns with  
#     numbers in ft.nbrs and verify using dim() on the dataframes     
#     train and traindata.
#     we already have feature names and numbers - reuse
  traindata <- trainX[,feat.nbrs]
  names(traindata) <- feat.names

#     Change the levels in activities column (y_train) to           
#     descriptive labels (factor variable) and append the column on
#     the left of traindata and call the modified as traindata
#     we already have act_id and act_names

  trainY <- read.table("./train/y_train.txt", header=FALSE,sep="")
  names(trainY) <- c("ACTIVITY")
  trainY$ACTIVITY <- factor(trainY$ACTIVITY, levels = act_id, labels = act_names)
  traindata <-cbind(trainY,traindata)

#     Read the file subject_test into a dtaframe and append the    
#     heading 'SUBJECT' to it. Then append it as the first column to
#     the dataframe traindata
  subj_table <- read.table("./train/subject_train.txt", header=FALSE, sep = "")
  names(subj_table) <- c("SUBJECT")
  traindata <- cbind(subj_table,traindata)
  
#    merge Test and Train data sets
  
   alldata <- rbind(testdata,traindata)

#   Reshape the data.
  library(reshape2)

#    Set Dimensions and Measures
#    Create the tidy data set
melteddata <- melt(alldata, id = c("SUBJECT", "ACTIVITY"))
tidydataset <- dcast(melteddata, SUBJECT + ACTIVITY ~ variable, mean)
write.table(tidydataset, "tidydataset.txt",row.name=FALSE, sep = "\t")