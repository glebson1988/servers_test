# README

## Tiny ping

### Description

By using this app you can add new IP's. When a new IP is added, it will automatically ping.
At the same time, just after ping statistic will be save to DB:
- average_rtt
- minimum_rtt
- maximum_rtt
- median_rtt
- standard_deviation
- percentage_lost

After that there is an opportunity to get IP statistic for some period.

**Clone repo and run:**
```
bundle
rake db:create
rake db:migrate
shotgun --server=puma --port=3000 config.ru
```

**Query examples:**

1. List of IP's:<br>
`curl "http://localhost:3000/nodes" `<br>
2. Add new IP and ping it :<br>
`curl -X POST "http://localhost:3000/nodes?ip_address=8.8.8.8" `<br>
3. Delete IP:<br>
`curl -X DELETE "http://localhost:3000/nodes?ip_address=8.8.8.8" `<br>
4.  IP-statistic:<br>
`curl "http://localhost:3000/statistics?ip_address=8.8.8.8&start_time=2023-01-01%2012:00:00&end_time=2023-01-31%2012:00:00" `<br>
