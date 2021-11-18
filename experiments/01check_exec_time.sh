#!/bin/sh

PARSER="python3 ../src/dot2soucha_parser/dot2soucha.py"
MODEL_DIR="../data/2021_11_ctt_automatawiki"
FSMLIB="../src/fsm_lib"
A_LOG="./stats.log"

rm -f $A_LOG
echo "FSM\tCTT\tEXTRA_STATES\tEXEC_TIME" > $A_LOG 

for EXTRA_STATES in 0 1 2 3; do
    for CTT in w wp h hsi spy spyh; do
# for EXTRA_STATES in 0; do
#     for CTT in w hsi spy; do
    for SUL in  Bankcard DTLS MQTT QUICprotocol SSH TCP TLS; do 
            for F_DOT in "${MODEL_DIR}/$SUL"/*.dot; do 
                start=`date +%s.%N`
                $PARSER -f "${F_DOT}" | $FSMLIB -m $CTT -es $EXTRA_STATES > /dev/null
                end=`date +%s.%N`
                runtime=$( echo "$end - $start" | bc -l )
                echo "${F_DOT}\t${CTT}\t${EXTRA_STATES}\t${runtime}" >> $A_LOG 
            done
        done
    done
done