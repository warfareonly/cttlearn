#!/bin/sh

PARSER="python3 ../src/dot2soucha_parser/dot2soucha.py"
CTT=spy
EXTRA_STATES=3
MODEL_DIR="../data/2021_11_ctt_automatawiki"
EXEC_DIR="../src"

# CoffeeMachine is not present!
# echo "${MODEL_DIR}/CoffeeMachine/coffeemachine.dot"
$PARSER -f "${MODEL_DIR}/QUICprotocol/QUICprotocolwith0RTT.dot"           | ${EXEC_DIR}/fsm_lib -m $CTT -es $EXTRA_STATES >/dev/null

exit 0
$PARSER -f "./benchmarks/QUICprotocol/QUICprotocolwith0RTT.dot"     | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/QUICprotocol/QUICprotocolwithout0RTT.dot"  | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null

$PARSER -f "./benchmarks/MQTT/ActiveMQ/invalid.dot"                 | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/ActiveMQ/non_clean.dot"               | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/ActiveMQ/simple.dot"                  | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/ActiveMQ/single_client.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/ActiveMQ/two_client_will_retain.dot"  | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/emqtt/invalid.dot"                    | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/emqtt/non_clean.dot"                  | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/emqtt/simple.dot"                     | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/emqtt/single_client.dot"              | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/emqtt/two_client_same_id.dot"         | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/emqtt/two_client_will_retain.dot"     | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/emqtt/two_client.dot"                 | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/hbmqtt/invalid.dot"                   | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/hbmqtt/non_clean.dot"                 | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/hbmqtt/simple.dot"                    | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/hbmqtt/single_client.dot"             | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/hbmqtt/two_client_will_retain.dot"    | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/hbmqtt/two_client.dot"                | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/mosquitto/invalid.dot"                | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/mosquitto/mosquitto.dot"              | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/mosquitto/non_clean.dot"              | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/mosquitto/single_client.dot"          | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/mosquitto/two_client_same_id.dot"     | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/mosquitto/two_client_will_retain.dot" | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/mosquitto/two_client.dot"             | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/VerneMQ/invalid.dot"                  | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/VerneMQ/non_clean.dot"                | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/VerneMQ/simple.dot"                   | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/VerneMQ/single_client.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/VerneMQ/two_client_same_id.dot"       | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/VerneMQ/two_client_will_retain.dot"   | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
$PARSER -f "./benchmarks/MQTT/VerneMQ/two_client.dot"               | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null

$PARSER -f "./benchmarks/Nordsec16/client_097.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null      
$PARSER -f "./benchmarks/Nordsec16/client_097e.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/client_098f.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/client_098j.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/client_098l.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/client_098m.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/client_098za.dot"          | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null        
$PARSER -f "./benchmarks/Nordsec16/client_100m.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/client_101.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null      
$PARSER -f "./benchmarks/Nordsec16/client_101h.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/client_102.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null      
$PARSER -f "./benchmarks/Nordsec16/client_110-pre1.dot"       | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null           
$PARSER -f "./benchmarks/Nordsec16/libressl_server_2.2.1.dot" | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null                 
$PARSER -f "./benchmarks/Nordsec16/server_097.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null      
$PARSER -f "./benchmarks/Nordsec16/server_097c.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/server_097e.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/server_098l.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/server_098m.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/server_098s.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/server_098u.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/server_098za.dot"          | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null        
$PARSER -f "./benchmarks/Nordsec16/server_100.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null      
$PARSER -f "./benchmarks/Nordsec16/server_101.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null      
$PARSER -f "./benchmarks/Nordsec16/server_101k.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null       
$PARSER -f "./benchmarks/Nordsec16/server_102.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null      
$PARSER -f "./benchmarks/Nordsec16/server_110pre1.dot"        | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null          




# TODO fix state identifiers. they're integer # $PARSER -f  "./benchmarks/Passport/passport.flat_0_1.dot"
# TODO fix state identifiers. they're integer # $PARSER -f  "./benchmarks/Passport/passport.flat_0_10.dot"
# TODO fix state identifiers. they're integer # $PARSER -f  "./benchmarks/Passport/passport.flat_0_2.dot"
# TODO fix state identifiers. they're integer # $PARSER -f  "./benchmarks/Passport/passport.flat_0_3.dot"
# TODO fix state identifiers. they're integer # $PARSER -f  "./benchmarks/Passport/passport.flat_0_4.dot"
# TODO fix state identifiers. they're integer # $PARSER -f  "./benchmarks/Passport/passport.flat_0_5.dot"
# TODO fix state identifiers. they're integer # $PARSER -f  "./benchmarks/Passport/passport.flat_0_6.dot"
# TODO fix state identifiers. they're integer # $PARSER -f  "./benchmarks/Passport/passport.flat_0_7.dot"
# TODO fix state identifiers. they're integer # $PARSER -f  "./benchmarks/Passport/passport.flat_0_8.dot"
# TODO fix state identifiers. they're integer # $PARSER -f  "./benchmarks/Passport/passport.flat_0_9.dot"
# TODO fix the state identifiers and indicate initial state # ./benchmarks/ToyModels/cacm.dot
# TODO fix the state identifiers and indicate initial state # ./benchmarks/ToyModels/lee_yannakakis_distinguishable.dot
# TODO fix the state identifiers and indicate initial state # ./benchmarks/ToyModels/lee_yannakakis_non_distinguishable.dot
# TODO fix the state identifiers and indicate initial state # ./benchmarks/ToyModels/naiks.dot
# TODO fix the state identifiers and indicate initial state # $PARSER -f "./benchmarks/Xray/learnresult1.dot" | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
# TODO fix the state identifiers and indicate initial state # $PARSER -f "./benchmarks/Xray/learnresult2.dot" | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
# TODO fix the state identifiers and indicate initial state # $PARSER -f "./benchmarks/Xray/learnresult3.dot" | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
# TODO fix the state identifiers and indicate initial state # $PARSER -f "./benchmarks/Xray/learnresult4.dot" | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
# TODO fix the state identifiers and indicate initial state # $PARSER -f "./benchmarks/Xray/learnresult5.dot" | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
# TODO fix the state identifiers and indicate initial state # $PARSER -f "./benchmarks/Xray/learnresult6.dot" | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the alphabet # $PARSER  -f "./benchmarks/FromRhapsodyToDezyne/model1.dot" 
#TODO fix the alphabet # $PARSER  -f "./benchmarks/FromRhapsodyToDezyne/model2.dot" 
#TODO fix the alphabet # $PARSER  -f "./benchmarks/FromRhapsodyToDezyne/model3.dot" 
#TODO fix the alphabet # $PARSER  -f "./benchmarks/FromRhapsodyToDezyne/model4.dot" 
#TODO fix the initial state $PARSER -f  ./benchmarks/SSH/BitVise.dot.fixed             | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f  ./benchmarks/SSH/DropBear.dot.fixed            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null 
#TODO fix the initial state $PARSER -f  ./benchmarks/SSH/OpenSSH.dot.fixed             | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f  ./benchmarks/TCP/TCP_FreeBSD_Client.dot.fixed  | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null           
#TODO fix the initial state $PARSER -f  ./benchmarks/TCP/TCP_FreeBSD_Server.dot.fixed  | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null           
#TODO fix the initial state $PARSER -f  ./benchmarks/TCP/TCP_Linux_Client.dot.fixed    | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null         
#TODO fix the initial state $PARSER -f  ./benchmarks/TCP/TCP_Linux_Server.dot.fixed    | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null         
#TODO fix the initial state $PARSER -f  ./benchmarks/TCP/TCP_Windows8_Client.dot.fixed | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null            
#TODO fix the initial state $PARSER -f  ./benchmarks/TCP/TCP_Windows8_Server.dot.fixed | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null            
#TODO fix the initial state $PARSER -f ./benchmarks/Passport/complete_learned_model.dot | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null          
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/1_learnresult_MasterCard_fix.dot"         | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/10_learnresult_MasterCard_fix.dot"        | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/4_learnresult_MAESTRO_fix.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/4_learnresult_PIN_fix.dot"                | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/4_learnresult_SecureCode Aut_fix.dot"     | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/ASN_learnresult_MAESTRO_fix.dot"          | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/ASN_learnresult_SecureCode Aut_fix.dot"   | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/learnresult_fix.dot"                      | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/Rabo_learnresult_MAESTRO_fix.dot"         | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/Rabo_learnresult_SecureCode_Aut_fix.dot"  | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/Bankcard/Volksbank_learnresult_MAESTRO_fix.dot"    | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/GnuTLS_3.3.12_client_full.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null            
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/GnuTLS_3.3.12_client_regular.dot"        | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/GnuTLS_3.3.12_server_full.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/GnuTLS_3.3.12_server_regular.dot"        | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/GnuTLS_3.3.8_client_full.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/GnuTLS_3.3.8_client_regular.dot"         | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/GnuTLS_3.3.8_server_full.dot"            | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/GnuTLS_3.3.8_server_regular.dot"         | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/miTLS_0.1.3_server_regular.dot"          | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/NSS_3.17.4_client_full.dot"              | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/NSS_3.17.4_client_regular.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/NSS_3.17.4_server_regular.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/OpenSSL_1.0.1g_client_regular.dot"       | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/OpenSSL_1.0.1g_server_regular.dot"       | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/OpenSSL_1.0.1j_client_regular.dot"       | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/OpenSSL_1.0.1j_server_regular.dot"       | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/OpenSSL_1.0.1l_client_regular.dot"       | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/OpenSSL_1.0.1l_server_regular.dot"       | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/OpenSSL_1.0.2_client_full.dot"           | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/OpenSSL_1.0.2_client_regular.dot"        | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/OpenSSL_1.0.2_server_regular.dot"        | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/RSA_BSAFE_C_4.0.4_server_regular.dot"    | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the initial state $PARSER -f "./benchmarks/TLS/RSA_BSAFE_Java_6.1.1_server_regular.dot" | ./bin/FSMlib -m $CTT -es $EXTRA_STATES >/dev/null
#TODO fix the state labels and IDs  # "./benchmarks/Edentifier2/learnresult_new_device-simple_fix.dot"
#TODO fix the state labels and IDs  # "./benchmarks/Edentifier2/learnresult_new_Rand_500_10-15_MC_fix.dot"
#TODO fix the state labels and IDs  # "./benchmarks/Edentifier2/learnresult_new_W-method_fix.dot"
#TODO fix the state labels and IDs  # "./benchmarks/Edentifier2/learnresult_old_500_10-15_fix.dot"
#TODO fix the state labels and IDs  # "./benchmarks/Edentifier2/learnresult_old_device-simple_fix.dot"
