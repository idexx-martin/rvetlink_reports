view: referral_detail_query {
  derived_table: {
    sql: SELECT r.[StatusTimestamp],
       r.[ProviderId],
       r.[ProviderLocationId],
       r.[ProviderName],
       r.[PracticeRdvmId],
       r.[ReferredBy],
       r.[SubmittedBy],
       r.[PracticeName],
       r.[RequestedDoctor],
       r.[PrimaryContact],
       r.[LastName],
       r.[PatientName],
       r.[Specialty],
       r.[ReferralId],
       r.[Version],
       rf.[FileUrl]
FROM [Import].[Referrals] AS r
INNER JOIN [Import].[ReferralFiles] AS rf ON rf.[ReferralId] = r.[ReferralId] AND rf.[ReferralFileId] = 0
INNER JOIN [Import].[Providers] AS p ON p.[ProviderId] = r.[ProviderId]
WHERE r.[StatusTimestamp] BETWEEN {% parameter p_start_date %} AND DATEADD(second, 59, DATEADD(minute, 59, DATEADD(hour, 23, {% parameter p_end_date %})))
AND p.Providercode = {% parameter p_provider_code %}
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: status_timestamp {
    type: time
    sql: ${TABLE}.StatusTimestamp ;;
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}.ProviderId ;;
  }

  dimension: provider_location_id {
    type: number
    sql: ${TABLE}.ProviderLocationId ;;
  }

  dimension: provider_name {
    type: string
    sql: ${TABLE}.ProviderName ;;
  }

  dimension: practice_rdvm_id {
    type: string
    sql: ${TABLE}.PracticeRdvmId ;;
  }

  dimension: referred_by {
    type: string
    sql: ${TABLE}.ReferredBy ;;
  }

  dimension: submitted_by {
    type: string
    sql: ${TABLE}.SubmittedBy ;;
  }

  dimension: practice_name {
    type: string
    sql: ${TABLE}.PracticeName ;;
  }

  dimension: requested_doctor {
    type: string
    sql: ${TABLE}.RequestedDoctor ;;
  }

  dimension: primary_contact {
    type: string
    sql: ${TABLE}.PrimaryContact ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.LastName ;;
  }

  dimension: patient_name {
    type: string
    sql: ${TABLE}.PatientName ;;
  }

  dimension: specialty {
    type: string
    sql: ${TABLE}.Specialty ;;
  }

  dimension: referral_id {
    type: number
    sql: ${TABLE}.ReferralId ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.Version ;;
  }

  dimension: file_url {
    type: string
    sql: ${TABLE}.FileUrl ;;
    link: {
      label: "View"
      url: "({{ file_url }}"
    }
  }

  set: detail {
    fields: [
      status_timestamp_time,
      provider_id,
      provider_location_id,
      provider_name,
      practice_rdvm_id,
      referred_by,
      submitted_by,
      practice_name,
      requested_doctor,
      primary_contact,
      last_name,
      patient_name,
      specialty,
      referral_id,
      version,
      file_url
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
