###########################################################################################################
###########################################################################################################
# Average change over age multi-level models with lmer and gmm4 R-packages
# Plotting

###########################################################################################################
# Jessica S. Flannery, 2022, updated 2024

###########################################################################################################
###########################################################################################################
# package imports
###########################################################################################################
library(dplyr)
library(ggplot2)
library(viridis)
library(interactions)
library(data.table)
library(misty)
library(performance)
library(gamm4)
library(lattice)
library(ggpmisc)
library(ggpubr)
library(ggdist)
library(lavaan)
library(lavaanPlot)
library(mgcv)
library(AICcmodavg)
library(psych)
library(mgcViz)
library(tidymv)
library(gratia)
library(itsadug)
library(mgcv)
library(irr)
###########################################################################################################
# data import
data_long <- read.csv("/path/data_roi_long.csv")
data <- read.csv("/path/data/data.csv")

###########################################################################################################
#Centering stuff! 
data_long$age_grandmc <- data_long$age - mean(data_long$age)
data_long$meanFD_grandmc <- data_long$meanFD - mean(data_long$meanFD)
data_long$roi <- factor(data_long$roi)
data_long$sex <- factor(data_long$sex)
###############################################################################################################
###############################################################################################################
#Centering stuff! 
data$age_grandmc <- data$age - mean(data$age)
data$meanFD_grandmc <- data$meanFD - mean(data$meanFD)
data_long$sex <- factor(data_long$sex)

##############################################################################################################
# AGE EFFECT controlling for ROI
#########################################################################################################
##########################################################################################################

############################################################################################################
# #generalized additive mixed model is a generalized linear mixed model 
##########################################################################################################
dev <- gamm4(nT2w ~ meanFD_grandmc + sex + roi + s(age_grandmc, k=4, fx=T), random=~(1 + age_grandmc + roi || Subj), family=gaussian(), data=data_long,
                REML=TRUE, control=NULL)

summary(dev$mer)
summary(dev$gam)
plot.gam(dev$gam, residuals=TRUE, se=TRUE, pages=1)
plot.gam(dev$gam, pages=1, seWithMean=TRUE, ylim=c(0.02,-0.06))

plot_smooth(dev$gam, view="age", rm.ranef=FALSE, rug=FALSE, col="blue", ylab='nT2*w', ylim=c(1.25,1.16), lwd=2.5)

dev2 <- gamm4(nT2w ~ meanFD + sex + roi + s(age, by = roi, k=4, fx=T), random=~(age||Subj), family=gaussian(), data=data_long,
             REML=TRUE, control=NULL)

p3 <- plot_smooth(dev2$gam, view="age", cond=list(roi="0"),
                  rm.ranef=FALSE, rug=FALSE, col="darkmagenta", ylab='nT2*w', ylim=c(1.4,0.8), lwd=2.5) 
p3 + plot_smooth(dev2$gam, view="age", cond=list(roi="1"),
                 rm.ranef=FALSE, rug=FALSE, col="darkgreen", add=TRUE, lwd=2.5) 
p3 + plot_smooth(dev2$gam, view="age", cond=list(roi="2"),
                 rm.ranef=FALSE, rug=FALSE, col="navyblue", add=TRUE, lwd=2.5) 
p3 + plot_smooth(dev2$gam, view="age", cond=list(roi="3"),
                 rm.ranef=FALSE, rug=FALSE, col="cyan", add=TRUE, lwd=2.5) 

p4 <- ggplot(data=data,aes(x=age,y=Caud)) + 
  theme(panel.background = element_rect(fill='transparent', color=NA), 
        plot.background = element_rect(fill='transparent', color=NA), panel.grid.major = element_blank()) + 
  geom_point(data=data,aes(x=age,y=Caud),alpha=0.7, colour="navyblue") + 
  xlab("Age") + ylab("nT2w") + 
  geom_point(data=data,aes(x=age,y=Put),alpha=0.7, colour="darkgreen") +
  geom_point(data=data,aes(x=age,y=GP),alpha=0.7, colour="cyan") +
  geom_point(data=data,aes(x=age,y=Nac),alpha=0.7, colour="darkmagenta") + 
  scale_y_reverse() + scale_x_continuous(breaks=seq(12, 18, 1)) + theme_classic() + theme(
    axis.line = element_line(size = 1, colour = "black")) + theme(
      axis.ticks = element_line(size = 1, colour = "black")) + theme(
        axis.ticks.length = unit(0.15, "cm")) + theme(
          legend.text = element_text(size=12, colour = 'black')) + theme(
            legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
              axis.text = element_text(size = 12, colour='black')) + theme(
                axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                  axis.title.x = element_text(size=15, colour = 'black', face='bold'))


p4 + theme(panel.background = element_rect(fill='transparent', color='NA'), 
plot.background = element_rect(fill='transparent', color='NA'), 
panel.grid.major = element_blank())

plot(p4, bg='transparent')

ggsave('/myplot.png', p4, bg='transparent')

theme_classic()
theme_set(theme_bw())

################################################################################################################
################################################################################################################
#Average Basal Ganglia 
################################################################################################################
################################################################################################################
##BG
# create plot of GAM models #
BG_gam <- gamm4(BG ~ meanFD + sex + s(age, k=4, fx=T), random=~(age||Subj), family=gaussian(), data=data,
                  REML=TRUE, control=NULL)

summary(BG_gam$mer)
summary(BG_gam$gam)
plot.gam(BG_gam$gam, residuals=TRUE, se=TRUE, pages=1)
plot.gam(BG_gam$gam, pages=1, seWithMean=TRUE)


################################################################################################################
################################################################################################################
#plot by ROI
################################################################################################################
################################################################################################################
################################################################################################################
##CAUD
# create plot of GAM models #
caud_gam <- gamm4(Caud ~ meanFD + sex + s(age, k=4, fx=T), random=~(age|Subj), family=gaussian(), data=data,
                  REML=TRUE, control=NULL)

summary(caud_gam$mer)
summary(caud_gam$gam)
pred_caud_ci <- get_gam_predictions(caud_gam$gam, age)


pred_caud <- predict(caud_gam$gam,data, type = "response", se.fit=T)      #Fgam is model, CTdataW is dataset
data$pred_caud <- pred_caud$fit
data$dev_se_caud <- pred_caud$se
data$BGLower_caud <- data$pred_caud - (1.96*(data$dev_se_caud))
data$BGUpper_caud <- data$pred_caud + (1.96*(data$dev_se_caud))
plot_smooth(caud_gam$gam, view="age", rm.ranef=FALSE, rug=FALSE, col="navyblue", ylab='nT2*w', ylim=c(1.14,1.06), lwd=2.5)

################################################################################################################
##PUTAMEN
# create plot of GAM models #
put_gam <- gamm4(Put ~ meanFD + sex + s(age, k=4, fx=T), random=~(age|Subj), family=gaussian(), data=data,
                 REML=TRUE, control=NULL)

summary(put_gam$mer)
summary(put_gam$gam)
pred_put_ci <- get_gam_predictions(put_gam$gam, age)
put_low <- pred_put_ci$CI_lower
put_high <- pred_put_ci$CI_upper
pred_put <- predict(put_gam$gam,data, type = "response", se.fit=T)      #Fgam is model, CTdataW is dataset
data$pred_put <- pred_put$fit
data$dev_se_put <- pred_put$se
data$BGLower_put <- data$pred_put - (1.96*(data$dev_se_put))
data$BGUpper_put <- data$pred_put + (1.96*(data$dev_se_put))
plot_smooth(put_gam$gam, view="age", rm.ranef=FALSE, rug=FALSE, col="darkgreen", ylab='nT2*w', ylim=c(1.10,1.02), lwd=2.5)


################################################################################################################
##GP
gp_gam <- gamm4(GP ~ meanFD + sex + s(age, k=4, fx=T), random=~(age|Subj), family=gaussian(), data=data,
                REML=TRUE, control=NULL)

summary(gp_gam$mer)
summary(gp_gam$gam)
pred_gp_ci <- get_gam_predictions(gp_gam$gam, age)
gp_low <- pred_gp_ci$CI_lower
gp_high <- pred_gp_ci$CI_upper

pred_gp <- predict(gp_gam$gam,data, type = "response", se.fit=T)      #Fgam is model, CTdataW is dataset
data$pred_gp <- pred_gp$fit
data$dev_se_gp <- pred_gp$se
data$BGLower_gp <- data$pred_gp - (1.96*(data$dev_se_gp))
data$BGUpper_gp <- data$pred_gp + (1.96*(data$dev_se_gp))
plot_smooth(gp_gam$gam, view="age", rm.ranef=FALSE, rug=FALSE, col="cyan", ylab='nT2*w', ylim=c(1,0.8), lwd=2.5)



################################################################################################################
##Nacc
nac_gam <- gamm4(Nac ~ meanFD + sex + s(age, k=4, fx=T), random=~(age|Subj), family=gaussian(), data=data,
                  REML=TRUE, control=NULL)

summary(nac_gam$mer)
summary(nac_gam$gam)
pred_nac_ci <- get_gam_predictions(nac_gam$gam, age)
pred_nac_ci
nac_low <- pred_nac_ci$CI_lower
nac_high <- pred_nac_ci$CI_upper

pred_nac <- predict(nac_gam$gam,data, type = "response", se.fit=T, interval="confidence", level=0.95) 
pred_nac
data$pred_nac <- pred_nac$fit
data$dev_se_nac <- mean(pred_nac$se)
data$BGLower_nac <- data$pred_nac - (1.96*(data$dev_se_nac))
data$BGUpper_nac <- data$pred_nac + (1.96*(data$dev_se_nac))
data$BGLower_nac
data$BGUpper_nac
plot_smooth(nac_gam$gam, view="age", rm.ranef=FALSE, rug=FALSE, col="darkmagenta", ylab='nT2*w', ylim=c(1.3,1.1), lwd=2.5)

################################################################################################################
################################################################################################################
# create plot of GAM models #
################################################################################################################

plot_BG3 <- ggplot(data=data,aes(x=age,y=Caud)) + theme_classic() + 
  geom_smooth(data=data,aes(age,pred_caud),se=T, method="gam", formula = y~s(x,bs="re"), colour="navyblue") + 
  geom_point(data=data,aes(x=age,y=Caud),alpha=0.7, colour="navyblue") +
  xlab("Age") + ylab("nT2w")
################################################################################################################
plot_BG3 + geom_smooth(data=data,aes(age,pred_put), method="gam",formula = y~s(x,bs="re"), colour="darkgreen") + 
  geom_point(data=data,aes(x=age,y=Put),alpha=0.7, colour="darkgreen") +
  geom_smooth(data=data,aes(age,pred_gp),method="gam",formula = y~s(x,bs="re"), colour="cyan") + 
  geom_point(data=data,aes(x=age,y=GP),alpha=0.7, colour="cyan") +
  geom_smooth(data=data,aes(age,pred_nac),method="gam",formula = y~s(x,bs="re"), colour="darkmagenta") + 
  geom_point(data=data,aes(x=age,y=Nac),alpha=0.7, colour="darkmagenta") + 
  scale_y_reverse() + scale_x_continuous(breaks=seq(12, 18, 1)) + theme_classic() + theme(
    axis.line = element_line(size = 1, colour = "black")) + theme(
      axis.ticks = element_line(size = 1, colour = "black")) + theme(
        axis.ticks.length = unit(0.15, "cm")) + theme(
          legend.text = element_text(size=12, colour = 'black')) + theme(
            legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
              axis.text = element_text(size = 12, colour='black')) + theme(
                axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                  axis.title.x = element_text(size=15, colour = 'black', face='bold'))
################################################################################################################
################################################################################################################
# create plot of GAM models #
################################################################################################################

plot_BG3 <- ggplot(data=data,aes(x=age,y=Caud)) + theme_classic() + 
  geom_smooth(data=data,aes(age,pred_caud),method="gam", formula = y~s(x,bs="re"), colour="navyblue") + 
  geom_point(data=data,aes(x=age,y=Caud),alpha=0.7, colour="navyblue") + 
  geom_ribbon(data=data,aes(ymin=BGLower_caud, ymax=BGUpper_caud, x=age), show.legend=FALSE, fill ="navyblue", alpha=0.3) +
  xlab("Age") + ylab("nT2w")
plot_BG3
################################################################################################################
plot_BG3 + geom_smooth(data=data,aes(age,pred_put),method="gam",formula = y~s(x,bs="re"), colour="darkgreen") + 
  geom_point(data=data,aes(x=age,y=Put),alpha=0.7, colour="darkgreen") +
  geom_ribbon(data=data,aes(ymin=BGLower_put, ymax=BGUpper_put, x=age), show.legend=FALSE, fill ="darkgreen", alpha=0.3) +
  geom_smooth(data=data,aes(age,pred_gp),method="gam",formula = y~s(x,bs="re"), colour="cyan") + 
  geom_point(data=data,aes(x=age,y=GP),alpha=0.7, colour="cyan") +
  geom_ribbon(data=data,aes(ymin=BGLower_gp, ymax=BGUpper_gp, x=age), show.legend=FALSE, fill ="cyan", alpha=0.3) +
  geom_smooth(data=data,aes(age,pred_nac),method="gam",formula = y~s(x,bs="re"), colour="darkmagenta") + 
  geom_point(data=data,aes(x=age,y=Nac),alpha=0.7, colour="darkmagenta") + 
  geom_ribbon(data=data,aes(ymin=BGLower_nac, ymax=BGUpper_nac, x=age), show.legend=FALSE, fill ="darkmagenta", alpha=0.3) + 
  scale_y_reverse() + scale_x_continuous(breaks=seq(12, 18, 1)) + theme_classic() + theme(
    axis.line = element_line(size = 1, colour = "black")) + theme(
      axis.ticks = element_line(size = 1, colour = "black")) + theme(
        axis.ticks.length = unit(0.15, "cm")) + theme(
          legend.text = element_text(size=12, colour = 'black')) + theme(
            legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
              axis.text = element_text(size = 12, colour='black')) + theme(
                axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                  axis.title.x = element_text(size=15, colour = 'black', face='bold'))


################################################################################################################
################################################################################################################
################################################################################################################
plot_BG2 <- ggplot(data=data,aes(x=age,y=Caud)) + theme_classic() + 
  geom_smooth(data=data,aes(age,pred_caud),method="gam",formula = y~s(x,bs="re"), colour="navyblue") + 
  geom_point(data=data,aes(x=age,y=Caud),alpha=0.7, colour="navyblue") + 
  geom_ribbon(data=pred_caud_ci,aes(ymin=CI_lower, ymax=CI_upper, x=age), show.legend=FALSE, fill ="navyblue", alpha=0.3) +
  xlab("Age") + ylab("nT2w")
plot_BG2
################################################################################################################
plot_BG2 + geom_smooth(data=data,aes(age,pred_put),method="gam",formula = y~s(x,bs="re"), colour="darkgreen") + 
  geom_point(data=data,aes(x=age,y=Put),alpha=0.7, colour="darkgreen") +
  geom_ribbon(data=pred_put_ci,aes(ymin=CI_lower, ymax=CI_upper, x=age, group=.idx), show.legend=FALSE, fill ="darkgreen", alpha=0.3) +
  geom_smooth(data=data,aes(age,pred_gp),method="gam",formula = y~s(x,bs="re"), colour="cyan") + 
  geom_point(data=data,aes(x=age,y=GP),alpha=0.7, colour="cyan") +
  geom_ribbon(data=pred_gp_ci,aes(ymin=CI_lower, ymax=CI_upper, x=age, group=.idx), show.legend=FALSE, fill ="cyan", alpha=0.3) +
  geom_smooth(data=data,aes(age,pred_nac),method="gam",formula = y~s(x,bs="re"), colour="darkmagenta") + 
  geom_point(data=data,aes(x=age,y=Nac),alpha=0.7, colour="darkmagenta") + 
  geom_ribbon(data=pred_nac_ci,aes(ymin=CI_lower, ymax=CI_upper, x=age, group=.idx), show.legend=FALSE, fill ="darkmagenta", alpha=0.3) + 
  scale_y_reverse() + scale_x_continuous(breaks=seq(12, 18, 1)) + theme_classic() + theme(
    axis.line = element_line(size = 1, colour = "black")) + theme(
      axis.ticks = element_line(size = 1, colour = "black")) + theme(
        axis.ticks.length = unit(0.15, "cm")) + theme(
          legend.text = element_text(size=12, colour = 'black')) + theme(
            legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
              axis.text = element_text(size = 12, colour='black')) + theme(
                axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                  axis.title.x = element_text(size=15, colour = 'black', face='bold'))


################################################################################################################
################################################################################################################
plot_BG <- ggplot(data=data,aes(x=age,y=Caud)) + theme_classic() + 
  geom_smooth(data=data,aes(age,pred_caud),method="gam",formula = y~s(x,bs="re"), colour="navyblue") + 
  geom_point(data=data,aes(x=age,y=Caud),alpha=0.7, colour="navyblue") + 
  xlab("Age") + ylab("nT2w")
################################################################################################################
plot_BG + geom_smooth(data=data,aes(age,pred_put),method="gam",formula = y~s(x,bs="re"), colour="darkgreen", se=1.96, shade=TRUE) + 
  geom_point(data=data,aes(x=age,y=Put),alpha=0.7, colour="darkgreen") +
  geom_smooth(data=data,aes(age,pred_gp),method="gam",formula = y~s(x,bs="re"), colour="cyan", se=1.96, shade=TRUE) + 
  geom_point(data=data,aes(x=age,y=GP),alpha=0.7, colour="cyan") + 
  geom_smooth(data=data,aes(age,pred_nac),method="gam",formula = y~s(x,bs="re"), colour="darkmagenta",se=1.96, shade=TRUE) + 
  geom_point(data=data,aes(x=age,y=Nac),alpha=0.7, colour="darkmagenta") + 
  scale_y_reverse() + scale_x_continuous(breaks=seq(12, 18, 1)) + theme_classic() + theme(
    axis.line = element_line(size = 1, colour = "black")) + theme(
      axis.ticks = element_line(size = 1, colour = "black")) + theme(
        axis.ticks.length = unit(0.15, "cm")) + theme(
          legend.text = element_text(size=12, colour = 'black')) + theme(
            legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
              axis.text = element_text(size = 12, colour='black')) + theme(
                axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                  axis.title.x = element_text(size=15, colour = 'black', face='bold'))
################################################################################################################
################################################################################################################
# create plot of GAM models #

pred <- predict(dev$gam,data_long, type = "response", se.fit=T)      #Fgam is model, CTdataW is dataset
data_long$pred <- pred$fit
data_long$dev_se <- pred$se
data_long$BGLower <- data_long$pred - (1.96*(data_long$dev_se))
data_long$BGUpper <- data_long$pred + (1.96*(data_long$dev_se))

plot_BG <- ggplot(data=data_long,aes(x=age,y=nT2w)) + theme_classic() + 
  geom_smooth(data=data_long,aes(age,pred),method="gam",formula = y~s(x,bs="re")) +
  geom_point(data=data_long,aes(x=age,y=nT2w),alpha=0.7) +
  xlab("Age") + 
  ylab("nT2w") 

plot_BG + scale_y_reverse() + theme_classic() + theme(
  axis.line = element_line(size = 1, colour = "black")) + theme(
    axis.ticks = element_line(size = 1, colour = "black")) + theme(
      axis.ticks.length = unit(0.15, "cm")) + theme(
        legend.text = element_text(size=12, colour = 'black')) + theme(
          legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
            axis.text = element_text(size = 12, colour='black')) + theme(
              axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                axis.title.x = element_text(size=15, colour = 'black', face='bold'))


####################################################################
# box plot 

####################################################################
# create named vector of colors for ROI levels
roi_colors <- c("cyan", "darkmagenta", "darkgreen", "navyblue")
names(roi_colors) <- c("Pallidum","NAcc","Putamen","Caudate")

data_long$roi_name2 <- factor(data_long$roi_name, order = TRUE, levels =c("Pallidum", "NAcc", "Putamen", "Caudate"))

# create boxplot

data_long %>%
  ggplot() +
  aes(x = roi_name2,
      y = nT2w,
      fill = roi_name2) +
  geom_point(aes(color = roi_name2),
             position = position_jitter(w = .15),
             size = 0.5,
             alpha = 0.15) +
  geom_boxplot(width = .24,
               outlier.shape = NA,
               alpha = 0.8) +
  geom_flat_violin(position = position_nudge(x = .2),
                   trim = TRUE, 
                   alpha = 0.6, 
                   scale = "width")  +
  scale_x_discrete(expand = c(0,0)) +
  scale_fill_manual(values = roi_colors) + theme_classic() +
  scale_color_manual(values = roi_colors) + scale_y_reverse() + theme(
    axis.line = element_line(size = 0.2, colour = "black")) + theme(
      axis.ticks = element_line(size = 0.2, colour = "black")) + theme(
        axis.ticks.length = unit(0.15, "cm")) + theme(
          legend.text = element_text(size=12, colour = 'black')) + theme(
            legend.title = element_text(size=15, colour = 'black', face='bold')) + theme(
              axis.text = element_text(size = 12, colour='black')) + theme(
                axis.title.y = element_text(size=15, colour = 'black', face='bold')) + theme(
                  axis.title.x = element_text(size=15, colour = 'black', face='bold')) + 
  xlab("ROI") + ylab("nT2*w") + theme(legend.position = "none")


####################################################################
####################################################################
#high intraclass correlation coefficients (ICCs, Psych package, ver 2.1.6,
#Revelle, 2022) in basal ganglia nT2*w values across visits (raw values:
####################################################################
####################################################################

#get icc of caud nT2w
model <- lmer(BG ~ (1 | Subj), 
              data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
icc(model)

#get icc of caud nT2w
model <- lmer(Caud ~ (1 | Subj), 
              data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
icc(model)

#get icc of GP nT2w
model <- lmer(GP ~ (1 | Subj), 
              data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
icc(model)

#get icc of put nT2w
model <- lmer(Put ~ (1 | Subj), 
              data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
icc(model)

#get icc of Nacc nT2w
model <- lmer(Nac ~ (1 | Subj), data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
icc(model)

#within a given subject nT2w have a 0.742 correlation, 74.2% of variance in nT2w is associated with between subject differences. 

#get icc of BG nT2w
model <- lmer(BG ~ (1 | Subj), data=data, control=lmerControl(optimizer="bobyqa",optCtrl=list(maxfun= 2e5)))
icc(model)

#within a given subject nT2w have a 0.763 correlation, 76.3% of variance in nT2w is associated with between subject differences. 

#######################################################################################################
# Spaghetti Plot by subject
##############################################################################################################
#cyan, magenta, darkblue, darkgreen
##############################################################################################################
## define base for the graphs and store in object 'p'

## define base for the graphs and store in object 'p'
p <- ggplot(data = data_long, aes(x = age, y = nT2w, group = Subj, ci=TRUE))
p + geom_line() + stat_smooth(aes(group = 1), method = "lm", se = TRUE, colour="cyan") + facet_grid(
  . ~ roi_name) + theme_classic() + scale_y_reverse() + theme(axis.title.y = element_text(
                                size=15, colour = 'black', face='bold')) + theme(
                                  axis.title.x = element_text(
                                    size=15, colour = 'black', face='bold')) + theme(
                                      axis.text = element_text(
                                        size = 12, colour='black')) + xlab("Age") + ylab("nT2*w")

## define base for the graphs and store in object 'p'
p <- ggplot(data = data_long, aes(x = age, y = nT2w, group = Subj, ci=TRUE))
p + geom_line() + stat_smooth(aes(group = 1), method = "lm", se = TRUE, colour="magenta") + facet_grid(
  . ~ roi_name) + theme_classic() + scale_y_reverse() + theme(axis.title.y = element_text(
    size=15, colour = 'black', face='bold')) + theme(
      axis.title.x = element_text(
        size=15, colour = 'black', face='bold')) + theme(
          axis.text = element_text(
            size = 12, colour='black')) + xlab("Age") + ylab("nT2*w")

## define base for the graphs and store in object 'p'
p <- ggplot(data = data_long, aes(x = age, y = nT2w, group = Subj, ci=TRUE))
p + geom_line() + stat_smooth(aes(group = 1), method = "lm", se = TRUE, colour="darkblue") + facet_grid(
  . ~ roi_name) + theme_classic() + scale_y_reverse() + theme(axis.title.y = element_text(
    size=15, colour = 'black', face='bold')) + theme(
      axis.title.x = element_text(
        size=15, colour = 'black', face='bold')) + theme(
          axis.text = element_text(
            size = 12, colour='black')) + xlab("Age") + ylab("nT2*w")

## define base for the graphs and store in object 'p'
p <- ggplot(data = data_long, aes(x = age, y = nT2w, group = Subj, ci=TRUE))
p + geom_line() + stat_smooth(aes(group = 1), method = "lm", se = TRUE, colour="darkgreen") + facet_grid(
  . ~ roi_name) + theme_classic() + scale_y_reverse() + theme(axis.title.y = element_text(
    size=15, colour = 'black', face='bold')) + theme(
      axis.title.x = element_text(
        size=15, colour = 'black', face='bold')) + theme(
          axis.text = element_text(
            size = 12, colour='black')) + xlab("Age") + ylab("nT2*w")

##############################################################################################################


