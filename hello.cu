#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>
#include<curand.h>

using namespace std; 

__global__ void add(int*a, int*b, int*c) {

int tid = blockIdx.x;
 if(tid<1000) 
c[tid] = a[tid] + b[tid]; 

} 

int main(void) {

int a[1000], b[1000], c[1000]; 
int *dev_a, *dev_b, *dev_c;
cudaMalloc( (void**)&dev_a, 1000*sizeof(int));
cudaMalloc( (void**)&dev_b, 1000*sizeof(int));
cudaMalloc( (void**)&dev_c, 1000*sizeof(int)); 

for ( int i=0; i<1000; i++) 
{

 a[i] =i;
b[i] = i*i; 

} 

cudaMemcpy(dev_a, a, 1000*sizeof(int), cudaMemcpyHostToDevice);
cudaMemcpy(dev_b, b, 1000*sizeof(int), cudaMemcpyHostToDevice); 
add<<<1000,1>>>(dev_a, dev_b, dev_c); 
cudaMemcpy(c, dev_c, 1000*sizeof(int), cudaMemcpyDeviceToHost); 

for (int i=0; i<1000; i++) 
{
cout<<c[i]<<"\n"; 
}
return 0; 
}
