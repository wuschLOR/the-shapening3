##############################################################################
##                          daten zusammenführen                             
##############################################################################


# Workspace leeren
rm(list = ls())


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


# speichern als Rdata ##########################################################
write.csv          (bob, file = "shapes2data_raw.csv")
save               (bob, file = "shapes2data_raw.Rda")
foreign:::write.dta(bob, file = "shapes2data_raw.dta") # kann spss auch importiern


# Workspace leeren
rm(list = ls())
# end ##########################################################################

