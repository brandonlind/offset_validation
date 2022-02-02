
#----------------------------------------------------------------------------------------------------------#
# Given a trained gradient forest, fit model to input climate data, `range_data`; save offset netCDF file.
#
# Usage
# -----
# Rscript gradient_fitting_script.R gfOut_trainingfile range_file predfile maskfile basename save_dir
#
# Parameters
# ----------
# gfOut_trainingfile - file path to trained gradient forest object, saved as .RDS
# range_file - tab delimited .txt file path with columns for `lat`, `lon`, and each env used in training
#    - generally, these are the envdata extracted from ClimateNA GIS data, and then clipped
#        to the range map
#    - these can be current, future, or uniform (eg for common garden) climate
#    - see eg yeaman03:/notebooks/007_JP_gea/07_gradient_forest/01_prep_spatial_envdata.ipynb
# predfile - path to RDS of object saved from interpolating gradient forest model across landscape
#    for the same time period as the data that went into training (created in gradient_training.R)
# maskfile - path to RDS object of a blank range map (same map used to clip range_file data)
#    - this was created by setting all values to 0, and then saving RDS
#    - see https://www.mountainmanmaier.com/software/pop_genom/
# basename - the basename prefix wanted for saving files in `save_dir`
# save_dir - the directory where files should be saved
#----------------------------------------------------------------------------------------------------------#

library(gradientForest)
library(raster)

args = commandArgs(trailingOnly=TRUE)
gfOut_trainingfile <- args[1]
range_file <- args[2]
predfile <- args[3]
maskfile <- args[4]
basename <- args[5]
save_dir <- args[6]

calc_euclid <- function(proj, curr){
    #-------------------------------------------------------------------#
    # CALCULATE EUCLIDEAN DISTANCE BETWEEN CURRENT AND PROJECTED OFFSET
    #-------------------------------------------------------------------#
    
    df <- data.frame(matrix(ncol=ncol(proj), nrow=nrow(proj)))
    stopifnot(all(colnames(proj) == colnames(curr)))
    for (i in 1:ncol(proj)){
        # square each difference between the column data
        df[,i] <- (proj[,i] - curr[,i])**2
    }
    # sum by rows then take the square root of each
    return (sqrt(apply(df, 1, sum)))
}

get_offset <- function(outfile){
    #--------------------------#
    # CALCULATE GENETIC OFFSET
    #--------------------------#
    
    # predict offset for common garden
    ptm <- proc.time()
    projOut <- predict(gfOut, range_data[, envs])
    print(proc.time() - ptm)

    # calc offset
    offset <- calc_euclid(projOut, predOut)

    # put offset into GIS layer
    m2 <- readRDS(maskfile)
    m2[range_cells] <- offset

    # save netCDF file
    writeRaster(m2,
                outfile,
                format='CDF',
                overwrite=TRUE)
    cat(sprintf('
Saved netCDF file to:
'))
    cat(sprintf(sprintf('	%s', outfile)))
}



# SET UP NAMESPACE
envs <- c('Elevation', 'AHM', 'CMD', 'DD5', 'DD_0', 'EMT', 'EXT', 'Eref', 'FFP', 'MAP', 'MAT', 'MCMT', 'MSP', 'MWMT',
              'NFFD', 'PAS', 'SHM', 'TD', 'bFFP', 'eFFP')
stopifnot(length(envs) == 20)
gfOut <- readRDS(gfOut_trainingfile)
range_data <- read.csv(range_file, sep='\t')
predOut <- readRDS(predfile)

# load mask shapefile, use to get cell IDs for each of the lat/long in range_data
mask <- readRDS(maskfile)
range_cells <- cellFromXY(mask, range_data[ ,c('lon','lat')])



# FIT GRADIENT FOREST MODEL TO INPUT ENVDATA
cat(sprintf('
Fitting gradient forest model to input envdata ...
'))
ptm <- proc.time()
projOut <- predict(gfOut, range_data[ , envs])
print(proc.time() - ptm)



# CALCULATE OFFSET
cat(sprintf('
Calculating offset ...
'))
netCDF_file <- paste0(
    save_dir,
    sprintf('/%s_offset.nc', basename)
)
get_offset(netCDF_file)


# SAVE
outfile <- paste0(
    save_dir,
    sprintf('/%s_gradient_forest_fitted.RDS', basename)
)
saveRDS(projOut, outfile)

