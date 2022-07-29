#!/bin/bash

# echo "Subject: Sending email using sendmail"

touch croncron.txt 
touch compliantLogs.txt
echo ".........." >> compliantLogs.txt
COUNTER=0

echo -e "Date bash script ran: $(date)\n\n" >> croncron.txt
echo -e "Date bash script ran: $(date)\n" >> compliantLogs.txt

# checking SSH root login is disabled 
### -i --- case insesitive check		### $2 = no
### tr --- translate upper case to lower, checks setting matches 'no'
PRL=$(grep -i '^\s*PermitRootLogin' /etc/ssh/sshd_config | awk '{print $2}' | tr '[:upper:]' '[:lower:]')
echo "PermitRootLogin is set to: " $PRL
if [ "$PRL" == "no" ]; then
### quote "$PRL" (in quotation marks) to handle unary operator unexpected error when rule is uncommented/has no value 
	echo "PermitRootLogin is Compliant" >> compliantLogs.txt
else
	COUNTER=$(( COUNTER + 1 ))
	### email formatting to check if there is existing error, if yes, then put 'Error summary' string before error report
	if [ $COUNTER = 1 ]; then
		echo "Error summary: " >> croncron.txt
		fi
	echo "($COUNTER) error: PermitRootLogin is NOT SET correctly" >> croncron.txt
	echo "non-compliant: permitrootlogin"
fi


# checking SSH PermitEmptyPasswords is disabled
PEP=$(grep -i '^\s*PermitEmptyPasswords' /etc/ssh/sshd_config | awk '{print $2}' | tr '[:upper:]' '[:lower:]')
echo "PermitEmptyPasswords is set to: " $PEP
if [ "$PEP" == "no" ]; then
	echo "PermitEmptyPasswords is Compliant" >> compliantLogs.txt
else
	COUNTER=$(( COUNTER + 1 ))
	if [ $COUNTER = 1 ]; then
		echo "Error summary: " >> croncron.txt
		fi
	echo "($COUNTER) error: PermitEmptyPasswords is NOT SET correctly" >> croncron.txt
	echo "non-compliant: permitemptypassword"
fi


# checking SSH Protocol is set to 2
PTC=$(grep -i '^\s*Protocol' /etc/ssh/sshd_config | awk '{print $2}')
echo "Protocol is set to: " $PTC
if [ "$PTC" == 2 ]; then
	echo "Protocol is Compliant" >> compliantLogs.txt
else
	COUNTER=$(( COUNTER + 1 ))
	if [ $COUNTER = 1 ]; then
		echo "Error summary: " >> croncron.txt
		fi
	echo "($COUNTER) error: SSH Protocol is NOT SET correctly" >> croncron.txt
	echo "non-compliant: ssh protocol"
fi


# checking password expiration is 90 days or less
### grep '^\s*' ensures to grep trailing whitespaces before 'PASS_MAX_DAYS'
PEXP=$(grep -i '^\s*PASS_MAX_DAYS' /etc/login.defs | awk '{print $2}')

echo "PASS_MAX_DAYS is set to: " $PEXP
if [ "$PEXP" -le "90" ]; then
	echo "PASS_MAX_DAYS is Compliant" >> compliantLogs.txt
else
	COUNTER=$(( COUNTER + 1 ))
	if [ $COUNTER = 1 ]; then
		echo "Error summary: " >> croncron.txt
		fi
	echo "($COUNTER) error: Password expiration is NOT SET correctly" >> croncron.txt
	echo "non-compliant: password expiration"
fi


# checking system accounts are non-login

### awk -F:
#### --- defines field separator [i.e. colon ':'] (from awk man page)

### egrep -v "^\+"
#### ^ defines start of line		#### \+ escape meta characters
### -v, --invert-match, selects non-matching lines (from egrep man page)

### awk statement defines the only accepted fields are:
#### column 1 defines that : for user that is not 'root', 'sync', 'shutdown' or 'halt';
#### fields in column 3 must be less than 1000;
#### fields in column 7 must be '/usr/sbin/nologin' or '/bin/false'; else print those that do not fulfil grep function
egrep -v "^\+" /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<1000 && $7!="/usr/sbin/nologin" && $7!="/bin/false") {print}' 
if (($? == 0)) ; then
	echo "System accounts are Compliant" >> compliantLogs.txt
else
	COUNTER=$(( COUNTER + 1 ))
	if [ $COUNTER = 1 ]; then
		echo "Error summary: " >> croncron.txt
		fi
	echo "(5) error: System accounts is NOT SET correctly" >> croncron.txt
	echo "non-compliant: system accounts"
fi

echo ".........." >> compliantLogs.txt

if [ $COUNTER = 0 ]; then
echo -e "System is compliant\n" >> croncron.txt
mail -s "Compliant Status OK" stengg1306@gmail.com < croncron.txt
else 
# echo "Number of issues found:" >> croncron.txt
# echo -e "$COUNTER/5 \n" >> croncron.txt
mail -s "Compliant Status Error: $COUNTER issues found" stengg1306@gmail.com < croncron.txt
fi

rm croncron.txt





