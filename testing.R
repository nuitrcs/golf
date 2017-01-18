library(dplyr)


results<-data.frame(i=1:52200, xs, xn, xw, xe, x2, x3, x4, x5, x6, x7, distance)
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
    for (x5 in seq(0,70,2.5)) { # angle
      for (x6 in seq(1,15)) { # length
        for (x7 in seq(1,10)) { # strength
          distance <- runif(1, min=0,max=3.5)+ 
            xs*runif(1, min=0,max=3)+
            xn*runif(1, min=2,max=4.5)+
            xw*-0.07*x5+ 
            xe*0.1*x5+ 
            x2*(runif(1, min=.1,max=.25)*3.55*x7*x6) + 
            x3*(runif(1, min=.25,max=.4)*3.55*x7*x6) + 
            x4*(runif(1, min=.35,max=.45)*3.55*x7*x6) + 
            .21*x7*x7 + 2.32*x7 + 1.91*x5 - x5*x5*.022 + 1.65*(x7-5) 
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

arrange(results, distance) %>% head(n=20)

filter(results, distance<0) %>% nrow()


r1<-lm(distance~north+south+east*angle+west*angle+strength*length*weight_medium+strength*length*weight_medium+strength*length*weight_heavy+I(strength^2)+strength+angle+I(angle^2), data=results)
summary(r1)
