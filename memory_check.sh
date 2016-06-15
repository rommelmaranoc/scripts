#!/bin/bash
#RommelP.Maranoc

mem() { echo "Parameters: $0 [-c >= 90] [-w >=60 or <90] [-e <Email>]" 1>&2; exit 0; }

opt()
{
echo -e "\n";
memory=$(free -m | awk 'NR==2{printf "%.0f",$3*100/$2 }');
echo -n " Option: ";
read Option;
        if [ "$Option" == "0" ]; then
                if [ "$memory" -lt "${w}" ]; then
                         exit 0;
                else
                        clear;
                        echo -e "\n*****Condition not Meet******";
                        opt

                fi
        elif [ "$Option" == "1" ]; then
                if [ "$memory" -ge "${w}" ] && [ "$memory" -lt "${c}" ]; then
                        exit 0;
                else
                        clear;
                        echo -e "\n*****Condition not Meet******";
                        opt

                fi
        elif [ "$Option" == "2" ]; then
                if [ "$memory" -ge "${c}" ] && [ "$memory" -le 100 ]; then
                        subj=$(date +"%Y%m%d %H:%M Memory Check-Critical");proc=$( ps aux --sort=-%mem | awk 'NR<=11{printf "\n%s\t%s\t%s\t%s\t%s\t%s\t%s",$1,$2,$3,$4,$5,$6,$11}');echo -e "Good day! Hi All, \n\nPlease see top 10 Process Running on this system. \nCurrent Memory usage is $memory% \n\n$proc \n\nThanks." > /root/scripts/usage.txt | mutt -s "$subj" -i  /root/scripts/usage.txt ${e} < /dev/null;
                        exit 0;
                else
                        clear;
                        echo -e "\n*****Condition not Meet******";
                        opt

                fi
        else
                clear;
                echo -e "\n*****Invalid Input******";
                echo -e " Input Paremeters:0,1,2 \n";
                opt

        fi
}


while getopts ":c:w:e:" o; do
    case "${o}" in
        c)
            c=${OPTARG}
            ;;
        w)
            w=${OPTARG}
                        ;;
         e)
           e=${OPTARG}
           ;;
        *)
            mem
            ;;
    esac
done



shift $((OPTIND-1))

if [ -z "${c}" ] || [ -z "${w}" ] || [ -z "${e}" ]; then
        clear;
        echo "*****Please follow parameter/format below*****";
        mem

elif [ "${c}" -ge 90 ] && [ "${w}" -ge 60 ] && [ "${w}" -lt 90 ] && [ "${c}" -le 100 ]; then
        clear;
        #echo "Critical: "${c}%;echo "Warning:  "${w}%;echo "Email:   " ${e};
                echo -e "\n *****Output******";
        critical=$(b=.01;c=${c};a=$(free -m | awk 'NR==2{printf $2}');crit=$(echo "scale=4; $a*($b*$c)" | bc);echo $crit mb;);warning=$(d=.01;e=${w};f=$(free -m | awk 'NR==2{printf $2}');warn=$(echo "scale=2; $f*($d*$e)" | bc);echo $warn mb;);echo " Critical: "$critical;echo " Warning:  "$warning;echo " Email:   " ${e};

                opt


else
        mem
fi
