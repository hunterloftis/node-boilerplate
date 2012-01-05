# node upstart script
cat <<'EOF' > /etc/init/$project.conf 
description "$project server"

start on filesystem or runlevel [2345]
stop on runlevel [!2345]

respawn
respawn limit 10 5
umask 022

script
  HOME=/home/$deployer
  . $HOME/.profile
  exec /usr/local/bin/node $HOME/app/current/server.js >> /var/log/$project.log 2>&1
end script

post-start script
  PID=\`status $project | awk '/post-start/ { print $4 }'\`
  echo $PID > /var/run/$project.pid
end script

post-stop script
  rm -f /var/run/$project.pid
end script
EOF

start $project