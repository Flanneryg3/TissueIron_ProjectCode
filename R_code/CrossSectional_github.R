###########################################################################################################
# Cross sectional anaylses at final timepoint (timepoint in which the task was completed) 
#Average nT2w (tissue iron) at wave 5 and cogcon  at ave 5 only 
# Plotting

###########################################################################################################
# Jessica S. Flannery, 2023, updated 2024

###########################################################################################################
###########################################################################################################
# package imports
###########################################################################################################
library(dplyr)
library(viridis)
library(lme4)
library(nlme)
library(lmerTest)
library(interactions)
library(data.table)
library(misty)
library(performance)
library(foreign)
library("boot")
library("pscl")
library("foreign")
library("MASS")
library("RColorBrewer")
library("AER")
library("lattice")
library("knitr")
library("sjPlot")
library(ggplot2)
###########################################################################################################
# data import

data <- read.csv("./data_w5.csv")
data_noADHD <- read.csv("./data_w5_noADHD.csv")

#Centering stuff! 
data$age_grandmc <- data$age - mean(data$age)
data$meanFD_grandmc <- data$meanFD - mean(data$meanFD)
data$drug_ever <- factor(data$drug_ever)
#Centering stuff! 
data_noADHD$age_grandmc <- data_noADHD$age - mean(data_noADHD$age)
data_noADHD$meanFD_grandmc <- data_noADHD$meanFD - mean(data_noADHD$meanFD)
data_noADHD$drug_ever <- factor(data_noADHD$drug_ever)

##################################################################################################################
###################################################################
#Boost BG BOLD signal and Boost in cognitive control behavior (dprime) at final timepoint 
##################################################################################################################

###################################################################
######################################################################################################################################
# Big boost behavior 
summary(m1 <- glm(formula = dprime_BB_NB ~ age_grandmc + meanFD_grandmc + AnyBoost_BG,
                  family = gaussian, data = data))

summary(m2 <- glm(formula = dprime_BB_NB ~ age_grandmc + meanFD_grandmc + BB_BG,
                  family = gaussian, data = data))

summary(m3 <- glm(formula = dprime_BB_NB ~ age_grandmc + meanFD_grandmc + SB_BG,
                  family = gaussian, data = data))
######################################################################################################################
# Small boost behavior 
summary(m4 <- glm(formula = dprime_SB_NB ~ age_grandmc + meanFD_grandmc + AnyBoost_BG,
                  family = gaussian, data = data))

summary(m5 <- glm(formula = dprime_SB_NB ~ age_grandmc + meanFD_grandmc + BB_BG,
                  family = gaussian, data = data))

summary(m6 <- glm(formula = dprime_SB_NB ~ age_grandmc + meanFD_grandmc + SB_BG,
                  family = gaussian, data = data))
######################################################################################################################
# cognitive control behavior in general 

summary(m7 <- glm(formula = dprime_all ~ age_grandmc + meanFD_grandmc + AnyBoost_BG,
                  family = gaussian, data = data))

summary(m8 <- glm(formula = dprime_all ~ age_grandmc + meanFD_grandmc + BB_BG,
                  family = gaussian, data = data))

summary(m9 <- glm(formula = dprime_all ~ age_grandmc + meanFD_grandmc + SB_BG,
                  family = gaussian, data = data))

####################################################################################################################
# Any boost behavior  
summary(m10 <- glm(formula = dprime_any_NB ~ age_grandmc + AnyBoost_BG,
                  family = gaussian, data = data))

summary(m11 <- glm(formula = dprime_any_NB ~ age_grandmc + BB_BG,
                  family = gaussian, data = data))

summary(m12 <- glm(formula = dprime_any_NB ~ age_grandmc + SB_BG,
                  family = gaussian, data = data))
###################################################################

####################################################################################################################
# Any boost behavior and tissue iron at final time point
summary(m13 <- glm(formula = Put ~ age_grandmc + meanFD_grandmc + dprime_any_NB,
                   family = gaussian, data = data))

summary(m13 <- glm(formula = Put ~ age_grandmc + meanFD_grandmc + dprime_BB_NB,
                   family = gaussian, data = data))

summary(m13 <- glm(formula = Put ~ age_grandmc + meanFD_grandmc + dprime_SB_NB,
                   family = gaussian, data = data))

summary(m14 <- glm(formula = Nac ~ age_grandmc + meanFD_grandmc + dprime_any_NB,
                   family = gaussian, data = data))

summary(m15 <- glm(formula = Caud ~ age_grandmc + meanFD_grandmc+ dprime_any_NB,
                   family = gaussian, data = data))

summary(m16 <- glm(formula = GP ~ age_grandmc + meanFD_grandmc + dprime_any_NB,
                   family = gaussian, data = data))

summary(m17 <- glm(formula = BG ~ age_grandmc + meanFD_grandmc + dprime_any_NB,
                   family = gaussian, data = data))
###################################################################
######################################################################################################################################

p <- plot_model(m10, type="pred", terms = c("AnyBoost_BG"), auto.label = FALSE, 
                axis.title = c("BG BOLD   ", "D-PRIME BOOST"), 
                colors = c("blue"), title = "", line.size = 1, dot.size = 3, show.data = TRUE)


p + set_theme(geom.linetype=1) + theme_classic() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=12, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold'))


p <- plot_model(m11, type="pred", terms = c("BB_BG"), auto.label = FALSE, 
                axis.title = c("BG BOLD   ", "D-PRIME BOOST"), 
                colors = c("blue"), title = "", line.size = 1, dot.size = 3, show.data = TRUE)


p + set_theme(geom.linetype=2) + theme_classic() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=12, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold'))


p <- plot_model(m12, type="pred", terms = c("SB_BG"), auto.label = FALSE, 
                axis.title = c("BG BOLD   ", "D-PRIME BOOST"), 
                colors = c("blue"), title = "", line.size = 1, dot.size = 3, show.data = TRUE)


p + set_theme(geom.linetype=1) + theme_classic() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=12, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold'))

######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
###################################################################
#BOOST BOLD and BG TISSUE IRON at wave 5 
##################################################################################################################
###############################

data <- read.csv("./data_w5.csv")
#data <- read.csv("/Users/jessicaflannery/Desktop/planets/R_stats/data/data_w5_noADHD.csv")

#Centering stuff! 
data$age_grandmc <- data$age - mean(data$age)
data$meanFD_grandmc <- data$meanFD - mean(data$meanFD)
##################################################################################################################
###############################
summary(TIm1 <- glm(formula = BG ~ age_grandmc + meanFD_grandmc + sex + AnyBoost_BG,
                  family = gaussian, data = data))

summary(TIm2 <- glm(formula = BG ~ age_grandmc + meanFD_grandmc + sex + BB_BG,
                  family = gaussian, data = data))

summary(TIm3 <- glm(formula = BG ~ age_grandmc + meanFD_grandmc + sex + SB_BG,
                  family = gaussian, data = data))

###################################################################
######################################################################################################################################

p <- plot_model(TIm1, type="pred", terms = c("AnyBoost_BG"), auto.label = FALSE, 
                axis.title = c("BG BOLD   ", "nT2*w Values"), 
                colors = c("blue"), title = "", line.size = 1, dot.size = 3, show.data = TRUE)


p + set_theme(geom.linetype=2) + theme_classic() + scale_y_reverse() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=12, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold'))

p <- plot_model(TIm2, type="pred", terms = c("BB_BG"), auto.label = FALSE, 
                axis.title = c("BG BOLD   ", "nT2*w Values"), 
                colors = c("blue"), title = "", line.size = 1, dot.size = 3, show.data = TRUE)


p + set_theme(geom.linetype=2) + theme_classic() + scale_y_reverse() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=12, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold'))

p <- plot_model(TIm3, type="pred", terms = c("SB_BG"), auto.label = FALSE, 
                axis.title = c("BG BOLD   ", "nT2*w Values"), 
                colors = c("blue"), title = "", line.size = 1, dot.size = 3, show.data = TRUE)


p + set_theme(geom.linetype=2) + theme_classic() + scale_y_reverse() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=12, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold'))

######################################################################################################################################
###################################################################
#BOOST BOLD and substance use at wave 5 
##################################################################################################################

# drug_any_W5 (highest amount of any drug in the past year)
# drug_ever_W5
# max_drug (highest amount of any drug in a year)
# drug_ever (ever used substances yes/no)
#############################################################################################
summary(SUm1 <- glm(formula = AnyBoost_BG ~ age_grandmc + sex + drug_ever,
                    family = gaussian, data = data))

summary(SUm2 <- glm(formula = BB_BG ~ age_grandmc + sex + drug_ever,
                    family = gaussian, data = data))

summary(SUm3 <- glm(formula = SB_BG ~ age_grandmc + sex + drug_ever,
                    family = gaussian, data = data))

#############################################################################################
summary(SUm2 <- glm(formula = dprime_any_NB ~ age_grandmc + sex + drug_ever_W5,
                    family = gaussian, data = data))

summary(SUm3 <- glm(formula = dprime_BB_NB ~ age_grandmc + sex + drug_ever_W5,
                    family = gaussian, data = data))

summary(SUm4 <- glm(formula = dprime_SB_NB ~ age_grandmc + sex + drug_ever_W5,
                    family = gaussian, data = data))

#############################################################################################
#############################################################################################
summary(SUm6 <- glm(formula = BG ~ age_grandmc + meanFD_grandmc + sex + drug_ever_W5,
                    family = gaussian, data = data))


#############################################################################################
#############################################################################################
#############################################################################################
