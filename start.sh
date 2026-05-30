#!/bin/bash

# Railway sets PORT dynamically — default to 8080 if not set
PORT=${PORT:-8080}

echo "Starting Tomcat on port $PORT"

# Replace port 8080 with the actual Railway PORT in server.xml
sed -i "s/port=\"8080\"/port=\"$PORT\"/" /usr/local/tomcat/conf/server.xml

# Start Tomcat
exec catalina.sh run
