view: portal_usage_query {
  derived_table: {
    sql: SELECT s.ProviderCode,
         l.PracticeId,
       r.PracticeName,
       r.PracticeCode,
       COUNT(l.PracticeId) AS 'LOGIN_COUNT',
       MAX(l.LoginTimestamp) AS 'LAST_LOGIN_DATE',
       ROUND(COUNT(l.PracticeId) / DATEDIFF(week, '2015/1/1', GETDATE()), 1) AS 'WEEKLY_AVG',
       DENSE_RANK() OVER (ORDER BY COUNT(l.PracticeId) DESC) AS 'RANK'
  FROM Import.Logins AS l
  INNER JOIN Import.Practices AS r ON l.PracticeId = r.PracticeId AND l.ProviderId = r.ProviderId
  INNER JOIN Import.Providers AS s ON l.ProviderId = s.ProviderId
  WHERE l.LoginTimestamp BETWEEN {% parameter p_start_date %} AND DATEADD(second, 59, DATEADD(minute, 59, DATEADD(hour, 23, {% parameter p_end_date %}))) AND s.Providercode = {% parameter p_provider_code %}
  GROUP BY s.Providercode, l.PracticeId, r.PracticeCode, r.PracticeName  ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: provider_code {
    type: string
    sql: ${TABLE}.ProviderCode ;;
  }

  dimension: practice_id {
    type: number
    sql: ${TABLE}.PracticeId ;;
  }

  dimension: practice_name {
    type: string
    sql: ${TABLE}.PracticeName ;;
  }

  dimension: practice_code {
    type: string
    sql: ${TABLE}.PracticeCode ;;
  }

  dimension: login_count {
    type: number
    sql: ${TABLE}.LOGIN_COUNT ;;
  }

  dimension_group: last_login_date {
    type: time
    sql: ${TABLE}.LAST_LOGIN_DATE ;;
  }

  dimension: weekly_avg {
    type: number
    sql: ${TABLE}.WEEKLY_AVG ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.RANK ;;
  }

  set: detail {
    fields: [
      provider_code,
      practice_id,
      practice_name,
      practice_code,
      login_count,
      last_login_date_time,
      weekly_avg,
      rank
    ]
  }

  parameter: p_start_date {
    type:  date
  }

  parameter: p_end_date {
    type:  date
  }

  parameter: p_provider_code {
    type:  string
  }
}
