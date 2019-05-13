#! /usr/bin/env bash

set -x

JOBSTORE=aws:us-east-1:tthyer-cwl-cluster-bsmn

toil clean $JOBSTORE

toil-cwl-runner --provisioner aws \
--jobStore $JOBSTORE \
--provisioner aws \
--batchSystem mesos \
--logLevel INFO \
--logFile /var/log/toil/bsmn.log \
--retryCount 0 \
--metrics \
--nodeTypes m5.xlarge \
--nodeStorage 100 \
--runCwlInternalJobsOnWorkers \
--targetTime 300 \
--minNodes 3 \
--maxNodes 6 \
--rescueJobsFrequency 300 \
--defaultDisk 100 \
--defaultMemory 6 \
workflow-entrypoint.cwl test-workflow-entrypoint.json