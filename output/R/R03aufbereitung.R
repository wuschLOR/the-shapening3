################################################################################
##                          daten aufbereiten                             
################################################################################

# Workspace leeren
rm(list = ls())

# Rohdaten laden 

load("shapes2data_mod.Rda")

## invalid responses ###########################################################
# NA invalid responses aka 'FAIL' bob$ratingTaste
TFindex=bob$ratingTaste=='FAIL'
bob$ratingTaste[TFindex]     <- NA
bob$ratingWert[TFindex]      <- NA
# bob$reactionStimON[TFindex]  <- NA # will ich das ?
# bob$reactionStimOFF[TFindex] <- NA # will ich das ?


# keyValues -1 da die cedrus box nur werte von 2-8 ausgibt######################
bob$ratingWert <- bob$ratingWert -1


## speichern als Rdata #########################################################

write.csv          (bob, file = "shapes2data_mod.csv")
save               (bob, file = "shapes2data_mod.Rda")
foreign:::write.dta(bob, file = "shapes2data_mod.dta") # kann spss auch importiern


# Workspace leeren

rm(list = ls())

## end #########################################################################