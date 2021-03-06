#!/usr/bin/env sh

################################################################################
# File: checkout_data_files.sh
#
# The purpose of this script is to obtain lookup tables used by the WRF physics
#   packages. At present, the only method for acquiring these tables is through
#   the MPAS-Dev github repository using either git, svn, or curl.
#
# If none of the methods used in this script are successful in acquiring the 
#   tables, please attempt to manually download the files from the MPAS-Data 
#   repository at www.github.com/MPAS-Dev/MPAS-Data/. All *.TBL and *.DBL files
#   should be copied into a subdirectory named 
#   src/core_atmosphere/physics/physics_wrf/files before continuing the build
#   process.
#
# If all else fails, please contact the MPAS-A developers 
#   via "mpas-atmosphere-help@googlegroups.com".
#
################################################################################

if [ -s physics_wrf/files/CAM_ABS_DATA.DBL ]; then
   echo "*** WRF physics tables appear to already exist; no need to obtain them again ***"
   exit 0
fi


#
# Try using 'git'
#
which git
if [ $? == 0 ]; then
   echo "*** trying git to obtain WRF physics tables ***"
   git clone git://github.com/MPAS-Dev/MPAS-Data.git
   if [ $? == 0 ]; then
      mv MPAS-Data/atmosphere/physics_wrf/files physics_wrf/
      rm -rf MPAS-Data
      exit 0
   else
      echo "*** failed to obtain WRF physics tables using git ***"
   fi
else
   echo "*** git not in path ***"
fi


#
# Try using 'svn'
#
which svn
if [ $? == 0 ]; then
   echo "*** trying svn to obtain WRF physics tables ***"
   svn checkout --non-interactive --trust-server-cert https://github.com/MPAS-Dev/MPAS-Data.git
   if [ $? == 0 ]; then
      mv MPAS-Data.git/trunk/atmosphere/physics_wrf/files physics_wrf/
      rm -rf MPAS-Data.git
      exit 0
   else
      echo "*** failed to obtain WRF physics tables using svn ***"
   fi
else
   echo "*** svn not in path ***"
fi


#
# Try using 'curl'
#
which curl
if [ $? == 0 ]; then
   echo "*** trying curl to obtain WRF physics tables ***"
   curl -o master.zip https://codeload.github.com/MPAS-Dev/MPAS-Data/zip/master
   if [ $? == 0 ]; then
      which unzip
      if [ $? == 0 ]; then
         unzip master.zip
         mv MPAS-Data-master/atmosphere/physics_wrf/files physics_wrf/
         rm -rf master.zip MPAS-Data-master
         exit 0
      else
         echo "*** unzip not in path -- unable to unzip WRF physics tables"
         rm -f master.zip
      fi
   else
      echo "*** failed to obtain WRF physics tables using curl ***"
   fi
else
   echo "*** curl not in path ***"
fi


echo "***************************************************************"
echo "Unable to obtain WRF physics tables using git, svn, or curl."
echo "This may be because 'git', 'svn', and 'curl' are not installed,"
echo "or it could be due to network connectivity problems."
echo " "
echo "Please see src/core_atmosphere/physics/checkout_data_files.sh"
echo "for suggestions on how to remedy this issue."
echo "***************************************************************"

exit 1
