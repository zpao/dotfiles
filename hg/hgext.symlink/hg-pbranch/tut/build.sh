#! /bin/bash

homedir=$HOME
rootdir=`pwd`
workdir=/tmp/hg-tut-$USER

export HGPATH=$rootdir/..
export HGRCPATH=$workdir/.hgrc
export HOME=$workdir

rm -rf $workdir
rm -rf build/
mkdir -p $workdir
mkdir -p build/ref/
cp -r src build/src

for f in $@; do
	mkdir -p build/bash/${f%/*}
	mkdir -p build/ref/${f%/*}
	mkdir -p build/src/${f%/*}
	( cd $workdir; python $rootdir/docbash.py $rootdir/{src,build/src,build/ref}/$f.rextile $rootdir/build/bash/$f.sh )
	diff  \
		-I "[	 ]\+Message-Id: .*$" \
		-I "[	 ]\+In-Reply-To: .*$" \
		-I "[	 ]\+References: .*$" \
		-I "[	 ]\+User-Agent: .*$" \
		-I "[	 ]\+Date: .*$" \
		{src,build/ref}/$f.rextile
	if [ "$?" -ne "0" ]; then
		dis meld {src,build/ref}/$f.rextile
	fi
done

mkdir -p build/doc/
( cd build/src; rextile )
find build/doc/ -name "*.htm" | xargs sed -e "s/^_//" -i
cp -t build/doc/ src/*.css

