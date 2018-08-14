#!/bin/bash

if [ "x$CPULIST" != "x" ]; then
  echo '"cpu_threads_conf": [' > cpu.txt
  if [ "x$CPUPM" = "x" ]; then
    CPUPM=1
  fi
  for cpu in $(echo $CPULIST | tr -d '"' | tr -d "'"); do
    lpm='"low_power_mode"'
    np='"no_prefetch"'
    atc='"affine_to_cpu"'
    cpupm=$(echo "$cpu:" | cut -d':' -f2)
    cpu=$(echo "$cpu:" | cut -d':' -f1)
    if [ "x$cpupm" = "x" ]; then
      cpupm=$CPUPM
    fi
    echo "  { $lpm: $cpupm, $np: true, $atc: $cpu }," >> cpu.txt
  done
  echo '],' >> cpu.txt
fi

if [ "x$PORT" = "x" ]; then
  PORT=0
fi
if [ "x$VERBOSE" = "x" ]; then
  VERBOSE=4
fi
cat > pools.txt <<POOLS
"pool_list": [
    {
        "pool_address": "pool.veronite.space:5555",
        "wallet_address": "VERayXr4cJgha8Lg9VwcYrDzxMc8SJpkY8S6q9H2kEsEfkR5Xp3AHaJ4hdzDrBP6nxc9PG95chCDphr4xNpCy3rdj8v117VYTPJ",
        "rig_id": "mio",
        "pool_password": "x",
        "use_nicehash": false,
        "use_tls": false, /* Set to true if you are using an SSL port */
        "tls_fingerprint": "",
        "pool_weight": 1
    },
],
"currency": "cryptonight_heavy",

"currency": "monero7",
POOLS

cat > config.txt <<CONFIG
"call_timeout": 10,
"retry_time": 30,
"giveup_limit": 0,
"verbose_level": $VERBOSE,
"print_motd": true,
"h_print_time": 60,
"aes_override": null,
"use_slow_memory": "warn",
"tls_secure_algo": true,
"daemon_mode": false,
"flush_stdout": true,
"output_file": "",
"httpd_port": $PORT,
"http_login": "",
"http_pass": "",
"prefer_ipv4": true,
CONFIG

echo '============================== pools.txt ==============================='
cat pools.txt
echo '============================== config.txt =============================='
cat config.txt
echo '=============================== cpu.txt ================================'
cat cpu.txt
echo '========================================================================'

if [ "x$OUTFILE" = "x" ]; then
  /usr/bin/xmr-stak
else
  /usr/bin/xmr-stak > $OUTFILE 2>&1
fi
