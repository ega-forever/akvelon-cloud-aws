#!/bin/bash

docker run -it --rm -v $(pwd)/loadtest:/bzt-configs blazemeter/taurus config.yaml
