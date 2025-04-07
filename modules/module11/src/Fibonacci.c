#include <studio.h>
/**
 * Program Name: Fibonacci.c
 * Author: Zuriel Garcia
 * Date: 4/7/2025
 * Purpose: This program calculates the n-th Fibonacci number, baser on user input. C programmed.
**/
int Fibonacci(int n)
{
	if (n == 0)
	{
		return 0;
	}else{
		if (n == 1)
		{
			return 1;
		}else{
			return Fibonacci(n - 1) + Fibonacci(n - 2);
		}
	}
}
int main()
{
	int n;
	
	do{
		printf("Enter the position (n) of the Fibonacci sequence: \n");
		scanf("%d", &n);
		if (n < 0)
		{
			printf("Please enter a non-negative number!");
		}

	}while (n < 0)

	result = Fibonacci(n);
	
	printf("Fibonacci number at position %d is: %d\n", n, result);

	return 0;
}


