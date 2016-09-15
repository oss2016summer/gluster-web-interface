#include <cstdio>
#include <cstring>
#define max(a,b) ((a)<(b)?(b):(a))

int main()
{
	int counter[10] = {0};
	char number[100];

	scanf("%s", number);

	int len = strlen(number);
	for(int i = 0; i <len; i++) 
		counter[number[i] - 48]++;

	while(counter[6] < counter[9])
	{
		counter[6]++;
		counter[9]--;
	}

	while(counter[9] < counter[6])
	{
		counter[6]--;
		counter[9]++;
	}

	int sol = 0;
	for(int i = 0; i < 10; i++)
		if(sol < counter[i]) sol = counter[i];

	printf("%d\n", sol);
}
