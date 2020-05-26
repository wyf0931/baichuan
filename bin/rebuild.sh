cd /opt/zhizhiting-blog

echo 'start pull new contents ...'
git pull

echo 'start build contents ...'
hugo >> /opt/zhizhiting-blog/log/crontab-task.log 2&1
echo 'build end.'

