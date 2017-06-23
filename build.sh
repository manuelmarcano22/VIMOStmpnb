#First remove all containers base on the trytemp image
docker stop $(docker ps -af ancestor=trytemp -q );  docker rm $(docker ps -af ancestor=trytemp -q )
docker stop $(docker ps -af name=proxy -q) ; docker rm $(docker ps -af name=proxy -q)
docker stop $(docker ps -af ancestor=jupyter/tmpnb -q );  docker rm $(docker ps -af ancestor=trytemp -q )
docker pull jupyter/tmpnb
docker build -f Dockerfile -t trytemp .
export TOKEN=$( head -c 30 /dev/urandom | xxd -p )
docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN --name=proxy jupyter/configurable-http-proxy --default-target http://127.0.0.1:9999

docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN -v /var/run/docker.sock:/docker.sock jupyter/tmpnb python orchestrate.py --image='trytemp' --command='
source activate iraf27; trustn=$(find VIMOSReduced/ -not -path *.ipynb_checkpoints/*   -name *.ipynb); for i in $trustn; do jupyter trust $i; done ;jupyter notebook --allow-root  --no-browser --NotebookApp.base_url={base_path} --NotebookApp.token="" --NotebookApp.iopub_data_rate_limit=100000000  --ip=0.0.0.0 --port {port}'



