view: order_items {
  sql_table_name: PUBLIC.ORDER_ITEMS ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
    value_format_name: usd
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: MontantCommandeMoyen {
    type: average
    sql: ${sale_price} ;;
    drill_fields: [detail*]  # champs qui s'afficheront si on clique sur l'élément MontantCommandeMoyen dans le dashboard
    value_format_name: usd  # arrondir à 2 décimales
  }

  measure: NombreCommandes{
    type: count
  }

  measure: NombreMois {
    hidden: yes  # on ne peut pas l'utiliser dans les look
    type: count_distinct
    drill_fields: [detail*]
    sql: ${created_month} ;;
  }

  measure: PrixVenteTotal {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: PrixVenteMoyen {
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: DepensesMoyenneParClient {
    type: number
    value_format_name: usd
    sql: 1.0 * ${PrixVenteTotal} / NULLIF(${users.count},0) ;;
    drill_fields: [detail*]
  }

  measure: first_order {
    type: date_raw
    sql: MIN(${created_raw});;
    hidden: yes
  }
  measure: latest_order {
    type: date_raw
    sql: MAX(${created_raw});;
    hidden: yes
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      order_id,
      status,
      created_date,
      sale_price,
      products.brand,
      products.name,
      users.name,
      users.email
    ]
  }
}
