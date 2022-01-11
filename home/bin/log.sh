KEEP_LINES=4000
function create_log() {
    if [ -f $1 ]; then
        LOG=$(tail -n $KEEP_LINES $1 2>/dev/null) && echo "${LOG}" >$1
    fi
    exec > >(tee -a $1)
    exec 2>&1
}
function log() {
    echo "[$(date --rfc-3339=seconds)] $*"
}