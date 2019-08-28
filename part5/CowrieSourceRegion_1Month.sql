WITH source_of_ip_addresses AS (
  SELECT jsonPayload.src_ip AS ip, COUNT(*) as cnt
  FROM `gcp-honeypot-book.cowrie.cowrie_access_*` 
  WHERE
    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
    AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
  AND jsonPayload.eventid = 'cowrie.session.connect'
  AND jsonPayload.src_ip IS NOT null  
  GROUP BY ip
)

SELECT country_iso_code, SUM(cnt) cnt
FROM (
  SELECT ip, country_iso_code, cnt
  FROM (
    SELECT *, NET.SAFE_IP_FROM_STRING(ip) & NET.IP_NET_MASK(4, mask) network_bin
    FROM source_of_ip_addresses, UNNEST(GENERATE_ARRAY(9,32)) mask
    WHERE BYTE_LENGTH(NET.SAFE_IP_FROM_STRING(ip)) = 4
  )
  JOIN (
    SELECT locations.country_iso_code
    , NET.IP_FROM_STRING(REGEXP_EXTRACT(network, r'(.*)/' )) network_bin
    , CAST(REGEXP_EXTRACT(network, r'/(.*)' ) AS INT64) mask
    FROM `bigquery-public-data.geolite2.ipv4_city_blocks` as blocks
    JOIN `bigquery-public-data.geolite2.ipv4_city_locations` as locations
    USING(geoname_id)
  )
  USING (network_bin, mask)
)
GROUP BY 1
ORDER BY 2 DESC