##############################################################################
##                          daten zusammenführen                             
##############################################################################

# Workspace leeren
rm(list = ls())

## Rohdaten laden ##############################################################

load("shapes2data_raw.Rda")

## delete rename colums ########################################################
# change rename dauer and delete unused dauer rows
# TODO - das sollte sich auch atomatisieren lassen 

bob$dauerCue <- NULL
bob$dauerFix <- NULL

names(bob)[names(bob)=='dauerPre'] <- 'dauerCue'

## NaN -> NA ###################################################################
# change matlab NaN to NA cause NA is for numbers
for (i in 1:length(bob)) {
  TFindex <- is.nan(bob[,i]) #make a truefalse array for one colum
  bob[ TFindex , i] <- NA # zeilen die TRUE sind also NA werden überschrieben
}


  

## speichern als Rdata #########################################################
write.csv          (bob, file = "shapes2data_mod.csv")
save               (bob, file = "shapes2data_mod.Rda")
foreign:::write.dta(bob, file = "shapes2data_mod.dta") # kann spss auch importiern


# Workspace leeren
rm(list = ls())
## end #########################################################################
