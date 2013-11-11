#!/bin/bash
#
# About
# =====
#
# Log battery info from command-line with SYSTEM_PROFILER(8) and IOREG(8) to a 
# user-configurable directory.
#
# Run with -h to see usage options. 
#
# Documentation available at http://home.strw.leidenuniv.nl/~werkhoven/etc/battlog.html . This script is known to work on OS X 10.7 & 10.9.
#
# Data logging
# ============
#
# When an output directory is given with -o, the following properties are 
# logged:
# 
# 1. From system_profiler(8):
#     ExternalConnected, CellVoltage, MaxCapacity, Voltage, CurrentCapacity, BatteryInstalled, CycleCount, DesignCapacity, Temperature, FullyCharged, InstantAmperage, Amperage, DesignCycleCount9C
# 
# 2. From ioreg(8):
#     FirmwareVersion, HardwareRevision, CellRevision, ChargeInformation, ChargeRemaining(mAh), FullyCharged, Charging, FullChargeCapacity(mAh), CycleCount, Condition, Amperage(mA), Voltage(mV), ACChargerInformation, Connected, Wattage(W), Revision, Charging
#
# Data is stored to two files:
#
# 1. YYYYMM_MAC_battery-meta_log.txt
#     Contains full output from system_profiler(8) and ioreg(8) once a month, to backtrace what data is being logged
#
# 2. YYYYMM_MAC_battery-meta_log.txt
#     Contains concise output from same tools to use less disk space.
#
# Using in crontab
# ================
# 
# Example crontab entry:
# */15 *  *  *  *     $HOME/bin/battery_logger.sh -o $HOME/Documents/batt_log
# 
# This crontab entry will also list uptime every minute (for load checking)
# */1  *  *  *  *     /bin/echo $(/bin/date +\%Y\%m\%d-\%H\%M\%S) $(/usr/bin/uptime) >> $HOME/Documents/mac_health/00_poweron-log.txt
#
#
# Copyright (c) 2012 Tim van Werkhoven <timvanwerkhoven@gmail.com>
# This file is licensed under the Creative Commons Attribution-Share Alike
# license versions 3.0 or higher,  see
# http://creativecommons.org/licenses/by-sa/3.0/

USAGE_STR="Usage: $0 -o [DIR] -h -v"

while getopts "o:hv" opt; do
  case $opt in
    v)
      DEBUG=1
      ;;
    o)
      OUTDIR=$OPTARG
      ;;
    h)
      cat <<USAGE_INFO
${USAGE_STR}
Log battery info to DIR using system_profiler(8) and ioreg(8)
Example:
    $0 -o ./ (logs to current directory)
    $0 (runs in debug mode)

Run as a cron-job to log battery health over time.

$0 accepts the options:
  -o DIR                    directory to store data to
  -v                        show debug information
  -h                        show this help text
USAGE_INFO
      exit
      ;;
    \?)
      echo ${USAGE_STR}
      exit
      ;;
  esac
done

# Check if we run in debug mode
test ${DEBUG} && echo "Running in debug mode..."

# Version of output format
APIVER=0.91

# Tool paths
SYSPROF=/usr/sbin/system_profiler
UPTIME=/usr/bin/uptime
UNAME=/usr/bin/uname
IOREG=/usr/sbin/ioreg
GREP=/usr/bin/grep
DATE=/bin/date
ECHO=/bin/echo
BZIP=/usr/bin/bzip2
SED=/usr/bin/sed
CUT=/usr/bin/cut
TR=/usr/bin/tr

# ============================================================================
# FILE MANAGEMENT
# ============================================================================

# Get system MAC address for unique filenames
SYSID=$(/sbin/ifconfig en0 | ${GREP} ether | ${TR} -d ':' | ${CUT} -d ' ' -f 2)

test ${DEBUG} && echo "Got SYSID: ${SYSID}"

# Files to use
METAFILE=${OUTDIR}/$(${DATE} +%Y%m)_${SYSID}_battery-meta_log.txt
LOGFILE=${OUTDIR}/$(${DATE} +%Y%m)_${SYSID}_battery_log.txt
# This is the previous logfile
LASTLOGFILE=${OUTDIR}/$(${DATE} -v-1m +%Y%m)_${SYSID}_battery_log.txt

test ${DEBUG} && echo "Got METAFILE: ${METAFILE},  LOGFILE: ${LOGFILE},  LASTLOGFILE: ${LASTLOGFILE}"

# Make output directory
test ${OUTDIR} && mkdir -p ${OUTDIR}

# Compress file from last month,  if it exists. This will append a zip-suffix to the file so this test will not trigger again. If output file already exists, bzip will complain. Silence by redirecting errors to /dev/null
test -f ${LASTLOGFILE} && ${BZIP} -q ${LASTLOGFILE} > /dev/null 2>&1

# Store system information to file, if it does not exist (i.e. once a month)
test ! -f ${METAFILE} && test ${OUTDIR} && ${UNAME} -a >> ${METAFILE} && ${SYSPROF} SPSoftwareDataType SPPowerDataType >> ${METAFILE} && ${IOREG} -lrSc AppleSmartBattery >> ${METAFILE}

test ${DEBUG} && ${UNAME} -a && ${SYSPROF} SPSoftwareDataType SPPowerDataType && ${IOREG} -rSk Temperature

# ============================================================================
# IOREG(8) PARSING
# ============================================================================

# We want these fields from ioreg:
# ExternalConnected,  CellVoltage,  MaxCapacity,  Voltage,  CurrentCapacity,  BatteryInstalled,  CycleCount,  DesignCapacity,  Temperature,  FullyCharged,  InstantAmperage,  Amperage,  IsCharging,  DesignCycleCount9C

IOREG_GREPSTR="\(Cycle\|ExternalConnected\|Voltage\|Installed\|Capacity\|Voltage\|Temperature\|Charged\|Amperage\)"
IOREG_GREPIGNSTR="LegacyBatteryInfo"

# Get all values with property names, sort for reproducible orders
IOREG_HDR=$(${IOREG} -rSk Temperature | ${GREP} ${IOREG_GREPSTR} | ${GREP} -v ${IOREG_GREPIGNSTR} | sort | ${TR} "\n=" ",:" | ${TR} -d " \"")

# Remove property names and only take data
IOREG_DATA=$(${ECHO} ${IOREG_HDR} | ${SED} -E 's/[a-zA-Z9]+://g' | ${TR} -d "()")

test ${DEBUG} && echo "Got IOREG_HDR: ${IOREG_HDR}"
test ${DEBUG} && echo "Got IOREG_DATA: ${IOREG_DATA}"

# ============================================================================
# SYSTEM_PROFILER(8) PARSING
# ============================================================================

# We want these fields from system_profiler:
# Firmware Version,  Hardware Revision,  Cell Revision,  Charge Remaining,  Fully Charged,  Charging,  Full Charge Capacity,  Cycle Count,  Condition,  Amperage,  Voltage,  Connected,  Wattage,  Revision,  Family

SYSPROF_GREPSTR="\(Version\|Revision\|Cell\|Charg\|Cycle\|Condition\|Amperage\|Voltage\|Connected\|Wattage\|Family|\)"

# Get all values with property names, sort for reproducible orders
SYSPROF_HDR=$(${SYSPROF} SPPowerDataType | ${GREP} ${SYSPROF_GREPSTR} | sort | ${TR} "\n" ", " | ${TR} -d " ")

# Remove property names and only take data
SYSPROF_DATA=$(${ECHO} ${SYSPROF_HDR} | ${SED} -E 's/[a-zA-Z9\(\)]+://g')

test ${DEBUG} && echo "Got SYSPROF_HDR: ${SYSPROF_HDR}"
test ${DEBUG} && echo "Got SYSPROF_DATA: ${SYSPROF_DATA}"

# ============================================================================
# STORE DATA
# ============================================================================

# Get date as ISO 8601 + timezone in HHMM offset from UTC
DATEINFO=$(${DATE} +%Y-%m-%dT%H:%M:%S%z)
# Get uptime and load info, replace , with ; as we use commas for field separators
LOADINFO=$(${UPTIME} | ${TR} "," ";")

test ${DEBUG} && echo "Got APIVER: ${APIVER}, DATEINFO: ${DATEINFO},  LOADINFO: ${LOADINFO}"
test ${DEBUG} && echo ${DATEINFO}, ${APIVER}, ${LOADINFO}, "IOREG", ${IOREG_DATA}, "SYSPROF", ${SYSPROF_DATA}

# Add header to logfile if it does not exist (i.e. once a month)
test ! -f ${LOGFILE} && test ${OUTDIR} && ${ECHO} "Date, APIVER, uptime, " ${IOREG_HDR} ${SYSPROF_HDR} >> ${LOGFILE}

# Add data to logfile
test ${OUTDIR} && ${ECHO} ${DATEINFO}, ${APIVER}, ${LOADINFO}, "IOREG", ${IOREG_DATA}, "SYSPROF", ${SYSPROF_DATA} >> ${LOGFILE}

