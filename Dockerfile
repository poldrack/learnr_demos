FROM rocker/shiny-verse

MAINTAINER Mark Edmondson (r@sunholo.com)

# install R package dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    ## clean up
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/ \ 
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
    
## Install packages from CRAN
RUN install2.r --error \ 
    -r 'http://cran.rstudio.com' \
    googleAuthR \
    remotes \
    learnr \
    && Rscript -e "remotes::install_github(c('MarkEdmondson1234/googleID', 'rstudio-education/gradethis'))" \
    ## clean up
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

ARG UNAME=shiny
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME
RUN chown -R $UNAME /srv/shiny-server
RUN chgrp -R $UNAME /srv/shiny-server
USER $UNAME 


## assume shiny app is in build folder /shiny
## COPY ./shiny/ /srv/shiny-server/myapp/
