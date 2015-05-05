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


# Geschlecht extrahieren
bob$vpSex    = str_sub(bob$vpCode_lowerstr, 8, 8)
bob$vpSex         <- as.factor(bob$vpSex)
levels(bob$vpSex) <- c('male' , 'female')


bob$vpCode_lowerstr <- NULL


# stimulus aufbrechen
str.split.cue = str_split_fixed (bob$cue , c('_'), 5) # spliten am _

str.split.cue=data.frame (str.split.cue , stringsAsFactors=FALSE) # als datafram umwandeln um mit $ anzusteuern

names(str.split.cue)[names(str.split.cue)=='X1'] <-'cueBaujahr'
names(str.split.cue)[names(str.split.cue)=='X2'] <-'cueMarke'
names(str.split.cue)[names(str.split.cue)=='X3'] <-'cueReihe'
names(str.split.cue)[names(str.split.cue)=='X4'] <-'cueAnsicht'
names(str.split.cue)[names(str.split.cue)=='X5'] <-'cueAusrichtung'


TFPfeil =str.split.cue$cueBaujahr=='Pfeil'
str.split.cue$cueAusrichtung[TFPfeil] = str.split.cue$cueMarke[TFPfeil] # ausrichtung relocaten
str.split.cue$cueMarke[TFPfeil]       = str.split.cue$cueBaujahr[TFPfeil] # marke "pfeil"relocaten


str.split.cue$cueReihe[TFPfeil]   <- NA
str.split.cue$cueAnsicht[TFPfeil] <- NA
str.split.cue$cueBaujahr[TFPfeil] <- NA
  
str.split.cue$cueBaujahr      <-as.factor(str.split.cue$cueBaujahr)
str.split.cue$cueMarke        <-as.factor(str.split.cue$cueMarke)
str.split.cue$cueReihe        <-as.factor(str.split.cue$cueReihe)
str.split.cue$cueAnsicht      <-as.factor(str.split.cue$cueAnsicht)
str.split.cue$cueAusrichtung  <-as.factor(str.split.cue$cueAusrichtung)

levels(str.split.cue$cueAusrichtung)[levels(str.split.cue$cueAusrichtung)== 'L.png'] <- 'left'
levels(str.split.cue$cueAusrichtung)[levels(str.split.cue$cueAusrichtung)== 'R.png'] <- 'right'

# zusammenführen
bob=data.frame(bob , str.split.cue)

# stimulus noch hübshc machen
bob$stimulusType= bob$stimulus
levels(bob$stimulusType)[levels(bob$stimulusType)=='E.png'] <- 'E'
levels(bob$stimulusType)[levels(bob$stimulusType)=='T.png'] <- 'T'


## speichern als Rdata #########################################################

write.csv          (bob, file = "shapes2data_clean.csv")
save               (bob, file = "shapes2data_clean.Rda")
foreign:::write.dta(bob, file = "shapes2data_clean.dta") # kann spss auch importiern


# Workspace leeren

rm(list = ls())

## end #########################################################################