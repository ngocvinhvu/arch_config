openssl s_client -servername $1 -connect ${1}:${2} </dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ~/test.pem
