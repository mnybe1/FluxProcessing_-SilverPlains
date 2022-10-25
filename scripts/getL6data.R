
library(data.table)
library(janitor)
library(plotly)
library(plyr)
library(dplyr)
library(knitr)
library(tidyverse)
#library(devtools)
library(openair)
library(tidyr)
library(naniar)
library(forecast)
library(kableExtra)
library(htmltools)
library(ggpubr)
library(rstatix)
library(broom)
library(gtable)
library(gridExtra)
library(cowplot)
library(viridis)
library(zoo)

rm(list = ls())


#Below are conversion factors and functions used in the markdown file:
d.avg <- 1800 * 48 #60 secs * 60 mins * 24 hours (# of secs in day)
co2_conv <- 12.01/(10^6) 

tidy.csv <- function(x){
  input <- x[-c(1,2),] %>%
    row_to_names(., 1)
}  

gofC.f <- function(x){ # function to convert to mean 30 minute to g of C
  (x*d.avg)*co2_conv
}

gtomg.f <- function(x){ # function to convert from g to mg
  x*1000
}


input <- fread("R:/SET/PlantSci/Shared Work Spaces/Ecology/Flux/SP_data/PFP/L6/SilverPlains_L6.csv", header = FALSE, na.strings = "-9999") 
input <- tidy.csv(input)

input <- input %>% dplyr::select(xlDateTime, Fe, Fg_Av, Fh, Fld, Flu, Fn, Fsu, Fsd, Precip, RH, Sws, Ta, Ts, VPD, Wd_SONIC_Av, Ws_SONIC_Av,ER_LT_all, GPP_LT,GPP_SOLO, NEE_LT, ET, ER, PAR, ustar, L, Uy_SONIC_Sd) # select variables (add more as needed)
colnames(input) <- c('Timestamp', 'LE', 'G', 'H', 'LWin', 'LWout', 'NETRAD', 'SWout', 'SWin', 'Precip', 'RH', 'SWC', 'Ta', 'Ts', 'VPD', 'WD', 'WS', 'ER_LT', 'GPP_LT', 'GPP_SOLO', 'NEE_LT', 'ET', 'ER_ngf', 'PAR', 'u_star', 'L', 'sigma_v')

input$Timestamp <- as.POSIXct(input$Timestamp, format= "%d/%m/%Y %H:%M") # change from character to POSIXct
input[,2:22] <- as.data.frame(sapply(input[,2:22], as.numeric)) # convert data frame from character to numeric

input$jday <-yday(input$Timestamp) # add jday
input$Year <- year(input$Timestamp) # extract year
input$Year <- as.factor(input$Year) # convert year from integer to factor
input$month <- month(as.POSIXct(input$Timestamp)) # extract month
input$month <- as.factor(input$month)


input4paper1 <- input %>% filter(Timestamp < "2022-06-01 00:00:00")

write.csv(input4paper1, "C:/Users/Marion/Documents/UTas/Papers/paperone_V2.csv")
