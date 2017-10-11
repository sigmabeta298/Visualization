options( java.parameters = "-Xmx4g" )
library(XLConnect)
### Notes:
# Check input and output file name
# Check sheet name, column names, start row and column
# Check if any additional cleanup needed.


## Function to write to excel
write_to_excel <- function(wbobj, sheetname, dataobj) {
  createSheet(wbobj, name=sheetname)
  writeWorksheet(wbobj, data=dataobj, sheet = sheetname, header = TRUE)
  setColumnWidth(wbobj, sheet = sheetname, column = 1:ncol(dataobj), width = -1) # Auto column width
}
##

#Input raw file
wb = loadWorkbook("~/Work/Test_data/CustomGraphs/NetworkPlot/Cornzyme_merged_data_subtable.xlsx")
raw_data <- readWorksheet(wb, sheet="Sheet1", startRow = 1, startCol = 1, header = TRUE)

raw_data <- subset(raw_data, !is.na(TSA.Tm.IF), select = c("Mutations", "TSA.Tm.IF"))

# EG specific - if HIF over wild type value present, use that instead of Average HIF
# raw_data <- subset(raw_data, select = c("Total.Mutations", "Average.HIF", "HIF.over.WT"))
# raw_data <- raw_data[!(is.na(raw_data$Total.Mutations)), ]
# raw_data <- raw_data[!grepl("WT", raw_data$Total.Mutations), ]
# # raw_data <- raw_data[!grepl("\\s?[1-9]+\\s?", raw_data$Total.Mutations), ]
# 
# raw_data$HIF_Median <- ifelse(is.na(raw_data$HIF.over.WT), raw_data$Average.HIF, raw_data$HIF.over.WT)

raw_data$Mutations <- gsub("([[:punct:]])", " ", raw_data$Mutations)
raw_data$Mutations <- gsub("^\\s+|\\s+$", "",raw_data$Mutations)
# View(raw_data)
# 
# mixsort <- function(s) {
#   l <- strsplit(s, split = " ")
#   custom.sort <- function(x){x[order(as.numeric(gsub('\\w([0-9]+)\\w','\\1',x)))]}
#   sl <- custom.sort(l[[1]])
#   fs <- paste(sl, collapse = " ")
#   return (fs)
# }
# raw_data$Mutation <- mapply(mixsort, raw_data$Total.Mutation) # count of combination order
# raw_data <- subset(raw_data, select = c("Mutation", "HIF_Median"))
#EXCEL
file <- '/home/smbk/Work/Test_data/CustomGraphs/NetworkPlot/Conrzyme_cleaned.xlsx'
wb <- loadWorkbook(file, create = TRUE)
write_to_excel(wb, "Raw_data", raw_data)
saveWorkbook(wb)
xlcFreeMemory()
