#########################################################################
###	Warming in Quantiles
#########################################################################



#Contents:
#-load all required packages and data
#-specify cut-off dates
#-data preparation - the following datasets are created
#  "cet1659.rds" ~ CET dataset (monthly mean temperatures from January 1659 until December 2020)
#  "datRef.rds" ~ CET dataset (monthly mean temperatures from January 1850 until December 1900)
#  "dat1850.rds" ~ CET dataset (monthly mean temperatures from January 1850 until December 2020)
#  "dat1850Ano.rds" ~ CET anomaly dataset (monthly mean temperature anomalies from January 1850 until December 2020)
#  "dat1961.rds" ~ CET dataset (monthly mean temperatures from January 1961 until December 2020)
#  "dat1961Ano.rds" ~ CET anomaly dataset (monthly mean temperature anomalies from January 1961 until December 2020)
#  "tempAnomalies.RData" ~ several objects required for exploratory data analysis
#










rm(list = ls())





###	Specify colors


cols.tmp		<- c(
#				"#f58080"	# lightred
				"#efa540"	# orange
				,"#2266ee"	# blue
				,"#aabb55"	# lightgreen
				,"#c4bdb7"	# lightgrey
				,"#827f7b"	# grey
				,"#6b625d"	# darkgrey
#				,"#830433"	# darkred
				,"#c10f0f"	# red
				,"#6978c6" 	# blue velvet
				)




###	Load dataset


CET		<- url("http://www.metoffice.gov.uk/hadobs/hadcet/cetml1659on.dat")
dat		<- read.table(CET, sep = "", skip = 6, header = TRUE,
                  fill = TRUE, na.string = c(-99.99, -99.9))
names(dat)	<- c(month.abb, "Annual") 								# fix up df names
dat		<- dat[!is.na(rowSums(dat, na.rm = FALSE)), ]					# remove last line with NAs
#saveRDS(object = dat, file = "cet1659.rds")
#rm(list=(ls()[ls() != "dat"]))
#save.image("../data/cet1659.RData")



###	Subset data and create dataset of temperature anomalies


datRef		<- dat[as.numeric(rownames(dat)) >= 1850 & as.numeric(rownames(dat)) <= 1900, ]
refColMeans		<- colMeans(datRef)
refColMedians	<- apply(X = datRef, MARGIN = 2, FUN = median)
#saveRDS(object = datRef, file = "datRef.rds")
#rm(list=(ls()[ls() != "datRef"]))
#save.image("../data/datRef.RData")


dat1850		<- dat[as.numeric(rownames(dat)) >= 1850 & as.numeric(rownames(dat)) <= 2020, ]
#saveRDS(object = dat1850, file = "dat1850.rds")
#rm(list=(ls()[ls() != "dat1850"]))
#save.image("../data/dat1850.RData")

dat1850Ano		<- t(apply(X = dat1850[,1:12], MARGIN = 1, FUN = function(x) x - refColMeans[1:12]))
#saveRDS(object = dat1850Ano, file = "dat1850Ano.rds")
#rm(list=(ls()[ls() != "dat1850Ano"]))
#save.image("../data/dat1850Ano.RData")


dat1961		<- dat[as.numeric(rownames(dat)) >= 1961 & as.numeric(rownames(dat)) <= 2020, ]
dat1961Ano		<- t(apply(X = dat1961[,1:12], MARGIN = 1, FUN = function(x) x - refColMeans[1:12]))
dat1961AnoMed	<- t(apply(X = dat1961[,1:12], MARGIN = 1, FUN = function(x) x - refColMedians[1:12]))
#saveRDS(object = dat1961, file = "dat1961.rds")
#rm(list=(ls()[ls() != "dat1961"]))
#save.image("../data/dat1961.RData")

#saveRDS(object = dat1961Ano, file = "dat1961Ano.rds")
#rm(list=(ls()[ls() != "dat1961Ano"]))
#save.image("../data/dat1961Ano.RData")


rm(CET)

save.image(file = "tempAnomalies.RData")


















