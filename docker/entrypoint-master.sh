#!/bin/bash
set -e

THREADS=${THREADS:-10}
DURATION=${DURATION:-60}
RAMPUP=${RAMPUP:-10}
TARGET_URL=${TARGET_URL:-https://jsonplaceholder.typicode.com/posts}
WORKERS=${WORKERS:-3}

WORKER_LIST=""
for i in $(seq 1 $WORKERS); do
  if [ -z "$WORKER_LIST" ]; then
    WORKER_LIST="jmeter-worker-$i"
  else
    WORKER_LIST="$WORKER_LIST,jmeter-worker-$i"
  fi
done

echo "================================================"
echo "  JMeter Distributed Load Test"
echo "  Target:   $TARGET_URL"
echo "  Threads:  $THREADS"
echo "  Duration: $DURATION seconds"
echo "  Ramp-up:  $RAMPUP seconds"
echo "  Workers:  $WORKER_LIST"
echo "================================================"

echo "Waiting for workers to come online..."
for worker in $(echo $WORKER_LIST | tr ',' ' '); do
  echo "  Checking $worker:1099..."
  for i in $(seq 1 30); do
    if nc -z $worker 1099 2>/dev/null; then
      echo "  ✅ $worker is ready"
      break
    fi
    if [ $i -eq 30 ]; then
      echo "  ❌ $worker not ready after 30 attempts — aborting"
      exit 1
    fi
    sleep 2
  done
done

echo ""
echo "All workers ready. Starting test..."
echo ""

rm -rf /results/results.jtl /results/html-report

JVM_ARGS="-Xms1g -Xmx1g"
export JVM_ARGS

jmeter -n \
  -t /test-scripts/LoadTest.jmx \
  -R $WORKER_LIST \
  -l /results/results.jtl \
  -e -o /results/html-report \
  -Jthreads=$THREADS \
  -Jduration=$DURATION \
  -Jrampup=$RAMPUP \
  -Jtarget_url=$TARGET_URL \
  -Dsummariser.interval=30 \
  -Dserver.rmi.ssl.disable=true

echo ""
echo "================================================"
echo "  Test complete! Results in /results/"
echo "================================================"