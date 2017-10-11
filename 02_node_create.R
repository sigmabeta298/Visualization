options( java.parameters = "-Xmx4g" )
library(XLConnect)
library(plyr)

## Function to write to excel
write_to_excel <- function(wbobj, sheetname, dataobj) {
  createSheet(wbobj, name=sheetname)
  writeWorksheet(wbobj, data=dataobj, sheet = sheetname, header = TRUE)
  setColumnWidth(wbobj, sheet = sheetname, column = 1:ncol(dataobj), width = -1) # Auto column width
}
##

#Input raw file
wb = loadWorkbook("~/Work/Test_data/CustomGraphs/NetworkPlot/EG1_top20.xlsx")
raw_data <- readWorksheet(wb, sheet="Raw_data", startRow = 1, startCol = 1, header = TRUE)

## Clean up the data 
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
raw_data$Mutation <- trim(raw_data$Mutation)

# multi_whitespace <- function(x) gsub("\\s+", " ", x)
# raw_data$Mutation <- multi_whitespace(raw_data$Mutation)
##

## Get unique mutations and derieve median of HIF
raw_data <- aggregate(HIF_Median ~ Mutation, raw_data, median)

countSpaces <- function(s) { sapply(gregexpr(" ", s), function(p) { sum(p>=0) + 1} ) }
raw_data$NCombo <- mapply(countSpaces, raw_data$Mutation) # count of combination order

raw_data <- raw_data[order(raw_data$NCombo),]

## Asign row names and start the count from 0 as NetworkD3 requires that
rownames(raw_data) <- 1:nrow(raw_data)
raw_data$Sls <- as.numeric(rownames(raw_data))
raw_data$ID <- abs(1 - raw_data$Sls)

raw_data <- subset(raw_data, select = c("ID", "Mutation", "HIF_Median", "NCombo"))

#EXCEL
file <- '/home/smbk/Work/Test_data/CustomGraphs/NetworkPlot/Results/EG/EG_top20.xlsx'
wb <- loadWorkbook(file, create = TRUE)
write_to_excel(wb, "Node", raw_data)
saveWorkbook(wb)
xlcFreeMemory()
