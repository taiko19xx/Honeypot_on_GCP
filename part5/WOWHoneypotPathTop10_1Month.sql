SELECT jsonPayload.path AS path, COUNT(jsonPayload.path) AS cnt
FROM `gcp-honeypot-book.wowhoneypot.wowhoneypot_access_*` 
WHERE
  _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
  AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
GROUP BY path
ORDER BY cnt DESC
LIMIT 10