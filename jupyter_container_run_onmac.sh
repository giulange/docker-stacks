# jupyter : to develop python and other language codes
# https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html
#
# CALL
#  ./jupyter_container_run_onmac.sh # OR
#  ./jupyter_container_run_onmac.sh jupyter

# optional first argument:
defval="jupyter"
container=${1:-$defval}

# parameters:
HOST_USER=giulianolangella
CONTAINER_USER=giuliano

# binds:
vARGS=" \
-v /Users/$HOST_USER:/home/$CONTAINER_USER \
-v /Users/$HOST_USER/work/Didattica/Veterinaria/PrecisionLivestockFarming/lectures:/home/PLF \
-v /Users/$HOST_USER/work/Didattica/Agraria/GeVS:/home/GeVS \
-v /Users/$HOST_USER/work/R:/home/R \
"
# others to be added!u

# DOCKER RUN
docker run -d --name $container \
$vARGS \
--mac-address 12:32:bc:32:00:12 \
--ip=172.18.0.88 \
-p 8888:8888 \
-p 8093:80 \
--user root \
-w /home/$NB_USER \
-e CHOWN_HOME=yes \
-e NB_USER=giuliano \
-e NB_UID=501 \
-e NB_GID=20 \
-e JUPYTER_TOKEN=a \
-t $container > /dev/null

#--restart always \
#--net landsupport_bridge \

