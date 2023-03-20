sudo docker run --name=signal-desktop   --security-opt seccomp=unconfined `#optional` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 3001:3000 \
  -v ~/.config/signal_container:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
guacamole_signal:latest
