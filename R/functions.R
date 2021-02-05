#'One Sample t-test
#'
#'Compare the mean of the sample with a value
#'
#'@param x sample
#'@param m0 value to be tested against
#'@param clt applies or not clt_transform function
#'@return p-value of test along with a histogram
#'@export
t_test_one_sample <- function(x,m0,clt=F,...) {
  if (clt==T) {
    kwargs <- list(...)
    if (is.null(kwargs$outcome)) {
      x <- clt_transform(x)
    } else {
      x <- clt_transform(x,outcome = kwargs$outcome,n=kwargs$n)
    }
  }
  m <- mean(x)
  sd <- sqrt(sum((m-x)**2)/length(x))
  t <- (m-m0)/(sd/sqrt(length(x)))
  p_value <- round(2*pt(-abs(t),df=length(x)-1,lower.tail=TRUE),3)
  l <- list()
  l$result <- paste0("p-value:",p_value," , H_0: sample's true mean is ",m0)
  #create histogram
  p <- ggplot2::ggplot() +
    ggplot2::geom_histogram(ggplot2::aes(x)) +
    ggplot2::geom_vline(xintercept = m0) +
    ggplot2::ggtitle(label = paste0('Histogram of Sample vs H_0 mean (vline):',as.character(m0))) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  l$plot <- p
  return(l)
}



#'Two Sample t-test
#'
#'Compare the means of two samples
#'
#'@param x1,x2 samples to be compared
#'@param clt applies or not clt_transform function
#'@return p-value of test along with a histogram
#'@export
t_test_two_sample <- function(x1,x2,clt=F,...) {
  if (clt==T) {
    kwargs <- list(...)
    if (is.null(kwargs$outcome)) {
      x1 <- clt_transform(x1)
      x2 <- clt_transform(x2)
    } else {
      x1 <- clt_transform(x1,outcome = kwargs$outcome,n=kwargs$n)
      x2 <- clt_transform(x2,outcome = kwargs$outcome,n=kwargs$n)
    }
  }
  m1 <- mean(x1)
  m2 <- mean(x2)
  sd1 <- sqrt(sum((m1-x1)**2)/length(x1))
  sd2 <- sqrt(sum((m2-x2)**2)/length(x2))
  m_diff <- m1-m2
  sd_pooled <- (((length(x1)-1)*(sd1**2)) + ((length(x2)-1)*(sd2**2)))/ (length(x1)+length(x2)-2)
  t <- m_diff/(sqrt(sd_pooled)*sqrt(1/length(x1)+1/length(x2)))
  p_value <- round(2*pt(-abs(t),df=length(x1)+length(x2)-2,lower.tail=TRUE),3)
  l <- list()
  l$result <- paste0("p-value:",p_value," , H_0: samples' mean equal")
  #create histogram
  p <- ggplot2::ggplot( data = rbind(data.frame(
    group=c(rep("x1",length(x1)),rep("x2",length(x2))),
    values=c(x1,x2))),ggplot2::aes(x=values, fill=group)) +
    ggplot2::geom_histogram( color="#e9ecef", alpha=0.6, position = 'identity') +
    ggplot2::scale_fill_manual(values=c("#69b3a2", "#404080")) +
    ggplot2::ggtitle(label = paste0('Side by side Sample histograms')) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  hrbrthemes::theme_ipsum() +
    ggplot2::labs(fill="")
  l$plot <- p
  return(l)
}



#'Central Limit Theorem transformation
#'
#'According to CLT we sample multiple times to produce a vector of sample means
#'
#'@param x data to be transformed
#'@param outcome 'continuous'/'dichotomous' depending on the related outcome
#'@return vector of means based on sampling according to CLT
#'@export
clt_transform <- function(x,outcome='continuous',...) {
  kwargs=list(...)
  if (outcome=='continuous') {
      #condition to use CLT
      if (length(x)>=31) {
        z <- NULL
        set.seed(3)
        for (i in 1:2000) {
          #according to CLT samples should be sufficiently large, n>=30, with replacement
          z[i] <- mean(sample(x,30,replace = T))
        }
        return(z)
      } else {
        stop('sample size n < 31')
      }
  } else if (outcome=='dichotomous') {
    n=kwargs$n
    #success for any given trial
    p=sum(x)/length(x)
    #condition to use CLT
    if (min(c(n*p,n*(1-p)))>5) {
      z <- NULL
      set.seed(3)
      for (i in 1:2000) {
        #according to CLT samples should be sufficiently large, n>=30, with replacement
        s <- sample(x,n,replace = T)
        z[i] <- sum(s)/length(s)
      }
      return(z)
    } else {
      stop('min(np,n(1-p)) <= 5 for n selected')
    }
  }

}



