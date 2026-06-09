#!/bin/tcsh

# --- user settings
set date_str = 2024090100   # start date (YYYYMMDDHH)
set date_end = 2024110100   # end date (YYYYMMDDHH)
set int_hour = 6            # interval in hours

set basescript = /autofs/ncrc-svm1_home1/Kun.Gao/nudge_scripts/aifs/run_process_aifs.csh

set date_list = (`../utils/gen_date_list.csh $date_str $date_end $int_hour`)
#echo $date_list

# --- loops over all dates
foreach date ($date_list)

   set init_date = `echo $date | cut -c1-8`  # YYYYMMDD
   set init_hh = `echo $date | cut -c9-10`   # HH

   set src_dir = '/gpfs/f5/gfdl_w/scratch/Kun.Gao/DATA_for_nudge/aifs/raw/'${init_date}${init_hh} #'Z/'
   set dst_dir = '/gpfs/f5/gfdl_w/scratch/Kun.Gao/DATA_for_nudge/aifs/processed/'${init_date}.${init_hh}'Z/'

   #set src_dir = '/gpfs/f6/bil-coastal-gfdl/scratch/Kun.Gao/aifs/raw/'${init_date}.${init_hh}'Z/'
   #set dst_dir = '/gpfs/f6/bil-coastal-gfdl/scratch/Kun.Gao/aifs/processed/'${init_date}.${init_hh}'Z/'

   if ( -d $src_dir && ! -d $dst_dir ) then
     echo 'Processing' $date
     sbatch --job-name=process_aifs_${date} --export=date=${date},ALL $basescript
   endif

end

