library(dplyr)



counter

arrange(results, desc(distance)) %>% head()

hist(results$distance, breaks=25)

arrange(results, distance) %>% head(n=20)

filter(results, distance<0) %>% nrow()


r1<-lm(distance~north+south+east*angle+west*angle+strength*length*weight_medium+strength*length*weight_medium+strength*length*weight_heavy+I(strength^2)+strength+angle+I(angle^2), data=results)
summary(r1)



library(ggplot2)

ggplot(results, aes(distance)) + geom_histogram(bins=25) + facet_grid(angle ~ .)
ggplot(results, aes(distance)) + geom_histogram(bins=25) + facet_grid(length ~ .)
ggplot(results, aes(distance)) + geom_histogram(bins=25) + facet_grid(strength ~ .)
filter(results, weight_light==0) %>% ggplot(aes(distance)) + geom_histogram(bins=25) + facet_grid(weight_heavy ~ .)



setwd("/Users/christina/projects/srinivasan/golf")
write.csv(results, file="simulateddata.csv", row.names=FALSE, quote=FALSE)
