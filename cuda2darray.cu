#include<stdio.h>
#include<cuda.h>
#include<cuda_runtime.h>
#include<device_launch_parameters.h>
#include<iostream>

using namespace std; 
//#define BLOCKSIZE_x 16
//#define BLOCKSIZE_y 16

//#define Nrows 3
//#define Ncols 5

/*****************/
/* CUDA MEMCHECK */
/*****************/
//#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }

/*inline void gpuAssert(cudaError_t code, char *file, int line, bool abort = true)
{
    if (code != cudaSuccess)
    {
      fprintf(stderr, "GPUassert: %s %s %dn", cudaGetErrorString(code), file, line);
      if (abort) {  exit(code); }
    }
}
*/
/*******************/
/* iDivUp FUNCTION */
/*******************/
//int iDivUp(int hostPtr, int b){ return ((hostPtr % b) != 0) ? (hostPtr / b + 1) : (hostPtr / b); }

/******************/
/* TEST KERNEL 2D */
/******************/
/*__global__ void test_kernel_2D(float *devPtr, size_t pitch)
{
   int tidx = blockIdx.x*blockDim.x + threadIdx.x;
   int tidy = blockIdx.y*blockDim.y + threadIdx.y;
   int arr[5] = {10,20,30,40,50}; 
   if ((tidx < Ncols) && (tidy < Nrows))
   {
       float *row_a = (float *)((char*)devPtr + tidy * pitch);
       row_a[tidx] = arr[tidx];
    }
}
*/
/********/
/* MAIN */
/********/
/*int main()
{
   float hostPtr[Nrows][Ncols];
   float *devPtr;
   size_t pitch;

   for (int i = 0; i < Nrows; i++)
   for (int j = 0; j < Ncols; j++) {
   hostPtr[i][j] = 1.f;
   //printf("row %i column %i value %f \n", i, j, hostPtr[i][j]);
}

// --- 2D pitched allocation and host->device memcopy
gpuErrchk(cudaMallocPitch(&devPtr, &pitch, Ncols * sizeof(float), Nrows));
gpuErrchk(cudaMemcpy2D(devPtr, pitch, hostPtr, Ncols*sizeof(float), Ncols*sizeof(float), Nrows, cudaMemcpyHostToDevice));

dim3 gridSize(iDivUp(Ncols, BLOCKSIZE_x), iDivUp(Nrows, BLOCKSIZE_y));
dim3 blockSize(BLOCKSIZE_y, BLOCKSIZE_x);

test_kernel_2D << <gridSize, blockSize >> >(devPtr, pitch);
gpuErrchk(cudaPeekAtLastError());
gpuErrchk(cudaDeviceSynchronize());

gpuErrchk(cudaMemcpy2D(hostPtr, Ncols * sizeof(float), devPtr, pitch, Ncols * sizeof(float), Nrows, cudaMemcpyDeviceToHost));

for (int i = 0; i < Nrows; i++)
   for (int j = 0; j < Ncols; j++)
      printf("row %i column %i value %f \n", i, j, hostPtr[i][j]);

return 0;

}*/ 

#define BLOCK_SIZE 16
#define GRID_SIZE 1
__global__ void YourKernel(int d_A[BLOCK_SIZE][BLOCK_SIZE], int d_B[BLOCK_SIZE][BLOCK_SIZE]){
	int row = blockIdx.y * blockDim.y + threadIdx.y;
	int col = blockIdx.x * blockDim.x + threadIdx.x;
//	if (row >= h || col >= w)return;
	d_B[row][col] = row-col; 
	d_A[row][col] = row+col; 
	/* whatever you wanna do with d_A[][] and d_B[][] */
}


int main(){
	int *d_A[BLOCK_SIZE][BLOCK_SIZE];
	int *d_B[BLOCK_SIZE][BLOCK_SIZE];

	int a[16][16];
	int b[16][16];
	/* d_A initialization */
        cudaMalloc( (void**)&d_A, 256*sizeof(int));
	cudaMalloc( (void**)&d_B, 256*sizeof(int));

	dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE); // so your threads are BLOCK_SIZE*BLOCK_SIZE, 256 in this case
	dim3 dimGrid(GRID_SIZE, GRID_SIZE); // 1*1 blocks in a grid
         
	YourKernel<<<dimGrid, dimBlock>>>(d_A,d_B); //Kernel invocation
        cudaMemcpy(a, d_A, 256*sizeof(int), cudaMemcpyDeviceToHost);
	cudaMemcpy(b, d_B, 256*sizeof(int), cudaMemcpyDeviceToHost); 
         
	 
	for(int i=0;i<16;i++)
		for(int j=0; j<16;j++)
			cout<<a[i][j]<<" "; 
        return 0; 
}
