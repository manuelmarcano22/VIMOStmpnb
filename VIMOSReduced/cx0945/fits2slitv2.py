#!/bin/python2
"""
2016-12-28 
It generates regions files from the pre-images and the spectra from slit definitions in MASK coordinates (spectra file), and the transformation coefficients to convert from mask to CCD coordinates. Details on these transformations can be found in. 
http://www.eso.org/observing/dfo/quality/VIMOS/qc/mask2ccd_qc1.html
"""
import numpy as np
from astropy.io import fits
import glob, os, re


# Read file CX sources. 
filetwo = "../idradectotal.dat"
gbsid = []
racxo = []
deccxo = []

#Read data for sources
with open(filetwo) as file:
	for line in file:
		gbsid.append(line.split()[0])
		racxo.append(np.pi * float(line.split()[1])/180.)
		deccxo.append(np.pi * float(line.split()[2])/180.)
		
gbsid =np.array(gbsid,dtype=str)
racxo = np.array(racxo,dtype=float)
deccxo = np.array(deccxo,dtype=float)

# loop in different quadrant
for i in glob.glob('mos_science_extracted_*Q[1-4]*') :
		quad = re.findall('Q[1-4]',i)[0] #i.split('_')[-1]
		OBsp = i.split('_')[2]
		preimage = glob.glob('VI_SREI_*'+quad+'*')[0]
		OBim = preimage.split('_')[2]
		preheader = fits.getheader(preimage)
		spheader = fits.getheader(i)
		with open(OBim+'_'+OBsp+'_'+quad+'.reg','w') as fout:
			fout.write('global color={color} dashlist=8 3 width=1 '\
					'font="helvetica 10 normal" '\
					'fixed=0 edit=1 move=1 delete=1 '\
					'select=1 highlite=1 dash=0 '\
					'include=1 source=1 \n'\
					'image \n'.format(color='green'))
			#Coefficient for the MASK to CCD from pre-image
			x0 = float(preheader['*CCD X0'][0] )
			y0 = float(preheader['*CCD Y0'][0]) 
			axx = float(preheader['*CCD XX'][0])
			ayy = float(preheader['*CCD YY'][0]) 
			axy = float(preheader['*CCD XY'][0])
			ayx = float(preheader['*CCD YX'][0]) 
			#iterate over slits
			for slit in [1,2,3,4,5,6]:
				#Get info about the slit in teh spheader.
				##xx is the lower x value, cx the length.
				## Assume slit is not tilted.
				xx = spheader["*"+str(slit+1)+"*XX"][0]
				yy = spheader["*"+str(slit+1)+"*YY"][0]
				cx = spheader["*"+str(slit+1)+"*CX"][0]
				xc = xx + cx/2
				yc = yy
				dx = cx
				#Convert MASK corrd to CCD coords:
				ccdxc = axx * xc + axy * yc + x0
				ccddx = axx * dx
				ccdyc = ayx * xc + ayy*yc + y0
				#The slits are a 1".0 width 
				#the 1".0/0".205/pix ccddy = 4.88
				ccddy = 4.88
				#Search CX number and make region file
				ra = np.pi * spheader["*SLIT"+str(slit+1)+"*RA"][0]/180.
				dec = np.pi * spheader["*SLIT"+str(slit+1)+"*DEC"][0]/180.
				#Seacth CXO neastes. Less 3 arcsec
				radeccxo = np.transpose([np.cos(ra)*racxo, deccxo])
				nearby = (180/np.pi)*3600 *\
						np.linalg.norm(\
						np.array([np.cos(ra)*ra,dec]) - radeccxo  
						,axis =1)
				if (-7 < nearby.min() <7):
					fout.write('box('\
							'{xc},{yc},'\
							'{dx},{dy},0) # '\
							'font="helvetica 18 normal" '
							'text={gid}\n'
							.format(xc=ccdxc,yc=ccdyc,
								dx=ccddx,dy=ccddy,\
								gid=\
								'{'+gbsid[\
								np.argmin(nearby)]+'}' ))

