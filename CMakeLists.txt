cmake_minimum_required(VERSION 3.16)
project(QSabotage VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Multimedia)
find_package(Python3 REQUIRED COMPONENTS Interpreter)

set(SOUND_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/sounds/fire.wav
    ${CMAKE_CURRENT_SOURCE_DIR}/sounds/explosion.wav
    ${CMAKE_CURRENT_SOURCE_DIR}/sounds/heli_hum.wav
    ${CMAKE_CURRENT_SOURCE_DIR}/sounds/splat.wav
)

add_custom_command(
    OUTPUT ${SOUND_FILES}
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/generate_sounds.py
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/generate_sounds.py
    COMMENT "Generating placeholder sound effects"
)

add_custom_target(generate_sounds DEPENDS ${SOUND_FILES})

qt_add_executable(QSabotage main.cpp)

qt_add_qml_module(QSabotage
    URI QSabotage
    VERSION 1.0
    QML_FILES
        main.qml
        Turret.qml
        Helicopter.qml
        Paratrooper.qml
        Explosion.qml
    RESOURCES
        sounds/fire.wav
        sounds/explosion.wav
        sounds/heli_hum.wav
        sounds/splat.wav
)

add_dependencies(QSabotage generate_sounds)

target_link_libraries(QSabotage PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Multimedia
)
