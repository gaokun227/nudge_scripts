#!/bin/tcsh

# --- user settings
set date_str = 2024090100   # start date (YYYYMMDDHH)
set date_end = 2024111500   # end date (YYYYMMDDHH)
set int_hour = 12            # interval in hours

set basescript = /gpfs/f5/gfdl_w/scratch/Kun.Gao/AIFS_nudge/scripts/run_get_aifs.csh

set date_list = (`./gen_date_list.csh $date_str $date_end $int_hour`)
#set hour_list = ( `seq 0 6 126` )
#echo $hour_list
echo $date_list

# --- loops over all dates
foreach date ($date_list)
   set dst_dir = /gpfs/f5/gfdl_w/scratch/Kun.Gao/AIFS_nudge/aifs/raw/$date

   if ( ! -d $dst_dir ) then 
     echo 'Processing' $date
     sbatch --job-name=get_aifs_${date} --export=date=${date},ALL $basescript
   endif
end

