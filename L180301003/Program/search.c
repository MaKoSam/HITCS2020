#include <stdio.h>
#include <math.h>
#include <sys/time.h>

#define DIM  32
#define N  1000000

struct timeval start, end;

double dataSq[5];
double querySq[5];

int precalculate(double data[][DIM], int data_len, double query[][DIM], int query_len, int dim) {
    if(query_len > data_len)
    return 0;
    
    int i;
    int j;
    double summ;
    for(i = 0; i < data_len; i++) {
        summ = 0;
        for(j = 0; j < dim; j++) {
            summ += data[i][j] * data[i][j];
        }
        dataSq[i] = summ;
    }
    
    for(i = 0; i < query_len; i++) {
        summ = 0;
        for(j = 0; j < dim; j++) {
            summ += query[i][j] * query[i][j];
        }
        querySq[i] = summ;
    }
    
    return 1;
}

double cosine_likely(double x[], double y[], int dim) {
	double mx = 0, my = 0, s = 0;
	int i;
	for(i = 0; i < dim; i++) {
		mx += (x[i] * x[i]);
		my += (y[i] * y[i]);
		s  += x[i] * y[i];
	}
    
	if(mx < 1e-10 || my < 1e-10)
	  s = 0;
	else
	  s = s / sqrt(mx * my);
	return s;
}

//MARK: Search: return the position of the maximum score if the score > 0, orelse return -1;
int search(double data[][DIM], int data_len, double query[][DIM], int query_len) {
    if(query_len > data_len)
        return -1;
    
    double fMaxScore = 0;
    int i, j, iMaxPos = -1;
    double score;
    
    for(i = 0; i <= data_len - query_len; i++) {
        score = 0;
        for(j = 0; j < query_len; j++)
            score += cosine_likely(data[i + j], query[j], DIM);
        score /= query_len;
        if(score > fMaxScore) {
            //printf("i=%d score=%lf fMaxScore=%lf\n",i, score,fMaxScore);
            fMaxScore = score;
            iMaxPos = i;
        }
    }

	return iMaxPos;
}

typedef double(*ArrayPtrType)[DIM];

int main() {
	int data_len = 0, query_len = 0;
	double (*data)[DIM], (*query)[DIM], *p;
	int i, iPos = -1;
    bzero(&end, sizeof(end)); 
    bzero(&start, sizeof(start));  
	
	//--------- read data ------------------------  
	while(data_len < 1) {
		printf("data len: ");
		scanf("%d", &data_len);
	}
	
	data = (ArrayPtrType)malloc(data_len * DIM * sizeof(double));
	p=(double*)data;
	printf("Please input %d %1d-dimension data:\n", data_len, DIM) ;
	for(i = 0; i < data_len * DIM; i++)
	   scanf("%lf" ,p+i);

    printf("input data is:\n");
	for(i = 0; i < data_len * DIM; i++)
	   printf("%lf\t", p[i]);
	printf("\n");	 
	   
	//--------- read query ------------------------  
	while(query_len<1) {
		printf("query len: ");
		scanf("%d", &query_len);
	}	
	query = (ArrayPtrType)malloc(query_len * DIM * sizeof(double));
	p = (double*)query;
	printf("Please input %d %1d-dimension vectors:\n", query_len, DIM) ;
	for(i = 0; i < query_len * DIM; i++)
	   scanf("%lf", p + i);
	printf("input query is:\n");
	for(i = 0; i < query_len * DIM; i++)
	   printf("%lf\t", p[i]);
	printf("\n");
	
    //--------- search query in data ------------------------  	  
	printf("\nbegin search...\n");   
	if (precalculate(data, data_len, query, query_len, DIM) == 1) {
        iPos = search(data, data_len, query, query_len);
        if( iPos > -1)
            printf("Find query in data at pos: %d\n",iPos);
        else
            printf("Do not find query in data!\n");
    } else
        printf("Do not find query in data!\n");
	
    //MARK: Code for  speed test of search function
    dobule fScanTime;
    gettimeofday(&start, NULL);
    for(i = 1; i < N; i++) {
       iPos += search(data, data_len, query, query_len);
    }
    gettimeofday(&end, NULL);
    fScanTime = end.tv_sec - start.tv_sec + (end.tv_usec - start.tv_usec) * 0.000001;
    printf("\n\nspeed test finish, use time:%lfs\n\n", fSearchTime);
    
	free(data);
	free(query);
	return 0;
}

/*compile command in linux:
(1)create asm program .s
gcc search.c -S -lm -Og
(2)create executable prog
gcc search.c -o search -lm  -Og  
*/
