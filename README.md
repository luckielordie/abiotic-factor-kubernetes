# Zomboid Docker

`docker run --rm --name zomboid -dit -p 16261:16261/udp -p 16262:16262/udp -v /zomboid_server/JTWZomboid:/root/Zomboid --mount type=bind,source=/home/ec2-user/steamapps,target=/home/steam/project_zomboid/steamapps luckielordie/zomboid:latest`
