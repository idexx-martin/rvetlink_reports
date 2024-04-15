view: checkout_notices_sent_query {
  derived_table: {
    sql: SELECT n.ProviderId,
      p.ProviderCode,
      p.ProviderName,
      ISNULL(p.ProviderLocationId, n.ProviderLocationId) AS ProviderLocationId,
      n.PracticeId,
      n.PracticeRdvmId,
      p2.PracticeName,
      n.ClientId,
      n.ClientName,
      n.PatientId,
      n.PatientName,
      n.Reason,
      n.CheckOutTimestamp,
      MAX(n.NotificationTimestamp) AS NotificationTimestamp,
      MAX(CAST(n.EmailSent AS INT)) AS EmailSent,
      MAX(CAST(n.FaxSent AS INT)) AS FaxSent
FROM Import.NotificationCheckOuts AS n
LEFT OUTER JOIN Import.ProviderLocations AS x ON x.ProviderId = n.ProviderId AND x.ProviderSecondaryLocationId = n.ProviderLocationId
LEFT OUTER JOIN Import.Providers AS p ON p.ProviderId = x.ProviderId AND p.ProviderLocationId = x.ProviderMainLocationId
LEFT OUTER JOIN Import.Practices AS p2 ON p2.ProviderId = x.ProviderId AND p2.PracticeId = n.PracticeId
LEFT OUTER JOIN Import.Providers AS sdvm ON sdvm.ProviderId = p.ProviderId
WHERE n.CheckOutTimestamp BETWEEN {% parameter p_start_date %} AND DATEADD(second, 59, DATEADD(minute, 59, DATEADD(hour, 23, {% parameter p_end_date %})))
AND sdvm.ProviderCode = {% parameter p_provider_code %}
AND n.IsDeceased = 0
GROUP BY n.ProviderId, ISNULL(p.ProviderLocationId, n.ProviderLocationId), n.PracticeId, n.ClientId, n.ClientName, n.PatientId, n.PatientName, n.Reason, n.CheckOutTimestamp, p.ProviderCode, p.ProviderName, p2.PracticeName, n.PracticeRdvmId
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

  dimension: practice_rdvm_id {
    type: number
    sql: ${TABLE}.PracticeRdvmId ;;
  }

  dimension: provider_code {
    type: string
    sql: ${TABLE}.ProviderCode ;;
  }

  dimension: provider_name {
    type: string
    sql: ${TABLE}.ProviderName ;;
  }

  dimension: provider_location_id {
    type: number
    sql: ${TABLE}.ProviderLocationId ;;
  }

  dimension: practice_id {
    type: number
    sql: ${TABLE}.PracticeId ;;
  }

  dimension: practice_name {
    type: string
    sql: ${TABLE}.PracticeName ;;
  }

  dimension: client_id {
    type: string
    sql: ${TABLE}.ClientId ;;
  }

  dimension: client_name {
    type: string
    sql: ${TABLE}.ClientName ;;
  }

  dimension: patient_id {
    type: string
    sql: ${TABLE}.PatientId ;;
  }

  dimension: patient_name {
    type: string
    sql: ${TABLE}.PatientName ;;
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
      provider_name,
      provider_location_id,
      practice_id,
      practice_name,
      practice_rdvm_id,
      client_id,
      client_name,
      patient_id,
      patient_name,
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
