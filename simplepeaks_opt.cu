#include<cuda.h> 
#include<curand_kernel.h> 
#include<curand.h>
#include<stdio.h>
#include<cuda_runtime.h> 
#include<Eigen/Eigen> 
#include<iostream> 
#include"math.h"
#include<time.h>  
#include<algorithm> 
#include<thrust/sort.h> 
using namespace std; 
using namespace Eigen; 


__device__ double S(float *x) {

double out = 3*pow((double)(1-x[0]),2)*exp(-pow((double)x[0],2) - pow((double)(x[1]+1),2)) - 10*(x[0]/5 - pow((double)x[0],3) - pow((double)x[1],5))*exp((double)-pow((double)x[0],2) - pow((double)x[1],2)) - 1/3*exp((double)-pow((double)(x[0]+1),2) -pow((double)x[1],2)); 

return out; 

} 

__global__ void math_tester(int seed, double *mu, double*sigma, double *x_0, double *x_1, double *sample) {

int tid = threadIdx.x + blockIdx.x*blockDim.x; 

double x0_ker, x1_ker, s_max;
double x0_max, x1_max; 
s_max = -500000; 

curandState_t state; 
curand_init(seed, tid, 0, &state); 
for (int i=0; i<320; i++)
{
 //curand_init(seed, tid, 0, &state); 
 x0_ker = curand_normal(&state)*sigma[0] + mu[0];
 x1_ker = curand_normal(&state)*sigma[1] + mu[1]; 
 float x[2] = {x0_ker, x1_ker};
 if(s_max < S(x)) 
 {
    s_max = S(x); 
    x0_max = x0_ker;
    x1_max = x1_ker; 
 }

}



//if (tid < 10240)
//{

//curand_init(seed, tid, 0, &state); 
//x_0[tid] = curand_normal(&state)*sigma[0] + mu[0]; 
//x_1[tid] = curand_normal(&state)*sigma[1] + mu[1];
//float x[2] = {x_0[tid], x_1[tid]}; 
sample[tid] = s_max;
x_0[tid] = x0_max;
x_1[tid] = x1_max;
//tid+= blockDim.x + gridDim.x;
//} 
__syncthreads();

}

int main () 

{


 int threads = 100;
 int blocks = 100;
double *dev_mu, *dev_sigma, *dev_x0, *dev_x1, *dev_sample; 

double mu[2]= {-3,-3};
double sigma[2] = {3,3};
double x0[threads*blocks];
double x1[threads*blocks]; 
double sample_0[threads*blocks]; 
double sample_1[threads*blocks]; 

cudaMalloc( (void**)&dev_mu, 2*sizeof(double)); 
cudaMalloc( (void**)&dev_sigma, 2*sizeof(double)); 
cudaMalloc( (void**)&dev_x0, threads*blocks*sizeof(double));
cudaMalloc( (void**)&dev_x1, threads*blocks*sizeof(double)); 
cudaMalloc( (void**)&dev_sample, threads*blocks*sizeof(double));

while ( max(sigma[0], sigma[1]) > 0.00001) 
{  

cudaMemcpy(dev_mu, &mu, 2*sizeof(double), cudaMemcpyHostToDevice);
cudaMemcpy(dev_sigma, &sigma, 2*sizeof(double), cudaMemcpyHostToDevice);

math_tester<<<blocks,threads>>>(time(NULL), dev_mu, dev_sigma, dev_x0, dev_x1, dev_sample); 

cudaMemcpy(&x0, dev_x0, threads*blocks*sizeof(double), cudaMemcpyDeviceToHost); 
cudaMemcpy(&x1, dev_x1, threads*blocks*sizeof(double), cudaMemcpyDeviceToHost);
cudaMemcpy(&sample_0, dev_sample, threads*blocks*sizeof(double), cudaMemcpyDeviceToHost); 
cudaMemcpy(&sample_1, dev_sample, threads*blocks*sizeof(double), cudaMemcpyDeviceToHost); 

double mu0=0, mu1=0, sigma0=0, sigma1=0; 

thrust::sort_by_key(sample_0, sample_0 + threads*blocks, x0);
thrust::sort_by_key(sample_1, sample_1 + threads*blocks, x1); 
for (int i=threads*blocks*0.9; i<threads*blocks; i++)
{
   mu0 += x0[i];
   mu1 += x1[i];
}

mu[0] = mu0/double((0.1*threads*blocks));
mu[1] = mu1/double((0.1*threads*blocks));
 

for ( int i =threads*blocks*0.9; i<threads*blocks; i++) 
 {
	 sigma0 += pow((x0[i]-mu[0]),2);
	 sigma1 += pow((x1[i]-mu[1]),2); 
 }
sigma[0] = sqrt(sigma0/double((0.1*threads*blocks))); 
sigma[1] = sqrt(sigma1/double((0.1*threads*blocks)));

cout<<sample_0[9]<<" "<<sigma[0]<<" "<<sigma[1]<<" "<<mu[0]<<" "<<mu[1]<<"\n"; 
}
return 0;
}










