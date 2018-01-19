# VIMOS temporary Jupyter Notebook

Based on [tmpn](https://github.com/jupyter/tmpnb) to create a temporary Jupyter Notebook servers using Docker containers. The docker container has python 2.7 with IRAF install thought [Astroconda](http://astroconda.readthedocs.io/en/latest/index.html). 

Currently at:

http://vimos.manuelpm.me:8000/

## Local Copy

To have a local working copy execute the build.sh file. 

```bash
chmod +x build.sh
./build.sh
```

Or for a non-temporary Jupyter notebook server see: 

[VIMOSDocker](https://github.com/manuelmarcano22/VIMOSDocker)

## To-Do:

- [ ] Cannot create a terminal. 
- [ ] Use [tini](https://github.com/krallin/tini) to start Jupyter Notebooks
- [ ] Get it to work with Apache Reverse Proxy for my Domain
- 
