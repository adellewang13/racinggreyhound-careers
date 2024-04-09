#---Loading and Cleaning Data---
greyhounds.raw <-read.csv(file.choose()) 
attach(greyhounds.raw) 
names(greyhounds.raw)

head(greyhounds.raw)

#Eliminating duplicate greyhounds across years
isDupe = duplicated(greyhounds.raw$Name)
#head(duplicates)
duplicates = which(isDupe==TRUE)
head(duplicates)

greyhounds.dat = greyhounds.raw %>% filter(!row_number() %in% duplicates)
nrow(greyhounds.dat)

head(greyhounds.dat[,c(8,9)])

#Checking for multicollinearity
library("usdm")
vifstep(x=greyhounds.dat[,c(8,10,14,15)], th=5) #only checking relevant quantitative variables

greyhounds.data = greyhounds.dat[,c(3,5,8,10,14,15)]
attach(greyhounds.data)

#---Checking model assumptions
#Scatterplot of each predictor
par(mfrow(c(2,2)))
greyhounds.data %>%
  ggplot(aes(x=Wins, y=CareerRaces)) +
  geom_point() +
  geom_smooth(method='lm',se = FALSE) +
  labs(title='Wins vs. Career Races', x='\n Wins', y='Career Races \n')

greyhounds.data %>%
  ggplot(aes(x=WinPercent, y=CareerRaces)) +
  geom_point() +
  geom_smooth(method='lm',se = FALSE) +
  labs(title='Win Percent vs. Career Races', x='\n Win Percent', y='Career Races \n')

cor(WinPercent, CareerRaces)
cor(Top3, CareerRaces)

greyhounds.data %>%
  ggplot(aes(x=WinDist, y=CareerRaces)) +
  geom_point() +
  geom_smooth(method='lm',se = FALSE) +
  labs(title='Race Distance vs. Career Races', x='\n Race Distance', y='Career Races \n')

greyhounds.data %>%
  ggplot(aes(x=Top3, y=CareerRaces)) +
  geom_point() +
  geom_smooth(method='lm',se = FALSE) +
  labs(title='Top 3 Placements vs. Career Races', x='\n Top 3 Placements', y='Career Races \n')

greyhounds.data %>% 
  group_by(Sex)%>% 
  summarise(mCarRaces=mean(CareerRaces),sCarRaces=sd(CareerRaces),
            Count=n())

mean.df<-data.frame(x1='f',x2='m',y1=147,y2=133)
greyhounds.data %>%
  ggplot(aes(x=Sex, y=CareerRaces)) +
  geom_point() +
  stat_summary(fun='mean',color='orchid') +
  geom_segment(aes(x=x1,y=y1,xend=x2,yend=y2),
               col='orchid', data=mean.df) +
  labs(x = '\n Sex', y='Career Races \n',
       title='Sex vs. Career Races')

#Individual linear models
wins.lm=lm(CareerRaces~Wins,data=greyhounds.data) 
summary(wins.lm)

winperc.lm=lm(CareerRaces~WinPercent,data=greyhounds.data) 
summary(winperc.lm)

windist.lm=lm(CareerRaces~WinDist,data=greyhounds.data) 
summary(windist.lm)

top3.lm=lm(CareerRaces~Top3,data=greyhounds.data) 
summary(top3.lm)

sex.lm=lm(CareerRaces~Sex,data=greyhounds.data) 
summary(sex.lm)

#Residual plots - normality, homoskedasticity
greyhounds.data$eWins = resid(wins.lm) #extracting residuals
greyhounds.data$eWinperc = resid(winperc.lm)
greyhounds.data$eWinDist = resid(windist.lm)
greyhounds.data$eTop3 = resid(top3.lm)
greyhounds.data$eSex = resid(sex.lm)
attach(greyhounds.data)
names(greyhounds.data)

#Normality
qqnorm(eWins,pch=20,ces=0.5)
qqline(eWins,col='orchid')

qqnorm(eWinperc,pch=20,ces=0.5)
qqline(eWinperc,col='orchid')

qqnorm(eWinDist,pch=20,ces=0.5)
qqline(eWinDist,col='orchid')

qqnorm(eTop3,pch=20,ces=0.5)
qqline(eTop3,col='orchid')

qqnorm(eSex,pch=20,ces=0.5)
qqline(eSex,col='orchid')

#Homoskedasticity
greyhounds.data %>% ggplot(aes(x=Wins,y=eWins)) +
  geom_point() +
  geom_abline(slope=0,col='orchid') +
  labs(title='Residual vs. Wins',x='\n Wins',y='Residual \n')

greyhounds.data %>% ggplot(aes(x=WinPercent,y=eWinperc)) +
  geom_point() +
  geom_abline(slope=0,col='orchid') +
  labs(title='Residual vs. Win Percent',x='\n Win Percent',y='Residual \n')

greyhounds.data %>% ggplot(aes(x=WinDist,y=eWinDist)) +
  geom_point() +
  geom_abline(slope=0,col='orchid') +
  labs(title='Residual vs. Race Distance',x='\n Race Distance',y='Residual \n')

greyhounds.data %>% ggplot(aes(x=Top3,y=eTop3)) +
  geom_point() +
  geom_abline(slope=0,col='orchid') +
  labs(title='Residual vs. Top 3 Placements',x='\n Top 3 Placements',y='Residual \n')

greyhounds.data %>%
  ggplot(aes(x=Sex,y=eSex)) + 
  geom_point()+
  geom_abline(slope=0,col='orchid') + 
  labs(x='\n Sex',y='Residual \n')

#Try Box-Cox on Win percent and Top 3
install.packages("MASS")
library("MASS")
boxcox(winperc.lm)
boxcox(top3.lm)
#Both show lambda = 0, do log transformation

winperc2.lm=lm(log(CareerRaces)~WinPercent,data=greyhounds.data) 
summary(winperc2.lm)
plot(resid(winperc2.lm)~WinPercent,greyhounds.data)

top32.lm=lm(log(CareerRaces)~Top3,data=greyhounds.data) 
summary(top32.lm)
plot(resid(top32.lm)~Top3,greyhounds.data)
#Both have improvement in residual plot but not significant improvement in model fit, don't do box cox for simplicity/interpretability

#Finding best model
#Splitting into training and testing
training.id = sample(1:460, 368, replace=FALSE)
training.data = greyhounds.data[training.id,]
testing.data = greyhounds.data[-training.id,]

#find optimal linear regression model
lm.full <- lm(CareerRaces~.,data = training.data)
summary(lm.full)
anova(lm.full)
lm.AIC <- step(lm.full, direction="both",trace=FALSE,steps=1000,k=2)
summary(lm.AIC)
anova(lm.AIC)
lm.BIC <- step(lm.full, direction="both",trace=FALSE,steps=1000,k=log(460))
summary(lm.BIC)

#Calculating evaluation stats (SSR and F-score) on testing data
Y.hat.full = predict(lm.full, newdata=testing.data)
full.error = sum((CareerRaces[-training.id]-Y.hat.full)^2)
full.error
n <- nrow(testing.data)
p <- ncol(testing.data) - 1
SST.full <- sum((testing.data$CareerRaces - mean(testing.data$CareerRaces))^2)
Fscore.full <- ((SST.full - full.error) / (p - 1)) / (full.error / (n - p))
Fscore.full

#Calculating evaluation stats (SSR and F-score) on testing data
Y.hat.AIC = predict(lm.AIC, newdata=testing.data)
AIC.error = sum((CareerRaces[-training.id]-Y.hat.AIC)^2)
AIC.error
SST.AIC <- sum((testing.data$CareerRaces - mean(testing.data$CareerRaces))^2)
Fscore.AIC <- ((SST.AIC - AIC.error) / (p - 1)) / (AIC.error / (n - p))
Fscore.AIC

#Pruned tree model
install.packages('tree')
library(tree)
unpr.fit.tree = tree(CareerRaces~., data=training.data)
treeresult <- cv.tree(unpr.fit.tree, K=10, FUN=prune.tree)
plot(treeresult)
greyhounds.besttree <- prune.tree(unpr.fit.tree,best=9)
greyhounds.besttree$rsq

#Calculating evaluation stats (SSR and F-score) on testing data
Y.hat.tree = predict(greyhounds.besttree,newdata=testing.data)
tree.error = sum((CareerRaces[-training.id]-Y.hat.tree)^2)
tree.error

n <- nrow(testing.data)
p <- ncol(testing.data) - 1
SST.tree <- sum((testing.data$CareerRaces - mean(testing.data$CareerRaces))^2)
Fscore.tree <- ((SST.tree - tree.error) / (p - 1)) / (tree.error / (n - p))
Fscore.tree

#Random Forest model
install.packages("randomForest")
library(randomForest)
fit.RF <- randomForest(CareerRaces~.,data=training.data,ntree=100,mtry=2)
summary(fit.RF)

#Calculating evaluation stats (SSR and F-score) on testing data
Y.hat.RF = predict(fit.RF,newdata=testing.data)
RF.error = sum((CareerRaces[-training.id]-Y.hat.RF)^2)
RF.error

SST.rf <- sum((testing.data$CareerRaces - mean(testing.data$CareerRaces))^2)
Fscore.rf <- ((SST.rf - RF.error) / (p - 1)) / (RF.error / (n - p))
Fscore.rf


