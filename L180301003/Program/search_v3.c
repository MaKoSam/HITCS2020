#include <stdio.h>
#include <math.h>
#include <sys/time.h>

#define N  1000000

struct timeval start, end;

double dataSq[6];
double querySq[6];

//MARK: - Precalculate()
void precalculate(int DIM, double data[][DIM], int data_len, double query[][DIM], int query_len) {
    int i, j;
    double dataSum, querySum;
    for(i = 0; i < data_len; i++) {
        if(i < query_len) {
            dataSum = 0;
            querySum = 0;
            
            for(j = 0; j < DIM; j++) {
                dataSum += data[i][j] * data[i][j];
                querySum += query[i][j] * query[i][j];
            }
            dataSq[i] = dataSum;
            querySq[i] = querySum;
            
        } else {
            dataSum = 0;
            
            for(j = 0; j < DIM; j++) {
                dataSum += data[i][j] * data[i][j];
            }
            dataSq[i] = dataSum;
        }
    }
    return;
}

double cosine_likely(double* x, double* y, int dim, double xy) {
	double s = 0;
	int i;
	for(i = 0; i < dim; i++) {
		s  += x[i] * y[i];
	}
	return s / sqrt(xy);
}

//MARK: - Search()
//      - Return the position of the maximum score if the score > 0, orelse return -1;
int search(int DIM, double data[][DIM], int data_len, double query[][DIM], int query_len) {
    int i, j;
    double score;
    double fMaxScore = 0;
    int iMaxPos = -1;
    
    for(i = 0; i <= data_len - query_len; i++) {
        score = 0;
        for(j = 0; j < query_len; j++) {
            if(!(dataSq[i + j] < 1e-10 || querySq[j] < 1e-10)) {
                score += cosine_likely(data[i + j], query[j], DIM, dataSq[i + j] * querySq[j]);
            }
        }
        
        score /= query_len;
        if(score > fMaxScore) {
            //printf("i=%d score=%lf fMaxScore=%lf\n",i, score,fMaxScore);
            fMaxScore = score;
            iMaxPos = i;
        }
    }

	return iMaxPos;
}

//typedef double(*ArrayPtrType)[32];

int main() {
    int DIM;
    printf("Input Data Size:");
    scanf("%d", &DIM);
    
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
	
	data = malloc(data_len * DIM * sizeof(double));
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
	query = malloc(query_len * DIM * sizeof(double));
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
    
    if(query_len > data_len) {
        printf("Do not find query in data!\n");
        return 0;
    }
    
    precalculate(DIM, data, data_len, query, query_len);
    
    iPos = search(DIM, data, data_len, query, query_len);
    if( iPos > -1)
        printf("Find query in data at pos: %d\n",iPos);
    else
        printf("Do not find query in data!\n");
	
    //MARK: Code for  speed test of search function
    double fScanTime;
    gettimeofday(&start, NULL);
    for(i = 1; i < N; i++) {
       iPos += search(DIM, data, data_len, query, query_len);
    }
    gettimeofday(&end, NULL);
    fScanTime = end.tv_sec - start.tv_sec + (end.tv_usec - start.tv_usec) * 0.000001;
    printf("\n\nspeed test finish, use time:%lfs\n\n", fScanTime);
    
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
