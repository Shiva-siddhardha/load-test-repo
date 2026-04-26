# ⚡ Distributed Load Testing with JMeter + GitHub Actions

Run distributed load tests for free using GitHub Actions — no cloud account needed.

## How It Works

- GitHub Actions spins up a free Ubuntu runner
- JMeter master + N worker containers run on that runner via Docker
- Results are stored permanently per-run on GitHub Pages
- Browse all historical runs from a single dashboard URL

## Architecture
GitHub Actions Runner (free, 2CPU 7GB RAM)
├── jmeter-master      ← coordinates the test
├── jmeter-worker-1    ← sends HTTP requests
├── jmeter-worker-2    ← sends HTTP requests
└── jmeter-worker-3    ← sends HTTP requests
│
▼
Target API
│
▼
GitHub Pages Dashboard
(one URL, all runs listed)

## Running a Test

1. Go to **Actions → Distributed Load Test → Run workflow**
2. Fill in:
   - **threads** — virtual users per worker
   - **duration** — test duration in seconds
   - **rampup** — seconds to reach full load
   - **workers** — number of JMeter worker containers (1–3)
3. Click **Run workflow**
4. Watch live logs — summary prints every 30 seconds
5. View results at your GitHub Pages URL when done

## Customizing the Test

Edit `test-scripts/my-api-test/LoadTest.jmx` to change:
- Target URL / endpoints
- HTTP method (GET, POST, etc.)
- Request headers or body
- Multiple endpoints (add more HTTP Samplers)

The JMX file is your test plan — all URL configuration lives there.

## Viewing Results

All runs are stored at:
https://YOUR_USERNAME.github.io/YOUR_REPO/

The index page lists every run with threads/duration/workers. Click **View Report** to open the full JMeter HTML dashboard for that run.

## File Structure
├── .github/workflows/load-test.yml   ← workflow (trigger + params)
├── docker/
│   ├── Dockerfile.master
│   ├── Dockerfile.worker
│   ├── entrypoint-master.sh          ← controls jmeter command
│   └── entrypoint-worker.sh
├── docker-compose.yml
└── test-scripts/my-api-test/
├── LoadTest.jmx                  ← EDIT THIS for your target
└── data/ids.csv

## Cost

$0. GitHub Actions free tier + GitHub Pages = fully free.