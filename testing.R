library(dplyr)


results<-data.frame(i=1:60480, 0, xs, xn, xw, xe, x2, x3, x4, x5, x6, x7, distance) #52200, 26100, 
counter<-1
for (a in 1:4) {
  if (a==1) {
    xs<-1
    xn<-0
    xw<-0
    xe<-0
  } else if (a==2) {
    xs<-0
    xn<-1
    xw<-0
    xe<-0
  } else if (a==3) {
    xs<-0
    xn<-0
    xw<-1
    xe<-0
  } else if (a==4) {
    xs<-0
    xn<-0
    xw<-0
    xe<-1
  }
  for (b in 1:3) {
    if (b==1) {
      x2<-1
      x3<-0
      x4<-0
    } else if (b==2) {
      x2<-0
      x3<-1
      x4<-0
    } else if (b==3) {
      x2<-0
      x3<-0
      x4<-1
    }
    for (x5 in seq(0,70,5)) { # angle, 2.5
      for (x6 in seq(1,15,2)) { # length
        for (x7 in seq(1,10,1.5)) { # strength
          for (day in 1:6) {
            x7b<-x7^2.5/31.6
            distance <- runif(1, min=0,max=3.5)+ 
              xs*runif(1, min=0,max=3)+
              xn*runif(1, min=2,max=4.5)+
              xw*-0.07*x5+ 
              xe*0.1*x5+ 
              x2*(runif(1, min=.15,max=.2)*3.65*x7b*x5^.5) + 
              x3*(runif(1, min=.2,max=.35)*3.65*x7b*x5^.5) + 
              x4*(runif(1, min=.35,max=.45)*3.65*x7b*x5^.5) + 
              .5*x7b*x7b + .2*x6 + .7*x7b*x6 + 1.925*x5 - x5*x5*.023 + 2.85*(x7b-5) 
            distance <- max(distance, runif(1,.2,6)) # correct for negative distance
            #introduce daily variation
            distance <- distance * 0.85 * (1.1 + 0.01*rnorm(1) * .8*((day %% 5) + 1)) #more variation on some days than others
            distance <- distance + distance * 0.01*(day %% 3) # some days get a pure distance boost
            if (runif(1) < .02) {
              distance <- distance * runif(1,0.08,.4);
            } else if (runif(1) < .01) {
              distance <- runif(1,0,5);
            }
            
            results[counter,]<-c(counter, day, xs, xn, xw, xe, x2, x3, x4, x5, x6+33, x7, distance)
            counter<-counter+1
            if (counter %% 1000 == 0) {
              print(counter)
            }
          }
        }
      }
    }
  }
}



names(results)<-c("iteration","day","south","north","west","east","weight_light","weight_medium","weight_heavy","angle","length","strength","distance")
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
ggplot(results, aes(distance)) + geom_histogram(bins=50) + facet_grid(strength ~ .)
filter(results, weight_light==0) %>% ggplot(aes(distance)) + geom_histogram(bins=25) + facet_grid(weight_heavy ~ .)



setwd("/Users/christina/projects/srinivasan/golf")
write.csv(results, file="simulateddata.csv", row.names=FALSE, quote=FALSE)
