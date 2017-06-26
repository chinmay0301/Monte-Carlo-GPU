#include<cuda.h>
#include<curand_kernel.h>
#include<curand.h>
#include<stdio.h>
#include<cuda_runtime.h>
#include<Eigen/Eigen>
#include<iostream>
#include<time.h>
#include"math.h"
#include<algorithm>
#include<thrust/sort.h> 

using namespace std;
using namespace Eigen; 



__device__ double m_data[36] = {0,0,200,0,0,0,609,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
//__constant__ double m_data[36]; 

__device__ double S(int *arr) 

{
	double out =0; 
	for (int i=0; i<6; i++)
	{
		for(int j=0; j<=5-i; j++)
		{
			if(arr[i]!=arr[j])
				out += m_data[6*j +i]; 
		}
	}
		return out; 
}


__global__ void max_cut(int seed, double *p_arr, int *s, int *n1, int *n2, int *n3, int *n4, int *n5, int *n6) // n1,n2 etc are arrays of 1s, and 0s 
{

curandState_t state; 
int tid = threadIdx.x + blockIdx.x*blockDim.x;
curand_init(seed,tid,0,&state); 
int a[6], a_max[6];
int s_max=0; 
for(int i=0; i<100; i++) 
{
 a[0] = (curand_uniform(&state)<p_arr[0]) ? 1 : 0;
 a[1] = (curand_uniform(&state)<p_arr[1]) ? 1 : 0;
 a[2] = (curand_uniform(&state)<p_arr[2]) ? 1 : 0; 
 a[3] = (curand_uniform(&state)<p_arr[3]) ? 1 : 0; 
 a[4] = (curand_uniform(&state)<p_arr[4]) ? 1 : 0;
 a[5] = (curand_uniform(&state)<p_arr[5]) ? 1 : 0;


if(s_max<S(a))
{
	s_max = S(a); 
        for (int j=0; j<6; j++) 
		a_max[j] = a[j]; 
}

}
s[tid] = s_max;
n1[tid] = a_max[0];
n2[tid] = a_max[1];
n3[tid] = a_max[2];
n4[tid] = a_max[3];
n5[tid] = a_max[4];
n6[tid] = a_max[5];

__syncthreads(); 
}


int main()
{

	double arr_zero[6] = {0,0,0,0,0,0};
        MatrixXd m = MatrixXd::Zero(6,6); 
        
	int threads = 250;
	int blocks = 10; 
	m(0,1) = 100;
	m(2,3) = 150;
	m(4,1) = 20; 
        double err;    
	double *m_host_data = m.data();
	//double host_data[36]; 
	
//	for(int i=0; i<36; i++) 
   //        host_data[i] = m_host_data[i];       
//        double *m_test_data; 
       
  //   cudaMemcpyToSymbol("m_data", &host_data[0], sizeof(host_data), size_t(0), cudaMemcpyHostToDevice);
   //    cudaMemcpyFromSymbol(&m_test_data, "m_data", sizeof(m), cudaMemcpyDeviceToHost);        
       int *dev_out, *dev_n1, *dev_n2, *dev_n3, *dev_n4, *dev_n5, *dev_n6; 
       double *dev_p_arr; 
       int host_out[threads*blocks],host_n1[threads*blocks], host_n2[threads*blocks], host_n3[threads*blocks], host_n4[threads*blocks], host_n5[threads*blocks], host_n6[threads*blocks]; 
       int host_out1[threads*blocks]; 
       double p_arr[6]={0.5,0.5,0.5,0.5,0.5,0.5}; 
       double p[6]; 
       
       cudaMalloc( (void**)&dev_n1, sizeof(host_n1));
       cudaMalloc( (void**)&dev_n2, sizeof(host_n1));
       cudaMalloc( (void**)&dev_n3, sizeof(host_n1));
       cudaMalloc( (void**)&dev_n4, sizeof(host_n1));
       cudaMalloc( (void**)&dev_n5, sizeof(host_n1));
       cudaMalloc( (void**)&dev_n6, sizeof(host_n1));
       cudaMalloc( (void**)&dev_out, sizeof(host_n1));
       cudaMalloc( (void**)&dev_p_arr, sizeof(p_arr)); 
       
       for(int k=0; k<50; k++) 
       {

       cudaMemcpy(dev_p_arr, &p_arr, sizeof(p_arr), cudaMemcpyHostToDevice); 
       
       max_cut<<<blocks,threads>>>(time(NULL), dev_p_arr, dev_out, dev_n1, dev_n2, dev_n3, dev_n4, dev_n5, dev_n6);
       
       cudaMemcpy(&host_out, dev_out, sizeof(host_n1), cudaMemcpyDeviceToHost); 
       cudaMemcpy(&host_out1, dev_out, sizeof(host_n1), cudaMemcpyDeviceToHost); 
       cudaMemcpy(&host_n1, dev_n1, sizeof(host_n1), cudaMemcpyDeviceToHost);
       cudaMemcpy(&host_n2, dev_n2, sizeof(host_n1), cudaMemcpyDeviceToHost);
       cudaMemcpy(&host_n3, dev_n3, sizeof(host_n1), cudaMemcpyDeviceToHost);
       cudaMemcpy(&host_n4, dev_n4, sizeof(host_n1), cudaMemcpyDeviceToHost);
       cudaMemcpy(&host_n5, dev_n5, sizeof(host_n1), cudaMemcpyDeviceToHost);
       cudaMemcpy(&host_n6, dev_n6, sizeof(host_n1), cudaMemcpyDeviceToHost);
       
       thrust::sort_by_key(host_out, host_out+threads*blocks, host_n1); 
       memcpy(host_out, host_out1, sizeof(host_out)); 
       
       thrust::sort_by_key(host_out, host_out+threads*blocks, host_n2);
       memcpy(host_out, host_out1, sizeof(host_out));
       
       thrust::sort_by_key(host_out, host_out+threads*blocks, host_n3);
       memcpy(host_out, host_out1, sizeof(host_out));
       
       thrust::sort_by_key(host_out, host_out+threads*blocks, host_n4);
       memcpy(host_out, host_out1, sizeof(host_out));
       
       thrust::sort_by_key(host_out, host_out+threads*blocks, host_n5);
       memcpy(host_out, host_out1, sizeof(host_out));
       
       thrust::sort_by_key(host_out, host_out+threads*blocks, host_n6);
       memcpy(host_out, host_out1, sizeof(host_out));
       
       memcpy(p, p_arr, sizeof(p_arr)); 
       memcpy(p_arr, arr_zero, sizeof(arr_zero)); 
	        for(int i = 0.9*threads*blocks; i<threads*blocks; i++)
               {
		       p_arr[0]+= host_n1[i]/double(0.1*threads*blocks); 
		       p_arr[1]+= host_n2[i]/double(0.1*threads*blocks);
		       p_arr[2]+= host_n3[i]/double(0.1*threads*blocks);
		       p_arr[3]+= host_n4[i]/double(0.1*threads*blocks);
		       p_arr[4]+= host_n5[i]/double(0.1*threads*blocks);
                       p_arr[5]+= host_n6[i]/double(0.1*threads*blocks);
	       }
      	     
		err = 0; 
		for(int i=0;i<6;i++)
		     err += pow((p[i]-p_arr[i]),2);
	
		      if(sqrt(err)<1E-4)
		         break; 
		        else
	                cout<<err<<" "; 


		cout<<host_n1[threads*blocks-1]<< " "<<host_n2[threads*blocks-1]<<" "<<host_n3[threads*blocks-1]<<" "<<host_n4[threads*blocks-1]<<" "<<host_n5[threads*blocks-1]<<" "<<host_n6[threads*blocks-1]<<" "<<host_out[threads*blocks-1]<<"\n";
             cout<<p_arr[0]<<" "<<p_arr[1]<<" "<<p_arr[2]<<" "<<p_arr[3]<<" "<<p_arr[4]<<" "<<p_arr[5]<<"\n"; 
	       //cout<<host_data[i]<<" "; 
       }
       return 0;
}
