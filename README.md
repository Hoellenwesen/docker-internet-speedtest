# Internet Speedtest with Docker and InfluxDB

Check your internet bandwidth using the [Speedtest CLI](https://www.speedtest.net/apps/cli) from a Docker container. You can configure the tool to run periodically and save the results to an InfluxDB for visualization or long-term records.

```bash
docker run --rm ghcr.io/hoellenwesen/docker-internet-speedtest:latest
```

The result will then look like this:

```bash
Running a Speed Test...
Your download speed is 334 Mbps (29284399 Bytes/s).
Your upload speed is 42 Mbps (4012944 Bytes/s).
Your ping is 6.223 ms.
```

## Configuration

| Environment variable | Default value           | Description                       |
| -------------------- | ----------------------- | --------------------------------- |
| `LOOP`               | `false`                 | Run Speedtest in a loop           |
| `LOOP_DELAY`         | `60`                    | Delay in seconds between the runs |
| `DB_SAVE`            | `false`                 | Save values to InfluxDB           |
| `DB_HOST`            | `http://localhost:8086` | InfluxDB Hostname                 |
| `DB_NAME`            | `speedtest`             | InfluxDB Database name            |
| `DB_USERNAME`        | `admin`                 | InfluxDB Username                 |
| `DB_PASSWORD`        | `password`              | InfluxDB Password                 |

## Docker Compose Example

```yaml
version: "3"
services:
  influxdb:
    image: influxdb:1.8-alpine
    volumes:
      - influxdb:/var/lib/influxdb
    ports:
      - 8083:8083
      - 8086:8086
    environment:
      - INFLUXDB_ADMIN_USER="admin"
      - INFLUXDB_ADMIN_PASSWORD="password"
      - INFLUXDB_DB="speedtest"

  speedtest:
    image: ghcr.io/hoellenwesen/docker-internet-speedtest:latest
    environment:
      - LOOP=true
      - LOOP_DELAY=1800
      - DB_SAVE=true
      - DB_HOST=http://influxdb:8086
      - DB_NAME=speedtest
      - DB_USERNAME=admin
      - DB_PASSWORD=password
    privileged: true # Needed for 'sleep' in the loop
    depends_on:
      - influxdb

volumes:
  influxdb:
```
