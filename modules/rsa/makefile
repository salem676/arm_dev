ALL: CelsiusToFahrenheit InchesToFt KilometersPerHour Miles2Kilometers
LIB=libConversions.o
CC=gcc

CelsiusToFahrenheit: CelsiusToFahrenheit.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@
InchesToFt: InchesToFt.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@
KilometersPerHour: KilometersPerHour.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@
Miles2Kilometers: Miles2Kilometers.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@
.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
