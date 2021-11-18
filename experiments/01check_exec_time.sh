#!/bin/sh

PARSER="python3 ../src/dot2soucha_parser/dot2soucha.py"
MODEL_DIR="../data/2021_11_ctt_automatawiki"
FSMLIB="../src/fsm_lib"

for EXTRA_STATES in 0 1 2 3; do
    for CTT in soucha_w soucha_wp soucha_h soucha_hsi soucha_spy soucha_spyh; do
# for EXTRA_STATES in 0; do
#     for CTT in soucha_w soucha_hsi soucha_spy; do
        A_LOG="stats_${CTT}_es${EXTRA_STATES}.log"
        rm -f $A_LOG
        for SUL in  Bankcard DTLS MQTT QUICprotocol SSH TCP TLS; do 
            for F_DOT in "${MODEL_DIR}/$SUL"/*.dot; do 
                echo "fsm_model:\t${F_DOT}" >> $A_LOG
                $PARSER -f "${F_DOT}" | $FSMLIB -m $CTT -es $EXTRA_STATES 2>> $A_LOG > /dev/null
            done
        done
    done
done