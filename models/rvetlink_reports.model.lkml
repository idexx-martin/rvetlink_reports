connection: "rvetlink_data_warehouse"

# include all the views
include: "/views/**/*.view"

datagroup: rvetlink_reports_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 minute"
}

persist_with: rvetlink_reports_default_datagroup

explore: portal_usage_query {

}
