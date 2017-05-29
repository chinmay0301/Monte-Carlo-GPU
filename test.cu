#include<time.h>
#include<stdlib.h>
#include<math.h>
#include<valarray>
using namespace std;

__global__ void pi(int seed, float *estimate) {

curandState_t state;
int tid = threadIdx.x + blockIdx.x*blockDim.x;
int points =0;
float x,y;
// 4000/6000 trials per thread 
curand_init(seed,tid,0,&state);
for (int i=0;i<6000;i++)
{
x = curand_uniform(&state);
y = curand_uniform(&state);   
if(x*x + y*y <=1.0) 
points++;
}
estimate[tid]=points*4.0/6000;
}

int main() {
  int blocks =300;
  int threads =300; 
  float estimate[threads*blocks];  
  float *dev_est;
  cudaMalloc( (void**) &dev_est,threads*blocks*sizeof(float));
  pi<<<threads,blocks>>>(time(NULL),dev_est);
  cudaMemcpy(estimate, dev_est, threads*blocks*sizeof(float), cudaMemcpyDeviceToHost);

  valarray<float> myvalarray(estimate,threads*blocks);
  float pi = myvalarray.sum()/float(threads*blocks);
  cout<<pi;
  return 0;
}

