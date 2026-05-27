# Web page with WS

Show in page:
- clock host local
- NTP sync clock


Running: 
```

docker compose up -d --build 

``

Open in `http://localhost`.


For tests block the internet access. `iptables`:
```
# apply block
iptables -I FORWARD -s <IP_CONTAINER> -j DROP

# to revert
iptables -D FORWARD -s <IP_CONTAINER> -j DROP
```
