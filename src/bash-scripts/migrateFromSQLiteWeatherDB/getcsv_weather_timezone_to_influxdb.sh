#!/bin/bash

# 引数の次の日を取得: next_to_date "${to_date}"
next_to_date() {
    retval=$(date -d "$1 1 days" +'%F');
    echo "$retval"
}

# influxdb用CSV出力 timestamp: timezone (UTC with GMT location) 
get_csv() {
    device_name="$1"
    where_range="$2";
cat<<-EOF | sqlite3 "$PATH_WEATHER_DB" -csv
    SELECT
      td.name,
      strftime('%Y-%m-%dT%H:%M:%SZ', measurement_time, 'unixepoch'),
      temp_out,temp_in,humid,pressure
    FROM
      t_weather tw INNER JOIN t_device td ON td.id = tw.did  
    WHERE
      td.name = '${device_name}' AND ${where_range}
    ORDER BY measurement_time;
EOF
}

# 検索日は JST 時刻とする (SQLiteデータベースは JSTのタイムスタンプで保存している)
# getcsv_weather_timezone_to_influxdb.sh esp8266_1, 2024-01-01, 2024-01-01 ~/data/influxdb/csv
# All parameter required
from_date="$2"
to_date="$3"

eclude_to_date=$(next_to_date "$to_date");
echo "eclude_to_date: ${eclude_to_date}"
cond_from="(datetime(measurement_time, 'unixepoch', 'localtime') >= '"${from_date}"')"
cond_to_next="(datetime(measurement_time, 'unixepoch', 'localtime') < '"${eclude_to_date}"')"
where_range="(${cond_from} AND ${cond_to_next})"
csv_filepath="$4/t_weather_timezone.csv"

# For influxdb headers
schema='#constant measurement,weather'
data_type='#datatype tag,dateTime:RFC3339,double,double,double,double'
header='deviceName,time,temp_out,temp_in,humid,pressure'
echo $schema > "${csv_filepath}"
echo $data_type >> "${csv_filepath}"
echo $header >> "${csv_filepath}"
get_csv "$1" "${where_range}" >> "${csv_filepath}"
if [ $? = 0 ]; then
   echo "Output t_weather csv to ${csv_filepath}"
   row_count=$(cat "${csv_filepath}" | wc -l)
   row_count=$(( row_count - 1))
   echo "Record count: ${row_count}" 
else
   echo "Output error"
fi

