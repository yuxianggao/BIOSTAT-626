# BIOSTAT-626 Midterm 1 
## Data files 
Two tab-delimited text files ```training_data.txt``` and ```test_data.txt``` are provided. The training data (labeled activity information included) should be used to construct and test your ML algorithms. Apply your algorithm to the test data (containing only feature information) and predict the activity corresponding to each time window.


## Learning tasks

1. Build a binary classifier to classify the activity of each time window into static (0) and dynamic (1).
2. Build a refined multi-class classifier to classify walking (1), walking_upstairs (2), walking_downstairs (3), sitting (4), standing (5), lying (6), and static postural transition (7)


## Introduction of Task 1: 
First, I created a new column called "response", which labeled the "activity" column into static (0) and dynamic (1). Then, I split the training dataset at the ratio of 8:2 to better estimate the model accuracy. I considered and applied logistic regression (penalized with lasso), SVM, and randomforest as the classifier. After comparing their accuracy using cross validation, I chose the L1 regularized logistic regression for its highest accuracy. This model also works very well in the test dataset and achieves 100% accuracy as shown in the leaderboard. 


## Introduction of Task 2:
First, I changed the "response" column from two levels (0-1) to seven levels (1-7). Based on the performance of task 1, I still applied L1 regularized logistic regression, SVM, and randomforest as classifiers amd compared their performance on training set. L1 regularized logistic regression still has the highest accuracy and I used it to label the test dataset. It achieved 0.955 accuracy as shown in the leaderboard. In order to improve the model performance, I tried to design a community voting method to better increase the performance, but it worked poorly in the test dataset. At the end, I keep the L1 regularized logistic regression as my final model. 


