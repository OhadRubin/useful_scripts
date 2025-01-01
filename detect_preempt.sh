detect_preempt() {
  curl "http://metadata.google.internal/computeMetadata/v1/instance/preempted?wait_for_change=true" -H "Metadata-Flavor: Google"
  echo "Preempted" > /tmp/preempted.txt
}

detect_preempt &

while [ ! -f /tmp/preempted.txt ]; do
  sleep 1
  echo "Waiting for preemption..."
done
echo "Preempted"
exit 0