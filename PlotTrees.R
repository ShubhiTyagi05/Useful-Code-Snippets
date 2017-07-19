#Installing Required Packages
options(repos='http://cran.rstudio.org')
have.packages <- installed.packages()
cran.packages <- c('devtools','plotrix','randomForest','tree')
to.install <- setdiff(cran.packages, have.packages[,1])
if(length(to.install)>0) install.packages(to.install)
library(devtools)

if(!('reprtree' %in% installed.packages())){
  install_github('araastat/reprtree')
}
for(p in c(cran.packages, 'reprtree')) eval(substitute(library(pkg), list(pkg=p)))

#Creating and Plotting RF
library(randomForest)
library(reprtree)
model <- randomForest(Species ~ ., data=iris, importance=TRUE, ntree=500, mtry = 2, do.trace=100)
reprtree:::plot.getTree(model)


#Plotting Regression Decision Tree
library(rpart)
library(rpart.plot)
treeFitSub <- rpart(Yield ~ ., data = df[,c(7,40,6,25)],method="anova")
prp(type=2,extra=1,digits=4,box.palette="auto",fallen.leaves = TRUE,treeFitSub)
