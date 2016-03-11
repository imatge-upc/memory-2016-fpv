FROM    ubuntu:14.04

# Install python3
RUN     apt-get update
RUN     apt-get install -y python3
RUN apt-get install -y git-core
#RUN    apt-get install -y ca-certificates git-core ssh

# Make ssh dir
#RUN mkdir /root/.ssh/

#Get githib repository
WORKDIR /src
RUN git clone https://github.com/imatge-upc/lifelogging.git
WORKDIR lifelogging/memorygame

#You have to copy the images in the  directory

# Run http server on port 8000
EXPOSE  8000
CMD ["python3", "-m", "http.server", "8000"]

