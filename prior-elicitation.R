library(logspline)

getExamples = function() {
data = read.table("prior-edited.results", header=T, sep="\t", row.names=NULL)

cutoffs = unique(data$cutoff)
items = unique(as.character(data$item))

# for (cutoff in cutoffs) {
#   data = data[data$response != (cutoff+1),]
# }

# # histogram per item
# sapply(items, function(item) {
#   png(paste(c(item, ".png"), collapse=""), 600, 400)
#   hist(data$response[data$item == item], main=item, xlab="price",
#        ylab="frequency", breaks=100)
#   sapply(cutoffs, function(cutoff) {
#     abline(v=cutoff, col="blue")
#   })
#   dev.off()
# })
# 
# #histogram per cutoff
# sapply(cutoffs, function(cutoff) {
#   subdata = data$response[data$cutoff == cutoff]
#   png(paste(c(cutoff, ".png"), collapse=""), 600, 400)
#   hist(subdata, main=cutoff, xlab="price",
#        ylab="frequency", breaks=100)
#   abline(v=cutoff, col="blue")
#   dev.off()
#   print(paste(cutoff, length(subdata)/20))
# })
# 
# colors = rainbow(length(cutoffs))
# names(colors) = cutoffs
# #histogram per item per cutoff
# sapply(items, function(item) {
#   png(paste(c(item, "-cutoffs.png"), collapse=""), 1000, 600)
#   sapply(cutoffs, function(cutoff) {
#     subdata = data$response[data$cutoff == cutoff & data$item == item]
#     ub = max(data$response[data$item == item])
#     hist(subdata,
#          main=item, xlab="price", ylab="frequency",
#          ylim = c(0,15),
#          xlim=c(0, ub),
#          breaks=50, border=colors[as.character(cutoff)])
#     abline(v=cutoff, col=colors[as.character(cutoff)], lwd=2)
#     par(new=T)
#     
#     #lower density line
#     sub.subdata = subdata[subdata < cutoff]
#     f <- list()
#     f$x <- seq(0,max(sub.subdata),length.out=512)
#     f$y <- dlogspline(f$x, logspline(sub.subdata, lbound=0, ubound=cutoff))#,ubound=1))
#     plot(f$x, f$y, type="l", ylab="", xlab="",
#          main="", lwd=2, xlim=c(0,ub), ylim=c(0,0.005), yaxt='n')
#     par(new=T)
#     
#     #higher density line
#     super.subdata = subdata[subdata > cutoff]
#     f <- list()
#     f$x <- seq(0,max(super.subdata),length.out=512)
#     f$y <- dlogspline(f$x, logspline(super.subdata, lbound=cutoff))#,ubound=1))
#     plot(f$x, f$y, type="l", ylab="", xlab="",
#          main="", lwd=2, xlim=c(0,ub), ylim=c(0,0.005), yaxt='n')
#     par(new=T)
#   })
#   dev.off()
# })

tokens = 20
examples = list()

#scale all below elements so that there are 1000 tokens for each sample in the 0-50 range.
for (item in items) {
# for (item in c("backpack")) {
  new.item.data = c()
  uncaught.cutoffs = c()
  how.many.cutoffs = 0
  for (cutoff in cutoffs) {
    subdata = data$response[data$item == item & data$cutoff == cutoff & data$response < cutoff]
    n = length(subdata[subdata < 50])
    if (n != 0) {
      scale.factor = tokens/n
      new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
      how.many.cutoffs = how.many.cutoffs + 1
    } else {
      uncaught.cutoffs = c(uncaught.cutoffs, cutoff)
    }
  }
  how.many.less.than.100 = length(new.item.data[new.item.data < 100])/how.many.cutoffs
  uncaught.100.cutoffs = c()
  for (cutoff in uncaught.cutoffs) {
    subdata = data$response[data$item == item & data$cutoff == cutoff & data$response < cutoff]
    n = length(subdata[subdata < 100])
    if (n != 0) {
      scale.factor = how.many.less.than.100/n
      new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
      how.many.cutoffs = how.many.cutoffs + 1
    } else {
      uncaught.100.cutoffs = c(uncaught.100.cutoffs, cutoff)
    }
  }
  how.many.less.than.500 = length(new.item.data[new.item.data < 500])/how.many.cutoffs
  uncaught.500.cutoffs = c()
  for (cutoff in uncaught.100.cutoffs) {
    subdata = data$response[data$item == item & data$cutoff == cutoff & data$response < cutoff]
    n = length(subdata[subdata < 500])
    if (n != 0) {
      scale.factor = how.many.less.than.500/n
      new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
      how.many.cutoffs = how.many.cutoffs + 1
    } else {
      uncaught.500.cutoffs = c(uncaught.500.cutoffs, cutoff)
    }
  }
  how.many.less.than.1000 = length(new.item.data[new.item.data < 1000])/how.many.cutoffs
  uncaught.1000.cutoffs = c()
  for (cutoff in uncaught.500.cutoffs) {
    subdata = data$response[data$item == item & data$cutoff == cutoff & data$response < cutoff]
    n = length(subdata[subdata < 1000])
    if (n != 0) {
      scale.factor = how.many.less.than.1000/n
      new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
      how.many.cutoffs = how.many.cutoffs + 1
    } else {
      uncaught.1000.cutoffs = c(uncaught.1000.cutoffs, cutoff)
      print(paste(item, cutoff))
    }
  }
  how.many.between50and100 = length(new.item.data[new.item.data > 50 &
                                                    new.item.data < 100])/how.many.cutoffs
  uncaught.50to100.cutoffs = c()
  for (cutoff in c(50)) {
    subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
    n = length(subdata[subdata < 100 & subdata > 50])
    if (n != 0) {
      scale.factor = how.many.between50and100/n
      new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
      how.many.cutoffs = how.many.cutoffs + 1
    } else {
      uncaught.50to100.cutoffs = c(uncaught.50to100.cutoffs, cutoff)
      print(paste(item, cutoff))
    }
  }
  how.many.between100and500 = length(new.item.data[new.item.data > 100 &
                                                    new.item.data < 500])/how.many.cutoffs
  uncaught.100to500.cutoffs = c()
  for (cutoff in c(100)) {
    subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
    n = length(subdata[subdata < 500 & subdata > 100])
    if (n != 0) {
      scale.factor = how.many.between100and500/n
      new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
      how.many.cutoffs = how.many.cutoffs + 1
    } else {
      uncaught.100to500.cutoffs = c(uncaught.100to500.cutoffs, cutoff)
      print(paste(item, cutoff))
    }
  }
  how.many.between500and1000 = length(new.item.data[new.item.data > 500 &
                                                     new.item.data < 1000])/how.many.cutoffs
  uncaught.500to1000.cutoffs = c()
  for (cutoff in c(500)) {
    subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
    n = length(subdata[subdata < 1000 & subdata > 500])
    if (n != 0) {
      scale.factor = how.many.between500and1000/n
      new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
      how.many.cutoffs = how.many.cutoffs + 1
    } else {
      uncaught.500to1000.cutoffs = c(uncaught.500to1000.cutoffs, cutoff)
      print(paste(item, cutoff))
    }
  }
  how.many.between1000and5000 = length(new.item.data[new.item.data > 1000 &
                                                      new.item.data < 5000])/how.many.cutoffs
  uncaught.1000to5000.cutoffs = c()
  for (cutoff in c(1000)) {
    subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
    n = length(subdata[subdata < 5000 & subdata > 1000])
    if (n != 0) {
      scale.factor = how.many.between1000and5000/n
      new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
      how.many.cutoffs = how.many.cutoffs + 1
    } else {
      uncaught.1000to5000.cutoffs = c(uncaught.1000to5000.cutoffs, cutoff)
      print(paste(item, cutoff))
    }
  }
  how.many.between5000and10000 = length(new.item.data[new.item.data > 5000 &
                                                       new.item.data < 10000])/how.many.cutoffs
  uncaught.5000to10000.cutoffs = c()
  for (cutoff in c(5000)) {
    subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
    n = length(subdata[subdata < 10000 & subdata > 5000])
    if (n != 0) {
      scale.factor = how.many.between5000and10000/n
      new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
      how.many.cutoffs = how.many.cutoffs + 1
    } else {
      uncaught.5000to10000.cutoffs = c(uncaught.5000to10000.cutoffs, cutoff)
      print(paste(item, cutoff))
    }
  }
  how.many.above10000 = length(new.item.data[new.item.data > 10000])/how.many.cutoffs
  uncaught.above10000.cutoffs = c()
  for (cutoff in c(10000)) {
    subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
    n = length(subdata[subdata > 10000])
    if (how.many.above10000 > n/2) {
      if (n != 0) {
        scale.factor = how.many.above10000/n
        print(scale.factor)
        new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
        how.many.cutoffs = how.many.cutoffs + 1
      } else {
        uncaught.above10000.cutoffs = c(uncaught.above10000.cutoffs, cutoff)
        print(paste(item, cutoff))
      }
    } else {
#       print(paste(item))
    }
  }
  new.item.data = unlist(new.item.data)
  examples[[item]] = new.item.data
  
  #for every round number, sample from a region around it.
  for (i in 1:length(new.item.data)) {
    old = new.item.data[i]
    if (old %% 1000 == 0) {
      new.item.data[i] = runif(1, old-500, old+500)
    }
    else if (old %% 100 == 0) {
      new.item.data[i] = runif(1, old-50, old+50)
    }
    else if (old %% 10 == 0) {
      new.item.data[i] = runif(1, old-5, old+5)
    }
  }
  
  hist(x=new.item.data, main=item, breaks=100)
  par(new=T)
  f <- list()
  f$x <- seq(0,max(new.item.data),length.out=512)
  f$y <- dlogspline(f$x, logspline(new.item.data, lbound=0))#,ubound=1))
  plot(f$x, f$y, type="l", ylab="", xlab="",
       main="", lwd=2, xlim=c(0,max(unlist(new.item.data))), ylim=c(0,0.005), yaxt='n')
  par(new=F)
}
# 
# items100 = c()
# cutoffs100 = c()
# for (i in 1:length(uncaught.items)) {
#   item = uncaught.items[i]
#   cutoff = uncaught.cutoffs[i]
#   subdata = data$response[data$item == item & data$cutoff == cutoff & data$response < cutoff]
#   n = length(subdata[subdata < 100])
#   if (n !=0) {
#     scale.factor = how.many.less.than.100/n
#     new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#   } else {
#     uncaught.items = c(uncaught.items, item)
#     uncaught.cutoffs = c(uncaught.cutoffs, cutoff)
#   }
# }

return(examples)
}