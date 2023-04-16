setwd("/Users/yuxianggao/Desktop/626 Midterm")
library(dplyr)

#data cleaning
train0 <- read.table("training_data.txt", header = T)
test <- read.table("test_data.txt", header = T)
#train <- train[-c(1),]

#Response variable
#train_1 = subset(train0, train0$activity %in% c(1:6))
train_1 <- train0
#test1 = filter(test, test$V2 %in% c(1:6))
train_1$response = train_1$activity
#train_1$response[which(train_1$activity %in% c(1,2,3))]=1
#train_1$response[which(train_1$activity %in% c(4,5,6))]=0
train_1$response[train_1$response>7] <- 7

#Logistic
attach(train_1)
#x <- as.matrix(train_1[,-c(1,2,564)])
x <- train_1 %>% select(-c('subject','activity','response'))
x <- as.matrix(x)
y <- train_1$response
library(glmnet)
cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "multinomial")
cv.lasso$lambda.min
cv.lasso$lambda.1se
lasso.fit <- cv.lasso$glmnet.fit
plot(cv.lasso)
lasso.beta <- lasso.fit$beta[,which(cv.lasso$lambda==cv.lasso$lambda.min)]
sum(lasso.beta!=0)
#prediction
lasso.pred <- predict(lasso.fit,as.matrix(test[,-c(1)]),type='response')[,which(cv.lasso$lambda==cv.lasso$lambda.min)]
#lasso.label <- ifelse(lasso.pred>.5,1,0)
apply(pred,1,which.max)
#accuracy
lasso.acc <- mean(lasso.label==valid$response)
lasso.acc

library(caret)
set.seed(1)
folds <- createFolds(y = train_1$response, k = 5)
lasso.acc <- rep(0,5)
for (i in 1:5){
  train.i <- train_1[-folds[[i]],]
  valid.i <- train_1[folds[[i]],]
  x <- train.i %>% select(-c('subject','activity','response'))
  x <- as.matrix(x)
  y <- train.i$response
  cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")
  lasso.fit <- cv.lasso$glmnet.fit
  lasso.pred <- predict(lasso.fit,as.matrix(valid.i[,-c(1,2,564)]),type='response')[,which(cv.lasso$lambda==cv.lasso$lambda.min)]
  lasso.label <- ifelse(lasso.pred>.5,1,0)
  lasso.acc[i] <- mean(lasso.label==valid.i$response)
}
mean(lasso.acc)

#lda
library(MASS)
train.df <- train_1 %>% dplyr::select(-c('subject','activity'))
lda <- lda(response~.,train.df)
lda
#prediction
lda.pred <- predict(lda,test)
lda.pred$class

#qda
qda <- qda(response~.,train.df)
qda
#prediction
qda.pred <- predict(qda,test)
qda.pred$class

#svm
library(e1071)
svm <- svm(response~.,train.df)
svm
#prediction
svm.pred <- predict(svm,test,type='class')
svm.label <- ifelse(svm.pred>0,1,0)
