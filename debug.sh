echo "Configuring and building Thirdparty/DBoW2 ..."

cd Thirdparty/DBoW2
mkdir debug
cd debug
cmake .. -DCMAKE_BUILD_TYPE=Debug
make -j4

cd ../../g2o

echo "Configuring and building Thirdparty/g2o ..."

mkdir debug
cd debug
cmake .. -DCMAKE_BUILD_TYPE=Debug
make -j4

cd ../../../

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM2 ..."

mkdir debug
cd debug
cmake .. -DCMAKE_BUILD_TYPE=Debug
make -j4
