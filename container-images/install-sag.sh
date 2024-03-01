#!/bin/bash

# Required environment properties. Setup via Dockerfile
# _EMPOWER_USER
# _EMPOWER_PASSWORD
# _PROXY_HOST (optionaly. If set, the proxy is used)
# _PROXY_PORT (optionaly)

# Required files. Copied from git to via Dockerfile
# /tmp/licenseKey.xml
# /tmp/installer.script
# /tmp/support-patches.txt


###
# Download installer from empower
##
function downloadInstaller() {
  echo "***Downloading SAG installer from Empower..."
  if [[ -z "$_PROXY_HOST" ]]; then
    curl -o /tmp/installer.bin https://empowersdc.softwareag.com/ccinstallers/SoftwareAGInstaller20240105-Linux_x86_64.bin --
  else
    curl -o /tmp/installer.bin -x ${_PROXY_HOST}:${_PROXY_PORT} https://empowersdc.softwareag.com/ccinstallers/SoftwareAGInstaller20240105-Linux_x86_64.bin --
  fi
  chmod +x installer.bin
}


###
# Install products and fixes with SAG installer.
# Product list and fix list is defined in installer.script file.
##
function installProductsAndFixes() {
  echo "***Installing products and fixes..."

  # Change username and password in the installer.script file
  sed -i "s/^Username.*$/Username=${_EMPOWER_USER}/" /tmp/installer.script
  sed -i "s/^Password.*$/Password=${_EMPOWER_PASSWORD}/" /tmp/installer.script
  sed -i "s/^InstallDir.*$/InstallDir=\/opt\/softwareag/" /tmp/installer.script

  if [[ -z "$_PROXY_HOST" ]]; then
    ./installer.bin -readScript /tmp/installer.script -console
  else
    ./installer.bin -readScript /tmp/installer.script -console -proxyHost ${_PROXY_HOST} -proxyPort ${_PROXY_PORT}
  fi
}


###
# Read support-patch keys from support-patches.txt file.
# Install support patches one by one with SAG UpdateManager.
##
function installSupportPatches() {
  echo "***Installing support patches..."
  
  # read line by line from file /tmp/support-patches.txt. 
  # strip leading and trailing spaced
  # accept last line if terminating newline character is missing. Performed with: || [[ -n $line ]]
  while read -r line || [[ -n $line ]]
  do 
    # Ignore lines starting with #
    [[ ${line} =~ ^#.* ]] && continue
	
	# Ignore empty lines 
    [[ ${line} == "" ]] && continue

	SP_KEY=${line}
	
    # Build the sum.script file
    echo -e "installSP=y\nselectedFixes=${SP_KEY}.0.0.0001-0001\naction=Install fixes from Empower\ninstallDir=/opt/softwareag\ncombooption=Fix Management\ndiagnoserKey=${SP_KEY}" > /tmp/sum.script

    # Run the UpdateManager
    if [[ -z "$_PROXY_HOST" ]]; then
      /opt/softwareag/SAGUpdateManager/bin/UpdateManagerCMD.sh -empowerUser ${_EMPOWER_USER} -empowerPass ${_EMPOWER_PASSWORD} -readScript /tmp/sum.script
    else
      /opt/softwareag/SAGUpdateManager/bin/UpdateManagerCMD.sh -empowerUser ${_EMPOWER_USER} -empowerPass ${_EMPOWER_PASSWORD} -readScript /tmp/sum.script -proxyHost ${_PROXY_HOST} -proxyPort -proxyHost ${_PROXY_PORT} -proxyProtocol HTTP
    fi
  done < /tmp/support-patches
}


###
# Cleanup Filesystem
##
function cleanup() {
  echo "***Cleanup folder /tmp ..."
  rm -fr /tmp/*
  
  echo "Cleanup folder /opt/softwareag/IntegrationServer/replicate/archive ..."
  rm -fr /opt/softwareag/IntegrationServer/replicate/archive/*
}


downloadInstaller
installProductsAndFixes
installSupportPatches
cleanup