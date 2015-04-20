################################################################################
##                          daten zusammenführen                             ##
################################################################################


# Workspace leeren
rm(list = ls())


# pfad setzen optional wenn das rskript mit doppelkilck ausgeführt wurde 
#setwd("~git/the-shapening2/output/R/")


# pakete installieren ##########################################################

# install.packages("stringr")

# pakete laden #################################################################

library(stringr)



# get list of all csv files ####################################################
# http://stackoverflow.com/questions/11433432/importing-multiple-csv-files-into-r
# Dateiname aufbau: 'vpNummer _ vpCode _output.csv'
csvlist = list.files(pattern="*_output.csv")

# bob initieren
bob = rbind (read.csv(csvlist[1]))

# loop alle dateien einlesen und in ein file klatschen 
howmanycsv=length(csvlist)
for (i in 2:howmanycsv) {
  bob = rbind (bob , read.csv(csvlist[i]))
}


# Missing values ###############################################################
# missing values durck NA ersetzen 

# für die Reaktopnszeiten
bob$reactionStimOFF[bob$ratingWert==9999] <- NA
bob$reactionStimON[bob$ratingWert==9999]  <- NA
# und die eigentlichen keys
bob$ratingWert[bob$ratingWert==9999]        <- NA

# hats funtioniert ?
bob$ratingWert==9999
bob$reactionStimOF ==9999
bob$reactionStimON ==9999
#sollte auch mit recode gehn


# erster überblick
summary(bob)

# ratingWerts -1 da die cedrus box nur werte von 2-8 ausgibt######################
f.value <- function(datarow){
  math=datarow-1
  return(math)
}
bob$ratingWert= mapply(f.value, bob$ratingWert)

# sicherheitskopie #############################################################
bob_full = bob


#Übung raus ####################################################################
bob      = subset(bob , bob$blockBeschreibung != 'übung' )


# STRING stuff #################################################################
# http://gastonsanchez.com/blog/resources/how-to/2013/09/22/Handling-and-Processing-Strings-in-R.html
# erst mal die Buchstaben auf lower case bringen

# bob$vpCode_lower_str=tolower(bob$vpCode)
# bob$vpCode= as.factor(bob$vpCode_lower_str)

#vpcode zwerlegung Aufbau abc1998m #############################################
summary(bob$vpCode_lower_str)

# Geburtsdatum extrahieren
bob$vpGeburt = str_sub(bob$vpCode_lower_str, 4, 7) 
bob$vpGeburt = as.numeric (bob$vpGeburt)
bob$vpGeburt_alter = 2014-bob$vpGeburt

# Geschlecht extrahieren
bob$vpSex    = str_sub(bob$vpCode_lower_str, 8, 8)
bob$vpSex         <- as.factor(bob$vpSex)
levels(bob$vpSex) <- c('male' , 'female')


# speichern als Rdata ##########################################################
write.csv          (bob, file = "shapes1data.csv")
save               (bob, file = "shapes1data.Rda")
foreign:::write.dta(bob, file = "shapes1data.dta") # kann spss auch importiern


# sessionInfo speichern ########################################################
# https://stackoverflow.com/questions/21967254/how-to-write-a-reader-friendly-sessioninfo-to-text-file
writeLines(capture.output(sessionInfo()), "sessionInfo_R01.txt")

# Workspace leeren
rm(list = ls())
# end ##########################################################################

