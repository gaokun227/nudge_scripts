#!/bin/tcsh
#SBATCH --ntasks=1
#SBATCH --output=./stdout/%x.o%j
#SBATCH --cluster=c5
##SBATCH --qos=urgent
#SBATCH --account=gfdl_w
#SBATCH --time=02:00:00

module load cdo

# input vars
# - date in YYYYMMDDHH
# - source_dir
# - target_dir

#echo $date
#echo $source_dir
#echo $target_dir

set hh = `echo $date | cut -c9-10`  # last two chars
set infile=$source_dir/${date}/gfs*.atmanl.nc
set outfile=$target_dir/${date}.nc

mkdir -p $target_dir
rm -rf $target_dir/${date}*

if (! -f $outfile) then
  #echo $infile
  echo $outfile
  cdo -selvar,pressfc,hgtsfc,tmp,spfh,ugrd,vgrd -invertlat $infile $outfile 
  cdo samplegrid,2 $outfile $target_dir/${date}_0.25deg.nc
  cdo samplegrid,4 $outfile $target_dir/${date}_0.5deg.nc
  cdo samplegrid,9 $outfile $target_dir/${date}_1deg.nc
  cdo samplegrid,18 $outfile $target_dir/${date}_2deg.nc
  endif
end

