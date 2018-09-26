library(airGRteaching)
library(shiny)
library(data.table)

#DATA UPLOAD

BasinObs=readRDS("airGRdata")

#DEFINITION OF INPUT DATA AND MODEL TYPE


PREP=PrepGR(DatesR = BasinObs$DatesR, Precip = BasinObs$P,
            PotEvap = BasinObs$E, Qobs = BasinObs$Qmm, TempMean = BasinObs$T, HydroModel = "GR4J", 
            CemaNeige = TRUE, HypsoData = seq(from = 200, to = 1200, by = ((1000)/(100))), ZInputs = 500,  NLayers = 5)

#CALIBRATION

CAL <- CalGR(PrepGR = PREP, CalCrit="NSE", WupPer = NULL, CalPer = c("2012-01-01", "2012-05-31"))

#SIMULATION

SIM <- SimGR(PrepGR = PREP, CalGR = CAL, EffCrit = "NSE", WupPer= NULL, SimPer = c("2012-06-01", "2018-01-08"))

plot(PREP, main = "Observation")

plot(CAL, which="perf")

plot(CAL, which="iter")


###### SHINY

ShinyGR(ObsDF = BasinObs, SimPer= c("2012-01-01", "2018-08-01"))

