library(logspline)

unpruned.data = read.table("~/CoCoLab/prior-elicitation/prior-edited.results", header=T, sep="\t", row.names=NULL)

#might possibly want to remove anything that's 1+cutoff...
data = unpruned.data[unpruned.data$response != (unpruned.data$cutoff + 1),]

cutoffs = sort(unique(data$cutoff))
items = unique(as.character(data$item))

subject.Ns = sapply(cutoffs, function(c) {length(unique(data$subj[data$cutoff == c]))})
names(subject.Ns) = cutoffs

item = "watch"

regions = lapply(0:length(cutoffs), function(i) {
  if (i == 0) {
    lower = 0
  } else {
    lower = cutoffs[[i]]
  }
  if (i == length(cutoffs)) {
    upper = NaN
  } else {
    upper = cutoffs[[i+1]]
  }
  return(list(lower=lower, upper=upper))
})

dir = function(cutoff, region) {
  #is this region above or below the cutoff?
  if (region$lower >= cutoff) {
    #if the lower bound of the region is at or above the cutoff,
    #then everything in the region is at or above the cutoff.
    return("above")
  } else {
    return("below")
  }
}

index = function(cutoff, region) {
  #example matrix columns:
  #cutoff1.below | cutoff1.above | cutoff2.below | cutoff2.above
  cutoff.ind = which(cutoffs == cutoff)
  if (dir(cutoff, region) == "below") {
    return(cutoff.ind*2 - 1)
  } else {
    return(cutoff.ind*2)
  }
}

count = function(cutoff, region) {
  responses = item.data$response[item.data$cutoff == cutoff &
                                   item.data$dir == dir(cutoff, region)]
  if (is.nan(region$upper)) {
    return(sum(responses > region$lower))
  } else {
    return(sum(responses > region$lower & responses < region$upper))
  }
}

item.data = data[data$item == "watch",]
rows = sapply(regions, function(region) {
  lower = region$lower
  upper = region$upper
  c1 = cutoffs[1]
  region.rows = sapply(cutoffs[cutoffs != c1], function(ci) {
    row = rep(0,length(cutoffs)*2)
    c1.ind = index(c1, region)
    c1.count = count(c1, region)
    ci.ind = index(ci, region)
    ci.count = count(ci, region)
    row[c1.ind] = c1.count
    row[ci.ind] = -ci.count
    return(row)
  })
  return(c(region.rows))
})
print(matrix(c(rows), ncol=14, byrow=T))



# getExamples = function() {
#   data = read.table("~/CoCoLab/prior-elicitation/prior-edited.results", header=T, sep="\t", row.names=NULL)
#   #might possibly want to remove anything that's 1+cutoff...
#   #print(head(data))
#   data = data[data$response != (data$cutoff + 1),]
#   
#   cutoffs = unique(data$cutoff)
#   items = unique(as.character(data$item))
#   
#   subject.Ns = sapply(cutoffs, function(c) {length(unique(data$subj[data$cutoff == c]))})
#   names(subject.Ns) = cutoffs
# #   print(subject.Ns)
#   
# ###graphs!
# #   # # histogram per item
# #   # sapply(items, function(item) {
# #   #   png(paste(c(item, ".png"), collapse=""), 600, 400)
# #   #   hist(data$response[data$item == item], main=item, xlab="price",
# #   #        ylab="frequency", breaks=100)
# #   #   sapply(cutoffs, function(cutoff) {
# #   #     abline(v=cutoff, col="blue")
# #   #   })
# #   #   dev.off()
# #   # })
# #   # 
# #   # #histogram per cutoff
# #   # sapply(cutoffs, function(cutoff) {
# #   #   subdata = data$response[data$cutoff == cutoff]
# #   #   png(paste(c(cutoff, ".png"), collapse=""), 600, 400)
# #   #   hist(subdata, main=cutoff, xlab="price",
# #   #        ylab="frequency", breaks=100)
# #   #   abline(v=cutoff, col="blue")
# #   #   dev.off()
# #   #   print(paste(cutoff, length(subdata)/20))
# #   # })
# #   # 
# #   colors = rainbow(length(cutoffs))
# #   dark.colors = rainbow(length(cutoffs), s=1, v=0.5)
# #   names(colors) = cutoffs
# #   names(dark.colors) = cutoffs
# #   #histogram per item per cutoff
# #   sapply(items, function(item) {
# #     png(paste(c(item, "-cutoffs.png"), collapse=""), 1000, 600)
# #     sapply(cutoffs, function(cutoff) {
# #       subdata = data$response[data$cutoff == cutoff & data$item == item]
# #       ub = max(data$response[data$item == item])
# #       hist(subdata,
# #            main=item, xlab="price", ylab="frequency",
# #            ylim = c(0,15),
# #            xlim=c(0, ub),
# #            breaks=50, border=colors[as.character(cutoff)])
# #       abline(v=cutoff, col=colors[as.character(cutoff)], lwd=1)
# #       par(new=T)
# #       
# #       if (cutoff != 10000 & cutoff != 100 & cutoff != 50) {
# #         #lower density line
# #         sub.subdata = subdata[subdata < cutoff]
# #         f <- list()
# #         f$x <- seq(0,max(sub.subdata),length.out=512)
# #         f$y <- dlogspline(f$x, logspline(sub.subdata, lbound=0, ubound=cutoff))#,ubound=1))
# #         plot(f$x, f$y, type="l", ylab="", xlab="",
# #              main="", lwd=1, xlim=c(0,ub), ylim=c(0,0.005), yaxt='n',
# #              col=dark.colors[as.character(cutoff)])
# #         par(new=T)
# #         
# #         #higher density line
# #         super.subdata = subdata[subdata > cutoff]
# #         f <- list()
# #         f$x <- seq(0,max(super.subdata),length.out=512)
# #         f$y <- dlogspline(f$x, logspline(super.subdata, lbound=cutoff))#,ubound=1))
# #         plot(f$x, f$y, type="l", ylab="", xlab="",
# #              main="", lwd=1, xlim=c(0,ub), ylim=c(0,0.005), yaxt='n',
# #              col=dark.colors[as.character(cutoff)])
# #         par(new=T)
# #       }
# #     })
# #     dev.off()
# #   })
#   
#   tokens = 20
#   examples = list()
#   
#   #scale all below elements so that there are 1000 tokens for each sample in the 0-50 range.
#   for (item in items) {
#   # for (item in c("backpack")) {
#     new.item.data = c()
#     uncaught.cutoffs = c()
#     how.many.cutoffs = 0
#     for (cutoff in cutoffs) {
#       subdata = data$response[data$item == item & data$cutoff == cutoff & data$response < cutoff]
#       n = length(subdata[subdata < 50])
#       if (n != 0) {
#         scale.factor = tokens/n
#         new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#         how.many.cutoffs = how.many.cutoffs + 1
#       } else {
#         uncaught.cutoffs = c(uncaught.cutoffs, cutoff)
#       }
#     }
#     how.many.less.than.100 = length(new.item.data[new.item.data < 100])/how.many.cutoffs
#     uncaught.100.cutoffs = c()
#     for (cutoff in uncaught.cutoffs) {
#       subdata = data$response[data$item == item & data$cutoff == cutoff & data$response < cutoff]
#       n = length(subdata[subdata < 100])
#       if (n != 0) {
#         scale.factor = how.many.less.than.100/n
#         new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#         how.many.cutoffs = how.many.cutoffs + 1
#       } else {
#         uncaught.100.cutoffs = c(uncaught.100.cutoffs, cutoff)
#       }
#     }
#     how.many.less.than.500 = length(new.item.data[new.item.data < 500])/how.many.cutoffs
#     uncaught.500.cutoffs = c()
#     for (cutoff in uncaught.100.cutoffs) {
#       subdata = data$response[data$item == item & data$cutoff == cutoff & data$response < cutoff]
#       n = length(subdata[subdata < 500])
#       if (n != 0) {
#         scale.factor = how.many.less.than.500/n
#         new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#         how.many.cutoffs = how.many.cutoffs + 1
#       } else {
#         uncaught.500.cutoffs = c(uncaught.500.cutoffs, cutoff)
#       }
#     }
#     how.many.less.than.1000 = length(new.item.data[new.item.data < 1000])/how.many.cutoffs
#     uncaught.1000.cutoffs = c()
#     for (cutoff in uncaught.500.cutoffs) {
#       subdata = data$response[data$item == item & data$cutoff == cutoff & data$response < cutoff]
#       n = length(subdata[subdata < 1000])
#       if (n != 0) {
#         scale.factor = how.many.less.than.1000/n
#         new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#         how.many.cutoffs = how.many.cutoffs + 1
#       } else {
#         uncaught.1000.cutoffs = c(uncaught.1000.cutoffs, cutoff)
#         print(paste(item, cutoff))
#       }
#     }
#     how.many.between50and100 = length(new.item.data[new.item.data > 50 &
#                                                       new.item.data < 100])/how.many.cutoffs
#     uncaught.50to100.cutoffs = c()
#     for (cutoff in c(50)) {
#       subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
#       n = length(subdata[subdata < 100 & subdata > 50])
#       if (n != 0) {
#         scale.factor = how.many.between50and100/n
#         new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#         how.many.cutoffs = how.many.cutoffs + 1
#       } else {
#         uncaught.50to100.cutoffs = c(uncaught.50to100.cutoffs, cutoff)
#         print(paste(item, cutoff))
#       }
#     }
#     how.many.between100and500 = length(new.item.data[new.item.data > 100 &
#                                                       new.item.data < 500])/how.many.cutoffs
#     uncaught.100to500.cutoffs = c()
#     for (cutoff in c(100)) {
#       subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
#       n = length(subdata[subdata < 500 & subdata > 100])
#       if (n != 0) {
#         scale.factor = how.many.between100and500/n
#         new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#         how.many.cutoffs = how.many.cutoffs + 1
#       } else {
#         uncaught.100to500.cutoffs = c(uncaught.100to500.cutoffs, cutoff)
#         print(paste(item, cutoff))
#       }
#     }
#     how.many.between500and1000 = length(new.item.data[new.item.data > 500 &
#                                                        new.item.data < 1000])/how.many.cutoffs
#     uncaught.500to1000.cutoffs = c()
#     for (cutoff in c(500)) {
#       subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
#       n = length(subdata[subdata < 1000 & subdata > 500])
#       if (n != 0) {
#         scale.factor = how.many.between500and1000/n
#         new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#         how.many.cutoffs = how.many.cutoffs + 1
#       } else {
#         uncaught.500to1000.cutoffs = c(uncaught.500to1000.cutoffs, cutoff)
#         print(paste(item, cutoff))
#       }
#     }
#     how.many.between1000and5000 = length(new.item.data[new.item.data > 1000 &
#                                                         new.item.data < 5000])/how.many.cutoffs
#     uncaught.1000to5000.cutoffs = c()
#     for (cutoff in c(1000)) {
#       subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
#       n = length(subdata[subdata < 5000 & subdata > 1000])
#       if (n != 0) {
#         scale.factor = how.many.between1000and5000/n
#         new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#         how.many.cutoffs = how.many.cutoffs + 1
#       } else {
#         uncaught.1000to5000.cutoffs = c(uncaught.1000to5000.cutoffs, cutoff)
#         print(paste(item, cutoff))
#       }
#     }
#     how.many.between5000and10000 = length(new.item.data[new.item.data > 5000 &
#                                                          new.item.data < 10000])/how.many.cutoffs
#     uncaught.5000to10000.cutoffs = c()
#     for (cutoff in c(5000)) {
#       subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
#       n = length(subdata[subdata < 10000 & subdata > 5000])
#       if (n != 0) {
#         scale.factor = how.many.between5000and10000/n
#         new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#         how.many.cutoffs = how.many.cutoffs + 1
#       } else {
#         uncaught.5000to10000.cutoffs = c(uncaught.5000to10000.cutoffs, cutoff)
#         print(paste(item, cutoff))
#       }
#     }
#     how.many.above10000 = length(new.item.data[new.item.data > 10000])/how.many.cutoffs
#     uncaught.above10000.cutoffs = c()
#     for (cutoff in c(10000)) {
#       subdata = data$response[data$item == item & data$cutoff == cutoff & data$response > cutoff]
#       n = length(subdata[subdata > 10000])
#       if (how.many.above10000 > n/2) {
#         if (n != 0) {
#           scale.factor = how.many.above10000/n
#           print(scale.factor)
#           new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#           how.many.cutoffs = how.many.cutoffs + 1
#         } else {
#           uncaught.above10000.cutoffs = c(uncaught.above10000.cutoffs, cutoff)
#           print(paste(item, cutoff))
#         }
#       } else {
#   #       print(paste(item))
#       }
#     }
#     new.item.data = unlist(new.item.data)
#     if (item == "coffee+maker") {
#       examples[["coffee maker"]] = new.item.data
#     } else {
#       examples[[item]] = new.item.data
#     }
#     
#     #for every round number, sample from a region around it.
#     for (i in 1:length(new.item.data)) {
#       old = new.item.data[i]
#       if (old %% 1000 == 0) {
#         new.item.data[i] = runif(1, old-500, old+500)
#       }
#       else if (old %% 100 == 0) {
#         new.item.data[i] = runif(1, old-50, old+50)
#       }
#       else if (old %% 10 == 0) {
#         new.item.data[i] = runif(1, old-5, old+5)
#       }
#     }
#     
#     png(paste(c("~/CoCoLab/prior-elicitation/scaled-priors/", item, "-scaled.png"), collapse=""), 1000, 600, pointsize=24)
#     hist(x=new.item.data, main=item, breaks=100, xlab="price")
#     par(new=T)
#     f <- list()
#     f$x <- seq(0,max(new.item.data),length.out=512)
#     f$y <- dlogspline(f$x, logspline(new.item.data, lbound=0))#,ubound=1))
#     plot(f$x, f$y, type="l", ylab="", xlab="",
#          main="", lwd=2, xlim=c(0,max(unlist(new.item.data))),
#          ylim=c(0,0.005), yaxt='n')
#     par(new=F)
#     dev.off()
#   }
#   
#   item.names <- c("laptop", "sweater", "coffee maker", "watch", "headphones")
#   png("sorites-priors.png", 2200, 450, pointsize=32)
#   par(mfrow=c(1,5))
#   sapply(item.names, function(cat){
#     if (cat == "laptop") {
#       xlab = "price"
#       ylab = "frequency"
#     } else {
#       xlab = ""
#       ylab = ""
#     }
#     hist(x=examples[[cat]], main=cat, breaks=100, xlab=xlab, ylab=ylab)
#     abline(v=sd(examples[[cat]]), col=rainbow(3)[1])
#     abline(v=2*sd(examples[[cat]]), col=rainbow(3)[2])
#     abline(v=3*sd(examples[[cat]]), col=rainbow(3)[3])
#   })
#   dev.off()
#   
#   png("sorites-priors-in-stdev.png", 2200, 450, pointsize=32)
#   par(mfrow=c(1,5))
#   sapply(item.names, function(cat){
#     if (cat == "laptop") {
#       xlab = "price"
#       ylab = "frequency"
#     } else {
#       xlab = ""
#       ylab = ""
#     }
#     hist(x=examples[[cat]]/sd(examples[[cat]]), main=cat, breaks=100, xlab=xlab, ylab=ylab)
#   })
#   dev.off()
#   # 
#   # items100 = c()
#   # cutoffs100 = c()
#   # for (i in 1:length(uncaught.items)) {
#   #   item = uncaught.items[i]
#   #   cutoff = uncaught.cutoffs[i]
#   #   subdata = data$response[data$item == item & data$cutoff == cutoff & data$response < cutoff]
#   #   n = length(subdata[subdata < 100])
#   #   if (n !=0) {
#   #     scale.factor = how.many.less.than.100/n
#   #     new.item.data = c(new.item.data, c(replicate(round(scale.factor), subdata)))
#   #   } else {
#   #     uncaught.items = c(uncaught.items, item)
#   #     uncaught.cutoffs = c(uncaught.cutoffs, cutoff)
#   #   }
#   # }
#   
#   return(examples)
# }
# 
# examples = getExamples()