FROM ubuntu:latest
WORKDIR /code
ENV PORT 80

# RUN apt update && apt install -y gnupg gnupg2 gnupg1
# RUN echo "deb http://dk.archive.ubuntu.com/ubuntu/ bionic main universe" >> /etc/apt/sources.list
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

RUN apt update

### GCC and CMake
RUN apt install -y git cmake build-essential

### Eigen
RUN git clone https://gitlab.com/libeigen/eigen.git
RUN cd eigen && mkdir build_dir && cd build_dir && cmake ../ && make install

### Pangolin
RUN cd ../../
RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
RUN cd Pangolin \
    && sed -i -- 's/sudo//g' scripts/install_prerequisites.sh \
    && sed -i -- 's/PKGS_OPTIONS=()/PKGS_OPTIONS=(-y )/g' scripts/install_prerequisites.sh \
    && ./scripts/install_prerequisites.sh recommended \
    && cmake -DCMAKE_CXX_STANDARD=17 -B build && cmake --build build

### OpenCV 4.6.0
# RUN cd /code
# RUN apt install -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
# RUN apt install -y wget unzip
# RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip
# RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.x.zip
# RUN unzip opencv.zip && unzip opencv_contrib.zip
# RUN mkdir -p build && cd build
# RUN cmake -DOPENCV_EXTRA_MODULES_PATH=/code/opencv_contrib-4.x/modules -DCMAKE_CXX_STANDARD=14 /code/opencv-4.x
# RUN cmake --build .
# RUN make install

### GCC 6.0
# RUN apt install -y gcc-6 g++-6
# RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 6
# RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 6
# RUN update-alternatives --config gcc
# RUN update-alternatives --config g++

### Sophus
RUN cd /code
RUN git clone https://github.com/strasdat/Sophus
RUN cd Sophus && mkdir build && cd build \
    && cmake .. && cmake --build . && make install

### FMT
RUN cd /code
# RUN git clone https://github.com/fmtlib/fmt
# f441484 # issue-2746-intel
RUN git clone https://github.com/phprus/fmt
RUN cd fmt && git checkout bdfec1d \
    && mkdir build && cd build \
    && cmake .. && cmake --build . && make install

### FFmpeg
# RUN cd /code
# RUN git clone https://github.com/FFmpeg/FFmpeg.git
# RUN cd FFmpeg && ./configure --prefix=`pwd`/install \
#     --enable-pic --disable-doc --disable-static --enable-shared \
#     --enable-gpl --enable-nonfree --enable-postproc --disable-x86asm \
#     && make install -j4

### OpenCV 3.2.0
RUN cd /code
RUN apt-get install -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get install -y python3 python3-pip libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev
RUN apt install -y libdc1394-dev
RUN apt install -y software-properties-common
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" \
    && apt update && apt install -y libjasper1 libjasper-dev
RUN pip install numpy
RUN apt install -y wget unzip
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/refs/tags/3.2.0.zip
RUN unzip opencv.zip
RUN cd opencv-3.2.0 \
    && sed -i.bak 's/dumpversion/dumpfullversion/' cmake/OpenCVDetectCXXCompiler.cmake \
    && sed '21 {s/^/#/}' cmake/OpenCVCompilerOptions.cmake > cmake/_OpenCVCompilerOptions.cmake \
    && sed -i.bak '730s/char\* str/const char\* str/' modules/python/src2/cv2.cpp \
    && mv cmake/_OpenCVCompilerOptions.cmake cmake/OpenCVCompilerOptions.cmake \
    && mkdir build && cd build \
#    && PKG_CONFIG_PATH=/FFmpeg/install/lib/pkgconfig \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_CXX_STANDARD=14 -Wno-dev .. \
    -DWITH_FFMPEG=OFF \
# -DENABLE_PRECOMPILED_HEADERS=OFF 
#   && make opencv_modules -j4 && ldd lib/libopencv_videoio.so \
    && make -j4 && make install

### ORBSLAM2
# RUN rm -r build
RUN mkdir /code/ORBSLAM2
COPY . /code/ORBSLAM2
RUN cd /code/ORBSLAM2 && sh build.sh
