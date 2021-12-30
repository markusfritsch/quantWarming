#########################################################################
###	Warming in Quantiles
#########################################################################



#Contents:
#-load all required packages and data
#-set up design matrix for QTR modeling
#-fit QTR models
#-plot QTR models for selected quantiles
#





#	setwd("C:/Users/harry/harry/Research/!!!PersistenceQR/data")
#	setwd("J:/harry/Research/!!!PersistenceQR/data")
#	setwd("D:/Work/20_Projekte/502_QuantileWarming/R")




rm(list = ls())




#	install.packages("quantreg")
library(quantreg)
#	install.packages("forecast")
library(forecast)
#	install.packages("ggplot2")
library(ggplot2)
#	install.packages("gridExtra")
library(gridExtra)




###	Load dataset


load("tempAnomalies.RData")




###	Set up design matrix


dat1961Ano		<- cbind(dat1961Ano, c = 1, t = 1:nrow(dat1961Ano), t2 = (1:nrow(dat1961Ano))^2, t3 = (1:nrow(dat1961Ano))^3)
dat1961Ano[,14]	<- dat1961Ano[,14]/max(dat1961Ano[,14])
dat1961Ano[,15]	<- dat1961Ano[,15]/max(dat1961Ano[,15])
dat1961Ano[,16]	<- dat1961Ano[,16]/max(dat1961Ano[,16])
dat1961Ano		<- data.frame(dat1961Ano)




###
###	Fit regression quantiles for each month as in Franzke (2013): tau = (0.05; 0.5; 0.95)
###


###	tau = 0.05


#tau.vec	<- c(0.05, 0.1, 0.5, 0.9, 0.95)
#tau.vec	<- c(0.1, 0.25, 0.5, 0.75, 0.9)
tau.vec	<- c(0.05, 0.5, 0.95)
tau.vec2	<- seq(from = 0.1, to = 0.9, by = 0.1)

resMatQ.05	<- dat1961Ano[,1:12]
resMatQ.5	<- dat1961Ano[,1:12]
resMatQ.95	<- dat1961Ano[,1:12]



month		<- colnames(dat)[1:12]


for(k in 1:length(month)){
  m		<- month[k]
  form.tmp	<- as.formula(paste(m, " ~ c + t + t2 + t3 -1", sep = ""))

  for(j in 1:length(tau.vec)){
    rq.tmp	<- rq(form.tmp, data = dat1961Ano, tau = tau.vec[j])
    assign(paste(m, "_Q", tau.vec[j], sep = ""), value = rq.tmp)
  }
  for(i in 1:length(tau.vec2)){
    rq.tmp	<- rq(form.tmp, data = dat1961Ano, tau = tau.vec2[i])
    assign(paste(m, "_Q", tau.vec2[i], sep = ""), value = rq.tmp)
  }

  vec.tmp		<- paste(m, "_Q", tau.vec, sep = "")
  dat.tmp		<- cbind(Observed = dat1961Ano[,k],
						Q.05 = fitted(get(vec.tmp[1])),
						Q.5 = fitted(get(vec.tmp[2])),
						Q.95 = fitted(get(vec.tmp[3]))
						)
  dat.tmp	<- data.frame(cbind(Year = rownames(dat.tmp), dat.tmp) )
  dat.tmp	<- data.frame(do.call(what = cbind, lapply(FUN = as.numeric, X = dat.tmp)))
  res.tmp		<- dat.tmp
  res.tmp[,3]	<- res.tmp[,2] - res.tmp[,3]
  res.tmp[,4]	<- res.tmp[,2] - res.tmp[,4]
  res.tmp[,5]	<- res.tmp[,2] - res.tmp[,5]
  acf.tmp		<- apply(res.tmp[,3:5], FUN = acf, MARGIN = 2, plot = FALSE, lag.max = 8)
  pacf.tmp		<- apply(res.tmp[,3:5], FUN = pacf, MARGIN = 2, plot = FALSE, lag.max = 8)
  sum.tmp		<- lapply(FUN = summary, mget(paste(m, "_Q", tau.vec2, sep = "")), se = "boot", bsmethod = "wild")
  const.tmp		<- data.frame(cbind(tau = tau.vec2, do.call(what = rbind, lapply(lapply(sum.tmp, FUN = coefficients), FUN = function(x) x[1,1:2]))))
  const.tmp		<- cbind(const.tmp, LowerBd = const.tmp[,2] - 1.64*const.tmp[,3], UpperBd = const.tmp[,2] + 1.64*const.tmp[,3])
  t.tmp		<- data.frame(cbind(tau = tau.vec2, do.call(what = rbind, lapply(lapply(sum.tmp, FUN = coefficients), FUN = function(x) x[2,1:2]))))
  t.tmp		<- cbind(t.tmp, LowerBd = t.tmp[,2] - 1.64*t.tmp[,3], UpperBd = t.tmp[,2] + 1.64*t.tmp[,3])
  t2.tmp		<- data.frame(cbind(tau = tau.vec2, do.call(what = rbind, lapply(lapply(sum.tmp, FUN = coefficients), FUN = function(x) x[3,1:2]))))
  t2.tmp		<- cbind(t2.tmp, LowerBd = t2.tmp[,2] - 1.64*t2.tmp[,3], UpperBd = t2.tmp[,2] + 1.64*t2.tmp[,3])
  t3.tmp		<- data.frame(cbind(tau = tau.vec2, do.call(what = rbind, lapply(lapply(sum.tmp, FUN = coefficients), FUN = function(x) x[4,1:2]))))
  t3.tmp		<- cbind(t3.tmp, LowerBd = t3.tmp[,2] - 1.64*t3.tmp[,3], UpperBd = t3.tmp[,2] + 1.64*t3.tmp[,3])
  ols.tmp		<- coefficients(summary(lm(form.tmp, data = dat1961Ano)))
  ols.tmp		<- data.frame(cbind(Est = ols.tmp[,1], LowerBd = ols.tmp[,1] - 1.64*ols.tmp[,2], UpperBd = ols.tmp[,1] + 1.64*ols.tmp[,2]))

  assign(paste("l.plot_", m, sep = ""), value = ggplot(dat.tmp) +
	geom_ribbon(aes(x = Year, ymin = Q.05, ymax = Q.95), fill = cols.tmp[3], alpha = .5) +
	geom_hline(yintercept = 0, color = cols.tmp[3], lty = 1) +
	geom_hline(yintercept = 1.5, color = cols.tmp[1], lty = 1) +
	geom_hline(yintercept = 2, color = cols.tmp[7], lty = 1) +
	labs(y = paste("Mean temperature ", m,  " (°C)", sep = ""), x = "") +
	ylim(ymin = -6, ymax = 6) +
	scale_color_manual(values = c(
						"Observed" = cols.tmp[3],
						"Q.95" = cols.tmp[3],
						"Q.5" = cols.tmp[3],
						"Q.05" = cols.tmp[3]
						),
                       name = element_blank()) + 
	theme(
		legend.position = "none",
		panel.background = element_rect(fill = 'transparent'),
		panel.grid = element_blank() )
	)


}


#pdf(file = "../document/img/40_linePlotQTRMonthly.pdf", width=12, height=16)
gridExtra::grid.arrange(l.plot_Dec, l.plot_Jan, l.plot_Feb,
	l.plot_Mar, l.plot_Apr, l.plot_May,
	l.plot_Jun, l.plot_Jul, l.plot_Aug,
	l.plot_Sep, l.plot_Oct, l.plot_Nov, 
	nrow = 4)
#dev.off()

















