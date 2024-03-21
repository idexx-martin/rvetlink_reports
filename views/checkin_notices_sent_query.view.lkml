view: checkin_notices_sent_query {
  derived_table: {
    sql: SELECT n.ProviderId,
      p.ProviderCode,
      p.ProviderName,
      ISNULL(p.ProviderLocationId,
      n.ProviderLocationId) AS ProviderLocationId,
      n.PracticeId,
      p2.PracticeName,
      n.PracticeRdvmId,
      n.ClientId,
      n.ClientName,
      n.PatientId,
      n.PatientName,
      n.Reason,
      n.CheckInTimestamp,
      MAX(n.NotificationTimestamp) AS NotificationTimestamp,
      MAX(CAST(n.EmailSent AS INT)) AS EmailSent,
      MAX(CAST(n.FaxSent AS INT)) AS FaxSent
      FROM Import.NotificationCheckIns AS n
      LEFT OUTER JOIN Import.ProviderLocations AS x ON x.ProviderId = n.ProviderId AND x.ProviderSecondaryLocationId = n.ProviderLocationId
      LEFT OUTER JOIN Import.Providers AS p ON p.ProviderId = x.ProviderId AND p.ProviderLocationId = x.ProviderMainLocationId
      LEFT OUTER JOIN Import.Practices AS p2 ON p2.ProviderId = x.ProviderId AND p2.PracticeId = n.PracticeId
      WHERE n.CheckInTimestamp BETWEEN {% parameter p_start_date %} AND DATEADD(second, 59, DATEADD(minute, 59, DATEADD(hour, 23, {% parameter p_end_date %})))
      AND p.ProviderCode = {% parameter p_provider_code %}
      GROUP BY n.ProviderId, ISNULL(p.ProviderLocationId, n.ProviderLocationId), n.PracticeId, n.ClientId, n.ClientName, n.PatientId, n.PatientName, n.Reason, n.CheckInTimestamp, p.ProviderCode, n.PracticeRdvmId, p2.PracticeName, p.ProviderName
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

  dimension: practice_rdvm_id {
    type: string
    sql: ${TABLE}.PracticeRdvmId ;;
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

  dimension_group: check_in_timestamp {
    type: time
    sql: ${TABLE}.CheckInTimestamp ;;
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
      provider_name,
      provider_code,
      provider_location_id,
      practice_id,
      practice_name,
      practice_rdvm_id,
      client_id,
      client_name,
      patient_id,
      patient_name,
      reason,
      check_in_timestamp_time,
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
