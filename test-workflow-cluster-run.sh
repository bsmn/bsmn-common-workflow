#! /usr/bin/env bash

set -x

JOBSTORE=aws:us-east-1:tthyer-cwl-cluster-bsmn

toil clean $JOBSTORE

mkdir -p /var/log/toil/workers/bsmn

toil-cwl-runner --provisioner aws \
--jobStore $JOBSTORE \
--provisioner aws \
--batchSystem mesos \
--logLevel DEBUG \
--logFile /var/log/toil/bsmn.log \
--retryCount 0 \
--metrics \
--nodeTypes m5.2xlarge \
--nodeStorage 100 \
--targetTime 300 \
--maxNodes 2 \
--rescueJobsFrequency 300 \
--writeLogs /var/log/toil/workers/bsmn \
workflow-entrypoint.cwl test-workflow-entrypoint.json