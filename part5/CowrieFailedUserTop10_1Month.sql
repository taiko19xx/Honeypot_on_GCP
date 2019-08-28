SELECT jsonPayload.username AS user, COUNT(jsonPayload.password) AS cnt
FROM `gcp-honeypot-book.cowrie.cowrie_access_*` 
WHERE
  _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
  AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
AND jsonPayload.eventid = 'cowrie.login.failed'
GROUP BY user
ORDER BY cnt DESC
LIMIT 10