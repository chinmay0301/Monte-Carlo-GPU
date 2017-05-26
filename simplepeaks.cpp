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

double S(MatrixXd x)
{
		double out = 3*pow((1-x(0,0)),2)*exp(-pow(x(0,0),2) - pow((x(0,1)+1),2)) - 10*(x(0,0)/5 - pow(x(0,0),3) - pow(x(0,1),5))*exp(-pow(x(0,0),2) - pow(x(0,1),2)) - 1/3*exp(-pow((x(0,0)+1),2) -pow(x(0,1),2));
		return out; 

}


int main() {

		MatrixXd m(100,2);  
		MatrixXd s_inp(1,2); 
		default_random_engine generator;  
		double rho = 0.1;
		double eps = 1E-5;
		int N=100;  
		double mu[2] ={-3,-3}; 
		double sigma[2]={3,3};
		double a[100][2] = {};
		double s[100]; 
		while(max(sigma[0],sigma[1]) > 0.00001) {
				normal_distribution<double> distribution_0(mu[0],sigma[0]);
				normal_distribution<double> distribution_1(mu[1],sigma[1]);
				for (long int i=0;i<100;i++)
				{
						m(i,0) = distribution_0(generator); 
						m(i,1) = distribution_1(generator);
						s_inp(0,0) = m(i,0); s_inp(0,1) = m(i,1);   
						s[i] = S(s_inp);
						row_list[s[i]].push_back(m(i,0));
						row_list[s[i]].push_back(m(i,1)); 
				}
				double mu0 =0; 
				double mu1 = 0;
				double sigma0 =0;
				double sigma1=0; 
				int j=0;  
				for (j = (1-rho)*N-1, it = --row_list.end(); j<N; ++j, --it)
				{
						mu0 += (*it).second[0]; 
						mu1 += (*it).second[1]; 
					//	cout<<(*it).first<<" "<<(*it).second[0]<<" "<<(*it).second[1]<<"\n" ; 
				} 

				mu0 = mu0/11.0;  
				mu1 = mu1/11.0; 
				
				for ( j = (1-rho)*N-1, it = --row_list.end(); j<N; ++j, --it)
			    {
						sigma0 += pow(((*it).second[0]-mu0),2); 
				        sigma1 += pow(((*it).second[1]-mu1),2); 
                
				}
				sigma0 = sqrt(sigma0/10.0);  
				sigma1 = sqrt(sigma1/10.0); 
				mu[0]=mu0;mu[1]=mu1;sigma[0]=sigma0;sigma[1]=sigma1; 
				cout<<mu0<<" "<<mu1<<" "<<sigma0<<" "<<sigma1<<"\n";

		}
	
		for ( it = row_list.begin(); it!= row_list.end(); it++) 

	 		{
					//cout<<(*it).first<<"\n"; 
			} 

		return 0; 
}
