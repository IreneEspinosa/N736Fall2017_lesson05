# ===================================
# R code for N736 lesson 05
# date 9/11/2017
#
# Melinda Higgins, PhD.
# ===================================

# ===================================
# load datasets
# ===================================

library(readr)
dataA <- read_csv("dataA.csv")
dataA

dataB <- read_csv("dataB.csv")
dataB

# ===================================
# stack 2 datasets - add rows
# ===================================

library(dplyr)
dataAB <- bind_rows(dataA, dataB)
dataAB

dataAB <- union_all(dataA, dataB)
dataAB

# ===================================
# keep id var1 and var2
# ===================================

dataAB_var12 <- dataAB %>%
  select(id,var1,var2)
dataAB_var12

# ===================================
# load dataC
# ===================================

dataC <- read_csv("dataC.csv")
dataA
dataC

# ===================================
# do inner join for dataA and dataC
# ===================================

library(dplyr)
dataAC_innerjoin <- inner_join(dataA, dataC, by = "id")
dataAC_innerjoin

# ===================================
# do full (outer) join for dataA and dataC
# ===================================

dataAC_fulljoin <- full_join(dataA, dataC, by = "id")
dataAC_fulljoin

# ===================================
# do left join for dataA and dataC
# ===================================

dataAC_leftjoin <- left_join(dataA, dataC, by = "id")
dataAC_leftjoin

# ===================================
# do right join for dataA and dataC
# ===================================

dataAC_rightjoin <- right_join(dataA, dataC, by = "id")
dataAC_rightjoin


