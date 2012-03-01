# This code was written by Michael Lindgren (malindgren@alaska.edu) of The Scenarios Network of Alaska and Arctic Planning
#  at the University of Alaska Fairbanks for the purposes of aiding in the extraction of NetCDF data to a more easily digestible 
#  format for commercial GIS softwares...  It reads in the nc file as a raster brick, which allows for easy access to the data in 
#  a native R format, and extracts each layer from 1:Nlayers in the NetCDF to a *.tif file.
#
# This does require that the user inputs a few different options to be able to create the proper output filename.  This is a bit 
#  tedious but was hardwired in this way for use in many applications. Though in the future it would be nice to write in a parser
#  to turn the input filename into one that is for each individual file using some basic tenets of filenaming.
#
# The USER MUST INPUT THE NEEDED INFORMATION INTO THE VARIABLES inside of the # -- -- -- -- --

# This code is open access / open source and is able to be shared and re-used as needed.  please contact the author (Michael Lindgren)
#  with questions or to send some Kudos (always nice to get!) for writing it and making it available...



# the following packages are needed to run this code.  If you do not have these packages installed use the R command
#  install.packages('<name of package>') to install it directly from the command line. (this requires internet connection)
#  e.g. install.packages('raster') this will install the raster package.  You may need to indicate a mirror to download the 
#  data from, just choose the one that is geographically closest to where you are currently working
require(raster) # this asks R to put the raster library into the environments

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
setwd("/workspace/UA/malindgren/projects/Moritz_NetCDF_Ocean/working/") # set the working directory

#this line sets the output directory to wherever you want to write out the rasters 
output.dir <- "/workspace/UA/malindgren/projects/Moritz_NetCDF_Ocean/" # BE SURE TO LEAVE THE ENDING '/' !!!!

#path to the .nc file to be extracted to NetCDF
nc.path <- "/workspace/UA/malindgren/projects/Moritz_NetCDF_Ocean/chl_Omon_CanESM2_rcp26_r1i1p1_200601-210012.nc"

# this line is all it takes thanks to the raster package to create a stack of rasters from the multidimensional array NetCDF file
nc.stack <- brick("/workspace/UA/malindgren/projects/Moritz_NetCDF_Ocean/chl_Omon_CanESM2_rcp26_r1i1p1_200601-210012.nc")

# these variables should be set to the 2 or 3 digit variable code used to indentify the output data, the model group, the model name,
#  the rcp, and the realization physics run number [ALL OF WHICH CAN BE DERIVED FROM THE INPUT FILENAMES YOU GET FROM THE GROUP]
#   ----> this is used to create the output naming convention for the new raster layers <----
var <- 'chl'
model.group <- 'cccma'
model.name <- 'CanESM2'
rcp <- 'rcp26'
realizationPhys <- 'r1i1p1'

# these two vaiables should be set to the beginning year in the series and the end year in the series
#  they are used in creating the output naming convention
BeginYear <- 2006
EndYear <- 2100
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

# this variable creates a 2-digit scheme for month indicator 
months <- c("01","02","03","04","05","06","07","08","09","10","11","12")

count = 0

for(y in BeginYear:EndYear){
	print(paste("working on Year: ", y, sep=""))

	for(m in months){
		print(paste("         extracting... ", m, sep=""))

		count = count + 1  # this is used as an iterator to grab a file based on its position in the array

		# here we write the selected raster layer to file ** extension can be altered to get different format outputs depending on those file types supported by the 
		# {raster} package in R
		writeRaster(raster(nc.stack, layer=count), filename=paste(output.dir,var,"_",model.group,"_",model.name,"_",rcp,"_",realizationPhys,"_",m,"_",y,".tif", sep=""))

	}
}

print("	COMPLETED EXTRACTION! ")