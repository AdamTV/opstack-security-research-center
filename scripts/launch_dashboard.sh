/home/kali/.config/.foundry/bin#!/bin/bash
set -e

echo "[*] Ensuring OP Stack devnet services are running..."

# Check and start docker-compose or kurtosis
if [ -f "$HOME/opstack-lab/op-getting-started/docker-compose.yml" ]; then
  cd "$HOME/opstack-lab/op-getting-started"
  docker compose up -d
elif [ -d "$HOME/.kurtosis" ]; then
  echo "[*] Using Kurtosis to verify devnet..."
  kurtosis engine restart || true
  kurtosis service ls || true
fi

echo "[*] Waiting for dashboards (BlockScout, Grafana)..."
until curl -s http://localhost:4000 >/dev/null; do
  printf '.'
  sleep 2
done

until curl -s http://localhost:3000 >/dev/null; do
  printf '.'
  sleep 2
done

echo
echo "[+] Dashboards reachable. Launching Flask UI..."

cd "$HOME/opstack-lab"
python3 app.py
