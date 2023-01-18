#!/bin/bash
if curl -I --silent --fail app:5000 | grep -q "HTTP/1.1 200 OK"; then
    echo "unit testing passed"
else
    echo "unit testing failed"
    exit 1
fi