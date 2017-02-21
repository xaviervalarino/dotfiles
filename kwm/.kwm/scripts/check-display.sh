#!/bin/bash
external_monitor=$(system_profiler SPDisplaysDataType | grep -ic 23EA63)
[ $external_monitor -eq 1 ] && $1
