#! /usr/bin/env bash
#
# dynamische Message of the day (MOTD) für Debian
# Aufruf in /etc/profile oder ~/.profile (letzte Zeile)
#
# Autor: Christian Schmidt
# Datum: 06. Mai 2026
# Lizenz: GPL-2.0

# ┌────────────────────────────────────────────────────────────
# │  Funktion PrintLogo()
# │      Gibt einen weißen Rahmen und das rote Debian Logo
# │      sowie die gesammelten Informationen formatiert aus
# │          ESC =                  \x1b
# │          Reset all Modes =      \x1b[0m
# │          Set foreground color = \x1b[38;5;{ID}m
# │          Weiß =                 \x1b[38;5;231m
# │          Bordeauxrot =          \x1b[38;5;126m
# │          Cyan (8 bit) =         \033[1;36m
# │          Gelb =                 \x1b[38;5;226m
# │          Gelb (schwach) =       \x1b[38;5;229m
# └────────────────────────────────────────────────────────────

PrintInfo () {
	echo -e "\x1b[38;5;231m┌───────────────────────────────────────────────────────────────────────────────────────
\x1b[38;5;231m│\x1b[38;5;126m
\x1b[38;5;231m│\x1b[38;5;126m 	_,met\$\$\$\$\$gg.            \x1b[0m\033[1;36m $DATUM
\x1b[38;5;231m│\x1b[38;5;126m      ,g\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$P.         
\x1b[38;5;231m│\x1b[38;5;126m     ,g326P\"\"       \"\"\"Y\$\".     \x1b[0m Hostname......: \x1b[38;5;226m$HOSTNAME
\x1b[38;5;231m│\x1b[38;5;126m    ,\$\$P'               \`\$\$\$.     
\x1b[38;5;231m│\x1b[38;5;126m   ',\$\$P       ,ggs.     \`\$\$b:  \x1b[0m IP v6 Adresse.: \x1b[38;5;229m$IPV6
\x1b[38;5;231m│\x1b[38;5;126m   \`d\$\$'     ,\$P\"'   .    \$\$\$  \x1b[0m  IP v4 Adresse.: \x1b[38;5;229m$IPV4
\x1b[38;5;231m│\x1b[38;5;126m   \$\$P       d\$'     ,    \$\$P
\x1b[38;5;231m│\x1b[38;5;126m   \$\$:      \$\$.    -    ,d\$\$'   \x1b[0m Uptime........: \x1b[38;5;229m$UP1 \x1b[0mTage, \x1b[38;5;229m$UP2:$UP3 \x1b[0mStunden
\x1b[38;5;231m│\x1b[38;5;126m   \`\$\$;      Y\$b._   _,d\$P'     \x1b[0m Letzter Login.: \x1b[38;5;229m$LASTD \x1b[0mum \x1b[38;5;229m$LASTT Uhr \x1b[0mvon \x1b[38;5;229m$LASTPC
\x1b[38;5;231m│\x1b[38;5;126m    Y\$\$.    \`.\`\"Y\$\$\$\$P\"'          
\x1b[38;5;231m│\x1b[38;5;126m    \`\$\$b      \"-.__             \x1b[0m Ø Auslastung..: \x1b[38;5;229m$LOAD1 \x1b[0m(1 Min.) | \x1b[38;5;229m$LOAD2 \x1b[0m(5 Min.) | \x1b[38;5;229m$LOAD3 \x1b[0m(15 Min.)
\x1b[38;5;231m│\x1b[38;5;126m     \`Y\$\$b                        
\x1b[38;5;231m│\x1b[38;5;126m      \`Y\$\$.                     \x1b[0m Speicher auf /: Gesamt: \x1b[38;5;229m$DISK1 \x1b[0m| Belegt: \x1b[38;5;229m$DISK2 \x1b[0m| Frei: \x1b[38;5;229m$DISK3
\x1b[38;5;231m│\x1b[38;5;126m        \`\$\$b.                     
\x1b[38;5;231m│\x1b[38;5;126m          \`Y\$\$b.                \x1b[0m Hauptspeicher.: Gesamt: \x1b[38;5;229m$RAM1 \x1b[0m| Belegt: \x1b[38;5;229m$RAM2 \x1b[0m| Frei: \x1b[38;5;229m$RAM3 \x1b[0m| Swap: \x1b[38;5;229m$RAM4
\x1b[38;5;231m│\x1b[38;5;126m            \`\"Y\$b._      
\x1b[38;5;231m│\x1b[38;5;126m                \`\"\"\"\" 
\x1b[38;5;231m│ \x1b[0m"
}

# Datum & Uhrzeit
DATUM=`date +"%A, %e %B %Y um %H:%M Uhr"`

# Hostname
HOSTNAME=`hostname -f`

# letzter Login
LASTD=`last -2 -a -F | awk 'NR==2{print $4, $6, $5, $8}' | date +"%A, %d. %B %Y" --date=` #Datum & Format
LASTT=`last -2 -a | awk 'NR==2{print $7}'`    # Uhrzeit
LASTPC=`last -2 -a | awk 'NR==2{print $11}'`   # Remote-Computer

# Uptime
UP0=`cut -d. -f1 /proc/uptime`
UP1=$(($UP0/86400))        # Tage
UP2=$(($UP0/3600%24))        # Stunden
UP3=$(($UP0/60%60))        # Minuten
UP4=$(($UP0%60))        # Sekunden

# Durchschnittliche Auslasung
LOAD1=`cat /proc/loadavg | awk '{print $1}'`    # Letzte Minute
LOAD2=`cat /proc/loadavg | awk '{print $2}'`    # Letzte 5 Minuten
LOAD3=`cat /proc/loadavg | awk '{print $3}'`    # Letzte 15 Minuten

# Speicherbelegung
DISK1=`df -h | grep 'dev/sdd' | awk '{print $2}'`    # Gesamtspeicher
DISK2=`df -h | grep 'dev/sdd' | awk '{print $3}'`    # Belegt
DISK3=`df -h | grep 'dev/sdd' | awk '{print $4}'`    # Frei

# Arbeitsspeicher
RAM1=`free --mega -h | grep 'Speicher' | awk '{print $2}'`    # Total
RAM2=`free --mega -h | grep 'Speicher' | awk '{print $3}'`    # Used
RAM3=`free --mega -h | grep 'Speicher' | awk '{print $4}'`    # Free
RAM4=`free --mega -h | grep 'Swap' | awk '{print $3}'`    # Swap used

# IP Adressen
IPV4=`ip addr show eth0 | grep -vw "inet6" | grep "global" | grep -w "inet" | cut -d/ -f1 | awk '{ print $2 }'`
IPV6=`ip addr show eth0 | grep -vw "inet" | grep "link" | grep -w "inet6" | cut -d/ -f1 | awk '{ print $2 }'`

# Informationen ausgeben
PrintInfo

