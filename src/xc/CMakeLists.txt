set(SOURCES
    exc_cor.f90
   )

add_library(${SALMON_XC_LIB} STATIC ${SOURCES})
add_dependencies(${SALMON_XC_LIB} ${SALMON_PARALLEL_LIB} ${SALMON_IO_LIB})
list(APPEND SALMON_LINK_LIBRARIES ${SALMON_XC_LIB})
set(SALMON_LINK_LIBRARIES ${SALMON_LINK_LIBRARIES} PARENT_SCOPE)
