# Pass string as first param, for example: "%02d:%02d:%02d"
function stopwatch() {
    local BEGIN=$(date +%s)
    KEY=""
    while true; do
        local NOW=$(date +%s)
        local DIFF=$(($NOW - $BEGIN))
        local MINS=$(($DIFF / 60))
        local SECS=$(($DIFF % 60))
        local HOURS=$(($DIFF / 3600))
        local DAYS=$(($DIFF / 86400))
        printf "\r$1" $HOURS $MINS $SECS
        read -t 1 -n 1 -s KEY
        [[ $KEY != "" ]] && break
    done
}
