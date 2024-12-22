echo "Clean up"
rm -rf build/
sleep 3
echo "Creating build dir and changing the dir"
mkdir build && cd build
echo "Prepare"
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
echo "Build"
make -j$(nproc)
sleep 3
echo "Install"
sudo make install
echo "Run"
sleep 3
plasma-welcome
