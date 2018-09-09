SDL2_CFLAGS         := $(shell sdl2-config --cflags)
SDL2_LDFLAGS        := $(shell sdl2-config --libs)

COMMON_LIBRARIES     = -lstdc++ -lrt -lm
COMMON_HEADERS       = $(wildcard include/*.h)
COMMON_SOURCES       = $(wildcard src/*.cc)
COMMON_OBJECTS       = ${COMMON_SOURCES:.cc=.o}
COMMON_DEPENDENCIES  = ${COMMON_OBJECTS:.cc=.dep}
COMMON_INCLUDE_DIRS  = -I. -Iinclude
COMMON_LIBRARY_DIRS  = -Llibs
COMMON_WARNINGS      = -Wall
COMMON_CCFLAGS       = -std=c++11 -fstrict-aliasing -D__STDC_FORMAT_MACROS
COMMON_LDFLAGS       = 

TARGET1              = target1
TARGET1_MAIN         = main/target1.cc
TARGET1_WARNINGS     = ${COMMON_WARNINGS} -Wextra
TARGET1_LIBRARIES    = ${COMMON_LIBRARIES} ${SDL2_LDFLAGS}
TARGET1_CCFLAGS      = -ggdb ${COMMON_INCLUDE_DIRS} ${COMMON_CCFLAGS} ${SDL2_CFLAGS}
TARGET1_LDFLAGS      = ${COMMON_LDFLAGS} ${SDL2_LDFLAGS}
TARGET1_OBJECTS      = ${COMMON_OBJECTS} ${TARGET1_MAIN:.cc=.o}
TARGET1_DEPENDENCIES = ${COMMON_DEPENDENCIES} ${TARGET1_MAIN:.cc=.dep}

.PHONY: all clean distclean output

all:: ${TARGET1}

${TARGET1}: ${TARGET1_OBJECTS}
	${CC} ${LDFLAGS} ${TARGET1_LDFLAGS} -o $@ $^ ${TARGET1_LIBRARIES}

${TARGET1_OBJECTS}: %.o: %.cc ${TARGET1_DEPENDENCIES}
	${CC} ${CCFLAGS} ${TARGET1_CCFLAGS} -o $@ -c $<

${TARGET1_DEPENDENCIES}: %.dep: %.cc ${COMMON_HEADERS} Makefile
	${CC} ${CCFLAGS} ${TARGET1_CCFLAGS} -MM $< > $@

output:: ${TARGET1}

clean::
	rm -f *~ *.o *.dep src/*~ src/*.o src/*.dep main/*~ main/*.o main/*.dep ${TARGET1}

distclean:: clean ${TARGET1}

