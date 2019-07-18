#!/bin/sh
echo $JENKINS_HOME/jobs
while [ -d $JENKINS_HOME/jobs ]; do
  # sleep 10
  echo "Still waiting"
done