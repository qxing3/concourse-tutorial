#!/bin/bash


PIPELINE_HOME=$(dirname $0)

fly -t ci login -c http://10.200.200.55:8080 -n paas -u admin -p Time4fun@21v

fly -t ci sp -p my-pub -c $PIPELINE_HOME/mypipeline-parameters.yml -l $PIPELINE_HOME/credentials.yml -l $PIPELINE_HOME/docker_vars.yml
