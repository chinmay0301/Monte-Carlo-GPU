#include<iostream> 
#include<stdio.h>
#include<stdlib.h> 
#include<time.h>
#include<math.h> 
#include<ctime>
using namespace std; 


int main () {

long int n=300*300*6000;
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
cout<<"pi is roughly " <<pi;
return 0; 
}
