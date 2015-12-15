# If multiple threads have been set by the user also enable multithreaded nmake
IF(${THREADS} GREATER 1)
        SET(ENV{CL} "/MP")
ENDIF()

# Call nmake
EXECUTE_PROCESS(COMMAND nmake)

