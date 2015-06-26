#!/bin/sh
clear
PRECDPATH=`dirname $0`
echo "$PRECDPATH"
cd $PRECDPATH
CURRENTPATHCMD=`pwd`
ls
TARGETPATH="$CURRENTPATHCMD"
cd ..
CURRENTPATH="$CURRENTPATHCMD"
echo "CURRENTPATH = $CURRENTPATH"
dir=$(ls -l $CURRENTPATH |awk '/^d/ {print $NF}')
ISVAILDPATH="FALSE"
RIGHT="ISTRUE"
TARGETNAME=""
for i in $dir
do
if [[ $i =~ \.xcodeproj$ ]]; then
ISVAILDPATH="ISTRUE"
TARGETNAME="${i%.*}"
echo "$TARGETNAME"
echo $i
fi
done

if [ $ISVAILDPATH != $RIGHT ]
then

echo "current path is invalid"
exit 1
fi
cd $TARGETPATH
xcodebuild -target $TARGETNAME -configuration Release -sdk iphonesimulator -arch i386 -arch x86_64
xcodebuild -target $TARGETNAME -configuration Release -sdk iphoneos -arch armv7 -arch armv7s -arch arm64
LIBTOOL_FLAGS="-static"
FWNAME="ASDK"
RELEASEIPHONEA="$TARGETPATH/build/Release-iphoneos"
RELEASESIMULATORA="$TARGETPATH/build/Release-iphonesimulator"
STATICLIBNAME="lib$TARGETNAME.a"
HEADPATH=""
echo "Creating ASDK.framework"
if [ -d "ASDK.framework" ]; then
echo "Removing previous ASDK.framework copy"
rm -rf "ASDK.framework"
fi
mkdir -p "ASDK.framework/Headers"
libtool -no_warning_for_no_symbols $LIBTOOL_FLAGS -o $FWNAME.framework/$FWNAME $RELEASEIPHONEA/$STATICLIBNAME $RELEASESIMULATORA/$STATICLIBNAME
cp -r $RELEASEIPHONEA/"include/$TARGETNAME"/* $FWNAME.framework/Headers/
echo "Created $FWNAME.framework"
LIPOCMD=`lipo -info $FWNAME.framework/$FWNAME`
echo "CPU Architecture: $LIPOCMD"
rm -rf "build"









