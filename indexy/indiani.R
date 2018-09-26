lop <- c('data.table', 'ggplot2', 'SPEI', 'lfstat', 'hydroGOF', 'DEoptim', 'TUWmodel')

to.instal <- lop[which(!lop %in% installed.packages()[,'Package'])]

if(length(to.instal) != 0) install.packages(to.instal)

lapply(lop, library, character.only = T)

id <- '04201500'

dta <- as.data.table(read.fwf(sprintf('ftp://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/%s.dly', id), widths = c(8,10,10,10,10,10)))

names(dta) <- c('DTM', 'P', 'E', 'Q', 'Tmax', 'Tmin')

dta[, DTM := as.Date(gsub(' ','0', DTM), format = '%Y%m%d')]

dta_m <- dta[, .(P = sum(P, na.rm = T),
                 E = sum(E, na.rm = T),
                 Q = mean(Q, na.rm = T)),
             by = format(dta$DTM, '%Y-%m')]

setnames(dta, 'format', 'DTM')

dta_m[, BAL := P - E]
dta_m[, DTM := as.Date(paste(DTM,1,sep="-"),"%Y-%m-%d")]

dta_ts <- ts(dta_m[, -1], end = dta_m[dim(dta_m)[1], DTM], frequency = 12)


spei1 <- spei(dta_ts[,'BAL'], 1)
plot(spei1, main = 'SPEI')

spi1 <- spi(dta_ts[,'P'], 1)
plot(spi1, 'SPI')

year <- 1988

dv <- find_droughts(dta[(DTM %between% c(as.Date(paste(year, '11-1', sep = '-')), as.Date(paste(year + 5, '10-31', sep = '-')))) & (Q >= 0), .(DTM, Q)], threshold = function(x) quantile(x, 0.2, na.rm = TRUE))

summary(dv)

plot(dv)

