#include <studio.h>
/**
 * Program Name: RecursiveMult.c
 * Author: Zuriel Garcia
 * Date: 4/7/2025
 * Purpose: This program accepts two user numbers. The first m multiplier, the second, the succesive number of i#terations n. It calculates multiplication 
 * using succesive addition iterations.
**/
int mult(int m, int n)
{
	if (n == 1)
		return m;
	else
		return m + Mult(m, n - 1);
}
int main()
{
	int m, n, result;
	
	printf("Enter the multiplier (m): \n");
	scanf("%d", &m);
	
	printf("Enter the number of additions (n): \n");
	scanf("%d", &n);

	if (n < 1)
	{
		printf("Number of additions (n) must be at least 1.\n");
		return 1;
	}

	result = Mult(m,n);
	
	printf("Result of %d x %d using successive additions is: %d\n, m, n, result ");

	return 0;
}


