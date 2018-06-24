for i in $(seq 1 254) 
do
     ping -c 1 -t 1 192.168.2.$i >/dev/null
     if [ $? -eq 0 ]; then
          echo "host $i is up"
     fi
done
