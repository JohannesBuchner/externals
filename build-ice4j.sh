GROUPID=com.google.code.ice4j
ARTIFACTID=ice4j
SVNURL=http://ice4j.googlecode.com/svn/trunk/

if [ ! -e $ARTIFACTID ]; then
	echo svn checkout ...
	svn checkout $SVNURL $ARTIFACTID
fi
pushd $ARTIFACTID || exit 1
echo svn up ...
svn up

VERSION=$(svn info|grep Revision:|sed 's,Revision: \([0-9]*\),\1,g')

echo building version $VERSION ...
ant || exit 1


[ -s $ARTIFACTID.jar ] || exit 1

echo installing locally ...

mvn install:install-file -Dfile=$ARTIFACTID.jar -DgroupId=$GROUPID -DartifactId=$ARTIFACTID -Dversion=svn-$VERSION -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true || exit 1
echo deploying remotely ...
mvn deploy:deploy-file -Dfile=$ARTIFACTID.jar -DgroupId=$GROUPID -DartifactId=$ARTIFACTID -Dversion=svn-$VERSION -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -DrepositoryId=sourceforge -Durl=sftp://frs.sourceforge.net:/home/frs/project/j/ja/jakeapp/releases || exit 1

