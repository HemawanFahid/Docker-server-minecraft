This docker image provides a Minecraft Server that will automatically download the latest stable version at startup. You can also run/upgrade to any specific version or the latest snapshot.

To simply use the latest stable version, run
docker run -d -p 25565:25565 --name mc hemawan/minecraft-server

where the standard server port, 25565, will be exposed on your host machine.
