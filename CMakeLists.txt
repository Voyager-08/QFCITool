cmake_minimum_required(VERSION 3.21)

project(QFCITool VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Quick Qml QuickControls2 Svg)

qt_standard_project_setup()

qt_add_executable(QFCITool
    src/main.cpp
    src/AppController.cpp
    src/AppController.h
    resources.qrc
)

set_target_properties(QFCITool PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

target_link_libraries(QFCITool PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
    Qt6::Svg
)

target_include_directories(QFCITool PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

install(TARGETS QFCITool
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
