#!/bin/bash

function external_ip {
  echo "Fetching external IP..." >&2
  dig +short myip.opendns.com @resolver1.opendns.com
}
