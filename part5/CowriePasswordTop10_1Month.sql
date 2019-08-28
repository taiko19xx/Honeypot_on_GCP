SELECT jsonPayload.password AS passwd, COUNT(jsonPayload.password) AS cnt
FROM `gcp-honeypot-book.cowrie.cowrie_access_*` 
WHERE
  _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
  AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
AND (jsonPayload.eventid = 'cowrie.login.success' OR jsonPayload.eventid = 'cowrie.login.failed')
GROUP BY passwd
ORDER BY cnt DESC
LIMIT 10