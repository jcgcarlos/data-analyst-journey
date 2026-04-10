view: transactions  {

dimension: transaction_id {
    primary_key: yes
    sql: ${TABLE}.transaction_id ;;
}

dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
    value_format: "₱#,##0.00"
}

dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
}

dimension_group: created_at {
    type: time
    timeframes: [date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
}

dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    allowed_values: {
        value: "success"
        label: "Success"
    }
    allowed_values: {
        value: "failed"
        label: "Failed"
    }
    allowed_values: {
        value: "pending"
        label: "Pending"
    }
}

measure: total_transaction_amount {
    type: sum
    sql: ${TABLE}.amount ;;
    value_format: "₱#,##0.00"
}

measure: count_failed_transaction {
    type: count
    sql: ${TABLE}.status ;;
    filters: [status: "failed"]
}

}