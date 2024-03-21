view: referrals_total_query {
  derived_table: {
    sql: SELECT r.[PracticeName],
       r.[PracticeId],
       r.[PracticeRdvmId],
       COUNT(r.[ReferralId]) AS 'Total'
FROM [Import].[Referrals] AS r
INNER JOIN [Import].[Providers] AS p ON r.[ProviderId] = p.[ProviderId]
WHERE r.[StatusTimestamp] BETWEEN {% parameter p_start_date %} AND DATEADD(second, 59, DATEADD(minute, 59, DATEADD(hour, 23, {% parameter p_end_date %}))) AND p.Providercode = {% parameter p_provider_code %}
GROUP BY r.[PracticeName], r.[PracticeId], r.[]PracticeRdvmId],
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: practice_name {
    type: string
    sql: ${TABLE}.PracticeName ;;
  }

  dimension: practice_id {
    type: number
    sql: ${TABLE}.PracticeId ;;
  }

  dimension: practice_rdvm_id {
    type: string
    sql: ${TABLE}.PracticeRdvmId ;;
  }

  dimension: total {
    type: number
    sql: ${TABLE}.Total ;;
  }

  set: detail {
    fields: [practice_name, practice_id, practice_rdvm_id, total]
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
