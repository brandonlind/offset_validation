
#-----------------------------------------------------------------------------------------------------#
# From a saved RDS object output from gradient forest training, extract predictor importance and save
#-----------------------------------------------------------------------------------------------------#

library(gradientForest)

args = commandArgs(trailingOnly=TRUE)
rdsfile = args[1]

rds = readRDS(rdsfile)

df1 = data.frame(overall_importance=rds$overall.imp)
df2 = data.frame(weighted_importance=importance(rds, type='Weighted'))
df3 = data.frame(accuracy_importance=importance(rds, type='Accuracy'))

# combine df1 with df2
df = merge(df1, df2, by='row.names', all=TRUE)
rownames(df) = df[,'Row.names']
df = subset(df, select=-c(Row.names))

# combine df1+df2 with df3
df = merge(df, df3, by='row.names', all=TRUE)
rownames(df) = df[,'Row.names']
df = subset(df, select=-c(Row.names))

outfile <- gsub(".RDS", "_importances.txt", rdsfile)

write.table(df, outfile, sep='	', row.names=TRUE)

print("wrote to outfile:")
print(outfile)

