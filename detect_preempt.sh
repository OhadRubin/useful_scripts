detect_preempt() {
  curl "http://metadata.google.internal/computeMetadata/v1/instance/preempted?wait_for_change=true" -H "Metadata-Flavor: Google"
  /home/ohadr/.local/bin/alerts msg --message "Preempted"
#   echo "Preempted" > /tmp/preempted.txt
}

detect_preempt &

# while [ ! -f /tmp/preempted.txt ]; do
#   sleep 1
#   echo "Waiting for preemption..."
# done
# echo "Preempted"
# exit 0

# gcloud compute instances simulate-maintenance-event v4-4-node-64 --zone=us-central2-b --with-extended-notifications=True

# gcloud alpha compute tpus tpu-vm simulate-maintenance-event v4-64-node-4 --zone us-central2-b --workers=all --with-extended-notifications=True