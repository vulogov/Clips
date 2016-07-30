all: Clips.so

Clips.so:
	python setup.py build

clean:
	rm -f clipssrc/*.o
	rm -rf build
	rm src/clips.c

