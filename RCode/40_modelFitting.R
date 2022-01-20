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


###	tau = 0.05 and tau = 0.95


tau.vec	<- c(0.05, 0.5, 0.95)
tau.vec2	<- seq(from = 0.1, to = 0.9, by = 0.1)

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

  assign(paste("l.plot_", m, sep = ""), value = ggplot(dat.tmp) +
	geom_ribbon(aes(x = Year, ymin = Q.05, ymax = Q.95), fill = cols.tmp[3], alpha = .5) +
	geom_hline(yintercept = 0, color = cols.tmp[3], lty = 1) +
	geom_hline(yintercept = 1.5, color = cols.tmp[1], lty = 1) +
	geom_hline(yintercept = 2, color = cols.tmp[7], lty = 1) +
	labs(y = paste("Temperature anomaly ", m,  " (°C)", sep = ""), x = "Year") +
	ylim(ymin = -6, ymax = 10) +
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


#pdf(file = "../document/img/40_linePlotQTRMonthly.pdf", width=8, height=12)
gridExtra::grid.arrange(l.plot_Dec, l.plot_Jan, l.plot_Feb,
	l.plot_Mar, l.plot_Apr, l.plot_May,
	l.plot_Jun, l.plot_Jul, l.plot_Aug,
	l.plot_Sep, l.plot_Oct, l.plot_Nov, 
	nrow = 4)
#dev.off()












###
###	Merits of QTR over least squares
###


###	QQ-plots (Figure 8 in Haupt and Fritsch, 2021)


# a) normal distribution


ylim.qq		<- c(-6, 6)
month			<- colnames(dat)[-13]
tmp			<- as.numeric()

for(m in 1:length(month)){

  m.tmp	<- month[m]

  tmp		<- dat1850[,m] - refColMeans[m]
  dat.p	<- data.frame(cbind(Year = as.numeric(rownames(dat1850)), Temp.ano = tmp))

  assign(paste("qq.plot", "_", m.tmp, sep = ""), value = ggplot(data = dat.p[dat.p$Year >=1961, ], aes(sample = Temp.ano)) +
	stat_qq(distribution = stats::qnorm, col = cols.tmp[6]) + stat_qq_line(col = cols.tmp[6], lty = 2) +
	labs(y = paste("Emp. quan. temp. anomaly ", m.tmp, " (°C)", sep = ""), x = "Theoretical quant. N(0,1)") +
	ylim(ylim.qq) +
	theme(
		axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
		panel.background = element_rect(fill = "transparent"),
		panel.grid = element_blank() )
  )

}

#pdf(file = "../document/img/40_qqMonthly_ND.pdf", width=8, height=12)
gridExtra::grid.arrange(qq.plot_Dec, qq.plot_Jan, qq.plot_Feb,
	qq.plot_Mar, qq.plot_Apr, qq.plot_May,
	qq.plot_Jun, qq.plot_Jul, qq.plot_Aug,
	qq.plot_Sep, qq.plot_Oct, qq.plot_Nov, 
	nrow = 4)
#dev.off()







# b) t-distribution with df = 2


ylim.qq		<- c(-13.5, 13.5)
month			<- colnames(dat)[-13]
tmp			<- as.numeric()

for(m in 1:length(month)){

  m.tmp	<- month[m]

  tmp		<- dat1850[,m] - refColMeans[m]
  dat.p	<- data.frame(cbind(Year = as.numeric(rownames(dat1850)), Temp.ano = tmp))

  assign(paste("qq.plot", "_", m.tmp, sep = ""), value = ggplot(data = dat.p[dat.p$Year >=1961, ], aes(sample = Temp.ano)) +
	stat_qq_line(distribution = stats::qt, dparams = list("df" = 2), col = cols.tmp[6], lty = 2) +
	stat_qq(distribution = stats::qt, dparams = list("df" = 2), col = cols.tmp[6]) +
	labs(y = paste("Emp. quan. temp. anomaly ", m.tmp, " (°C)", sep = ""), x = "Theoretical quant. t-distr. (2 dof)") +
	ylim(ylim.qq) +
	theme(
		axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
		panel.background = element_rect(fill = "transparent"),
		panel.grid = element_blank() )
  )

}

#pdf(file = "../document/img/40_qqMonthly_tD2dof.pdf", width=8, height=12)
gridExtra::grid.arrange(qq.plot_Dec, qq.plot_Jan, qq.plot_Feb,
	qq.plot_Mar, qq.plot_Apr, qq.plot_May,
	qq.plot_Jun, qq.plot_Jul, qq.plot_Aug,
	qq.plot_Sep, qq.plot_Oct, qq.plot_Nov, 
	nrow = 4)
#dev.off()





# c) t-distribution with df = 5


ylim.qq		<- c(-8, 8)
month			<- colnames(dat)[-13]
tmp			<- as.numeric()

for(m in 1:length(month)){

  m.tmp	<- month[m]

  tmp		<- dat1850[,m] - refColMeans[m]
  dat.p	<- data.frame(cbind(Year = as.numeric(rownames(dat1850)), Temp.ano = tmp))

  assign(paste("qq.plot", "_", m.tmp, sep = ""), value = ggplot(data = dat.p[dat.p$Year >=1961, ], aes(sample = Temp.ano)) +
	stat_qq_line(distribution = stats::qt, dparams = list("df" = 5), col = cols.tmp[6], lty = 2) +
	stat_qq(distribution = stats::qt, dparams = list("df" = 5), col = cols.tmp[6]) +
	labs(y = paste("Emp. quan. temp. anomaly ", m.tmp, " (°C)", sep = ""), x = "Theoretical quant. t-distr. (5 dof)") +
	ylim(ylim.qq) +
	theme(
		axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
		panel.background = element_rect(fill = "transparent"),
		panel.grid = element_blank() )
  )

}

#pdf(file = "../document/img/40_qqMonthly_tD5dof.pdf", width=8, height=12)
gridExtra::grid.arrange(qq.plot_Dec, qq.plot_Jan, qq.plot_Feb,
	qq.plot_Mar, qq.plot_Apr, qq.plot_May,
	qq.plot_Jun, qq.plot_Jul, qq.plot_Aug,
	qq.plot_Sep, qq.plot_Oct, qq.plot_Nov, 
	nrow = 4)
#dev.off()





# c) t-distribution with df = 10


ylim.qq		<- c(-7, 7)
month			<- colnames(dat)[-13]
tmp			<- as.numeric()

for(m in 1:length(month)){

  m.tmp	<- month[m]

  tmp		<- dat1850[,m] - refColMeans[m]
  dat.p	<- data.frame(cbind(Year = as.numeric(rownames(dat1850)), Temp.ano = tmp))

  assign(paste("qq.plot", "_", m.tmp, sep = ""), value = ggplot(data = dat.p[dat.p$Year >=1961, ], aes(sample = Temp.ano)) +
	stat_qq_line(distribution = stats::qt, dparams = list("df" = 10), col = cols.tmp[6], lty = 2) +
	stat_qq(distribution = stats::qt, dparams = list("df" = 10), col = cols.tmp[6]) +
	labs(y = paste("Emp. quan. temp. anomaly ", m.tmp, " (°C)", sep = ""), x = "Theoretical quant. t-distr. (10 dof)") +
	ylim(ylim.qq) +
	theme(
		axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
		panel.background = element_rect(fill = "transparent"),
		panel.grid = element_blank() )
  )

}

#pdf(file = "../document/img/40_qqMonthly_tD10dof.pdf", width=8, height=12)
gridExtra::grid.arrange(qq.plot_Dec, qq.plot_Jan, qq.plot_Feb,
	qq.plot_Mar, qq.plot_Apr, qq.plot_May,
	qq.plot_Jun, qq.plot_Jul, qq.plot_Aug,
	qq.plot_Sep, qq.plot_Oct, qq.plot_Nov, 
	nrow = 4)
#dev.off()












if(FALSE){		# code to verify the above figure


ylim.qq		<- c(-10, 10)
#xlim.qq		<- c(-5, 5)
month			<- colnames(dat)[-13]
tmp			<- as.numeric()

for(m in 1:length(month)){

  m.tmp	<- month[m]

  tmp		<- dat1850[,m] - refColMeans[m]
  dat.p	<- data.frame(cbind(Year = as.numeric(rownames(dat1850)), Temp.ano = tmp))

  ano.tmp	<- sort(dat.p[dat.p$Year >= 1961, "Temp.ano"])

#  t.tmp	<- fitdistr(dat.p[dat.p$Year >=1961, "Temp.ano"], "t",
#			start = list(m=mean(dat.p[dat.p$Year >=1961, "Temp.ano"]),
#					s=sd(dat.p[dat.p$Year >=1961, "Temp.ano"]), df=3),
#			lower=c(-1, 0.001,1))
#
#  qt.tmp	<- c()

  assign(paste("qq.plot", "_", m.tmp, sep = ""), value = ggplot(data = dat.p[dat.p$Year >=1961, ], aes(sample = Temp.ano)) +
	stat_qq_line(distribution = stats::qt, dparams = 2, col = cols.tmp[6], lty = 2) +
	stat_qq(distribution = stats::qt, dparams = 2, col = cols.tmp[6]) +
#	xlim(xlim.qq) +
	ylim(ylim.qq) +
	labs(y = paste("Emp. quan. anomalies ", m.tmp, " (°C)", sep = ""), x = "Theoretical quant. t-distr.") +
	theme(
		axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
		panel.background = element_rect(fill = "transparent"),
		panel.grid = element_blank() )
  )

}

#pdf(file = "../document/img/40_qqMonthly_tDistr2df.pdf", width=8, height=12)
gridExtra::grid.arrange(qq.plot_Dec, qq.plot_Jan, qq.plot_Feb,
	qq.plot_Mar, qq.plot_Apr, qq.plot_May,
	qq.plot_Jun, qq.plot_Jul, qq.plot_Aug,
	qq.plot_Sep, qq.plot_Oct, qq.plot_Nov, 
	nrow = 4)
#dev.off()



}















###	Central tendency vs. extremes: Mean & median vs. 5 and 95%-quantiles (Figure 8 in Haupt and Fritsch, 2021)


###	tau = 0.05 and tau = 0.95


tau.vec	<- c(0.05, 0.5, 0.95)
tau.vec2	<- seq(from = 0.1, to = 0.9, by = 0.1)

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
  dat.tmp		<- data.frame(cbind(Year = rownames(dat.tmp), dat.tmp) )
  dat.tmp		<- data.frame(do.call(what = cbind, lapply(FUN = as.numeric, X = dat.tmp)))
  ols.tmp		<- lm(form.tmp, data = dat1961Ano)
  fitted.tmp	<- fitted(ols.tmp)
  coef.tmp		<- coefficients(summary(ols.tmp))
  coef.tmp		<- data.frame(cbind(Est = coef.tmp[,1], LowerBd = coef.tmp[,1] - 1.64*coef.tmp[,2], UpperBd = coef.tmp[,1] + 1.64*coef.tmp[,2]))

  assign(paste("l.plot_", m, sep = ""), value = ggplot(dat.tmp) +
	geom_line(aes(x = Year, y = Q.5), col = cols.tmp[3], lty = 1) +
	geom_line(aes(x = Year, y = fitted.tmp), col = cols.tmp[3], lty = 2) +
	geom_line(aes(x = Year, y = Observed), col = cols.tmp[4]) +
#	geom_hline(yintercept = 0, color = cols.tmp[3], lty = 1) +
#	geom_hline(yintercept = 1.5, color = cols.tmp[1], lty = 1) +
#	geom_hline(yintercept = 2, color = cols.tmp[7], lty = 1) +
	labs(y = paste("Temperature anomaly ", m,  " (°C)", sep = ""), x = "Year") +
	ylim(ymin = -6, ymax = 10) +
#	scale_color_manual(values = c(
#						"Observed" = cols.tmp[3],
#						"Q.95" = cols.tmp[3],
#						"Q.5" = cols.tmp[3],
#						"Q.05" = cols.tmp[3]
#						),
#                       name = element_blank()) + 
	theme(
		legend.position = "none",
		panel.background = element_rect(fill = 'transparent'),
		panel.grid = element_blank() )
	)


}


#pdf(file = "../document/img/40_centralTendencyMonthly.pdf", width=8, height=12)
gridExtra::grid.arrange(l.plot_Dec, l.plot_Jan, l.plot_Feb,
	l.plot_Mar, l.plot_Apr, l.plot_May,
	l.plot_Jun, l.plot_Jul, l.plot_Aug,
	l.plot_Sep, l.plot_Oct, l.plot_Nov, 
	nrow = 4)
#dev.off()











