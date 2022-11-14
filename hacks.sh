
https://stackoverflow.com/questions/68463996/http-multiple-port-forwarding-with-socat-bash

A potential solution to the problem is to create a handler script that takes the TCP-listen input and handles it.

router.sh:

socat TCP-LISTEN:8080,fork,reuseaddr EXEC:"bash -e ./route_handler.sh"

route_handler.sh:

tee >(socat - TCP4:127.0.0.1:8001 >> /dev/null) | socat - TCP4:127.0.0.1:8000

When port 8080 is hit, the results are sent to the localhost ports 8000 and 8001 are called. The output from port 8000 is returned to the TCP listener.


https://github.com/hashicorp/nomad/issues/6925

nomad alloc exec -i -t=false -task=promtail 0d253bda /usr/bin/socat - TCP4:localhost:3100



echo 'ok' | nomad alloc exec f7a /bin/sh -c 'cat > ${NOMAD_TASK_DIR}/myfile.txt'

