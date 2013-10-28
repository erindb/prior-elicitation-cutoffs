setwd("~/sorites-analysis/")  ###change this to actual location of repo

library(stats)
library(rjson)
library(logspline)

getExamples = function() {
  data = read.table("~/CoCoLab/prior-elicitation/prior-edited.results", header=T, sep="\t", row.names=NULL)
  #might possibly want to remove anything that's 1+cutoff...
  print(nrow(data))
  data = data[data$response != (data$cutoff + 1),]
  print(nrow(data))
  
  cutoffs = unique(data$cutoff)
  items = unique(as.character(data$item))
  
  subject.Ns = sapply(cutoffs, function(c) {length(unique(data$subj[data$cutoff == c]))})
  names(subject.Ns) = cutoffs
  
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
      }
    }
    new.item.data = unlist(new.item.data)
    if (item == "coffee+maker") {
      examples[["coffee maker"]] = new.item.data
    } else {
      examples[[item]] = new.item.data
    }
    
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
  }
  
  return(examples)
}

priors = function(src, item) {
  ylim=NULL
#   if (item == "laptop") {
#     ylim=c(0,0.04)
#   } else if (item == "watch") {
#     ylim=c(0,0.1)
#   } else {
#     ylim=c(0,0.2)
#   }
#   } else if (item == "watch") {
#     ylim=c(0,1)
#   } else if (item == "coffee maker") {
#     ylim=c(0,0.4)
#   } else {
#     ylim=c(0,0.5)
#   }
  #for speaker1 discretization:
  if (item == "coffee maker" || item == "headphones") {
    max.price=1000
  } else if (item == "sweater") {
    max.price=500
  } else {
    max.price=10001
  }
  grid = seq(0,max.price,1)
  
  if (src == "jrp") {
    item.names = c("laptop", "watch")
    
    expt.probs = list()
    x = c(50, 51, 500, 501, 1000, 1001, 5000, 5001, 10000, 10001)
    expt.probs[["electric kettle"]] = list(x=x, y=c(0.42049575, 0.386461042, 0.053285795,
                                                    0.053754236, 0.022280797, 0.021139675,
                                                    0.011161242, 0.011122894, 0.00826966,
                                                    0.01202891))
    expt.probs[["laptop"]] = list(x=x, y=c(0.021903549, 0.021316166, 0.200162566, 0.193891277,
                                           0.214864483, 0.192604147, 0.05994292, 0.053622981,
                                           0.020633218, 0.021058694))
    expt.probs[["watch"]] = list(x=x, y=c(0.230019621, 0.242461077, 0.130524754, 0.122500106,
                                          0.078377872, 0.071541811, 0.041416569, 0.041665985,
                                          0.021089062, 0.020403144))
    expt.pdf = lapply(c("laptop", "watch"), function(item) {
      smooth.spline(x=expt.probs[[item]]$x, y=expt.probs[[item]]$y)
    })
    names(expt.pdf) = c("laptop", "watch")
    
    est.kernel <- function(dist) {
      k = list()
      k$x = grid
      k$y = predict(expt.pdf[[dist]], grid)$y/((sum(predict(expt.pdf[[dist]])$y, grid)*(grid[2]-grid[1])))
      return(k)
    }
    
    prediction = est.kernel(item)
    x = prediction$x
    y = prediction$y
    
    plot(x, y, main=item, #paste(item, " - justine's rough priors"),
         ylab="", xlab="price", type="l", col="purple", yaxt="n", ylim=ylim)
    par(new=T)
  } else {
    item.names <- c("laptop", "sweater", "coffee maker", "watch", "headphones")
    
    if (src == "ebay") {
      #priors on prices from ebay:
      unscaled.examples <- list()
      w = read.table("~/CoCoLab/price-priors/ebay/watch-in-watches.txt")$V1
      unscaled.examples[["watch"]] = w
      unscaled.examples[["laptop"]] = read.table("~/CoCoLab/price-priors/ebay/laptop.txt")$V1
      unscaled.examples[["headphones"]] = read.table("~/CoCoLab/price-priors/ebay/headphones.txt")$V1
      unscaled.examples[["sweater"]] = read.table("~/CoCoLab/price-priors/ebay/sweater.txt")$V1
      unscaled.examples[["coffee maker"]] = read.table("~/CoCoLab/price-priors/ebay/coffee-maker.txt")$V1
      main = paste(item, " - ebay priors")
      color = "red"
    } else if (src == "jhp") {
      unscaled.examples = fromJSON(readLines("~/CoCoLab/price-priors/justine-orig/human-priors.JSON")[[1]])
      main = paste(item, " - justine's human priors")
      color="green"
    } else if (src == "amazon") {
      unscaled.examples = fromJSON(readLines("~/CoCoLab/price-priors/justine-orig/scraped-priors.JSON")[[1]])
      main = paste(item, " - amazon priors")
      #sorites won't actually run for watch because there's this crazy outlier:
      unscaled.examples[["watch"]] = sort(unscaled.examples[["watch"]])[1:(length(unscaled.examples[["watch"]])-1)]
      color="yellow"
    } else if (src == "ours") {
      unscaled.examples = getExamples()
      main = paste(item, " - justine&erin expt")
      color="blue"
    }
    
    #hist(unscaled.examples[[item]], breaks=200, main=item, xlab="price", xlim=c(0,10000), border=color, yaxt="n", ylim=ylim*length(unscaled.examples[[item]]))
    #par(new=T)
    
    #using r function density to find kernal density, so it's not actually continuous
    # kernel.granularity <- grid.steps #2^12 #how many points are calculated for the kernel density estimate
    # est.kernel <- function(dist, bw) {
    #   return(density(examples[[dist]], from=0, to=1, n=kernel.granularity,
    #                  kernel="gaussian", bw=bw, adjust=1))
    # }
    est.kernel <- function(dist,bw) {
      e <- unscaled.examples[[dist]]
      k <- list()
      k$y <- dlogspline(grid, logspline(e, lbound=0))#,ubound=1)) #do smoothing in original space
      k$x <- grid
      return(k)
    }
    k = est.kernel(item)
    plot(k$x, k$y, main=item, xlab="price", col=color, yaxt="n", type="l", ylim=ylim)
    par(new=T)
  }
}

ps=28

png("~/CoCoLab/prior-elicitation/how do our human priors, amazon priors, and ebay priors compare?/laptop-comparison.png", 1200, 840, pointsize=ps)
item = "laptop"
priors("ebay", item)
priors("jrp", item)
priors("ours", item)
priors("jhp", item)
priors("amazon", item)
legend("topright", c("justine's course-grained expt", "erin & justine's interval expt", "justine's original expt", "amazon", "ebay"), fill=c("purple", "blue", "green", "yellow", "red"))
dev.off()

png("~/CoCoLab/prior-elicitation/how do our human priors, amazon priors, and ebay priors compare?/watch-comparison.png", 1200, 840, pointsize=ps)
item = "watch"
priors("ebay", item)
priors("jrp", item)
priors("ours", item)
priors("jhp", item)
priors("amazon", item)
legend("topright", c("justine's course-grained expt", "erin & justine's interval expt", "justine's original expt", "amazon", "ebay"), fill=c("purple", "blue", "green", "yellow", "red"))
dev.off()

png("~/CoCoLab/prior-elicitation/how do our human priors, amazon priors, and ebay priors compare?/headphones-comparison.png", 1200, 840, pointsize=ps)
item = "headphones"
priors("ours", item)
priors("ebay", item)
priors("amazon", item)
priors("jhp", item)
legend("topright", c("erin & justine's interval expt", "justine's original expt", "amazon", "ebay"), fill=c("blue", "green", "yellow", "red"))
dev.off()

png("~/CoCoLab/prior-elicitation/how do our human priors, amazon priors, and ebay priors compare?/coffee-maker-comparison.png", 1200, 840, pointsize=ps)
item = "coffee maker"
priors("ours", item)
priors("amazon", item)
priors("ebay", item)
priors("jhp", item)
legend("topright", c("erin & justine's interval expt", "justine's original expt", "amazon", "ebay"), fill=c("blue", "green", "yellow", "red"))
dev.off()

png("~/CoCoLab/prior-elicitation/how do our human priors, amazon priors, and ebay priors compare?/sweater-comparison.png", 1200, 840, pointsize=ps)
item = "sweater"
priors("ours", item)
priors("jhp", item)
priors("amazon", item)
priors("ebay", item)
legend("topright", c("erin & justine's interval expt", "justine's original expt", "amazon", "ebay"), fill=c("blue", "green", "yellow", "red"))
dev.off()