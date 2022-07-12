FROM ubuntu:latest

WORKDIR /code

ENV PORT 80

RUN apt update && apt install -y git


RUN apt install -y cmake

RUN apt install -y build-essential


RUN git clone https://gitlab.com/libeigen/eigen.git

RUN cd eigen && mkdir build_dir && cd build_dir && cmake ../ && make install


RUN cd ../../

RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git

RUN cd Pangolin \
    && sed -i -- 's/sudo//g' scripts/install_prerequisites.sh \
    && sed -i -- 's/PKGS_OPTIONS=()/PKGS_OPTIONS=(-y )/g' scripts/install_prerequisites.sh \
    && ./scripts/install_prerequisites.sh recommended \
    && cmake -B build && cmake --build build


RUN cd /code

RUN apt install -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev

RUN apt install -y wget unzip

RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip

RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.x.zip

RUN unzip opencv.zip && unzip opencv_contrib.zip

RUN mkdir -p build && cd build

RUN cmake -DOPENCV_EXTRA_MODULES_PATH=/code/opencv_contrib-4.x/modules -DCMAKE_CXX_STANDARD=14 /code/opencv-4.x

RUN cmake --build .

RUN make install
