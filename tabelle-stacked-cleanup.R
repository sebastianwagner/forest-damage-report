#!/usr/bin/env Rscript

library(ggplot2)

# raw csv data
"SaSa eaten data RAW"
sasa_eaten_data_raw <- read.csv2("sasa_eaten.csv", sep=",", dec=".")
sr <- sasa_eaten_data_raw

"SaSa Eaten Data Synthetic"
syn_year <- c(rep(2000 , 3) , rep(2021 , 3) , rep(2029 , 3) , rep(2063 , 3) )
syn_year <- rep(as.integer(syn_year), 4)
syn_treekind <- rep(c("Buche" , "Fichte" , "Grenzstein") , 4)
syn_treekind <- rep(syn_treekind, 4)
syn_plot <- as.integer(c(rep(1, 12), rep(2, 12), rep(3,12), rep(4,12)))
syn_demage <- abs(rnorm(12 , 0 , 15))
syn_demage <- rep(syn_demage, 4)
synthetic <- data.frame(
  Jahr=syn_year,
  Plot=syn_plot,
  Baumart=syn_treekind,
  Fraß=syn_demage
)

# synthetic selection
"selection"
#sr <- synthetic #uncomment to use made-up data
str(sr)

# sas raw data internal labled
"internal labeling"
srl <- data.frame(
  year=sr$Jahr,
  "plot"=sr$Plot,
  treekind=sr$Baumart,
  demage=sr$Fraß
)
#str(srl)

# raw typing
"SaSa eaten data after Typing"
sasa_eaten_data_typed <- data.frame(
  year=as.factor(srl$year),
  "plot"=srl$"plot",
  treekind=srl$treekind,
  demage=srl$demage
)
st <- sasa_eaten_data_typed
str(st)
#st
## calculations
st <- subset(st, plot==2)

## output preparation
# relabel only
sl <- data.frame(
  Jahr=st$year,
  Baumart=st$treekind,
  Schadenshöhe=st$demage
)
#str(sl)

# Stacked
p <- ggplot(sl, aes(x=Jahr, fill=Baumart, y=Schadenshöhe)) +
    geom_bar(position="stack", stat="identity")
    #geom_col(position="dodge")
    #geom_col()
ggsave("out.png", plot = p, dpi=100)
