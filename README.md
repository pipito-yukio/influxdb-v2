# influxdb-v2

Scripts for Influxdb v2

## 1. Shell scripts

### 1-1. Migration SQLite3 WeatherDatabase

下記 Qiita 投稿記事で紹介したシェルスクリプト(No1)  
[InfluxDB v2 (OSS版) SQLite3データベースのマイグレーション](https://qiita.com/pipito-yukio/items/3f9b0e58969ef588082f)

```
bash-scripts/migrateFromSQLiteWeatherDB/
├── getcsv_weather_timezone_to_influxdb.sh
├── getcsv_weather_to_postgres.sh
└── getcsv_weather_unixtime_to_influxdb.sh
```

## 2. Docker resources

### 2-1. Telegraf を含まないシンプル版

Qiita 投稿記事 (No1) で使用したリソースファイル

```
docker/
└── simple
    ├── .env
    ├── docker-compose.yml
    └── influxv2.env
```


## 3. Pyton scripts
