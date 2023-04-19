# Chapter examins the customization of the user interface
# Many packages aimed to expand shiny, see: https://github.com/nanxstats/awesome-shiny-extensions

library(tidyverse)
library(here)
dependecies <- read_csv(here("Mastering_Shiny/dependecies.csv")) %>% pull(packages)
pacman::p_load(char = dependecies)

# Inputs ----

# Examples: sliderInput, selectInput, textInput, numericInput

# Common Structure:
