view: deceased_notices_sent_query {
  derived_table: {
    sql: SELECT p.ProviderCode,
       n.ProviderId,
       ISNULL(p.ProviderLocationId, n.ProviderLocationId) AS ProviderLocationId,
       pr.PracticeName,
       n.PracticeRdvmId,
       n.ClientId,
       n.PatientId,
       n.ClientName,
       n.PatientName,
       n.CheckOutTimestamp,
       n.NotificationTimestamp,
       n.Email,
       n.Fax,
       n.Reason
FROM Import.NotificationCheckOuts AS n
LEFT OUTER JOIN Import.ProviderLocations AS x ON x.ProviderId = n.ProviderId AND x.ProviderSecondaryLocationId = n.ProviderLocationId
LEFT OUTER JOIN Import.Providers AS p ON p.ProviderId = x.ProviderId AND p.ProviderLocationId = x.ProviderMainLocationId
INNER JOIN Import.Practices AS pr ON pr.PracticeId = n.PracticeId AND pr.ProviderId = n.ProviderId
WHERE (n.IsDeceased = 1)
AND p.[ProviderCode] = 'newhaven'
AND n.CheckOutTimestamp BETWEEN '01/01/2021 00:00:00' AND '01/01/2023 23:59:59'
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: provider_code {
    type: string
    sql: ${TABLE}.ProviderCode ;;
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

  dimension_group: check_out_timestamp {
    type: time
    sql: ${TABLE}.CheckOutTimestamp ;;
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

  dimension: reason {
    type: string
    sql: ${TABLE}.Reason ;;
  }

  set: detail {
    fields: [
      provider_code,
      provider_id,
      provider_location_id,
      practice_name,
      practice_rdvm_id,
      client_id,
      patient_id,
      client_name,
      patient_name,
      check_out_timestamp_time,
      notification_timestamp_time,
      email,
      fax,
      reason
    ]
  }
}
