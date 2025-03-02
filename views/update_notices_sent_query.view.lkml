view: update_notices_sent_query {
  derived_table: {
    sql: SELECT p.ProviderName,
       n.ProviderId,
       ISNULL(p.ProviderLocationId, n.ProviderLocationId) AS ProviderLocationId,
       pr.PracticeName,
       n.PracticeRdvmId,
       n.ClientId,
       n.PatientId,
       n.ClientName,
       n.PatientName,
       n.UpdateTimestamp,
       n.NotificationTimestamp,
       n.Email,
       n.Fax,
       n.Files
FROM Import.NotificationUpdates AS n
LEFT OUTER JOIN Import.ProviderLocations AS x ON x.ProviderId = n.ProviderId AND x.ProviderSecondaryLocationId = n.ProviderLocationId
LEFT OUTER JOIN Import.Providers AS p ON p.ProviderId = x.ProviderId AND p.ProviderLocationId = x.ProviderMainLocationId
INNER JOIN Import.Practices AS pr ON pr.PracticeId = n.PracticeId AND pr.ProviderId = n.ProviderId
WHERE n.NotificationTimestamp BETWEEN {% parameter p_start_date %} AND DATEADD(second, 59, DATEADD(minute, 59, DATEADD(hour, 23, {% parameter p_end_date %})))
AND p.ProviderCode = {% parameter p_provider_code %}
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: provider_name {
    type: string
    sql: ${TABLE}.ProviderName ;;
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}.ProviderId ;;
  }

  dimension: provider_location_id {
    type: number
    sql: ${TABLE}.ProviderLocationId ;;
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

  dimension: patient_id {
    type: string
    sql: ${TABLE}.PatientId ;;
  }

  dimension: client_name {
    type: string
    sql: ${TABLE}.ClientName ;;
  }

  dimension: patient_name {
    type: string
    sql: ${TABLE}.PatientName ;;
  }

  dimension_group: update_timestamp {
    type: time
    sql: ${TABLE}.UpdateTimestamp ;;
  }

  dimension_group: notification_timestamp {
    type: time
    sql: ${TABLE}.NotificationTimestamp ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.Email ;;
  }

  dimension: fax {
    type: string
    sql: ${TABLE}.Fax ;;
  }

  dimension: files {
    type: string
    sql: ${TABLE}.Files ;;
  }

  set: detail {
    fields: [
      provider_name,
      provider_id,
      provider_location_id,
      practice_name,
      practice_rdvm_id,
      client_id,
      patient_id,
      client_name,
      patient_name,
      update_timestamp_time,
      notification_timestamp_time,
      email,
      fax,
      files
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
