#!/bin/sh

CTT_LEARNING="java -jar ../src/benchmark.jar -cache -cexh RivestSchapire -clos CloseFirst -learn lstar"
MODEL_DIR="../data/automata_wiki/benchmarks"
MAX_PROCS=7
TIMEOUT=30m

# for EXTRA_STATES in 0 1 2; do
#     for CTT in soucha_w soucha_wp soucha_h soucha_hsi soucha_spy soucha_spyh; do
for EXTRA_STATES in 0 1; do
    for CTT in soucha_w soucha_wp soucha_hsi soucha_spy; do
        for SUL in  Bankcard DTLS MQTT QUICprotocol SSH TCP TLS; do
            for F_DOT in "${MODEL_DIR}/${SUL}/"*.dot; do 
                echo $CTT_LEARNING -eq $CTT -es $EXTRA_STATES -sul "$F_DOT"
            done
        done
    done
done | xargs -I CMD --max-procs=$MAX_PROCS timeout $TIMEOUT bash -c "CMD"
