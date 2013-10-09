data = read.table("prior-edited.results", header=T, sep="\t", row.names=NULL)
cutoffs = as.numeric(unique(data$cutoff))
items = as.character(unique(data$item))

# histogram per item
sapply(items, function(item) {
  png(paste(c(item, ".png"), collapse=""), 600, 400)
  hist(data$response[data$item == item], main=item, xlab="price",
       ylab="frequency", breaks=100)
  sapply(cutoffs, function(cutoff) {
    abline(v=cutoff, col="blue")
  })
  dev.off()
})

# histogram per cutoff
sapply(cutoffs, function(cutoff) {
  png(paste(c(cutoff, ".png"), collapse=""), 600, 400)
  hist(data$response[data$cutoff == cutoff], main=cutoff, xlab="price",
       ylab="frequency", breaks=100)
  abline(v=cutoff, col="blue")
  dev.off()
})

colors = rainbow(length(cutoffs))
names(colors) = cutoffs
#histogram per item per cutoff
sapply(items, function(item) {
  png(paste(c(item, "-cutoffs.png"), collapse=""), 1000, 600)
  sapply(cutoffs, function(cutoff) {
    hist(data$response[data$cutoff == cutoff & data$item == item],
         main=item, xlab="price", ylab="frequency",
         ylim = c(0,15),
         xlim=c(0, max(data$response[data$item == item])),
         breaks=50, border=colors[as.character(cutoff)])
    abline(v=cutoff, col=colors[as.character(cutoff)], lwd=2)
    par(new=T)
  })
  dev.off()
})