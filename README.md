# Phoromatic server in docker

Build docker:
```
docker build -t phoromatic .
```

You can run server with command:
```
docker run --name phoromatic -p 8089:8089 -p 8088:8088 -v ~/.phoronix-test-suite:/.phoronix-test-suite phoromatic:latest
```

To stop container use
```
docker stop phoromatic
```

To download cache test, add name to phoromatic_tests.txt and rebuild.
