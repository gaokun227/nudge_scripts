#!/bin/tcsh
#SBATCH --ntasks=1
#SBATCH --output=./stdout/%x.o%j
##SBATCH --qos=urgent
#SBATCH --time=02:00:00
#SBATCH --partition=dtn_f5_f6
#SBATCH --cluster=es
#SBATCH --account=gfdl_w

module load cdo

# input: date in YYYYMMDDHH 

set echo

set init_date = `echo $date | cut -c1-8`  # YYYYMMDD
set init_hh = `echo $date | cut -c9-10`   # HH

#set base = /gpfs/f6/bil-coastal-gfdl/scratch/Kun.Gao/aifs/
set base = /gpfs/f5/gfdl_w/scratch/Kun.Gao/DATA_for_nudge/aifs/

set src_dir = $base'/raw/'$date
set dst_dir = $base'/processed/'${init_date}.${init_hh}'Z/'

mkdir -p $dst_dir
cd $dst_dir

set hour_list = ( `seq 0 6 126` )

foreach hour ($hour_list)

  set hour_str = `printf "%03d" $hour`

  set filename = ${src_dir}/${date}'0000-'$hour'h-oper-fc.grib2'
  set filename_nc = ${date}'0000-'$hour_str'h-oper-fc.nc'

  cdo -f nc copy $filename tmp_$filename_nc
  cdo -sellonlatbox,0,360,-90,90 -invertlat -invertlev  tmp_$filename_nc $filename_nc
  rm -rf tmp*

end 
