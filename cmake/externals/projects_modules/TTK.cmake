##############################################################################
#
# medInria
#
# Copyright (c) INRIA 2013. All rights reserved.
# See LICENSE.txt for details.
# 
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
##############################################################################

function(TTK_project)
set(ep TTK)


## #############################################################################
## List the dependencies of the project
## #############################################################################

list(APPEND ${ep}_dependencies 
  ITK 
  VTK
  )
  
  
## #############################################################################
## Prepare the project
## #############################################################################

EP_Initialisation(${ep} 
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIRED_FOR_PLUGINS ON
  )



if (NOT USE_SYSTEM_${ep})
## #############################################################################
## Set directories
## #############################################################################

EP_SetDirectories(${ep}
  EP_DIRECTORIES ep_dirs
  )


## #############################################################################
## Define repository where get the sources
## #############################################################################

set (url "svn://scm.gforge.inria.fr/svnroot/ttk/trunk")

if (NOT DEFINED ${ep}_SOURCE_DIR)
  set(location SVN_REPOSITORY ${url})
endif()

execute_process(COMMAND svn info ${url}
  COMMAND grep "^Revision" 
  OUTPUT_VARIABLE SHA1
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )

set(${ep}_SHA1 ${SHA1} PARENT_SCOPE)

## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

# set compilation flags
if (UNIX)
  set(${ep}_c_flags "${${ep}_c_flags} -Wall")
  set(${ep}_cxx_flags "${${ep}_cxx_flags} -Wall")
endif()

set(cmake_args
  ${ep_common_cache_args}
  -DCMAKE_C_FLAGS:STRING=${${ep}_c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${${ep}_cxx_flags}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep}}    
  -DITK_DIR:FILEPATH=${ITK_DIR}
  -DVTK_DIR:FILEPATH=${VTK_DIR}
  -DBUILD_TESTING:BOOL=OFF  
  )


## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep}
  ${ep_dirs}
  ${location}
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  DEPENDS ${${ep}_dependencies}
  INSTALL_COMMAND ""    
  )
  
  
## #############################################################################
## Set variable to provide infos about the project
## #############################################################################

ExternalProject_Get_Property(TTK binary_dir)
set(${ep}_DIR ${binary_dir} PARENT_SCOPE)

endif()

endfunction()
