#!/bin/bash


# STATUS 2016-11-12: 
# v1.6 erlaubt Startzeit und hat Help
# graphiclevel ist funktional

# verbosity level 1 is verbose, 0 is terse
verbosity="0"

# graphic level
graphiclevel="1"

#Zeitvariable initialisieren
totaltime="0"

# Startzeit pro forma mal festlegen
# starttime="6:45"
if [ $1 == "now" ]
then 
starttime=$(date +%k:%M)
# echo $starttime
elif [ $1 == "help" ]
then 
echo "| Aufruf           |  sb1 now oder sb1 12:34                      |"
echo "| Aktuelles Format | Name-ohne-Leerzeichen  Zeitintervall-in-5min |"
exit 0
else
starttime=$1
fi
datenfile="/home/till//sbdaten"

### Grafikdefinition

function blockGrafik () {

# Zeilenbreite
lw="64"

# Subelemente
a="-"
#b="-"
# Aufbauelement
#c="$a$b"
c=$a
#Wachsende Zeile
d=""
# Anfangselement
e="||"
# Endelement
f="||"
# echo $c
# Beschreibung
# g="Description"
# Beschreibung aus Übergabeparameter
g=" "$1
# Zeichenanzahl
h=$(echo $g | wc -m)
# Minutenanzeige
minutes=$(echo $2" * 5" | bc)
# hochzählen
let "totaltime = $totaltime + $minutes"

#langphrase=$(echo $2"SE , "$minutes" Minuten.")
#echo $langphrase
if [ $minutes -gt 9 ]
then
alles="klar" 
#echo ">9"
#echo $minutes "Min"
else
# echo "lower than 10"
minutes="0${minutes}"
# echo $minutes "Min"

fi
minutephrase=$minutes" min"
minutephraselength=$(echo $minutephrase | wc -m)
# echo "$minutephrase ist $minutephraselength Zeichen lang"
# Leerzeichenanzahl
# Auffüllzeichen
# ohne Minutenphrase, works
#j=$(echo $lw - $h | bc)
# mit Minutenphrase
j=$(echo "$lw - $h - $minutephraselength -1" | bc)
# Auffüllzeichen Beschreibung
k="\040"
#k="."
# Komplettphrase
m=""
# Auffüllphrase
for l in $(seq 1 $j);
do
m="$m$k";
done

# --------------------------------------------
# Leerzeile
# Leerstellenzeichen
n="\040"
# Auffüllphrase
o=""
for p in $(seq 1 $lw)
do
o=$o$n
done

for i in $(seq 1 $lw);
do
d="$d$c"
# echo $d
done
# echo "alles:"
randzeile=$(echo "$e$d$f")
# ohne minutenphrase
#beschreibungszeile=$(echo $e$g$m$f)
#echo $m$minutephrase "für Beschreibungszeile"
beschreibungszeile=$(echo "$e$g$m ${minutephrase} $f")
fuellzeile=$(echo $e$o$f)
# mehrzeiliger Füller
# Zeilenanzahl über 1 hinaus
#q=3
let q="$2"
multifuellzeile="\n"$fuellzeile
if [ $q -eq 1 ]
then
multifuellzeile=""
else
for r in $(seq 3 $q);
do
multifuellzeile="$multifuellzeile\n$fuellzeile";
done
fi



# mit Randzeilen
# echo -e $randzeile"\n"$beschreibungszeile$multifuellzeile"\n"$randzeile

if [ $graphiclevel -eq 1 ]
then
# STANDARD: ohne Endzeile
echo -e $randzeile"\n"$beschreibungszeile$multifuellzeile
else
# ohne Grafik
echo -e $beschreibungszeile
fi

#ohne Randzeilen
#echo -e $beschreibungszeile$multifuellzeile

#echo "$e$d$f"
# echo "$e$g $h $j"
#echo $e$g$m"_"$f
#echo "$e$d$f"

}
# --------------------------------------------
# ohne Fileinput
#blockGrafik drei 3
#echo $q
#blockGrafik eine 1
#echo $q
#blockGrafik zwei 2
#echo $q
#blockGrafik fuenf  5
# echo $datenfile
# -----------------------------------------------
function readFile () {

datenzeilen=$(cat $datenfile | wc -l)

for fileschleife in $(seq 1 $datenzeilen);
do


param1=$(cat $datenfile | head -n $fileschleife | tail -n 1 | cut -f 1 -d "	")
#echo $param1
param2=$(cat $datenfile | head -n $fileschleife | tail -n 1 | cut -f 2 -d "	")
#echo $param2
blockGrafik $param1 $param2;
done

}
# --------------------------------------------------------

writeTime1 () {

starttimehour=$(echo $starttime | cut -f 1 -d ":")
starttimeminute=$(echo $starttime | cut -f 2 -d ":")

if [ $verbosity -eq 1 ]
then
echo "Start time is "$starttimehour":"$starttimeminute
else
echo $starttimehour":"$starttimeminute
fi
starttimeasminutes=$(echo "$starttimehour * 60 + $starttimeminute" | bc )
# echo $starttimeasminutes "as minutes"
}
# -------------------------------------------------------
writeTimeEnd () {

endtimeasminutes=$(echo "$starttimeasminutes + $totaltime" | bc )
# echo $endtimeasminutes
endtimehour=$(expr $(echo ${endtimeasminutes}) / 60 )
endtimeminute=$(expr $(echo ${endtimeasminutes}) % 60 )

if [ $endtimeminute -lt 10 ]
then
endtimeminute="0$endtimeminute"
fi
if [ $verbosity -eq 1 ]
then
echo "projected end time "$endtimehour":"$endtimeminute", total time "$totaltime" Minutes" 
else
echo $endtimehour":"$endtimeminute
fi
#echo "11:45"
}



# ===================================================
echo -e "\n"
writeTime1
readFile
echo $randzeile
writeTimeEnd
echo -e "\n"


#echo $q
# blockGrafik null  0
# echo $q

exit 0

