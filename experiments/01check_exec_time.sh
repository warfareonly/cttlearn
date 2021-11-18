#!/bin/sh

PARSER="python3 ../src/dot2soucha_parser/dot2soucha.py"
FSMLIB="../src/fsm_lib"
MODEL_DIR="../data/2021_11_ctt_automatawiki"

rm stats.log

# for EXTRA_STATES in 0 1 2; do
for EXTRA_STATES in 0; do
    # for ctt in soucha_w soucha_wp soucha_h soucha_hsi soucha_spy soucha_spyh; do
    for ctt in soucha_w; do
        echo "Bankcard/10_learnresult_MasterCard_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/10_learnresult_MasterCard_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "Bankcard/1_learnresult_MasterCard_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/1_learnresult_MasterCard_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "Bankcard/4_learnresult_MAESTRO_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/4_learnresult_MAESTRO_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "Bankcard/4_learnresult_PIN_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/4_learnresult_PIN_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "Bankcard/4_learnresult_SecureCode_Aut_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/4_learnresult_SecureCode_Aut_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "Bankcard/ASN_learnresult_MAESTRO_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/ASN_learnresult_MAESTRO_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "Bankcard/ASN_learnresult_SecureCode_Aut_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/ASN_learnresult_SecureCode_Aut_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "Bankcard/Rabo_learnresult_MAESTRO_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/Rabo_learnresult_MAESTRO_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "Bankcard/Rabo_learnresult_SecureCode_Aut_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/Rabo_learnresult_SecureCode_Aut_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "Bankcard/Volksbank_learnresult_MAESTRO_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/Volksbank_learnresult_MAESTRO_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "Bankcard/learnresult_fix.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/Bankcard/learnresult_fix.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/ctinydtls_ecdhe_cert_none.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/ctinydtls_ecdhe_cert_none.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/ctinydtls_ecdhe_cert_req.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/ctinydtls_ecdhe_cert_req.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/ctinydtls_psk.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/ctinydtls_psk.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/etinydtls_ecdhe_cert_none.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/etinydtls_ecdhe_cert_none.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/etinydtls_ecdhe_cert_req.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/etinydtls_ecdhe_cert_req.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/etinydtls_psk.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/etinydtls_psk.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/gnutls-3.5.19_psk_rsa_cert_nreq.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/gnutls-3.5.19_psk_rsa_cert_nreq.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/gnutls-3.6.7_all_cert_none.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/gnutls-3.6.7_all_cert_none.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/gnutls-3.6.7_all_cert_nreq.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/gnutls-3.6.7_all_cert_nreq.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/gnutls-3.6.7_all_cert_req.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/gnutls-3.6.7_all_cert_req.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/jsse-12_rsa_cert_none.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/jsse-12_rsa_cert_none.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/jsse-12_rsa_cert_nreq.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/jsse-12_rsa_cert_nreq.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/jsse-12_rsa_cert_req.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/jsse-12_rsa_cert_req.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/mbedtls_all_cert_none.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/mbedtls_all_cert_none.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/mbedtls_all_cert_nreq.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/mbedtls_all_cert_nreq.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/mbedtls_all_cert_req.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/mbedtls_all_cert_req.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/nss-3.6.7_dhe_ecdhe_rsa.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/nss-3.6.7_dhe_ecdhe_rsa.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/openssl-1.1.1b_all_cert_none_nreq.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/openssl-1.1.1b_all_cert_none_nreq.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/openssl-1.1.1b_all_cert_nreq.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/openssl-1.1.1b_all_cert_nreq.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/openssl-1.1.1b_all_cert_req.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/openssl-1.1.1b_all_cert_req.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/pion_ecdhe_cert_none.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/pion_ecdhe_cert_none.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/pion_ecdhe_cert_nreq.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/pion_ecdhe_cert_nreq.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/pion_ecdhe_cert_req.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/pion_ecdhe_cert_req.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/pion_psk.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/pion_psk.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/scandium-2.0.0_ecdhe_cert_none.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/scandium-2.0.0_ecdhe_cert_none.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/scandium-2.0.0_ecdhe_cert_nreq.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/scandium-2.0.0_ecdhe_cert_nreq.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/scandium-2.0.0_ecdhe_cert_req.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/scandium-2.0.0_ecdhe_cert_req.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/scandium-2.0.0_psk.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/scandium-2.0.0_psk.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/scandium_latest_ecdhe_cert_none.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/scandium_latest_ecdhe_cert_none.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/scandium_latest_ecdhe_cert_nreq.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/scandium_latest_ecdhe_cert_nreq.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/scandium_latest_ecdhe_cert_req.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/scandium_latest_ecdhe_cert_req.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/scandium_latest_psk.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/scandium_latest_psk.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/wolfssl-4.0.0_dhe_ecdhe_rsa_cert_req.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/wolfssl-4.0.0_dhe_ecdhe_rsa_cert_req.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "DTLS/wolfssl-4.0.0_psk.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/DTLS/wolfssl-4.0.0_psk.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        # echo "FromRhapsodyToDezyne/model1.dot" >> stats.log
        # $PARSER -f "${MODEL_DIR}/FromRhapsodyToDezyne/model1.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        # echo "FromRhapsodyToDezyne/model2.dot" >> stats.log
        # $PARSER -f "${MODEL_DIR}/FromRhapsodyToDezyne/model2.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        # echo "FromRhapsodyToDezyne/model3.dot" >> stats.log
        # $PARSER -f "${MODEL_DIR}/FromRhapsodyToDezyne/model3.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "FromRhapsodyToDezyne/model4.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/FromRhapsodyToDezyne/model4.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/ActiveMQ__invalid.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/ActiveMQ__invalid.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/ActiveMQ__non_clean.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/ActiveMQ__non_clean.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/ActiveMQ__simple.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/ActiveMQ__simple.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/ActiveMQ__single_client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/ActiveMQ__single_client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/ActiveMQ__two_client_will_retain.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/ActiveMQ__two_client_will_retain.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/VerneMQ__invalid.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/VerneMQ__invalid.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/VerneMQ__non_clean.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/VerneMQ__non_clean.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/VerneMQ__simple.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/VerneMQ__simple.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/VerneMQ__single_client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/VerneMQ__single_client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/VerneMQ__two_client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/VerneMQ__two_client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/VerneMQ__two_client_same_id.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/VerneMQ__two_client_same_id.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/VerneMQ__two_client_will_retain.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/VerneMQ__two_client_will_retain.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/emqtt__invalid.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/emqtt__invalid.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/emqtt__non_clean.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/emqtt__non_clean.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/emqtt__simple.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/emqtt__simple.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/emqtt__single_client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/emqtt__single_client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/emqtt__two_client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/emqtt__two_client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/emqtt__two_client_same_id.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/emqtt__two_client_same_id.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/emqtt__two_client_will_retain.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/emqtt__two_client_will_retain.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/hbmqtt__invalid.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/hbmqtt__invalid.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/hbmqtt__non_clean.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/hbmqtt__non_clean.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/hbmqtt__simple.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/hbmqtt__simple.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/hbmqtt__single_client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/hbmqtt__single_client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/hbmqtt__two_client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/hbmqtt__two_client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/hbmqtt__two_client_will_retain.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/hbmqtt__two_client_will_retain.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/mosquitto__invalid.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/mosquitto__invalid.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/mosquitto__mosquitto.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/mosquitto__mosquitto.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/mosquitto__non_clean.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/mosquitto__non_clean.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/mosquitto__single_client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/mosquitto__single_client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/mosquitto__two_client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/mosquitto__two_client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/mosquitto__two_client_same_id.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/mosquitto__two_client_same_id.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "MQTT/mosquitto__two_client_will_retain.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/MQTT/mosquitto__two_client_will_retain.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "QUICprotocol/QUICprotocolwith0RTT.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/QUICprotocol/QUICprotocolwith0RTT.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "QUICprotocol/QUICprotocolwithout0RTT.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/QUICprotocol/QUICprotocolwithout0RTT.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "SSH/BitVise.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/SSH/BitVise.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "SSH/DropBear.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/SSH/DropBear.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "SSH/OpenSSH.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/SSH/OpenSSH.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TCP/TCP_FreeBSD_Client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TCP/TCP_FreeBSD_Client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TCP/TCP_FreeBSD_Server.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TCP/TCP_FreeBSD_Server.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TCP/TCP_Linux_Client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TCP/TCP_Linux_Client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TCP/TCP_Linux_Server.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TCP/TCP_Linux_Server.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TCP/TCP_Windows8_Client.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TCP/TCP_Windows8_Client.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TCP/TCP_Windows8_Server.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TCP/TCP_Windows8_Server.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/GnuTLS_3.3.12_client_full.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/GnuTLS_3.3.12_client_full.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/GnuTLS_3.3.12_client_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/GnuTLS_3.3.12_client_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/GnuTLS_3.3.12_server_full.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/GnuTLS_3.3.12_server_full.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/GnuTLS_3.3.12_server_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/GnuTLS_3.3.12_server_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/GnuTLS_3.3.8_client_full.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/GnuTLS_3.3.8_client_full.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/GnuTLS_3.3.8_client_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/GnuTLS_3.3.8_client_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/GnuTLS_3.3.8_server_full.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/GnuTLS_3.3.8_server_full.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/GnuTLS_3.3.8_server_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/GnuTLS_3.3.8_server_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/NSS_3.17.4_client_full.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/NSS_3.17.4_client_full.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/NSS_3.17.4_client_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/NSS_3.17.4_client_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/NSS_3.17.4_server_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/NSS_3.17.4_server_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/OpenSSL_1.0.1g_client_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/OpenSSL_1.0.1g_client_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/OpenSSL_1.0.1g_server_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/OpenSSL_1.0.1g_server_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/OpenSSL_1.0.1j_client_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/OpenSSL_1.0.1j_client_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/OpenSSL_1.0.1j_server_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/OpenSSL_1.0.1j_server_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/OpenSSL_1.0.1l_client_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/OpenSSL_1.0.1l_client_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/OpenSSL_1.0.1l_server_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/OpenSSL_1.0.1l_server_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/OpenSSL_1.0.2_client_full.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/OpenSSL_1.0.2_client_full.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/OpenSSL_1.0.2_client_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/OpenSSL_1.0.2_client_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/OpenSSL_1.0.2_server_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/OpenSSL_1.0.2_server_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/RSA_BSAFE_C_4.0.4_server_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/RSA_BSAFE_C_4.0.4_server_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/RSA_BSAFE_Java_6.1.1_server_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/RSA_BSAFE_Java_6.1.1_server_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        echo "TLS/miTLS_0.1.3_server_regular.dot" >> stats.log
        $PARSER -f "${MODEL_DIR}/TLS/miTLS_0.1.3_server_regular.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        # echo "Xray_system_PCS/learnresult1.dot" >> stats.log
        # $PARSER -f "${MODEL_DIR}/Xray_system_PCS/learnresult1.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        # echo "Xray_system_PCS/learnresult2.dot" >> stats.log
        # $PARSER -f "${MODEL_DIR}/Xray_system_PCS/learnresult2.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        # echo "Xray_system_PCS/learnresult3.dot" >> stats.log
        # $PARSER -f "${MODEL_DIR}/Xray_system_PCS/learnresult3.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        # echo "Xray_system_PCS/learnresult4.dot" >> stats.log
        # $PARSER -f "${MODEL_DIR}/Xray_system_PCS/learnresult4.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        # echo "Xray_system_PCS/learnresult5.dot" >> stats.log
        # $PARSER -f "${MODEL_DIR}/Xray_system_PCS/learnresult5.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
        # echo "Xray_system_PCS/learnresult6.dot" >> stats.log
        # $PARSER -f "${MODEL_DIR}/Xray_system_PCS/learnresult6.dot"  | $FSMLIB -m $ctt -es $EXTRA_STATES >/dev/null 2>> stats.log
    done
done