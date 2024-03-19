view: checkout_notices_sent_query {
  derived_table: {
    sql: SELECT n.ProviderId,
      p.ProviderCode,
      ISNULL(p.ProviderLocationId, n.ProviderLocationId) AS ProviderLocationId,
      n.PracticeId,
      n.ClientId,
      n.PatientId,
      n.Reason,
      n.CheckOutTimestamp,
      MAX(n.NotificationTimestamp) AS NotificationTimestamp,
      MAX(CAST(n.EmailSent AS INT)) AS EmailSent,
      MAX(CAST(n.FaxSent AS INT)) AS FaxSent
FROM Import.NotificationCheckOuts AS n
LEFT OUTER JOIN Import.ProviderLocations AS x ON x.ProviderId = n.ProviderId AND x.ProviderSecondaryLocationId = n.ProviderLocationId
LEFT OUTER JOIN Import.Providers AS p ON p.ProviderId = x.ProviderId AND p.ProviderLocationId = x.ProviderMainLocationId
WHERE n.CheckOutTimestamp BETWEEN {% parameter p_start_date %} AND DATEADD(second, 59, DATEADD(minute, 59, DATEADD(hour, 23, {% parameter p_end_date %})))
AND p.ProviderCode = {% parameter p_provider_code %}
AND n.IsDeceased = 0
GROUP BY n.ProviderId, ISNULL(p.ProviderLocationId, n.ProviderLocationId), n.PracticeId, n.ClientId, n.PatientId, n.Reason, n.CheckOutTimestamp, p.ProviderCode
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}.ProviderId ;;
  }

  dimension: provider_code {
    type: string
    sql: ${TABLE}.ProviderCode ;;
  }

  dimension: provider_location_id {
    type: number
    sql: ${TABLE}.ProviderLocationId ;;
  }

  dimension: practice_id {
    type: number
    sql: ${TABLE}.PracticeId ;;
  }

  dimension: client_id {
    type: string
    sql: ${TABLE}.ClientId ;;
  }

  dimension: patient_id {
    type: string
    sql: ${TABLE}.PatientId ;;
  }

  dimension: reason {
    type: string
    sql: ${TABLE}.Reason ;;
  }

  dimension_group: check_out_timestamp {
    type: time
    sql: ${TABLE}.CheckOutTimestamp ;;
  }

  dimension_group: notification_timestamp {
    type: time
    sql: ${TABLE}.NotificationTimestamp ;;
  }

  dimension: email_sent {
    type: number
    sql: ${TABLE}.EmailSent ;;
  }

  dimension: fax_sent {
    type: number
    sql: ${TABLE}.FaxSent ;;
  }

  set: detail {
    fields: [
      provider_id,
      provider_code,
      provider_location_id,
      practice_id,
      client_id,
      patient_id,
      reason,
      check_out_timestamp_time,
      notification_timestamp_time,
      email_sent,
      fax_sent
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
