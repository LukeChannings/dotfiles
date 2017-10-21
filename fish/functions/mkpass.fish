function mkpass
    set -x 'LC_ALL' 'C'
    cat /dev/random | tr -dc '[:alnum:]' | head -c 40
end
