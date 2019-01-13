#export JDK_HOME=""
#export JRE_HOME=""
#export ANT_HOME=""
#export MVN_HOME=""

if [ ! -z "${JDK_HOME}" ]; then
	export PATH=${JDK_HOME}/bin:${PATH}
fi

if [ ! -z "${ANT_HOME}" ]; then
	export PATH=${ANT_HOME}/bin:${PATH}
fi

if [ ! -z "${MVN_HOME}" ]; then
	export PATH=${MVN_HOME}/bin:${PATH}
fi
