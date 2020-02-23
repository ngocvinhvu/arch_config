a=1; for i in `cat 1000.txt`; do goldendict $i; echo $a: $i; let a+=1; sleep 0.8; done;
