#include<iostream>

using namespace std;


void add (int a[], int b[], int c[])
{
   for (int i=0; i<1000; i++)
   c[i] = a[i] +b[i]; 
  

}


int main() {

int a[1000], b[1000], c[1000];
for ( int i=0; i<1000; i++)
{

 a[i] =i;
b[i] = i*i;

}

add(a,b,c); 

for (int i=0; i<1000; i++)
{
cout<<c[i]<<"\n";
}
return 0;
}
                                                                                                                                                                                                             

