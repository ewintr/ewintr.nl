FROM pierrezemb/gostatic
COPY ./headerConfig.json /config/headerConfig.json
COPY ./public/ /srv/http/

