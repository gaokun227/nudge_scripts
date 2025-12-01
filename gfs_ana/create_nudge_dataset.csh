#!/bin/tcsh
module load cdo

# --- user settings
set date_str = 2025081400   # start date (YYYYMMDDHH)
set date_end = 2025081700   # end date (YYYYMMDDHH)
set int_hour = 6            # interval in hours

set source_dir = /gpfs/f5/gfdl_w/scratch/Kun.Gao/GFSv16/
set target_dir = /gpfs/f5/gfdl_w/scratch/Kun.Gao/NCEP_nudge/nudge_${date_str}_00Z/
mkdir -p $target_dir

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

# --- loops over all dates
foreach date ($date_list)
   set hh = `echo $date | cut -c9-10`
   set infile=$source_dir/${date}/gfs*.atmanl.nc
   set outfile=$target_dir/${date}.nc

   if (! -f $outfile) then
   #echo $infile
      echo $outfile
      cdo -selvar,pressfc,hgtsfc,tmp,spfh,ugrd,vgrd -invertlat $infile $outfile 
   endif
end

