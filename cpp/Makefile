SOURCES=src/scan.cpp src/token.cpp src/main.cpp

all: clean
	mkdir -p bin
	g++ $(SOURCES) -o bin/calc

clean:
	rm -rf bin

debug: clean
	mkdir -p bin
	g++ $(SOURCES) -D debug -o bin/calc

run: all
	bin/calc