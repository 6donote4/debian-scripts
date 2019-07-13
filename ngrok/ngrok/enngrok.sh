#!/bin/bash
./bin/ngrokd -tlsKey=server.key -tlsCrt=server.crt -domain="donote.tk" -httpAddr=":8081" -httpsAddr=":8082"
