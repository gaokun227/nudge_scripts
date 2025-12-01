#!/bin/tcsh

# Purpose: collected needed GFS files for a given date

# --- list of model init. dates
set date_str = 2025080100   # start date (YYYYMMDDHH)
set date_end = 2025103012   # end date (YYYYMMDDHH)
set int_hour = 12           # interval in hours
set model_run_days = 5

set res = 0.25deg #13km

set src_dir = /gpfs/f5/gfdl_w/scratch/Kun.Gao/GFSv16_nudge/$res/
set dst_base = /gpfs/f5/gfdl_w/scratch/Kun.Gao/NCEP_nudge/$res/

set ini_date_list = (`./gen_date_list.csh $date_str $date_end $int_hour`)
echo $ini_date_list

# --- loops over all dates
foreach ini_date ($ini_date_list)

   echo "Processing" $ini_date
   set ymd = `echo $ini_date | cut -c1-8`
   set hh   = `echo $ini_date | cut -c9-10`
   set name = ${ymd}.${hh}Z
    
   set dst_dir = $dst_base/$name 
   rm -rf $dst_dir
   mkdir -p $dst_dir 

   set yyyy = `echo $ini_date | cut -c1-4`
   set mm   = `echo $ini_date | cut -c5-6`
   set dd   = `echo $ini_date | cut -c7-8`
   set hh   = `echo $ini_date | cut -c9-10`
   set end_date = `date -u -d "${yyyy}-${mm}-${dd} ${hh}:00 ${model_run_days} days" +%Y%m%d%H`
   #echo $end_date

   set nudge_date_list = (`./gen_date_list.csh $ini_date $end_date 6`) # every 6 hours

   foreach date ($nudge_date_list)

      set files = ( $src_dir/*${date}*nc )

      if ( $#files == 0 ) then
        echo "Warning: No files found for date $date in $src_dir"
        continue    # or 'continue' if inside a foreach loop
      else
        ln -sf $files $dst_dir/
      endif

      #ln -sf $src_dir/*${date}*nc $dst_dir/
   end
end
