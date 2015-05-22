#!/bin/sh -ex

# Although zookeeper's ant build does have an 'rpm' target we roll our own
# because the destination directory for us is different (/opt/zookeeper-x.y.z)

export WORKSPACE=${WORKSPACE:-.}
export ALTISCALE_RELEASE=${ALTISCALE_RELEASE:-4.0.0}
export DATE_STRING=`date +"%Y%m%d%H%M"`
export INSTALL_DIR=${WORKSPACE}/install-${DATE_STRING}
export DESCRIPTION=${DESCRIPTION:-"Altiscale Zookeeper rpm"}

if [ -z "$ARTIFACT_VERSION" ]; then
  echo "Please define the ARTIFACT_VERSION. This is usually the version of the project you're trying to build"
  exit 1;
fi


# Create the base directory where fpm will be run
rm -rf ${INSTALL_DIR}/opt
mkdir --mode=0755 -p ${INSTALL_DIR}/opt

# Copy the tar.gz file (we expect zookeeper-x.y.z.tar.gz)
cp build/zookeeper-?.?.?.tar.gz ${INSTALL_DIR}/opt

#Untar the tarball
cd ${INSTALL_DIR}/opt
tar xvf zookeeper-?.?.?.tar.gz

#Run fpm to create the rpm
export RPM_NAME=alti-zookeeper-${ARTIFACT_VERSION}
fpm --verbose \
--maintainer ops@altiscale.com \
--vendor Altiscale \
--provides ${RPM_NAME} \
--description "${DESCRIPTION}" \
-s dir \
-t rpm \
-n ${RPM_NAME} \
-v ${ALTISCALE_RELEASE} \
--iteration ${DATE_STRING} \
--rpm-user root \
--rpm-group root \
-C ${INSTALL_DIR} \
opt
