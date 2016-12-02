#!/bin/bash

# Fix the date and time of the VM
service ntp stop
ntpdate -s time.nist.gov
service ntp start
