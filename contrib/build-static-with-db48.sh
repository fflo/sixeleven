SIXELEVEN_ROOT=$(pwd)/..

# Pick some path to install BDB to, here we create a directory within the bitcoin directory
BDB_PREFIX="${SIXELEVEN_ROOT}/contrib/db48"
mkdir -p $BDB_PREFIX

# Fetch the source and verify that it is not tampered with
wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c
# -> db-4.8.30.NC.tar.gz: OK
tar -xzvf db-4.8.30.NC.tar.gz
# bugfix DB48 build: atomic error
patch db-4.8.30.NC/dbinc/atomic.h < db48-patch/atomic.patch

# Build the library and install to our prefix
cd db-4.8.30.NC/build_unix/
#  Note: Do a static build so that it can be embedded into the executable, instead of having to find a .so at runtime
../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$BDB_PREFIX
make install

# Configure Bitcoin Core to use our own-built instance of BDB
cd $SIXELEVEN_ROOT/src
make
