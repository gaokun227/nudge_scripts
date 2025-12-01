#!/bin/tcsh

# --- user settings
set date_str = 2025110100   # start date (YYYYMMDDHH)
#set date_end = 2024101000   # end date (YYYYMMDDHH)
set date_end = 2025110500   # end date (YYYYMMDDHH)
set int_hour = 6            # interval in hours

set source_dir = /gpfs/f5/gfdl_w/scratch/Kun.Gao/GFSv16/
set target_dir = /gpfs/f5/gfdl_w/scratch/Kun.Gao/GFSv16_nudge/
mkdir -p $target_dir

set basescript = /gpfs/f5/gfdl_w/scratch/Kun.Gao/NCEP_nudge/scripts/run_create_nudge_general.csh

set date_list = (`./gen_date_list.csh $date_str $date_end $int_hour`)
echo $date_list

# --- loops over all dates
foreach date ($date_list)

   set infile=$source_dir/${date}/gfs*.atmanl.nc
   set outfile=$target_dir/${date}.nc

   if (! -f $infile) then
      echo 'Warning: could not find', $infile
   endif

   if (-f $infile && ! -f $outfile) then
      echo 'Processing' $date
      sbatch --job-name=${date} --export=date=${date},source_dir=${source_dir},target_dir=${target_dir},ALL $basescript
   endif
end

