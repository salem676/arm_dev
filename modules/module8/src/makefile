libConversions: libConversions.s
	gcc libConversions.s -g -c -o libConversions.o
	gcc main.s libConversions.o -g -o main
	gcc Miles2Kilometers.s libConversions.o -g -o Miles2Kilometers
	gcc KilometersPerHour.s libConversions.o -g -o KilometersPerHour
	gcc InchesToFt.s libConversions.o -g -o InchesToFt
