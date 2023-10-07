#!/bin/bash

# Define variables
ref_ip="your_ref_ip_here"

echo "Starting SDCRI Provider..."
(cd ri && mvn -Pprovider -Pallow-snapshots exec:java) &
provider_pid=$!

# Sleep for a while to allow the provider to start
sleep 30

echo "Starting SDC 11073 Consumer..."
(cd sdc11073 && python3 -m unittest examples.ReferenceTest.test_reference.Test_Reference.test_client_connects)
test_exit_code=$?

echo "Terminating SDCRI Provider..."
kill "$provider_pid"

exit "$test_exit_code"
