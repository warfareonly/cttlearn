#/bin/sh

echo "Compiling JAR"
mvn compile assembly:single
echo "Compilation finished: benchmark.jar"
cp ./target/benchmarking-0.0.1-jar-with-dependencies.jar ./benchmark.jar
