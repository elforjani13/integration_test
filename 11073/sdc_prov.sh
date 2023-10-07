# Define variables
ref_fac="theFacility"
ref_bed="comfyBed"
ref_poc="noPoint"
ref_ca="$(pwd)/certs"
ref_ssl_passwd="dummypass"
# ref_pro_key=

# Function to start SDC 11073 provider
start_sdc_provider() {
    if [ "$1" == "v1.x.y" ]; then
        python3 sdc11073/examples/reference_device.py &
    else
        python3 sdc11073/examples/reference_provider.py &
    fi
}

# Function to stop SDC 11073 provider
stop_sdc_provider() {
    jobs && kill %1
    pkill -f sdc11073
}

# Main script
args=("$@")

echo "arg1 is ${args[0]}"

echo "Starting SDC 11073 provider..."
start_sdc_provider "${args[0]}"

echo "Starting SDCri consumer..."
cd ri && mvn -Pconsumer-tls -Pallow-snapshots exec:java
test_exit_code=$?

echo "Terminating SDC 11073 provider..."
stop_sdc_provider

exit "$test_exit_code"