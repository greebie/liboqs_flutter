cmake_minimum_required(VERSION 3.4.1)
add_library(liboqs SHARED IMPORTED)
set_target_properties(liboqs PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/liboqs.so)