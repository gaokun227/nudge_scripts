#!/bin/tcsh

# --- user settings
set date_str = 2025080100   # start date (YYYYMMDDHH)
set date_end = 2025103100   # end date (YYYYMMDDHH)
set int_hour = 12            # interval in hours

set basescript = /gpfs/f5/gfdl_w/scratch/Kun.Gao/AIFS_nudge/scripts/run_process_aifs.csh

set date_list = (`./gen_date_list.csh $date_str $date_end $int_hour`)
echo $date_list

# --- loops over all dates
foreach date ($date_list)

   set init_date = `echo $date | cut -c1-8`  # YYYYMMDD
   set init_hh = `echo $date | cut -c9-10`   # HH
   set dst_dir = '/gpfs/f5/gfdl_w/scratch/Kun.Gao/AIFS_nudge/aifs/processed/'${init_date}.${init_hh}'Z/'
   if ( ! -d $dst_dir ) then
     echo 'Processing' $date
     sbatch --job-name=process_aifs_${date} --export=date=${date},ALL $basescript
   endif

end

