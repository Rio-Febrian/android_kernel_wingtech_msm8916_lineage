ROOT_DIR="$(dirname "$(pwd)")"
KERNEL_DIR=$(pwd)
ANYKERNEL_DIR=$ROOT_DIR/AnyKernel2_Pack
BINARY_DIR=$KERNEL_DIR/arch/arm/boot
ZIMAGE=$BINARY_DIR/zImage
DTB=$BINARY_DIR/dt.img
TEMP_DIR=$ROOT_DIR/temp
KERNEL_NAME=LateAutumn
OUTPUT_DIR=$ROOT_DIR/$KERNEL_NAME-Builds
VERSION_FILE=$OUTPUT_DIR/versioninfo
. $VERSION_FILE
echo "Creating anykernel zip.."
echo "Creating temporary directory.."
mkdir $TEMP_DIR
echo "Copying binaries.."
cp $ZIMAGE $TEMP_DIR/zImage
cp $DTB $TEMP_DIR/dtb
echo "Copying anykernel files.."
cp -r $ANYKERNEL_DIR/* $TEMP_DIR
cd $TEMP_DIR
MAJORVERSION=$majorversion
REVISION=$revision
MINORVERSION=$minorversion
TESTVERSION=$testversion
VERSION=$majorversion.$minorversion.$revision
echo -e "Build Type : \n1. Test\n2. Major upgrade\n3. Minor upgrade"
read -p "4. Revision upgrade : " istest
case $istest in
        [1]* )
	TESTVERSION=$( expr $TESTVERSION + 1)
	VERSION=$VERSION'-test'$TESTVERSION
	;;
	[2]* )
	MAJORVERSION=$( expr $MAJORVERSION + 1)
	MINORVERSION=0
	REVISION=0
	TESTVERSION=0
	;;
	[3]* )
	MINORVERSION=$( expr $MINORVERSION + 1)
	REVISION=0
	TESTVERSION=0
	;;
	[4]* )
	REVISION=$( expr $REVISION + 1)
	TESTVERSION=0
esac
if	[ $istest != 1 ]; then
	read -p "Build name : " name
	VERSION=$MAJORVERSION.$MINORVERSION.$REVISION'-'$name
fi
echo "Creating $VERSION zip.."
mkdir $OUTPUT_DIR
ZIP_LOC=$OUTPUT_DIR/$KERNEL_NAME-$VERSION.zip
zip -r9 $ZIP_LOC .
echo "Deleting temporary directory.."
rm -r $TEMP_DIR
echo "Flashable zip file created.."
echo "Updating version.."
rm $VERSION_FILE
echo "majorversion=$MAJORVERSION" > $VERSION_FILE
echo "minorversion=$MINORVERSION" >> $VERSION_FILE
echo "revision=$REVISION" >> $VERSION_FILE
echo "testversion=$TESTVERSION" >> $VERSION_FILE
echo "Version updated.."
