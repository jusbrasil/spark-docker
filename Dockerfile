FROM mesosphere/mesos:0.28.1

# Update the base ubuntu image with dependencies needed for Spark
RUN apt-get update && \
    apt-get install -y python libnss3 openjdk-7-jre-headless curl

RUN mkdir /opt/spark && \
    curl http://archive.apache.org/dist/spark/spark-1.5.0/spark-1.5.0-bin-hadoop2.6.tgz \
    | tar -xzC /opt
ENV SPARK_HOME /opt/spark
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so
