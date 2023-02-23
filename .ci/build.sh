set -ex

source shared-ci/prepare-archlinux.sh

# See *depends in https://github.com/archlinuxcn/repo/blob/master/archlinuxcn/qtermwidget-git/PKGBUILD
pacman -S --noconfirm --needed git cmake lxqt-build-tools-git qt5-tools python-pyqt5 pyqt-builder sip python-installer

cmake -B build -S . \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_EXAMPLE=ON \
    -DQTERMWIDGET_USE_UTEMPTER=ON
make -C build
make -C build install

cd pyqt
CXXFLAGS="-I$PWD/../lib -I$PWD/../build/lib" LDFLAGS="-L$PWD/../build" sip-wheel --verbose
python -m installer --destdir="$pkgdir" *.whl
