library(dplyr)


results<-data.frame(i=1:9450, xs, xn, xw, xe, x2, x3, x4, x5, x6, x7, distance) #52200, 26100
counter<-1
for (a in 3:4) {
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
      for (x6 in seq(1,15)) { # length
        for (x7 in seq(1,10,1.5)) { # strength
          distance <- runif(1, min=0,max=3.5)+ 
            xs*runif(1, min=0,max=3)+
            xn*runif(1, min=2,max=4.5)+
            xw*-0.07*x5+ 
            xe*0.1*x5+ 
            x2*(runif(1, min=.15,max=.2)*3.65*x7*x5^.5) + 
            x3*(runif(1, min=.2,max=.35)*3.65*x7*x5^.5) + 
            x4*(runif(1, min=.35,max=.45)*3.65*x7*x5^.5) + 
            .28*x7*x7 + 2.2*x6 + .7*x7*x6 + 2.25*x5 - x5*x5*.033 + 2.85*(x7-5) 
          results[counter,]<-c(counter, xs, xn, xw, xe, x2, x3, x4, x5, x6, x7, distance)
          counter<-counter+1
          if (counter %% 1000 == 0) {
            print(counter)
          }
        }
      }
    }
  }
}

names(results)<-c("iteration","south","north","west","east","weight_light","weight_medium","weight_heavy","angle","length","strength","distance")
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
