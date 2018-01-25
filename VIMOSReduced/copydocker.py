from shutil import copyfile
import subprocess

#for i in $(find -name CX*.ipynb -not -name *checkpoint*.ipynb); do readlink -f $i >> nameshere.txt ; done

alla = []
aqui = []
with open('names.txt','r') as f:
    for lines in f:
        linea = lines.replace('\n','')
        alla.append(linea)

with open('nameshere.txt','r') as f:
    for lines in f:
        linea = lines.replace('\n','')
        aqui.append(linea)

for allaa,aquii in zip(alla,aqui):
    subprocess.call(['docker','cp', 'vimosreduce:'+allaa, aquii])
