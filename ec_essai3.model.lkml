connection: "snowlooker"
label: "EC essai snowlooker"  # nom du projet qui sera afficher

# include all the views
include: "*.view"

datagroup: ec_essai3_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM order_items;;  # Cette requête renvoie un nouveau nombre dès qu'il y a des nouvelles données, ce qui déclanche le renouvellement des données du cache
  max_cache_age: "1 hour"  # les données du caches sont renouvellées toutes les "max_cache_age" heures maximum (si pas déclanchées par le sql_triger)
}

persist_with: ec_essai3_default_datagroup

#explore: distribution_centers {}

#explore: etl_jobs {}


#explore: inventory_items {
 # join: products {
  #  type: left_outer
   # sql_on: ${inventory_items.product_id} = ${products.id} ;;
    #relationship: many_to_one
  #}

  #join: distribution_centers {
   # type: left_outer
    #sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    #relationship: many_to_one
  #}
#}

explore: essaiexcel {
  label: "Excel Commandes"
}

explore: order_items {
  label: "Commandes et utilisateurs"  # affiché dans le menu "Explore"

  # "Views" inclues dans le explore :

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: events {
    type: left_outer
    sql_on: ${users.id}=${events.user_id} ;;
    relationship: many_to_one
  }
}

explore: events {
  label: "Evenements web"

  join: sessions {
    sql_on: ${events.session_id} =  ${sessions.session_id} ;;
    relationship: many_to_one
  }

  join: session_landing_page {
    from: events      # nom de la vue si le join n'est pas déjà le nom d'une vue
    sql_on: ${sessions.landing_event_id} = ${session_landing_page.id} ;;
    fields: [id,created_date, event_type, full_page_url, user_id]
    relationship: one_to_one
  }

  join: session_bounce_page {
    from: events
    sql_on: ${sessions.bounce_event_id} = ${session_bounce_page.id} ;;
    fields: [id,created_date, event_type, full_page_url, user_id]
    relationship: many_to_one
  }

  join: product_viewed {
    from: products
    sql_on: ${events.viewed_product_id} = ${product_viewed.id} ;;
    relationship: many_to_one
  }

  join: users {
    sql_on: ${sessions.session_user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_order_facts {
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
    view_label: "Users"
  }
}

#explore: products {
 # join: distribution_centers {
  #  type: left_outer
   # sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    #relationship: many_to_one
  #}
#}

# explore: users {}

explore: affinity {
  label: "Analyse des affinitées"

  always_filter: {  # filtre obligatoire pour créer un lookup avec cette vue, le filtre ce créé automatiquement dès qu'on utilise ce explore
    filters: {
      field: affinity.product_b_id  # champ sur lequel il faut un filtre
      value: "-NULL"
    }
  }

  join: product_a {
    from: products  # Nom dela vue
    view_label: "Product A Details"
    relationship: many_to_one
    sql_on: ${affinity.product_a_id} = ${product_a.id} ;;
  }

  join: product_b {
    from: products
    view_label: "Product B Details"
    relationship: many_to_one
    sql_on: ${affinity.product_b_id} = ${product_b.id} ;;
  }
}
