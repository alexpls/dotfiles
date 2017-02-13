#!/bin/bash

function external_ip {
  dig +short myip.opendns.com @resolver1.opendns.com
}
