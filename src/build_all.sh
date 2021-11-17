#/bin/sh

echo "Compiling LearnLib jar"
cd cttlearning
chmod +x ./build.sh
sh ./build.sh
mv ./benchmark.jar ../.
echo "Compilation finished: LearnLib"
cd ..

echo "Compiling FSMlib"
cd FSMlib
make -j8 all
cp ./build/fsm_lib ../fsm_lib
echo "Commpilation finished: FSMlib"
