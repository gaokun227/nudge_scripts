#!/bin/tcsh

# ===============================
# Usage: gen_date_list.csh <date_str> <date_end> <int_hour>
# Example: ./gen_date_list.csh 2024092000 2024092106 6
# ===============================

if ( $#argv < 3 ) then
    echo "Usage: $0 <date_str:YYYYMMDDHH> <date_end:YYYYMMDDHH> <int_hour>"
    exit 1
endif

set date_str = $1
set date_end = $2
set int_hour = $3

#echo $date_str, $date_end, $int_hour

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
