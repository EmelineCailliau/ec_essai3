view: users {
  sql_table_name: PUBLIC.USERS ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
    group_label: "Lieu"
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: CASE WHEN ${TABLE}.country = 'UK' THEN 'United Kingdom'
    ELSE ${TABLE}."COUNTRY"
    END
    ;;
    group_label: "Lieu"
  }

  dimension: majeur {
    # hidden: yes     # les utilisateurs ne verront pas ce champ
    type: yesno     # boolean (il y a aussi « number »,  « time » …)
    sql: ${age} >= 18 ;;       # condition pour que boolean=yes
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
    link: {
      label: "Infos Utilisateur"
      url: "/dashboards/19?Email={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
    group_label: "Nom"
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."GENDER" ;;
  }

  dimension: genre {
    sql: CASE
          WHEN ${gender}='Male' THEN 'Homme'
          WHEN ${gender}='Female' THEN 'Femme'
          ELSE 'Inconnu'
        END ;;
    # ajouter couleurs de font selon le genre (l'utilisation du paramètre html ne permet pas de garder le zoom sur les données avce les drill-fields)
    html:
      {% if value == 'Homme' %}
      <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% else %}
      <p style="color: black; background-color: pink; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
    group_label: "Nom"
  }

  # Concaténation du prénom et du nom
  dimension: name {
    sql: ${first_name} || ' ' || ${last_name} ;;
    group_label: "Nom"
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
    group_label: "Lieu"
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
    group_label: "Lieu"
  }

  dimension: location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
    group_label: "Lieu"
  }

  dimension: approx_location {
    type: location
    drill_fields: [location]
    sql_latitude: round(${TABLE}.latitude,1) ;;
    sql_longitude: round(${TABLE}.longitude,1) ;;
    group_label: "Lieu"
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}."STATE" ;;
    group_label: "Lieu"
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
  }

  dimension: zip {
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}."ZIP" ;;
    group_label: "Lieu"
  }

  dimension: history {  # affiche un lien menant vers un tableau contenant la liste des détails la vue order_item pour ce client
    sql: ${TABLE}.id ;;
    html: <a href="/explore/ec_essai3/order_items?fields=order_items.detail*&f[users.id]={{ value }}"> Order History </a> ;; # value correspond à l'id
    view_label: "Users Hisory"
  }

  measure: count {
    type: count
    drill_fields: [id, name, email, age, created_date, orders.count, order_items.count]
  }
}
