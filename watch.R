require(logspline)

rd = read.table("watch.txt")

#for discretization:
grid.steps = 128
grid = seq(0,1,length.out=grid.steps)
cache.index = function(v) {
  return(1+round(v*(grid.steps-1)))
}

examples = list(rd$V1)
#scale to max 1:
examples.scale <- lapply(examples, max)
examples <- lapply(examples, function(exs){
  return(exs/max(exs))
})

est.kernel <- function() {
  e <- examples[[1]]
  es <- examples.scale[[1]]
  k <- list()
  k$y <- dlogspline(grid*es, logspline(es*e, lbound=0))#,ubound=1)) #do smoothing in original space
  k$x <- grid
  return(k)
}

k = est.kernel()

plot(k$x, k$y, type="l")