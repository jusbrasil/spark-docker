FROM ubuntu:14.04

ENV SPARK_VERSION 2.1.0
ENV HADOOP_VERSION 2.7
ENV SPARK_HOME /opt/spark/dist

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
    apt-get install -y python libnss3 openjdk-8-jre-headless

WORKDIR ${SPARK_HOME}
