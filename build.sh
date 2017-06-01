docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker pull jupyter/tmpnb
docker build -f Dockerfile -t trytemp .
export TOKEN=$( head -c 30 /dev/urandom | xxd -p )
docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN --name=proxy jupyter/configurable-http-proxy --default-target http://127.0.0.1:9999
docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN -v /var/run/docker.sock:/docker.sock jupyter/tmpnb python orchestrate.py --image='trytemp' --command='source activate iraf27; jupyter notebook --allow-root  --no-browser --NotebookApp.base_url={base_path} --NotebookApp.token=""  --ip=0.0.0.0 --port {port}'

