git=`sh /etc/profile; which git`
build=`"$git" rev-list HEAD --count`

if [ $? != 0 ]; then
	echo "warning: Build number was not updated: Failed to get the number of git commits. Make sure the repository exists and has at least one commit in the current branch."
	exit 0
fi

infoPath="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
dsymInfoPath="${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}.dSYM/Contents/Info.plist"

setBuild() {
	echo "Setting build number in $infoPath"
	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $1" "$infoPath"
	if [ $? != 0 ]; then
		echo "error: Failed to set build number in $infoPath: $0"
		exit 1
	fi
	
	if [ -e dsymInfoPath ]; then
		echo "Setting build number in $dsymInfoPath"
		/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $1" "$dsymInfoPath"
		if [ $? != 0 ]; then
			echo "error: Failed to set build number in $dsymInfoPath: $0"
			exit 1
		fi
	fi
	
	echo "Build number set to $1"
}

if [ $CONFIGURATION = "Debug" ]; then
	branch=`"$git" rev-parse --abbrev-ref HEAD`
	setBuild "$build-$branch"
else
	setBuild $build
fi

