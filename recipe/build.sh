#!/bin/sh

chmod -R +w .
autoreconf -vfi

export CC=${PREFIX}/bin/h4cc
export DYLD_FALLBACK_LIBRARY_PATH=${PREFIX}/lib
export CFLAGS="-fPIC $CFLAGS"

./configure --prefix=${PREFIX} \
            --build=${BUILD} \
            --host=${HOST} \
            --with-hdf4=${PREFIX} \
            --with-zlib=${PREFIX} \
            --with-jpeg=${PREFIX} \
            --enable-install-include

make -j${CPU_COUNT}
make install
make check

pushd include
make install-includeHEADERS
popd
