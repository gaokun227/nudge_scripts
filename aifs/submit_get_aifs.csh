#!/bin/tcsh

# --- user settings
set date_str = 2024100100   # start date (YYYYMMDDHH)
set date_end = 2024110100   # end date (YYYYMMDDHH)
set int_hour = 06           # interval in hours

set basescript = /autofs/ncrc-svm1_home1/Kun.Gao/nudge_scripts/aifs/run_get_aifs_2024.csh 

set date_list = (`../utils/gen_date_list.csh $date_str $date_end $int_hour`)
echo $date_list

# --- loops over all dates
foreach date ($date_list)

   set dst_dir = /gpfs/f5/gfdl_w/scratch/Kun.Gao/DATA_for_nudge/aifs/raw/$date
   #set dst_dir = /gpfs/f6/bil-coastal-gfdl/scratch/Kun.Gao/aifs/raw/$date

   if ( ! -d $dst_dir ) then 
     echo 'Processing' $date
     sbatch --job-name=get_aifs_${date} --export=date=${date},ALL $basescript
   endif
end

