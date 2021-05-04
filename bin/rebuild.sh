cd /opt/zhizhiting-blog

echo 'start pull new contents ...'
git pull
echo 'pull end.'

echo 'start build contents ...'
cd /opt/zhizhiting-blog
hugo
echo 'build end.'

