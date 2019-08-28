SELECT timestamp, jsonPayload.clientip, jsonPayload.status, jsonPayload.path, jsonPayload.method
FROM `gcp-honeypot-book.wowhoneypot.wowhoneypot_access_*` 
WHERE
  _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
  AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
ORDER BY `timestamp` DESC 
LIMIT 10