#!/bin/tcsh

module load cdo

set skip = 2 # 2->0.25deg; 4->0.5deg; 9->1deg; 18->2deg 

set base = /gpfs/f5/gfdl_w/scratch/Kun.Gao/NCEP_nudge/nudge_20250814_00Z/
set source_dir = $base/13km
set target_dir = $base/0.25deg
mkdir -p $target_dir

set files = (`ls ${source_dir}/*.nc | xargs -n1 basename`)
echo $files

# --- loops over all dates

foreach file ($files)
    set infile = ${source_dir}/$file
    set outfile = ${target_dir}/$file
    if (! -f $outfile) then
      cdo samplegrid,$skip $infile $outfile 
    endif
end

