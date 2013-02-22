LOG="/var/log/rsnapshot.log"

date2stamp () {
    date --utc --date "$1" +%s
}

stamp2date (){
    date --utc --date "1970-01-01 $1 sec" "+%Y-%m-%d %T"
}

dateDiff (){
    case $1 in
        -s)   sec=1;      shift;;
        -m)   sec=60;     shift;;
        -h)   sec=3600;   shift;;
        -d)   sec=86400;  shift;;
        *)    sec=86400;;
    esac
    dte1=$(date2stamp $1)
    dte2=$(date2stamp $2)
    diffSec=$((dte2-dte1))
    if ((diffSec < 0)); then abs=3; else abs=1; fi
    echo $((diffSec/sec*abs))
}

function logThis {
        HOST="$1"
        mod="$2"
        output="$3"
        DATE=`date +%d/%b/%Y:%H:%M:%S`
        echo "[$DATE] $HOST - $mod: $output" >> $LOG
}
