#!/usr/bin/env Rscript

library(ggplot2)
library(tidyr)

# raw csv data
rawdata <- read.csv2("sasa_eaten.csv", sep=",", dec=".")

build_synthetic_data <- function() {
  syn_year <- c(rep(2000 , 3) , rep(2021 , 3) , rep(2029 , 3) , rep(2063 , 3) )
  syn_year <- rep(as.integer(syn_year), 4)
  syn_species <- rep(c("Buche" , "Fichte" , "BI") , 4)
  syn_species <- rep(syn_species, 4)
  syn_plot <- as.integer(c(rep(1, 12), rep(2, 12), rep(3,12), rep(4,12)))
  tree_count.size1.game_damage <- rep(abs(rnorm(12 , 0 , 15)), 4)
  tree_count.size1.intact <- rep(abs(rnorm(12 , 0 , 15)), 4)
  tree_count.size2.game_damage <- rep(abs(rnorm(12 , 0 , 15)), 4)
  tree_count.size2.intact <- rep(abs(rnorm(12 , 0 , 15)), 4)
  tree_count.size3.game_damage <- rep(abs(rnorm(12 , 0 , 15)), 4)
  tree_count.size3.intact <- rep(abs(rnorm(12 , 0 , 15)), 4)
  data.frame(
    Jahr=syn_year,
    Plot=syn_plot,
    Baumart=syn_species,
    `Höhe1.verbissen`=tree_count.size1.game_damage,
    `Höhe1.unverbissen`=tree_count.size1.intact,
    `Höhe2.verbissen`=tree_count.size2.game_damage,
    `Höhe2.unverbissen`=tree_count.size2.intact,
    `Höhe3.verbissen`=tree_count.size3.game_damage,
    `Höhe3.unverbissen`=tree_count.size3.intact
  )
}
# synthetic selection
rawdata <- build_synthetic_data() #uncomment to use made-up data

# sas raw data internal labled
as_internal_labels <- function(sr) {
  # tc is tree_count
  data.frame(
    year=sr$Jahr,
    `plot`=sr$Plot,
    species=sr$Baumart,
    tc.size1.game_damage=sr$`Höhe1.verbissen`,
    tc.size1.intact=sr$`Höhe1.unverbissen`,
    tc.size2.game_damage=sr$`Höhe2.verbissen`,
    tc.size2.intact=sr$`Höhe2.unverbissen`,
    tc.size3.game_damage=sr$`Höhe3.verbissen`,
    tc.size3.intact=sr$`Höhe3.unverbissen`
  )
}
internal_data <- as_internal_labels(rawdata)

# raw typing
# convert input int years to Factors
internal_data$year <- as.factor(internal_data$year)
pivot_data <- pivot_longer(
  internal_data,
  tc.size1.game_damage:tc.size3.intact,
  names_to=c("size_groups", "damage"),
  names_prefix="tc\\.",
  names_sep="\\.",
  values_to="tree_count"
)
pivot_data$size_groups <- as.factor(pivot_data$size_groups)
pivot_data$damage <- as.factor(pivot_data$damage)

## calculations
pivot_data <- subset(pivot_data, plot==1 )
pivot_data <- subset(pivot_data, size_groups=="size1")
st <- subset(pivot_data, damage=="game_damage")

## output preparation

# Stacked
p <- ggplot(st, aes(x=year, fill=species, y=`tree_count`)) +
    geom_bar(position=position_stack(), stat="identity") +
    labs(x = 'Jahr', y = 'Höhe1 verbissen', fill = 'Baumart')
    #geom_col(position="dodge")
    #geom_col()
ggsave("out.png", plot = p, dpi=100)
