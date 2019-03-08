#!/bin/bash

docker run -d -p 8787:8787 -v $(pwd):/home/rstudio -e DISABLE_AUTH=true local/rstudio
