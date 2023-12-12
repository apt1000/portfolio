#load the dataset
library(datasets)
library(caret)
data(iris)

iris = datasets::iris

#view the dataset
head(iris, 4)
tail(iris, 4)

#calculate summary statistics
summary(iris)
summary(iris$Sepal.Length)

#check for missing data
sum(is.na(iris))

#load the skimr package
library(skimr)

#view expanded summary statistics
skim(iris)

#group data by sepcies
iris%>%
  dplyr::group_by(Species)%>%
  skim()

#plot the dataset
plot(iris)
plot(iris, col = 'red')

#create scatter plot
plot(iris$Sepal.Width, 
     iris$Sepal.Length, 
     xlab = "Sepal Width", 
     ylab = "Sepal Length")

#create histogram
hist(iris$Sepal.Width, 
     xlab = "Sepal Width", 
     col = "red")

#create the feature plot
featurePlot(x = iris[,1:4], 
            y = iris$Species, 
            plot = "box")

#set the seed
set.seed(100)

#split data into train and test sets
train_index <- createDataPartition(iris$Species, 
                                   p = 0.8, 
                                   list = FALSE)
train_set <- iris[train_index, ]
test_set <- iris[-train_index, ]

#plot the train set
plot(train_set$Sepal.Length, 
     train_set$Sepal.Width, 
     xlab = "Sepal Length", 
     ylab = "Sepal Width")

#create the model
model <- train(Species ~ ., 
               data = train_set, 
               method = "svmPoly", 
               na.action = na.omit, 
               preProcess = c("scale", "center"), 
               trControl = trainControl(method = "none"), 
               tuneGrid = data.frame(degree = 1, 
                                     scale = 1, 
                                     C = 1))

#build cv model
model_cv <- train(Species ~ ., 
                  data = train_set, 
                  method = "svmPoly", 
                  na.action = na.omit, 
                  preProcess = c("scale", "center"), 
                  trControl = trainControl(method = "cv", 
                                           number = 10), 
                  tuneGrid = data.frame(degree = 1, 
                                        scale = 1, 
                                        C = 1))

#predict using the model
model_training <- predict(model, train_set)
model_testing <- predict(model, test_set)
model_cv_predict <- predict(model_cv, train_set)

#examine model performance
model_training_confusion <- confusionMatrix(model_training, 
                                         train_set$Species)
model_testing_confusion <- confusionMatrix(model_testing, 
                                           test_set$Species)
model_cv_confusion <- confusionMatrix(model_cv_predict, 
                                      train_set$Species)

print(model_training_confusion)
print(model_testing_confusion)
print(model_cv_confusion)

#view feature importance
importance <- varImp(model)
plot(importance, col = "red")