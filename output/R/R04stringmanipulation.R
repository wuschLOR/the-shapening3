################################################################################
##                          stringmanipulation                             
################################################################################

# Workspace leeren
rm(list = ls())

# Rohdaten laden 

load("shapes2data_mod.Rda") 


library(stringr)

## VP Code aufbrechen ##########################################################
#vpcode zwerlegung Aufbau abc1998m 

# vpcode alles klein schreiben

bob$vpCode_lowerstr=tolower(bob$vpCode)
bob$vpCode= as.factor(bob$vpCode_lowerstr)

summary(bob$vpCode_lowerstr)

# Geburtsdatum extrahieren
bob$vpGeburt = str_sub(bob$vpCode_lowerstr, 4, 7) 
bob$vpGeburt = as.numeric (bob$vpGeburt)
bob$vpGeburt_alter = 2015-bob$vpGeburt

bob$vpCode_lowerstr <- NULL

# Geschlecht extrahieren
bob$vpSex    = str_sub(bob$vpCode_lowerstr, 8, 8)
bob$vpSex         <- as.factor(bob$vpSex)
levels(bob$vpSex) <- c('male' , 'female')



## stimulus aufbrechen



## speichern als Rdata #########################################################

write.csv          (bob, file = "shapes2data_mod.csv")
save               (bob, file = "shapes2data_mod.Rda")
foreign:::write.dta(bob, file = "shapes2data_mod.dta") # kann spss auch importiern

# Workspace leeren

rm(list = ls())

## end #########################################################################