#!/bin/bash
export LC_ALL=C

free | grep Mem | awk '{print $3/$2 * 100.0}'
