#!/bin/bash
#
# @author: Xueyi Li
#
# Given the input data is in "./data.txt", one value per line.

scale=${1:-1}
MaxValue=$( sort -k2nr ./data.txt | head -n1 | cut -d" " -f2 )    # Find Max Value
MinValue=$( sort -k2n  ./data.txt | head -n1 | cut -d" " -f2 )    # Find Min Value
if (( scale > MaxValue )); then (( scale=MaxValue )); fi        # scale <= MaxValue


echo
plot_bar() {
    (( Line = $MaxValue/$scale ))               # apply scalar
    while [ $Line -gt 0 ]; do                   
        (( Line -= 1 ))                         # iterate/print each line after scaling           
        while IFS=" " read -r key Value; do
            if [ $Line -gt 0 ]; then
                (( Value /= $scale ))
                (( Value -= Line ))             # decide whether print " " or "█"
                if [ $Value -le 0 ]; then 
                    echo -n "           " 
                elif [ $Value -gt 0 ]; then
                    echo -n " ██████████"
                fi
            else                                # Line <= 0, the bottom/last line
                (( half=$scale/2 ))
                # echo $half, $Value
                if [ $Value -le 0 ]; then
                    echo -n "           "
                elif [ $Value -lt $half ]; then
                    echo -n " __________"
                elif [ $Value -lt $scale ]; then
                    echo -n " ▄▄▄▄▄▄▄▄▄▄"        
                else
                    echo -n " ██████████"
                fi
            fi
        done < ./data.txt
        echo
    done
    echo
}


plot_bar $*

while IFS=" " read -r Key Value; do printf "%-11s" "     $Value"; done < ./data.txt
echo
while IFS=" " read -r Key Value; do printf "%-11s" "     $Key"; done < ./data.txt

echo
echo

<<HERE
declare -A Keys
while IFS=" " read -r key value; do
    Keys["$key"]=$value
done < ./data.txt

echo "${Keys[@]}"
exit
HERE
