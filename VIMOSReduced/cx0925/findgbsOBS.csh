#!/bin/csh -f
alias MATH 'set \!:1 = `echo "\!:3-$" | bc -l`'

set obidsp = $1
set obidpreimg = $2
set quad = $3

    set datadir = "/Volumes/gbs/vimos_mtorres"
    set im = "$datadir/VIMOS-preimaging"
    set sp = "$datadir/VIMOS-spectroscopy"  
    echo "Searching in directory:" $datadir    
rm -rf junk*.lis

    echo "Pre-image/s:"
	find $im -name 'VI_SREI_'{$obidpreimg}'*Q'{$quad}'*.fits*' >> junk1.lis

     set lines=`cat junk1.lis`
    set i=1
    while ( $i <= $#lines )
    echo $lines[$i]
    cp $lines[$i] .
    @ i = $i + 1
    end
   # Spectra:
   # y2010-2011 products:
    echo "2D spectra:"
	find  $sp -name 'VI_SSEM_'{$obidsp}'*Q'{$quad}'*.fits*' -o -name 'VI_SEXM_'{$obidsp}'*Q'{$quad}'*.fits*' -o -name 'VI_SRFM_'{$obidsp}'*Q'{$quad}'*.fits*'   >> junk2.lis

   set lines2=`cat junk2.lis`
    set i=1
    while ( $i <= $#lines2 )
    echo $lines2[$i]
    cp $lines2[$i] .
   @ i = $i + 1
    end

    # y2013 products:
       echo "Spectra y2013 (any match??)"            
       find $sp/$obidsp* -name 'mos_science*extracted*Q'{$quad}'*.fits*' >> junk3.lis

    set lines3=`cat junk3.lis`
    set i=1
    while ( $i <= $#lines3 )
    echo $lines3[$i]
    cp $lines3[$i] .
    @ i = $i + 1
    end

    

    

