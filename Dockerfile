FROM ubuntu:14.04

ENV MESOS_VERSION 0.28.2-2.0.27.ubuntu1404
ENV SPARK_VERSION 1.5.0
ENV HADOOP_VERSION 2.6
ENV SPARK_HOME /opt/spark/dist

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF
RUN echo "deb http://repos.mesosphere.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/mesosphere.list

# Install basic tools
RUN apt-get update && \
    apt-get install -y curl git

# Install Spark
RUN mkdir -p /opt/spark && \
    curl http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    | tar -xzC /opt/spark/ && \
    mv /opt/spark/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME}

# Install LZO
RUN apt-get update && \
    apt-get install -y openjdk-6-jdk liblzo2-dev maven build-essential && \
    git clone https://github.com/twitter/hadoop-lzo.git && \
    cd hadoop-lzo && \
    git checkout release-0.4.19 && \
    mvn package && \
    cp target/hadoop-lzo-0.4.19.jar $SPARK_HOME && \
    cp target/native/Linux-amd64-64/lib/libgplcompression.* $SPARK_HOME && \
    cd .. && rm -rf hadoop-lzo

# Update the base ubuntu image with dependencies needed for Spark
RUN apt-get update && \
    apt-get install -y python libnss3 openjdk-7-jre-headless mesos=${MESOS_VERSION}

ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

WORKDIR ${SPARK_HOME}
