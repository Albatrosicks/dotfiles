bin/extras: extras.c | bin
	clang -std=c99 -O3 -F/System/Library/PrivateFrameworks/ -framework ApplicationServices -framework Carbon -framework SkyLight $< -o $@

bin:
	mkdir bin
