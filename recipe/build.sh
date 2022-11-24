#!/bin/sh

chmod -R +w .
autoreconf -vfi

export DYLD_FALLBACK_LIBRARY_PATH=${PREFIX}/lib
export CFLAGS="-fPIC $CFLAGS"

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 && $target_platform == "osx-arm64" ]]; then
    export he2_cv_f2cFortran_defined=no
    export he2_cv_32ptr=no
    export he2_cv_szlib_functional=no
    export he2_cv_szlib_can_encode=no
    export he2_cv_hdf4_szip_can_decode=no
    export he2_cv_hdf4_szip_can_encode=no
fi

./configure --prefix=${PREFIX} \
            --build=${BUILD} \
            --host=${HOST} \
            --with-hdf4=${PREFIX} \
            --with-zlib=${PREFIX} \
            --with-jpeg=${PREFIX} \
            --enable-install-include

make -j${CPU_COUNT}
make install
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check
fi

pushd include
make install-includeHEADERS
popd
