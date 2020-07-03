FROM rocker/shiny-verse

MAINTAINER Mark Edmondson (r@sunholo.com)

# install R package dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    git \
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

WORKDIR /srv/shiny-server
RUN git clone https://github.com/poldrack/learnr_demos.git
RUN sudo chown -R shiny /srv/shiny-server

## assume shiny app is in build folder /shiny
## COPY ./shiny/ /srv/shiny-server/myapp/
