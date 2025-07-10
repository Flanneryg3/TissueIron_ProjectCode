###########################################################################################################
###########################################################################################################
# Substance use group and Incentive-Dependent cognitive control group 
# Differential change in nT2*w values over age 
# Assessed with multi-level models with lmer R-packages
# Plotting

###########################################################################################################
# Jessica S. Flannery: 2022, updated 2024, updated 2025

###########################################################################################################
###########################################################################################################
# package imports
###########################################################################################################
library(dplyr)
library(viridis)
library(ggplot2)
library(dplyr)
library(mgcv)
library(interactions)
library(data.table)
library(misty)
library(performance)
library(lattice)
library(ggpmisc)
library(lme4)
library(lmerTest)
library(psych)
library(mgcViz)
library(tidygam)
library(scales)
library(gratia)
library(itsadug)
library(mgcv)
###########################################################################################################
# data import

data_long <- read.csv("./data_roi_long.csv")
data <- read.csv("./data.csv")
###########################################################################################################
#Centering stuff! 
data_long$age_grandmc <- data_long$age - mean(data_long$age)
data_long$age_submean <- ave(data_long$age, data_long$Subj, FUN = mean)
data_long$age_submc <- data_long$age - data_long$age_submean
data_long$meanFD_grandmc <- data_long$meanFD - mean(data_long$meanFD)
data_long$roi <- factor(data_long$roi)
data_long$drug_ever <- factor(data_long$drug_ever)
data_long$sex <- factor(data_long$sex)

###############################################################################################################
###############################################################################################################
#Centering stuff! 
data$age_grandmc <- data$age - mean(data$age)
data$age_submean <- ave(data$age, data$Subj, FUN = mean)
data$age_submc <- data$age - data$age_submean
data$meanFD_grandmc <- data$meanFD - mean(data$meanFD)
data$drug_ever <- factor(data$drug_ever)
data$sex <- factor(data$sex)

############################################################################################################
############################################################################################################
# Drug ever x age on tissue iron: omnibus test
# Assessing interacting effects of Basel Ganglia subregion (ROI)
# controlling for mean framewise displacement (meanFD) and biosex
############################################################################################################
############################################################################################################

omnibus_model <- lmer(nT2w ~ age_grandmc * drug_ever * roi + meanFD_grandmc + sex + (1 + age_grandmc + roi | Subj), data=data_long, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(omnibus_model)

############################################################################################################
# Follow-up for each basal ganglia subregion (roi)
############################################################################################################
Nac_model <- lmer(Nac ~ age_grandmc * drug_ever + meanFD_grandmc + sex  
              + (1 + age_grandmc | Subj), 
              data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Nac_model)
############################################################################################################
Put_model <- lmer(Put ~ age_grandmc * drug_ever + meanFD_grandmc + sex  
                  + (1 + age_grandmc | Subj), 
                  data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Put_model)
############################################################################################################
GP_model <- lmer(GP ~ age_grandmc * drug_ever + meanFD_grandmc + sex  
                  + (1 + age_grandmc | Subj), 
                  data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(GP_model)
############################################################################################################
Caud_model <- lmer(aud ~ age_grandmc * drug_ever + meanFD_grandmc + sex  
                 + (1 + age_grandmc | Subj), 
                 data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Caud_model)
############################################################################################################
# johnson_neyman test to assess age ranges in which substance use group significantly differed
############################################################################################################
data$drug_ever_num <- as.numeric(as.character(data$drug_ever)) 
model <- lmer(Nac ~ age * drug_ever_num + meanFD_grandmc + sex 
              + (meanFD_grandmc| Subj) + (age | Subj), 
              data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))

johnson_neyman(model, pred = "drug_ever_num", modx = "age")

############################################################################################################
# marginal effects within each group
############################################################################################################
# data import and clean
data_user <- read.csv("./data_user.csv")

data_user$age_grandmc <- data_user$age - mean(data_user$age)
data_user$meanFD_grandmc <- data_user$meanFD - mean(data_user$meanFD)
data_user$sex <- factor(data_user$sex)
############################################################################################################
# data import and clean
data_nonuser <- read.csv("./data_nonuser.csv")

data_nonuser$age_grandmc <- data_nonuser$age - mean(data_nonuser$age)
data_nonuser$meanFD_grandmc <- data_nonuser$meanFD - mean(data_nonuser$meanFD)
data_nonuser$sex <- factor(data_nonuser$sex)
############################################################################################################
#user
user_age_model <- lmer(Nac ~ age_grandmc + meanFD_grandmc + sex 
              + (1 + age_grandmc | Subj), 
              data=data_user, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(user_age_model)

############################################################################################################
#nonuser
nonuser_age_model <- lmer(Nac ~ age_grandmc + meanFD_grandmc + sex
              + (1 + age_grandmc | Subj), 
              data=data_nonuser, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(nonuser_age_model)

############################################################################################################
# Plot!! 
############################################################################################################
# with data points:
############################################################################################################
Nac_SU_plot <- interact_plot(Nac_model, pred=age, modx=drug_ever, plot.points=TRUE,
                                      x.label="AGE", y.label="NAcc", 
                                      legend.main="DRUG USE", interval=TRUE, 
                                      thickness.line = 3, vary.lty=TRUE, colors = c("aquamarine3", "purple"))

Nac_SU_plot + theme_classic() + scale_y_reverse(labels = label_number(accuracy=0.1), breaks=c(1.3, 1.2, 1.1, 1.0, 0.9)) + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=15, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold')
                ) + scale_x_discrete(limits=c(12, 13, 14, 15, 16, 17, 18))
############################################################################################################
# without  data points:
############################################################################################################

Nac_SU_plot <- interact_plot(Nac_model, pred=age, modx=drug_ever, plot.points=FALSE,
                             x.label="AGE", y.label="NAcc", 
                             legend.main="DRUG USE", interval=TRUE, 
                             thickness.line = 1, vary.lty=TRUE, colors = c("aquamarine3", "purple"))

Nac_SU_plot + theme_classic() + 
  scale_y_reverse(labels = label_number(accuracy=0.01), breaks=c(1.24, 1.22, 1.20, 1.18, 1.16, 1.14)) + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=15, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold')
                ) + scale_x_discrete(limits=c(12, 13, 14, 15, 16, 17, 18))


############################################################################################################
############################################################################################################
############################################################################################################
# dprime boost group x age on tissue iron (controlling for roi)
############################################################################################################
# importing data of subjects that have task data at the final time point 
############################################################################################################
data <- read.csv("./data.csv")

data$age_grandmc <- data$age - mean(data$age)
data$age_submean <- ave(data$age, data$Subj, FUN = mean)
data$age_submc <- data$age - data$age_submean
data$meanFD_grandmc <- data$meanFD - mean(data$meanFD)
data$dprime_any_NB_median <- factor(data$dprime_any_NB_median)
data$sex <- factor(data$sex)

############################################################################################################
############################################################################################################
# dprime_any_NB_median used to categorize BOOST-groups
# dprime_any_NB_median x age on tissue iron: omnibus test
# Assessing interacting effects of Basel Ganglia subregion (ROI)
# controlling for mean framewise displacement (meanFD) and biosex
############################################################################################################
############################################################################################################

omnibus_model <- lmer(nT2w ~ age_grandmc * dprime_any_NB_median * roi + meanFD_grandmc + sex 
                      + (1 + age_grandmc + roi | Subj), 
                      data=data_long, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(omnibus_model)

############################################################################################################
# Follow-up for each basal ganglia subregion (roi)
############################################################################################################
Put_model <- lmer(Put ~ meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                  + (1 + age_grandmc | Subj),
                  data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Put_model)
############################################################################################################
Nac_model <- lmer(Nac ~ meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                  + (1 + age_grandmc | Subj),
                  data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Nac_model)
############################################################################################################
Caud_model <- lmer(Caud ~ meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                  + (1 + age_grandmc | Subj),
                  data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Caud_model)
############################################################################################################
GP_model <- lmer(GP ~ meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                   + (1 + age_grandmc | Subj), 
                   data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(GP_model)

############################################################################################################
# follow up controlling for annual household income 
############################################################################################################
Put_model <- lmer(Put ~ income + meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                  + (1 + age_grandmc | Subj),
                  data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Put_model)
############################################################################################################
Nac_model <- lmer(Nac ~ income + meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                  + (1 + age_grandmc | Subj), 
                  data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Nac_model)
############################################################################################################
Caud_model <- lmer(Caud ~ income + meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                   + (1 + age_grandmc | Subj), 
                   data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Caud_model)
############################################################################################################
GP_model <- lmer(GP ~ income + meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                 + (1 + age_grandmc | Subj),
                 data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(GP_model)
############################################################################################################
############################################################################################################
# Sensitivity analyses with ADHD diagnoses excluded
############################################################################################################
############################################################################################################
############################################################################################################
# importing data of subjects that did not have ADHD
############################################################################################################
data_noADHD <- read.csv("./data_noADHD.csv")

data_noADHD$age_grandmc <- data_noADHD$age - mean(data_noADHD$age)
data_noADHD$meanFD_grandmc <- data_noADHD$meanFD - mean(data_noADHD$meanFD)
data_noADHD$dprime_any_NB_median <- factor(data_noADHD$dprime_any_NB_median)
data_noADHD$sex <- factor(data_noADHD$sex)
############################################################################################################

############################################################################################################
Put_model <- lmer(Put ~ meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                  + (1 + age_grandmc | Subj),
                  data=data_noADHD, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Put_model)
############################################################################################################
Nac_model <- lmer(Nac ~ meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                  + (1 + age_grandmc | Subj),
                  data=data_noADHD, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Nac_model)
############################################################################################################
Caud_model <- lmer(Caud ~ meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                   + (1 + age_grandmc | Subj), 
                   data=data_noADHD, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(Caud_model)
############################################################################################################
GP_model <- lmer(GP ~ meanFD_grandmc + sex + dprime_any_NB_median * age_grandmc 
                 + (1 + age_grandmc | Subj), 
                 data=data_noADHD, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(GP_model)

############################################################################################################
# marginal effects within each group
############################################################################################################
# data import and clean
############################################################################################################
############################################################################################################
data_II <- read.csv("./data_lowboost_II.csv")
data_II$age_grandmc <- data_II$age - mean(data_II$age, na.rm=TRUE)
data_II$age_submean <- ave(data_II$age, data_II$Subj, FUN = mean)
data_II$age_submc <- data_II$age - data_II$age_submean
data_II$meanFD_grandmc <- data_II$meanFD - mean(data_II$meanFD, na.rm=TRUE)

data_ID <- read.csv("./data_highboost_ID.csv")
data_ID$age_grandmc <- data_ID$age - mean(data_ID$age, na.rm=TRUE)
data_ID$age_submean <- ave(data_ID$age, data_ID$Subj, FUN = mean)
data_ID$age_submc <- data_ID$age - data_ID$age_submean
data_ID$meanFD_grandmc <- data_ID$meanFD - mean(data_ID$meanFD, na.rm=TRUE)
############################################################################################################
############################################################################################################
# Incentive Independent Group age effect
II_model <- lmer(Put ~ meanFD_grandmc + sex + age_grandmc 
              + (1 + age_grandmc | Subj),
              data=data_II, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(II_model)

############################################################################################################
# Incentive Dependent Group age effect
ID_model <- lmer(Put ~ meanFD_grandmc + sex + age_grandmc 
                 + (1 + age_grandmc | Subj), 
                 data=data_ID, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(ID_model)

############################################################################################################
# plot
############################################################################################################
Boost_age_model <- lmer(Put ~ meanFD_grandmc + sex + age * dprime_any_NB_median 
                    + (1 + age_grandmc | Subj),
              data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
############################################################################################################
#no data points
############################################################################################################
Put_dprimeBB_plot <- interact_plot(Boost_age_model, pred=age, modx=dprime_any_NB_median, modxvals = NULL, plot.points=FALSE,
                             x.label="AGE", y.label="Putamen nT2*w", 
                             legend.main="D-PRIME BOOST", interval=TRUE, 
                             thickness.line = 1, vary.lty=FALSE, colors = c("limegreen", "darkmagenta"))

Put_dprimeBB_plot + theme_classic() + scale_y_reverse() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=15, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold')) + scale_x_continuous(
                  breaks=c(12, 13, 14, 15, 16, 17, 18))

############################################################################################################
# with data points 
############################################################################################################
Put_dprimeBB_plot <- interact_plot(model, pred=age, modx=dprime_any_NB_median, modxvals = NULL, plot.points=TRUE,
                                   x.label="AGE", y.label="Putamen nT2*w", 
                                   legend.main="D-PRIME BOOST", interval=TRUE, 
                                   thickness.line = 1, vary.lty=FALSE, colors = c("limegreen", "darkmagenta"))

Put_dprimeBB_plot + theme_classic() + scale_y_reverse(breaks=c(1.1, 1.05, 1.0, 0.9, 0.8)) + theme(axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(axis.ticks.length = unit(0.15, "cm")) + theme(
      legend.text = element_text(size=15, colour = 'black')) + theme(legend.title = element_text(
        size=15, colour = 'black', face='bold')) + theme(axis.text = element_text(size = 15, colour='black')) + theme(
          axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.title.x = element_text(size=15, colour = 'black', face='bold')) + scale_x_continuous(
              breaks=c(12, 13, 14, 15, 16, 17, 18))

###############################################################################################
###############################################################################################
## Task BOLD signal in basal ganglia and interactive effects with age on nT2*w values  
###############################################################################################
###############################################################################################
data_planets <- read.csv("./data_planets.csv")

data_planets$age_grandmc <- data_planets$age - mean(data_planets$age)
data_planets$meanFD_grandmc <- data_planets$meanFD - mean(data_planets$meanFD)

###############################################################################################
############################################################################################################
# effect on average basal ganglia tissue iron (across all subregions)
############################################################################################################
# AnyBoost - No Boost BOLD signal in the basal ganglia 
############################################################################################################
anyboost_model <- lmer(BG ~ sex + meanFD_grandmc + age_grandmc + AnyBoost_BG * age_submc 
                       + (1 + age_grandmc | Subj), 
              data=data_planets, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(anyboost_model)

############################################################################################################
# BIGBoost - No Boost BOLD signal in the basal ganglia 
############################################################################################################
BB_model <- lmer(BG ~ sex + meanFD_grandmc + age_grandmc + BB_BG * age_submc 
                 + (1 + age_grandmc | Subj),
                       data=data_planets, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(BB_model)
############################################################################################################
# SMALLBoost - No Boost BOLD signal in the basal ganglia 
############################################################################################################
SB_model <- lmer(BG ~ sex + meanFD_grandmc + age_grandmc + SB_BG * age_submc 
                 + (1 + age_grandmc | Subj), 
                 data=data_planets, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(SB_model)

############################################################################################################
############################################################################################################
############################################################################################################
# Sensitivity analyses with ADHD diagnoses excluded
############################################################################################################
############################################################################################################
############################################################################################################
# importing data of subjects that did not have ADHD
############################################################################################################
data_noADHD <- read.csv("./data_noADHD.csv")

data_noADHD$age_grandmc <- data_noADHD$age - mean(data_noADHD$age)
data_noADHD$meanFD_grandmc <- data_noADHD$meanFD - mean(data_noADHD$meanFD)
data_noADHD$sex <- factor(data_noADHD$sex)
######################################################################################################
anyboost_model <- lmer(BG ~ sex + meanFD_grandmc + age_grandmc + AnyBoost_BG * age_submc 
                       + (1 + age_grandmc | Subj),
                       data=data_noADHD, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(anyboost_model)

############################################################################################################
# BIGBoost - No Boost BOLD signal in the basal ganglia 
############################################################################################################
BB_model <- lmer(BG ~ sex + meanFD_grandmc + age_grandmc + BB_BG * age_submc 
                 + (1 + age_grandmc | Subj), 
                 data=data_noADHD, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(BB_model)
############################################################################################################
# SMALLBoost - No Boost BOLD signal in the basal ganglia 
############################################################################################################
SB_model <- lmer(BG ~ sex + meanFD_grandmc + age_grandmc + SB_BG * age_submc 
                 + (1 + age_grandmc | Subj),
                 data=data_noADHD, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(SB_model)



############################################################################################################
# plot
############################################################################################################

model <- lmer(BG ~ sex + BB_BG_median * age + (age | Subj), data=data_planets, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(model)

BB_bold_plot <- interact_plot(model, pred=age, modx=BB_BG_median, modxvals = NULL, plot.points=TRUE,
                                   x.label="AGE", y.label="nT2*w", 
                                   legend.main="BOOST BOLD", interval=TRUE, 
                                   thickness.line = 1, vary.lty=FALSE, colors = c("forestgreen", "slateblue"))

BB_bold_plot + theme_classic() + scale_y_reverse() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=15, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold')
              ) + scale_x_discrete(limits=c(12, 13, 14, 15, 16, 17, 18))

BB_bold_plot <- interact_plot(model, pred=age, modx=BB_BG_median, modxvals = NULL, plot.points=FALSE,
                              x.label="AGE", y.label="nT2*w", 
                              legend.main="BOOST BOLD", interval=TRUE, 
                              thickness.line = 1, vary.lty=FALSE, colors = c("forestgreen", "slateblue"))

BB_bold_plot + theme_classic() + scale_y_reverse() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=15, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold')
              ) + scale_x_discrete(limits=c(12, 13, 14, 15, 16, 17, 18))

################################################################################
################################################################################

model <- lmer(BG ~ sex + SB_BG_median * age + (age | Subj), data=data_planets, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
summary(model)

SB_bold_plot <- interact_plot(model, pred=age, modx=SB_BG_median, modxvals = NULL, plot.points=TRUE,
                              x.label="AGE", y.label="nT2*w", 
                              legend.main="BOOST BOLD", interval=TRUE, 
                              thickness.line = 1, vary.lty=FALSE, colors = c("forestgreen", "slateblue"))

SB_bold_plot + theme_classic() + scale_y_reverse() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=15, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold')
              ) + scale_x_discrete(limits=c(12, 13, 14, 15, 16, 17, 18))

SB_bold_plot <- interact_plot(model, pred=age, modx=SB_BG_median, modxvals = NULL, plot.points=FALSE,
                              x.label="AGE", y.label="nT2*w", 
                              legend.main="BOOST BOLD", interval=TRUE, 
                              thickness.line = 1, vary.lty=FALSE, colors = c("forestgreen", "slateblue"))

SB_bold_plot + theme_classic() + scale_y_reverse() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=15, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold')
              ) + scale_x_discrete(limits=c(12, 13, 14, 15, 16, 17, 18))

################################################################################
################################################################################

AnyBoost_bold_plot <- interact_plot(model, pred=age, modx=AnyBoost_BG_median, modxvals = NULL, plot.points=TRUE,
                              x.label="AGE", y.label="nT2*w", 
                              legend.main="BOOST BOLD", interval=TRUE, 
                              thickness.line = 1, vary.lty=FALSE, colors = c("forestgreen", "slateblue"))

AnyBoost_bold_plot + theme_classic() + scale_y_reverse() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=15, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold')
              ) + scale_x_discrete(limits=c(12, 13, 14, 15, 16, 17, 18))

AnyBoost_bold_plot <- interact_plot(model, pred=age, modx=AnyBoost_BG_median, modxvals = NULL, plot.points=FALSE,
                              x.label="AGE", y.label="nT2*w", 
                              legend.main="BOOST BOLD", interval=TRUE, 
                              thickness.line = 1, vary.lty=FALSE, colors = c("forestgreen", "slateblue"))

AnyBoost_bold_plot + theme_classic() + scale_y_reverse() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=15, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 15, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold')
              ) + scale_x_discrete(limits=c(12, 13, 14, 15, 16, 17, 18))


################################################################################
################################################################################
################################################################################


