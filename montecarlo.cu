#include<iostream>
#include<stdio.h>
#include<cuda.h>
#include<cuda_runtime.h>
#include<stdlib.h>
#include<time.h>
#include<math.h>
#include<ctime>
#include<curand.h> 
#include<curand_kernel.h> 

using namespace std;

__device__ long int n_ok[1]={3};

__global__ void pi (int seed, float *x, float *y) { 

curandState_t state;
int tid = threadIdx.x + blockIdx.x*blockDim.x; 
if(tid < 1000)
{
curand_init(seed,tid,0,&state); 
*x = curand_uniform(&state);
*y = curand_uniform(&state); 
if ((*x)*(*x) + (*y)*(*y)>=1)
n_ok[0]++;
}
}
int main () {

/*long int n=1000000000;
long int n_ok =0;
float x,y;

srand(time(0));

for (long int i=0;i<n;i++)
{
x = rand();
x = x/RAND_MAX;
//srand(time(0)); 
y = rand();
y = y/RAND_MAX;

if(sqrt(x*x + y*y) <=1)
n_ok++;
}
float pi = 4.0 * n_ok/n;
cout<<"pi is roughly " <<pi; */ 
long int * n_ok1 = new long int;
float *x = new float;
float *y = new float; 
float *dev_x, *dev_y;  
cudaMalloc( (void**)&dev_x, sizeof(float));
cudaMalloc( (void**)&dev_y, sizeof(float));
//cudaMalloc( (void**)&dev_n, sizeof(long int));    
pi<<<128,128>>>(time(NULL), dev_x, dev_y); 
cudaMemcpy(x, dev_x, sizeof(float), cudaMemcpyDeviceToHost); 
cudaMemcpy(y, dev_y, sizeof(float), cudaMemcpyDeviceToHost);
cudaMemcpyFromSymbol(n_ok1, "n_ok", sizeof(long int), cudaMemcpyDeviceToHost); 
cout<< *x<<" "<<*y<<" "<<*n_ok1 ; 
//cudaFree(dev_n); 
cudaFree(dev_x);
cudaFree(dev_y);
cudaFree(n_ok1);
return 0;
}                      
