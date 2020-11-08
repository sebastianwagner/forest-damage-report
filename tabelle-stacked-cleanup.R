#!/usr/bin/env Rscript

library(ggplot2)

# raw csv data
sasa_eaten_data_raw = read.csv2("sasa_eaten.csv", sep=",", dec=".")
#str(sasa_eaten_data_raw)
sr = sasa_eaten_data_raw
#"SaSa eaten data RAW"
#sr

# raw typing
sasa_eaten_data_typed = data.frame(year=as.factor(sr$Jahr),treekind=sr$Baumart,demage=sr$Fraß)
#str(sasa_eaten_data_typed)
st = sasa_eaten_data_typed
"SaSa eaten data after Typing"
st

# relabel only
sasa_eaten_data_labeled = data.frame(Jahr=st$year,Baumart=st$treekind,Schadenshöhe=st$demage)


# synthetic
sasa_year <- c(rep("2000" , 3) , rep("2021" , 3) , rep("2029" , 3) , rep("2063" , 3) )
#sasa_year <- c(rep(2000 , 3) , rep(2021 , 3) , rep(2029 , 3) , rep(2063 , 3) )
sasa_treekind <- rep(c("Buche" , "Fichte" , "Grenzstein") , 4)
sasa_eaten <- abs(rnorm(12 , 0 , 15))
sasa_eaten_data_synthetic <- data.frame(Jahr=sasa_year,Baumart=sasa_treekind,Schadenshöhe=sasa_eaten)

"SaSa Eaten Data Synthetic"
#str(sasa_eaten_data_synthetic)

# selection
sasa_eaten_data = sasa_eaten_data_labeled 
#sasa_eaten_data = sasa_eaten_data_synthetic

# Stacked
p = ggplot(sasa_eaten_data, aes(x=Jahr, fill=Baumart, y=Schadenshöhe)) + 
    geom_bar(position="stack", stat="identity")
    #geom_col(position="dodge")
    #geom_col()
ggsave("out.png", plot = p, dpi=100)
