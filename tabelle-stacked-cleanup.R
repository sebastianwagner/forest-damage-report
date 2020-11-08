#!/usr/bin/env Rscript

library(ggplot2)

# raw csv data
rawdata <- read.csv2("sasa_eaten.csv", sep=",", dec=".")

build_synthetic_data <- function() {
  syn_year <- c(rep(2000 , 3) , rep(2021 , 3) , rep(2029 , 3) , rep(2063 , 3) )
  syn_year <- rep(as.integer(syn_year), 4)
  syn_treekind <- rep(c("Buche" , "Fichte" , "BI") , 4)
  syn_treekind <- rep(syn_treekind, 4)
  syn_plot <- as.integer(c(rep(1, 12), rep(2, 12), rep(3,12), rep(4,12)))
  syn_damage <- abs(rnorm(12 , 0 , 15))
  syn_damage <- rep(syn_damage, 4)
  data.frame(
    Jahr=syn_year,
    Plot=syn_plot,
    Baumart=syn_treekind,
    `Höhe1.verbissen`=syn_damage
  )
}
# synthetic selection
rawdata <- build_synthetic_data() #uncomment to use made-up data

# sas raw data internal labled
as_internal_labels <- function(sr) {
  data.frame(
    year=sr$Jahr,
    "plot"=sr$Plot,
    treekind=sr$Baumart,
    tree_count.size1.game_damage=sr$`Höhe1.verbissen`
  )
}
internal_data <- as_internal_labels(rawdata)

# raw typing
# convert input int years to Factors
internal_data$year <- as.factor(internal_data$year)
clean_internal_data <- internal_data

## calculations
st <- subset(clean_internal_data, plot==2)

## output preparation

# Stacked
p <- ggplot(st, aes(x=year, fill=treekind, y=tree_count.size1.game_damage)) +
    geom_bar(position="stack", stat="identity") +
    labs(x = 'Jahr', y = 'Höhe1 verbissen', fill = 'Baumart')
    #geom_col(position="dodge")
    #geom_col()
ggsave("out.png", plot = p, dpi=100)
