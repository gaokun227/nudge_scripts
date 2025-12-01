#!/bin/tcsh 

module load cdo

set source_dir = /gpfs/f5/gfdl_w/scratch/Kun.Gao/SHiELD_INPUT/SHiELD_IC_v16/C768r10n4_atl_new/
set target_dir = /gpfs/f5/gfdl_w/scratch/Kun.Gao/NCEP_nudge/ref_20240924_00Z/
mkdir -p $target_dir

set file = 'gfs_data.tile7'

set var = 'u_w'
set lev = 95 

#925 mb → k = 99
#850 mb → k = 95
#500 mb → k = 73
#200 mb → k = 52

set date_str = 2024092406   # start date (YYYYMMDDHH)
set date_end = 2024092700   # end date (YYYYMMDDHH)
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

   set ymd = `echo $date | cut -c1-8`
   set hh  = `echo $date | cut -c9-10`
   set date1 = ${ymd}.${hh}Z
   set infile=$source_dir/${date1}_IC/${file}.nc 
   set outfile=$target_dir/${date}_${file}_${var}_k${lev}.nc
   cdo -sellevel,$lev -selvar,$var $infile $outfile 
end
