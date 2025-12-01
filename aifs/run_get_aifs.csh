#!/bin/tcsh
#SBATCH --ntasks=1
#SBATCH --output=./stdout/%x.o%j
##SBATCH --qos=urgent
#SBATCH --time=02:00:00
#SBATCH --partition=dtn_f5_f6
#SBATCH --cluster=es
#SBATCH --account=gfdl_w

# input vars
# - date: model init date in  YYYYMMDDHH

# full src file format:
#https://storage.googleapis.com/ecmwf-open-data/20251021/00z/aifs-single/0p25/oper/20251021000000-126h-oper-fc.grib2

set echo

set dst_base = '/gpfs/f5/gfdl_w/scratch/Kun.Gao/AIFS_nudge/aifs/raw/'
mkdir -p $dst_base/$date/

set init_date = `echo $date | cut -c1-8`  # YYYYMMDD 
set init_hh = `echo $date | cut -c9-10`   # HH

set hour_list = ( `seq 0 6 126` ) # get forcast hour 0 to 126

foreach hour ($hour_list)

  set filename = ${date}'0000-'$hour'h-oper-fc.grib2'
  #set filename_nc = ${date}'0000-'$hour'h-oper-fc.nc'

  set src_file = 'https://storage.googleapis.com/ecmwf-open-data/'${init_date}'/'${init_hh}'z/aifs-single/0p25/oper/'${filename}
  set dst_file = $dst_base/$date/$filename 

  if ( ! -f $dst_file) then
    wget $src_file -O $dst_file
  endif
end
