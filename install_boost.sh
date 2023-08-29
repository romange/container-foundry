#!/bin/bash
set -ex

BVER=1.74.0
BOOST=boost_${BVER//./_}   # replace all . with _

# For sake of boost install we always use g++.
export CXX=g++

install_boost() {
    mkdir -p /tmp/boost && pushd /tmp/boost
    if ! [ -d $BOOST ]; then
      url="https://boostorg.jfrog.io/artifactory/main/release/${BVER}/source/$BOOST.tar.bz2"
      echo "Downloading from $url"
      if ! [ -e $BOOST.tar.bz2 ]; then wget -nv ${url} -O $BOOST.tar.bz2; fi

      tar -xjf $BOOST.tar.bz2
    fi

    booststap_arg="--without-libraries=graph_parallel,graph,wave,test,mpi,python,fiber,filesystem"
    cd $BOOST
    boostrap_cmd=`readlink -f bootstrap.sh`

    echo "CXX compiler ${CXX}"
    echo "Running ${boostrap_cmd} ${booststap_arg}"
    ${boostrap_cmd} ${booststap_arg} || { cat bootstrap.log; return 1; }
    b2_args=(define=BOOST_COROUTINES_NO_DEPRECATION_WARNING=1 link=static variant=release
            threading=multi --without-test --without-math --without-log --without-locale --without-graph --without-wave --without-mpi --without-python --without-fiber --without-filesystem --without-iostreams --without-serialization --without-chrono --without-timer --without-regex -j4)

    echo "Building targets with ${b2_args[@]}"
    ./b2 "${b2_args[@]}" cxxflags='-std=c++14 -Wno-deprecated-declarations'
    ./b2 install "${b2_args[@]}" -d0
    popd
    rm -rf /tmp/boost
}

install_boost 