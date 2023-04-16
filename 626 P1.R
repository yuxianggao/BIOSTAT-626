setwd("/Users/yuxianggao/Desktop/626 Midterm1")
train_2 <- train0
train_2$response = train_1$activity
train_2$response[which(train_1$activity %in% c(1,2,3))]=1
train_2$response[which(train_1$activity %in% c(4:12))]=0
x <- train_2 %>% select(-c('subject','activity','response'))
x <- as.matrix(x)
y <- train_2$response

train.new <- sample.split(train_1$response, SplitRatio = 0.8)


####Lasso Logistic
library(glmnet)
bi.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")
bi.fit <- bi.lasso$glmnet.fit
##Prediction
#bi.pred <- predict(bi.fit,as.matrix(test[,-c(1)]),type='response')[,which(bi.lasso$lambda==bi.lasso$lambda.min)]
cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial",subset=train.new)

bi.label <- ifelse(lasso.pred>.5,1,0)
##5 fold CV
library(caret)
set.seed(1)
folds <- createFolds(y = train_2$response, k = 5)
lasso.acc <- rep(0,5)
for (i in 1:5){
  train.i <- train_2[-folds[[i]],]
  valid.i <- train_2[folds[[i]],]
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
##Output
write.table(bi.label, file = "binaryclass_id.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)


####lda
library(MASS)
train.df <- train_1 %>% dplyr::select(-c('subject','activity'))
lda <- lda(response~.,train.df)
lda
##prediction
lda.pred <- predict(lda,test)
lda.pred$class

####qda
qda <- qda(response~.,train.df)
qda
#prediction
qda.pred <- predict(qda,test)
qda.pred$class

####Tree
#write.table(lasso.label, file = "multiclass_2596.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)
