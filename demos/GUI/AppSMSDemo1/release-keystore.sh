export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppSMSDemo1
keytool -genkey -v -keystore AppSMSDemo1-release.keystore -alias appsmsdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppSMSDemo1/appsmsdemo1keytool_input.txt
