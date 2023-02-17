sudo docker run -it --network=host --privileged --env="DISPLAY" --volume="$HOME/Git/path_planner:/workspace/src"
sudo docker run -it --network=host --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --env="DISPLAY"
