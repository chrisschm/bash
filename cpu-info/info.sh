#!/usr/bin/env bash
#
# CPU Informationen
# 
#
# Autor: Christian Schmidt
# Datum: 11. Mai 2026
# Lizenz: GPL-2.0

# ┌────────────────────────────────────────────────────────────────────────────
# │ Globale Variablen-Daklaration
# └────────────────────────────────────────────────────────────────────────────
TTYCOLUMNS=`tput cols`
CPUMODEL=''
CPUCORES=0
CPUMHZ=0
CPUCACHE=''
CPUTLB=''
PROCRUNNING=0
PROCBLOCKED=0

# ┌────────────────────────────────────────────────────────────────────────────
# │ function read_cpu_specs ()
# │     Spezifikationen der CPU einlesen und speichern
# └────────────────────────────────────────────────────────────────────────────
function read_cpu_specs () {
    CPUMODEL=`cat /proc/cpuinfo | grep 'model name' | cut -d: -f2 | awk 'NR==1{print}'`
    CPUCORES=`cat /proc/cpuinfo | grep 'siblings' | cut -d: -f2 | awk 'NR==1{print}'`
	CPUMHZ=`cat /proc/cpuinfo | grep 'cpu MHz' | cut -d: -f2 | awk 'NR==1{print}'`
	CPUCACHE=`cat /proc/cpuinfo | grep 'cache size' | cut -d: -f2 | awk 'NR==1{print}'`
	CPUTLB=`cat /proc/cpuinfo | grep 'TLB size' | cut -d: -f2 | awk 'NR==1{print}'`
	PROCRUNNING=`cat /proc/stat | grep 'procs_running' | awk '{print $2}'`
	PROCBLOCKED=`cat /proc/stat | grep 'procs_blocked' | awk '{print $2}'`
}

# ┌────────────────────────────────────────────────────────────────────────────
# │ function draw_frame ()
# │ 	Rahmen zeichnen
# └────────────────────────────────────────────────────────────────────────────
function draw_frame () {
	local cols=$(($TTYCOLUMNS))
	local line=7
	# Neue Zeile
	printf '\n'
	# Über Zeilen iterieren
	for ((l=1;l<=line;l++)); do
		# Über Spalten iterieren
		for ((c=1;c<=cols;c++)); do
			# Erste Zeile ausgeben (alle Spalten)
			if [ $l -eq 1 ]; then
				if [ $c -eq 1 ]; then
					printf '╔'
				elif [ $c -lt $cols ]; then
					printf '═'
				else
					printf '╗\n'
				fi
			# Zeile 2 ausgeben
			elif [ $l -eq 2 ]; then
				ZName="║ CPU Modell:"
				Zeile="$ZName\x1b[38;5;126m$CPUMODEL\x1b[0m"
				lenZeile=$((${#ZName} + ${#CPUMODEL} + 2))
				printf "$Zeile"
				for ((i = $lenZeile ; i <= $cols ; i++)); do
					printf ' '
				done
				printf '║\n'
				break	
			# Zeile 3 ausgeben
			elif [ $l -eq 3 ]; then
				ZName1="║ Taktrate..:"
				Zeile1="$ZName1\x1b[38;5;126m$CPUMHZ\x1b[0m"
				lenZeile=$((${#ZName1} + ${#CPUMHZ} + 2))
				printf "$Zeile1"
				for ((i = $lenZeile ; i <= $(($cols / 2)) ; i++)); do
					printf ' '
				done
				ZName2="Kerne:"
				Zeile2="$ZName2\x1b[38;5;126m$CPUCORES\x1b[0m"
				lenZeile=$((${#ZName2} + ${#CPUCORES} + 1))
				printf "$Zeile2"
				for ((i = $lenZeile ; i <= $(($cols / 2)) ; i++)); do
					printf ' '
				done				
				printf '║\n'
				break
			# Zeile 4 ausgeben
			elif [ $l -eq 4 ]; then
				ZName1="║ Cache.....:"
				Zeile1="$ZName1\x1b[38;5;126m$CPUCACHE\x1b[0m"
				lenZeile=$((${#ZName1} + ${#CPUCACHE} + 2))
				printf "$Zeile1"
				for ((i = $lenZeile ; i <= $(($cols / 2)) ; i++)); do
					printf ' '
				done
				ZName2="TLB..:"
				Zeile2="$ZName2\x1b[38;5;126m$CPUTLB\x1b[0m"
				lenZeile=$((${#ZName2} + ${#CPUTLB} + 1))
				printf "$Zeile2"
				for ((i = $lenZeile ; i <= $(($cols / 2)) ; i++)); do
					printf ' '
				done						
				printf '║\n'
				break
			# Zeile 5 ausgeben
			elif [ $l -eq 5 ]; then
				Zeile="╠═ Prozesse "
				printf "$Zeile"
				lenZeile=$((${#Zeile} + 2))
				for ((i = $lenZeile ; i <= $(($cols)) ; i++)); do
					printf '═'
				done
				printf '╣\n'
				break
			# Zeile 6 ausgeben
			elif [ $l -eq 6 ]; then
				ZName1="║ laufend...: "
				Zeile1="$ZName1\x1b[38;5;226m$PROCRUNNING\x1b[0m"
				lenZeile=$((${#ZName1} + 3))
				printf "$Zeile1"
				for ((i = $lenZeile ; i <= $(($cols / 2)) ; i++)); do
					printf ' '
				done	
				ZName2="angehalten: "
				Zeile2="$ZName2\x1b[38;5;226m$PROCBLOCKED\x1b[0m"
				lenZeile=$((${#ZName2} + ${#PROCBLOCKED} + 1))
				printf "$Zeile2"
				for ((i = $lenZeile ; i <= $(($cols / 2)) ; i++)); do
					printf ' '
				done	
				printf '║\n'
				break
			# Letzte Zeile ausgeben (nur erste Spalte)
			else
				if [ $c -eq 1 ]; then
					printf '╚'
				elif [ $c -lt $cols ]; then
					printf '═'
				else
					printf '╝'
				fi	
			fi
		done
	done	
}

read_cpu_specs
draw_frame
