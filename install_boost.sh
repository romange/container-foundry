#!/bin/bash
set -ex

BVER=1.84.0
BOOST=boost_${BVER//./_}   # replace all . with _

# For sake of boost install we always use g++.
export CXX=g++

install_boost() {
    mkdir -p /tmp/boost && pushd /tmp/boost
    
    if ! [ -d $BOOST ]; then
      url="https://archives.boost.io/release/${BVER}/source/$BOOST.tar.bz2"      
      echo "Downloading from $url"
      if ! [ -e $BOOST.tar.bz2 ]; then wget -nv ${url} -O $BOOST.tar.bz2; fi

      tar -xjf $BOOST.tar.bz2
    fi

    bootstrap_arg="--prefix=/opt/boost --with-libraries=context,header"
    cd $BOOST
    bootstrap_cmd=`readlink -f bootstrap.sh`

    echo "CXX compiler ${CXX}"
    echo "Running ${bootstrap_cmd} ${bootstrap_arg}"
    ${bootstrap_cmd} ${bootstrap_arg} || { cat bootstrap.log; return 1; }

    b2_args=(define=BOOST_COROUTINES_NO_DEPRECATION_WARNING=1 link=static variant=release
            ${B2_OPTS}
            threading=multi --without-test --without-math --without-log --without-locale --without-graph --without-wave
            --without-mpi --without-python --without-fiber --without-filesystem --without-iostreams
            --without-serialization --without-chrono --without-timer --without-regex --without-graph_parallel
            --without-url --without-program_options --without-date_time --without-json -j4)

    echo "Building targets with ${b2_args[@]}"
    ./b2 "${b2_args[@]}" \
    cxxflags="-std=c++14 -Wno-deprecated-declarations ${CXX_OPTS}" linkflags=${LINK_OPTS}

    ./b2 install "${b2_args[@]}" -d0
    popd
    rm -rf /tmp/boost
}

for ((i=1;i <= $#;));do
  ARG=${!i}
  case "$ARG" in
    --asan)
        CXX_OPTS='-fsanitize=address  -DBOOST_USE_ASAN'
        LINK_OPTS='-lasan'
        shift
        ;;
    --ucontext)
        B2_OPTS='context-impl=ucontext'
        shift
        ;;
    *)
     echo bad option "$ARG"
     exit 1
     ;;
  esac
done


install_boost