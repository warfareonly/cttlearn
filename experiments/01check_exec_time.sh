#!/bin/sh

PARSER="python3 ../src/dot2soucha_parser/dot2soucha.py"
MODEL_DIR="../data/2021_11_ctt_automatawiki"
FSMLIB="../src/fsm_lib"
A_LOG="./stats.log"

rm -f $A_LOG
echo "FSM\tCTT\tEXTRA_STATES\tTOT_RESETS\tTOT_SYMBOLS\tEXEC_TIME" > $A_LOG 

for EXTRA_STATES in 0 1 2 3; do
    for CTT in w wp h hsi spy spyh; do
# for EXTRA_STATES in 0; do
#     for CTT in w hsi spy; do
    for SUL in  Bankcard DTLS MQTT QUICprotocol SSH TCP TLS; do 
            for F_DOT in "${MODEL_DIR}/$SUL"/*.dot; do 
                start=`date +%s.%N`
                $PARSER -f "${F_DOT}" | $FSMLIB -m $CTT -es $EXTRA_STATES > testcase.tmp
                end=`date +%s.%N`
                runtime=$( echo "$end - $start" | bc -l )
                
                # The 'testcase.tmp' file has M lines
                # There is one for each generate test case
                # By counting the number of lines, you find the total number of resets/test cases
                tot_resets=$( wc -l testcase.tmp )
                
                # The lines of the 'testcase.tmp' file follow the format: "tc_x:	0,1,2,3"
                # Then, to calculates the number of symbols, you can use the characters:
                #   ':' that separates test case IDs from its respective test sequence
                #   ',' that separates test symbols
                # By counting the characters ':,', you find the total number of symbols
                tot_symbols=$( cat testcase.tmp |tr -cd ':,'| wc -c ) 
                echo "${F_DOT}\t${CTT}\t${EXTRA_STATES}\t${tot_resets}\t${tot_symbols}\t${runtime}" >> $A_LOG 
                rm -f testcase.tmp
            done
        done
    done
done