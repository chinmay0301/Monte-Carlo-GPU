#include<iostream>
#include"math.h"
#include<Eigen/Eigen>
#include<map> 
#include<thrust/host_vector.h>
#include<thrust/host_vector.h>
#include<thrust/device_vector.h>
#include<thrust/generate.h>
#include<thrust/reduce.h>
#include<thrust/functional.h>
#include<algorithm>
#include<cstdlib>



using namespace std; 
using namespace Eigen; 

int main()

{
	 thrust::host_vector<int> h_vec(100);
	   std::generate(h_vec.begin(), h_vec.end(), rand);

	     // transfer to device and compute sum
	     thrust::device_vector<int> d_vec = h_vec;
	       int x = thrust::reduce(d_vec.begin(), d_vec.end(), 0, thrust::plus<int>());
	         
	
	
	
	cout<<" ummm.... "<<x; 
return 0;

}

