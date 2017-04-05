SOURCES=src/scan.cpp src/token.cpp src/main.cpp

all: clean
	mkdir -p bin
	g++ $(SOURCES) -o bin/calc

clean:
	clear
	rm -rf bin

debug: clean
	mkdir -p bin
	g++ $(SOURCES) -D DEBUG -o bin/calc

run-debug: debug
	bin/calc

run: all
	bin/calc