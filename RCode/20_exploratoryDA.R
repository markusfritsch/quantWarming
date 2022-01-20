#########################################################################
###	Warming in Quantiles
#########################################################################



#Contents:
#-load all required packages and data
#-descriptives, figures, and tables for CET time series
#-descriptives, figures, and tables for CET anomaly time series
#





#	setwd("C:/Users/harry/harry/Research/!!!PersistenceQR/data")
#	setwd("J:/harry/Research/!!!PersistenceQR/data")
#	setwd("D:/Work/20_Projekte/502_QuantileWarming/R")




rm(list = ls())




#	install.packages("ggplot2")
	library(ggplot2)
#	install.packages("gridExtra")
	library(gridExtra)
#	install.packages("xtable")
	library(xtable)




###	Load datasets


load(file = "tempAnomalies.RData")









###
###	Descriptives and visualizations for CET data
###


###	Lineplots of monthly mean CET from 1850 until 2020 (Figure 1 in Haupt and Fritsch, 2021)


dat.p		<- dat1850[as.numeric(rownames(dat1850)) >= 1850 & as.numeric(rownames(dat1850)) <= 2020, 1:12]
dat.p		<- data.frame(cbind(Year = as.numeric(rownames(dat.p)), dat.p))
dat.p		<- reshape2::melt(dat.p, id.vars = "Year", measure.vars=colnames(dat.p)[2:13])
dat.p		<- cbind(dat.p, timeIndex = dat.p$Year + rep((0:11)/12, each = length(unique(dat.p$Year))))


l.plot	<- ggplot(dat.p) +
	geom_line(aes(x = timeIndex, y = value), col = cols.tmp[3]) +
	labs(y = "Monthly mean temperature (°C)", x = "Year") +
	theme(
		legend.key = element_rect(fill = "transparent", colour = "transparent"),
		panel.background = element_rect(fill = 'transparent'),
		panel.grid = element_blank() )

#pdf(file = "../document/img/10_linePlotMonthlyMeanTemp1850.pdf", width=8, height=4)
l.plot
#dev.off()






###	Time series plot of annual mean CET from 1850 until 2020 (Figure 2 in Haupt and Fritsch, 2021)


dat.p		<- data.frame(cbind("Year" = as.numeric(rownames(dat1850)), "annMean" = dat1850[,13]))

l.plot	<- ggplot(dat.p) +
	geom_line(aes(x = Year, y = annMean), col = cols.tmp[3]) +
	labs(y = "Annual mean temperature (°C)", x = "Year") +
	geom_hline(aes(yintercept = mean(dat.p[dat.p$Year >= 1850 & dat.p$Year <= 1900, 2])), lty = 2, color = cols.tmp[5]) +
	theme(
		legend.key = element_rect(fill = "transparent", colour = "transparent"),
		panel.background = element_rect(fill = 'transparent'),
		panel.grid = element_blank() )

#pdf(file = "../document/img/10_linePlotAnnTemp1850.pdf", width=8, height=4)
l.plot
#dev.off()






###	Season plot of months of CET from 1850 until 2020 next to each other (Figure 3 in Haupt and Fritsch, 2021)	


dat.p1		<- dat1850[as.numeric(rownames(dat1850)) >= 1961 & as.numeric(rownames(dat1850)) <= 2020, 1:12]
dat.p1		<- data.frame(cbind(Year = as.numeric(rownames(dat.p1)), dat.p1))
dat.p1		<- reshape2::melt(dat.p1, id.vars = "Year", measure.vars=colnames(dat.p1)[-1])
dat.p1$index	<- (1:nrow(dat.p1) - 1)*1/12 + 1961
id.tmp1		<- (0:11)*60 + 1
id.tmp2		<- (1:12)*60
dat.p2		<- cbind(data.frame(cbind(x1 = dat.p1$index[id.tmp1], x2 = dat.p1$index[id.tmp2],
				y1 = refColMeans[1:12], y2 = refColMeans[1:12])),
				Month = as.factor(rownames(dat.p1[id.tmp1, ])))
lab			<- unique(dat.p1$variable)



l.plot	<- ggplot() +
	geom_line(data = dat.p1, aes(x = index, y = value, group = variable, color = "Mean temp. \n 1961-2020") ) +
	geom_segment(data = dat.p2, aes(x = x1, xend = x2, y = y1, yend = y2, group = Month, color = "Mean monthly temp. \n 1850-1900"), lwd = 1) +
	geom_vline(data = dat.p1[id.tmp1, ], aes(xintercept = index), color = cols.tmp[5], lty = 2) +
	scale_color_manual(values = c("Mean monthly temp. \n 1850-1900" = cols.tmp[5], "Mean temp. \n 1961-2020" = cols.tmp[3]), 
                       name = element_blank()) + 
	labs(y = "Monthly mean temperature (°C)", x = "Month") +
	scale_x_continuous(breaks = (dat.p2$x1 + dat.p2$x2)/2, labels = lab) +
	theme(
		legend.position = "none",
		axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
		panel.background = element_rect(fill = 'transparent'),
		panel.grid = element_blank() )

#pdf(file = "../document/img/10_linePlotSeasons.pdf", width=8, height=4)
l.plot
#dev.off()










###	Table I


xtable(t(cbind(refColMeans[-13], apply(dat1961[, 1:12], FUN = mean, MARGIN = 2),
	apply(dat1961Ano[, 1:12], FUN = mean, MARGIN = 2))))























###
###	Descriptives and visualizations for anomaly data
###


#sum(dat1961Ano)
#colSums(dat1961Ano)




###	Lineplots of monthly anomalies from 1961 until 2020 (Figure 4 in Haupt and Fritsch, 2021)


dat.p		<- data.frame(cbind(Year = as.numeric(rownames(dat1961Ano)), dat1961Ano))
dat.p		<- reshape2::melt(dat.p, id.vars = "Year", measure.vars=colnames(dat.p)[2:13])
dat.p		<- cbind(dat.p, timeIndex = dat.p$Year + rep((0:11)/12, each = length(unique(dat.p$Year))))


l.plot	<- ggplot(dat.p) +
	geom_line(aes(x = timeIndex, y = value), col = cols.tmp[4]) +
	geom_hline(aes(yintercept = 0), color = cols.tmp[3], lty = 1) +
	geom_hline(aes(yintercept = 1.5), color = cols.tmp[1], lty = 1) +
	geom_hline(aes(yintercept = 2), color = cols.tmp[7], lty = 1) +
	labs(y = "Temperature anomaly (°C)", x = "Year") +
	theme(
		legend.key = element_rect(fill = "transparent", colour = "transparent"),
		panel.background = element_rect(fill = 'transparent'),
		panel.grid = element_blank() )

#pdf(file = "../document/img/10_linePlotAnoMonthly.pdf", width=8, height=4)
l.plot
#dev.off()







###	Lineplots of monthly anomalies over years and empirical density (Figure 5, left in Haupt and Fritsch, 2021)


dat.o		<- data.frame(cbind(Year = 1850:1900, t(apply(dat1850[as.numeric(rownames(dat1850)) <= 1900,1:12], FUN = function(x) x - refColMeans[1:12], MARGIN = 1)) ))
dat.o		<- reshape2::melt(dat.o, id.vars = "Year")
dat.p		<- data.frame(cbind(Year = as.numeric(rownames(dat1961Ano)), dat1961Ano))
dat.p		<- reshape2::melt(dat1961Ano, id.vars = "Year")
dat.p2	<- data.frame(cbind(Year = as.numeric(rownames(dat1961Ano)),
			Max = apply(X = dat1961Ano, FUN = max, MARGIN = 1), Min = apply(X = dat1961Ano, FUN = min, MARGIN = 1) ))
dat.p2	<- reshape2::melt(dat.p2, id.vars = "Year")

l.plot	<- ggplot() +
	geom_line(data = dat.p, aes(x = Var1, y = value, group = Var2), color = cols.tmp[4] ) +
	geom_line(data = dat.p2, aes(x = Year, y = value, group = variable), color = cols.tmp[6] ) +
	geom_hline(aes(yintercept = 0), color = cols.tmp[3], lty = 1) +
	geom_hline(aes(yintercept = 1.5), color = cols.tmp[1], lty = 1) +
	geom_hline(aes(yintercept = 2), color = cols.tmp[7], lty = 1) +
	labs(y = "Temperature anomaly (°C)", x = "Year") +
	theme(
		legend.position = "none",
		axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
		panel.background = element_rect(fill = 'transparent'),
		panel.grid = element_blank() )

#pdf(file = "../document/img/10_linePlotAnoYears.pdf", width=8, height=4)
l.plot
#dev.off()




###	Empirical density for monthly anomalies over the years (Figure 5, right in Haupt and Fritsch, 2021)

h.plot	<- ggplot() + 
 	geom_density(data = dat.o, aes(y = value, x=..density..), alpha = .2, fill = cols.tmp[5], col = cols.tmp[5]) + 
	geom_hline(yintercept = 0, color = cols.tmp[3], lty = 1) +
	geom_hline(yintercept = 1.5, color = cols.tmp[1], lty = 1) +
	geom_hline(yintercept = 2, color = cols.tmp[7], lty = 1) +
 	geom_density(data = dat.p, aes(y = value, x=..density..), alpha = .2, fill = cols.tmp[3], col = cols.tmp[5]) + 
	ylim(floor(min(dat.p2$value)), ceiling(max(dat.p2$value))) +
	scale_x_reverse() +
	labs(x = "Relative frequency", y = "") +
	theme(
		axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
		panel.background = element_rect(fill = "transparent"),
		panel.grid = element_blank() )

#pdf(file = "../document/img/10_empDensAno.pdf", width=8, height=4)
h.plot
#dev.off()





#pdf(file = "../document/img/10_linePlotAndEmpDensAnoYears.pdf", width=8, height=4)
gridExtra::grid.arrange(l.plot, h.plot, nrow = 1, ncol = 2, widths = c(3,1))
#dev.off()

mean(dat.p$value)









###	Boxplots for months for time horizon 1961-2020 vs. 1850-1900 (Figure 6 in Haupt and Fritsch, 2021)


dat.o		<- data.frame(cbind(Year = 1850:1900, t(apply(dat1850[as.numeric(rownames(dat1850)) <= 1900,1:12], FUN = function(x) x - refColMeans[1:12], MARGIN = 1)) ))
dat.p		<- data.frame(cbind(Year = as.numeric(rownames(dat1961Ano)), dat1961Ano))
dat.b		<- rbind(cbind(dat.o, type = "1850"), cbind(dat.p, type = "1961"))
dat.p		<- reshape2::melt(dat.p, id.vars = "Year")
dat.b		<- reshape2::melt(dat.b[,2:14], id.vars = "type")


b.plot	<- ggplot() +
	geom_hline(yintercept = 0, color = cols.tmp[3], lty = 1) +
	geom_hline(yintercept = 1.5, color = cols.tmp[1], lty = 1) +
	geom_hline(yintercept = 2, color = cols.tmp[7], lty = 1) +
	geom_boxplot(data = dat.b, aes(x = variable, y = value, fill = type), col = cols.tmp[6], alpha = 0.5,
		outlier.color = "black", outlier.fill = "black", outlier.alpha = NULL) +
#		outlier.color = cols.tmp[6], outlier.fill = cols.tmp[6], outlier.alpha = NULL) +
	scale_fill_manual(values = c("1850" = cols.tmp[5], "1961" = cols.tmp[3]), 
                       name = element_blank()) +
	labs(y = "Temperature anomaly (°C)", x = "Month") +
	theme(
		legend.position = "none",
		axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
		panel.background = element_rect(fill = 'transparent'),
		panel.grid = element_blank() )


#pdf(file = "../document/img/10_boxPlotMonths1850vs2020.pdf", width=8, height=4)
b.plot
#dev.off()












###	Histograms of monthly temperature anomalies for time horizon 1961-2020 vs. 1850-1900 (Figure 7 in Haupt and Fritsch, 2021)


xlim.hist		<- c(-6, 6)
ylim.hist		<- c(0, 0.5)
month			<- colnames(dat)[-13]
tmp			<- as.numeric()

for(m in 1:length(month)){

  m.tmp	<- month[m]

  tmp		<- dat1850[,m] - refColMeans[m]
  dat.p	<- data.frame(cbind(Year = as.numeric(rownames(dat1850)), Temp.ano = tmp))

  assign(paste("h.plot", "_", m.tmp, sep = ""), value = ggplot() +
	geom_density(data = dat.p[dat.p$Year <=1900, ], aes(x = Temp.ano, y=..density..), alpha = .2, fill = cols.tmp[6]) + 
	geom_density(data = dat.p[dat.p$Year >=1961, ], aes(x = Temp.ano, y=..density..), alpha = .2, fill = cols.tmp[3]) + 
	geom_vline(xintercept = 0, color = cols.tmp[3], lty = 1) +
	geom_vline(xintercept = 1.5, color = cols.tmp[1], lty = 1) +
	geom_vline(xintercept = 2, color = cols.tmp[7], lty = 1) +
	xlim(xlim.hist) +
	ylim(ylim.hist) +
	labs(y = "Relative frequency", x = paste("Temperature anomaly ", m.tmp, " (°C)", sep = "")) +
	theme(
		axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
		panel.background = element_rect(fill = "transparent"),
		panel.grid = element_blank() )
  )

}

#pdf(file = "../document/img/10_empDensMonthly.pdf", width=8, height=12)
gridExtra::grid.arrange(h.plot_Dec, h.plot_Jan, h.plot_Feb,
	h.plot_Mar, h.plot_Apr, h.plot_May,
	h.plot_Jun, h.plot_Jul, h.plot_Aug,
	h.plot_Sep, h.plot_Oct, h.plot_Nov, 
	nrow = 4)
#dev.off()


















































