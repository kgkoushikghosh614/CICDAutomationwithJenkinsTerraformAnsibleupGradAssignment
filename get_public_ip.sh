#!/bin/bash

echo "{\"allowed_ip_cidr\": \"$(curl -s http://ipv4.icanhazip.com)/32\"}"


