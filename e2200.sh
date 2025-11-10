sudo pacman -S base-devel cmake git
git clone https://github.com/xmrig/xmrig.git
cd xmrig
mkdir build && cd build
cmake .. -DWITH_AVX=OFF -DWITH_AVX2=OFF
make
