#!/bin/tcsh 

module load cdo

set base = /gpfs/f5/gfdl_w/scratch/Kun.Gao/NCEP_nudge/nudge_20250814_00Z/
set source_dir = $base/1deg/
set target_dir = $base/1deg_ref/
mkdir -p $target_dir

set var = 'ugrd'
set lat1 = 10 
set lat2 = 50
set lon1 = 260
set lon2 = 350

#set lev = 95
#925 mb → k = 99
#850 mb → k = 95
#500 mb → k = 73
#200 mb → k = 52

set date_str = 2025081406   # start date (YYYYMMDDHH)
set date_end = 2025081700   # end date (YYYYMMDDHH)
set int_hour = 6            # interval in hours

# --- generate date list 
set cur_date = $date_str
set date_list = ()

while ($cur_date <= $date_end)
    set date_list = ($date_list $cur_date)
    set yyyy = `echo $cur_date | cut -c1-4`
    set mm   = `echo $cur_date | cut -c5-6`
    set dd   = `echo $cur_date | cut -c7-8`
    set hh   = `echo $cur_date | cut -c9-10`
    set cur_date = `date -u -d "${yyyy}-${mm}-${dd} ${hh}:00 ${int_hour} hours" +%Y%m%d%H`
end
echo $date_list

# --- select data
foreach date ( $date_list )
   set infile = $source_dir/${date}.nc 
   set outfile = $target_dir/${var}_${date}_atl.nc
   cdo -selvar,$var -sellonlatbox,$lon1,$lon2,$lat1,$lat2 $infile $outfile 
end

cd $target_dir
cdo mergetime ${var}*atl.nc ${var}_atl_combined.nc 
mkdir -p 0tmp
mv *20*nc 0tmp
