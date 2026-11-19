function audit-all --description 'Each image the given hosts started containers from, with its first start'
    # audit-all HOST... [--since WHEN] [--until WHEN]
    #   HOST     SSH targets (e.g. aliases from ~/.ssh/config)
    #   --since  passed to journalctl, e.g. "2026-05-07" or "2 days ago"; --until likewise
    argparse --min-args 1 since= until= -- $argv; or return
    set -l prog '/container start/ && match($0,/[ ,]image=[^ ,)]+/){img=substr($0,RSTART+7,RLENGTH-7); if(!(img in seen)){seen[img]=1; print $4","$6","img}}'
    set -l remote "journalctl -u docker-events-start.service"
    set -q _flag_since; and set remote "$remote --since '$_flag_since'"
    set -q _flag_until; and set remote "$remote --until '$_flag_until'"
    set remote "$remote | awk '$prog'"

    # Query every host at once, then print them in the order given.
    set -l tmp (mktemp -d)
    for h in $argv
        ssh $h $remote >$tmp/$h &
    end
    wait
    begin
        echo server_name,start_date,image_name,ssh_host
        for h in $argv
            while read -l line
                set -l f (string split , -- $line)
                set -l start (TZ=America/Indiana/Indianapolis date -d $f[2] '+%Y-%m-%d %H:%M:%S %Z')
                echo "$f[1],$start,$f[3],$h"
            end <$tmp/$h
        end
    end | column -t -s ,
    rm -r $tmp
end
