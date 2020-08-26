#!/bin/bash
#
# Reads maillog and sends metrics to Prometheus
#

set -e

[[ -z "${PROMETHEUS_URL}" ]] && PROMETHEUS_URL="http://127.0.0.1:5090/write"
[[ -z "${PIPE}" ]] && PIPE="/tmp/.postfix_bexporter"

VERSION='dev'

export PIPE

trap 'rm -f "${PIPE}"' EXIT

if [[ ! -p "${PIPE}" ]]; then
    mkfifo "${PIPE}"
fi

export INCOMING_CONNECTIONS=0
export SASL_AUTH_FAILS=0
export DELIVERED_INCOMINGS=0

read_pipe() {

    exec 5<>"${PIPE}"

    while true; do

        last_input=""
        last_input_timestamp=0

        while read -t 0.1 line <&5; do

            last_input=( ${line} )

        done
            echo ""
            echo "Picked up from the pipe: ${last_input[*]}"

            if [[ "${#last_input[@]}" -eq 5 ]]; then

                input_idx="${last_input[0]}"
                input_incoming_connections="${last_input[1]}"
                input_sasl_auth_fails="${last_input[2]}"
                input_delivered_incomings="${last_input[3]}"
                input_timestamp="${last_input[4]}"
                

                echo "Pushing metrics"

                cat <<EOF | curl -s --data-binary @- "${PROMETHEUS_URL}" &
monitoring_postfix,instance="${HOSTNAME}" incoming_connections=${input_incoming_connections##*=}
monitoring_postfix,instance="${HOSTNAME}" sasl_auth_fails=${input_sasl_auth_fails##*=}
monitoring_postfix,instance="${HOSTNAME}" delivered_incomings=${input_delivered_incomings##*=}
EOF

            else
                echo "Data format is wrong. Expecting a 5-elements array." >&2
            fi

        sleep 60

    done
}

generate_metrics() {

    idx=0

    tail -f /var/log/maillog | while read line; do

        exec 5<>"${PIPE}"
        hit=0

        if [[ "${line}" =~ (.*postfix\/smtpd.*connect from.*) ]]; then
            INCOMING_CONNECTIONS=$(( INCOMING_CONNECTIONS + 1 ))
            hit=1

        elif [[ "${line}" =~ (.*SASL LOGIN authentication failed.*) ]]; then
            SASL_AUTH_FAILS=$(( SASL_AUTH_FAILS + 1 ))
            hit=1

        elif [[ "${line}" =~ (.*lost connection after AUTH from.*) ]]; then
            SASL_AUTH_FAILS=$(( SASL_AUTH_FAILS + 1 ))
            hit=1

        elif [[ "${line}" =~ (.*delivered to maildir.*) ]]; then
            DELIVERED_INCOMINGS=$(( DELIVERED_INCOMINGS + 1 ))
            hit=1
        fi

	if [[ "${hit}" == "1" ]]; then
            idx=$(( idx + 1 ))
            echo -ne "\rHIT: ${idx} INCOMING_CONNECTIONS=${INCOMING_CONNECTIONS} SASL_AUTH_FAILS=${SASL_AUTH_FAILS} DELIVERED_INCOMINGS=${DELIVERED_INCOMINGS}"
            echo "${idx} INCOMING_CONNECTIONS=${INCOMING_CONNECTIONS} SASL_AUTH_FAILS=${SASL_AUTH_FAILS} DELIVERED_INCOMINGS=${DELIVERED_INCOMINGS} $(date +%s)" >&5
        fi

    done
}

read_pipe &
generate_metrics
wait
