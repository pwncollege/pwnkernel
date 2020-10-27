SOURCES = $(shell ls *.c | grep -v mod)
OBJECTS = $(patsubst %.c,%.o,$(SOURCES))

all: 
	echo $(OBJECTS)
	make -C ../linux-4.19.87 M=$(PWD) obj-m="$(OBJECTS)" modules

clean:
	make -C ../linux-4.19.87 M=$(PWD) obj-m="$(OBJECTS)" clean
