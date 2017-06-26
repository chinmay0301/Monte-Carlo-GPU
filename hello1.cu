#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>
#include<map> 
#include<vector> 
using namespace std;


__global__ void add(int *a, int *b) {

map <double, vector<double> > row_list; 
int tid = blockIdx.x; 
row_list[tid].push_back(a[tid]);
row_list[tid].push_back(b[tid]); 
 

}



int main
(void) { 

int a[1000], b[1000]; 
int *dev_a, *dev_b; 
cudaMalloc( (void**)&dev_a, sizeof(a));
cudaMalloc( (void**)&dev_b, sizeof(b)); 

for (int i=0; i<1000; i++) 
{

 a[i] = i; 
 b[i] = i*i; 

} 

cudaMemcpy(dev_a, a, sizeof(a), cudaMemcpyHostToDevice); 
cudaMemcpy(dev_b, b, sizeof(b), cudaMemcpyHostToDevice); 

//add<<<1000,1>>>(dev_a, dev_b); 

return 0; 

}
