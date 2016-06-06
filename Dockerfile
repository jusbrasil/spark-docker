FROM mesosphere/mesos:0.28.1

ENV SPARK_VERSION 1.6.1
ENV HADOOP_VERSION 2.6

# Update the base ubuntu image with dependencies needed for Spark
RUN apt-get update && \
    apt-get install -y python libnss3 openjdk-7-jre-headless curl

RUN mkdir -p /opt/spark && \
    curl http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    | tar -xzC /opt/spark/ && \
    mv /opt/spark/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark/dist

ENV SPARK_HOME /opt/spark/dist
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

WORKDIR ${SPARK_HOME}
