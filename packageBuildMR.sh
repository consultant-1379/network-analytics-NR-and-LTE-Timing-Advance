#!/bin/bash
unset LS_COLORS
export PATH=/app/git/1.7.8/LMWP3/bin:$PATH
export M2_HOME=/proj/esjkadm100/tools/apache-maven-3.0.5
export PATH=$M2_HOME/bin:$PATH
module=$1
rstate=$2
product=$3
echo "$module"
echo "${rstate}"
echo "${product}"
#  added   comment
#  one more comment
function Arm104nexusDeploy {
	RepoURL=https://arm1s11-eiffel013.eiffel.gic.ericsson.se:8443/nexus/content/repositories/assure-releases	
	GroupId=com.ericsson.eniq.netanserver.dev
	ArtifactId=$module
	zipName=Ericsson-NR-and-LTE-Timing-Advance-Analysis
	
	echo "****"	
	echo "Deploying the zip /$zipName-19.4.zip as ${ArtifactId}${rstate}.zip to Nexus...."
        mv target/$zipName-19.4.zip target/${ArtifactId}.zip
	echo "****"	
  	mvn -B deploy:deploy-file \
	        	-Durl=${RepoURL} \
		        -DrepositoryId=assure-releases \
		        -DgroupId=${GroupId} \
		        -Dversion=${rstate} \
		        -DartifactId=${ArtifactId} \
		        -Dfile=target/${ArtifactId}.zip
		      
}
mvn package
Arm104nexusDeploy
rsp=$?
if [ $rsp == 0 ]; then
  git tag $product-$rstate
  git pull
  git push origin $product-$rstate 
fi
exit $rsp
