# The Visual Memory Game
This folder contains source code needed for the game implementation.

## Docker folder
Docker folder contains Docker file for the implementation of docker machine.  

### How to install run Docker machine
* Step 1: go to [Docker website](https://www.docker.com/products/overview#/docker_toolbox) and download "Docker Toolbox", installing "Kitematic" and "Docker QuickStart Terminal".
* Step 2: Once installed, start "Docker QuickStart Terminal".
* Step 3: Download "Dockerfile" from this repository.
* Step 4: In the terminal, change the directory to the ones that contains the "DockerFile".
* Step 5: run "$ docker built -t memory ."; where 'memory' is the name of docker image, but can change.
* Step 6: If success, run "$ docker run -it memory" to run built image.
* Step 6 b): If you need to execute some in docker machine run "$ docker run -it memory bash".

## Images folder
This folder contains images needed for the game, mixing 'targets' and 'fillers', including blank image.

## index.html file
Main web application file. Contains the visual structure of the game, instructions for the user and a command to show an image (it is a dynamic command).

## main.js
Main JavaScript file. Contains the algorithm for the image sequence.

## targets.txt and fillers.txt
This files must contain the name of the images to show. 'Targets' are the images to supervise and annotate as described in the main README. This files have to be in the same folder than 'images' folder.

## Other files
The other files are also needed to web appearance, extra functions...
