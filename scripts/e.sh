a=1; for i in `cat $@`; do goldendict $i; echo $a: $i; let a+=1; sleep 0.8; done;
