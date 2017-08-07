#!/bin/bash

# email printer toner information
# this script uses nagios/icinga plugin called check_snmp_printer

# add network printers to this array
declare -a printers=('10.0.0.1' '10.0.0.2')


printerScript='/usr/lib64/nagios/plugins/check_snmp_printer'
reportsBase='/REPORTDIR'
todaysDate=$(date +%F)
mkdir $reportsBase/$todaysDate
reportsDir=$reportsBase/$todaysDate
zipFile=$reportsBase/$todaysDate.zip


for i in "${printers[@]}"
do
        todaysDate=$(date +%F)
        echo $i > $reportsDir/$i.txt
        $printerScript -H $i -t "MODEL" >> $reportsDir/$i.txt
        $printerScript -H $i -t "CONSUM ALL" >> $reportsDir/$i.txt
done


cd $reportsDir
mv ./'10.0.0.1.txt' ./'Location 1.txt'
mv ./'10.0.0.2.txt' ./'Location 2.txt'


cd $reportsBase && zip -r $todaysDate.zip $todaysDate
/bin/mail -s "Daily Printer Report" -a $zipFile "report@printer.com" < /dev/null

exit
