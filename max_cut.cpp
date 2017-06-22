#include<iostream>
#include<math.h>
#include<random>
#include<algorithm> 
#include<Eigen/Eigen> 
#include<map>
#include<vector> 

using namespace std;
using namespace Eigen; 

map<double, vector<double> > row_list; 
map<double, vector<double> >:: iterator it;

MatrixXd m = MatrixXd::Zero(6,6); 


double S( int arr[])
{
	double out =0;
	for (int i=0; i<6; i++)
		for(int j=0; j<=5-i; j++)
		{
			if(arr[i]!=arr[j])
				out += m(i,j);
		}
return out; 
}


int main()
{   
        int N = 10000;
	m(0,1) = 609; 
        m(0,2) = 0;
     //	m(1,0) = 0;
//	m(1,2) = 0; 
	m(1,3) = 0;
	m(2,0) = 200;
	m(2,1) = 0;
//	m(2,3) = 150;
	m(5,3) = 0;
	m(5,4) = 0;
 
default_random_engine generator;
//bernoulli_distribution distribution(0.9);
int arr[6] = {1,0,1,0,1,0};
double p[6] = {0.5,0.5,0.5,0.5,0.5,0.5};
bernoulli_distribution dis1(p[0]);
bernoulli_distribution dis2(p[1]);
bernoulli_distribution dis3(p[2]);
bernoulli_distribution dis4(p[3]);
bernoulli_distribution dis5(p[4]);
bernoulli_distribution dis6(p[5]); 

MatrixXd n(N,6); 

for( int l=0;l<1000;l++)
{
 bernoulli_distribution dis1(p[0]);
 bernoulli_distribution dis2(p[1]);
 bernoulli_distribution dis3(p[2]);
 bernoulli_distribution dis4(p[3]);
 bernoulli_distribution dis5(p[4]);
 bernoulli_distribution dis6(p[5]);


for(long int i =0; i<N; i++)
{

  arr[0]= dis1(generator);
  arr[1]= dis2(generator);
  arr[2]= dis3(generator);
  arr[3]= dis4(generator);
  arr[4]= dis5(generator);
  arr[5] = dis6(generator);
  
  int x = S(arr); 
  
  for(int i=0; i<6; i++)
   row_list[x].push_back(arr[i]);
   

}

it = --row_list.end(); 
	//cout<<(*it).first<<" ";

double p_upd[6]={0,0,0,0,0,0}; 
//for(int j=0; j<(*it).second.size(); j++)
//{
  int p1=0, p2=1, p3=2, p4=3, p5=4, p6=5; 
  for(int k=0;k<(*it).second.size();k+=6)
  {	  p_upd[0]+=(*it).second[k+p1];
          p_upd[1]+=(*it).second[k+p2];
	  p_upd[2]+=(*it).second[k+p3];
	  p_upd[3]+=(*it).second[k+p4];
	  p_upd[4]+=(*it).second[k+p5];
	  p_upd[5]+=(*it).second[k+p6];
  }

//}	

for(int i=0; i<6; i++)
p_upd[i] = 6*p_upd[i]/double((*it).second.size()); 

for(int i=0; i<6; i++)
p[i]=p_upd[i]; 

for(int j=0; j<6; j++)
cout<<p_upd[j]<<" ";

cout<<(*it).first; 
cout<<"\n"; 
}
//cout<<"\n"<<(*it).second.size()<<((*it).first);
//it = row_list.begin(); 
//cout<<(*it).first<<" "<<(*it).second[0]<<(*it).second[1]<<(*it).second[2]<<(*it).second[3]<<(*it).second[4]<<(*it).second[5]; 
return 0; 
} 


