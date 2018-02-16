This project aims to have a Docker image of JMeter (currently version `4.0`, but this is customizable when building).

# Installation
```bash
git checkout https://github.com/iorga-group/jmeter-docker.git
cd jmeter-docker
```

Eventually, you can build the docker image this way:

```bash
docker-compose build
```

# Usage
In order to build & run without GUI a `.jmx` JMeter test you can do the following:

```bash
./build-and-run.sh ./path/to/my.jmx 01
```

It will generate the folder `run01` containing the rersults (`log.csv`), the log (`jmeter.log`) and the report folder (`report`).

Alternatively, you can run the previously built Docker image this way:

```bash
docker run -it --rm -u `id -u` -v "`pwd`:/workdir" iorga-group/jmeter bash
```

You will be able to use JMeter in the opened terminal
