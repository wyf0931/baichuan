while true; do
    if [[ "$(inotifywatch -r -t 5 -e modify,create,move,delete /opt/zhizhiting-blog 2>&1)" =~ filename ]]; then
	cd /opt/zhizhiting-blog;
    	hugo;
    fi;
done
