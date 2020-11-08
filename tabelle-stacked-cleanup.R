#!/usr/bin/env Rscript

library(ggplot2)

# raw csv data
"SaSa eaten data RAW"
sasa_eaten_data_raw <- read.csv2("sasa_eaten.csv", sep=",", dec=".")
sr <- sasa_eaten_data_raw

"SaSa Eaten Data Synthetic"
syn_year <- c(rep(2000 , 3) , rep(2021 , 3) , rep(2029 , 3) , rep(2063 , 3) )
syn_year <- rep(as.integer(syn_year), 4)
syn_treekind <- rep(c("Buche" , "Fichte" , "BI") , 4)
syn_treekind <- rep(syn_treekind, 4)
syn_plot <- as.integer(c(rep(1, 12), rep(2, 12), rep(3,12), rep(4,12)))
syn_damage <- abs(rnorm(12 , 0 , 15))
syn_damage <- rep(syn_damage, 4)
synthetic <- data.frame(
  Jahr=syn_year,
  Plot=syn_plot,
  Baumart=syn_treekind,
  `Höhe1.verbissen`=syn_damage
)

# synthetic selection
"selection"
sr <- synthetic #uncomment to use made-up data
str(sr)

# sas raw data internal labled
"internal labeling"
srl <- data.frame(
  year=sr$Jahr,
  "plot"=sr$Plot,
  treekind=sr$Baumart,
  damage=sr$`Höhe1.verbissen`
)
#str(srl)

# raw typing
"SaSa eaten data after Typing"
sasa_eaten_data_typed <- data.frame(
  year=as.factor(srl$year),
  "plot"=srl$"plot",
  treekind=srl$treekind,
  damage=srl$damage
)
st <- sasa_eaten_data_typed
str(st)
#st
## calculations
st <- subset(st, plot==2)

## output preparation

# Stacked
p <- ggplot(st, aes(x=year, fill=treekind, y=damage)) +
    geom_bar(position="stack", stat="identity") +
    labs(x = 'Jahr', y = 'Höhe1 verbissen', fill = 'Baumart')
    #geom_col(position="dodge")
    #geom_col()
ggsave("out.png", plot = p, dpi=100)
