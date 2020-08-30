if(NOT IDF_PATH)
    message(FATAL_ERROR "IDF_PATH not set.")
endif()
include("${IDF_PATH}/tools/cmake/utilities.cmake")

execute_process(COMMAND bash -c "sshpass -p 'alarm' rsync -aAXv --delete /home/alarm/evolutor 10.0.0.6:/home/alarm/ && \
    sshpass -p 'alarm' ssh 10.0.0.6 \"bash -i -c 'cd ${WORKING_DIRECTORY} && ${CMD}'\""
    RESULT_VARIABLE result
    )

if(${result})
    # No way to have CMake silently fail, unfortunately
    message(FATAL_ERROR "${TOOL} failed")
endif()
