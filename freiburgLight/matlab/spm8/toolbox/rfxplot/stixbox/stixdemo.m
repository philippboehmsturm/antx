%STIXDEMO Demonstrate various stixbox routines.

%       Anders Holtsberg, 25-11-94
%       Copyright (c) Anders Holtsberg

hold off
subplot(111)
echo on
clc
%	==========================================================
%	STIXDEMO
%	Let us start with some data, for example a small correlated 
%	two dimensional sample with some weird underlying distri-
%	bution.
%	==========================================================

n = 20;	
Y = rchisq(n,3);
X = Y + 3*rand(n,1);

pause % Strike any key to continue.
clc
%	==========================================================
%	IDENTIFY
%	The first thing to do with any data material is to plot it
%	and look at syspicious observations. Now, identify the 
%	numbers of some interesting observations by clicking with 
%	the left mouse button on them. Quit by clicking with 
%	another mouse button or press the space bar.
%	==========================================================

identify(X,Y,'o')

pause % Strike any key to continue.
clc
%	==========================================================
%	JACKKNIFE AND THE BOOTSTRAP
%	Let's compute the mean of our data material. Then we 
%	calculate the standard error by three methods: the usual
%	method, the jackknife method, and the bootstrap method.
%	==========================================================

mean(X)
std(X)/sqrt(n)
stdjack(X,'mean')
stdboot(X,'mean')

pause % Strike any key to continue. 
clc
%	==========================================================
%	JACKKNIFE AND THE BOOTSTRAP
%	For the median there is no standard method of computing 
%	the standard error but one can try jackknife (bad in
%	reality) and bootstrap (really good).
%	Note that the bootstrap gives slightly different values 
%	each time since it is resampling randomly.
%	==========================================================

median(X)
stdjack(X,'median')
stdboot(X,'median')
stdboot(X,'median')

pause % Strike any key to continue. 
clc
%	==========================================================
%	THE BOOTSTRAP IS VECTORIZED
%	A spectacular example is to give confidence intervals for the
%	quantile of a distribution. There are at least 3 ways to define 
%	an empirical quantile estimator. Look at the plot to see them 
%	applied to X.
%	==========================================================

XX = sort(X);
stairs([XX(1);XX],(0:n)'/n)
hold on
plot(XX,((1:n)'-0.5)/n,'g')
plot(XX,(1:n)'/(n+1),'m')
grid
hold off

pause % Strike any key to continue. 

clc
%	==========================================================
%	THE BOOTSTRAP IS VECTORIZED
%	Let's use the method indicated by the green line and compute
%	some quantiles for X along with its standard deviation. The 
%	bootstrap is used for computing a standard deviation estimate 
%	which we use for plotting a 90 percent confidence interval 
%	through a normal approximation.
%	==========================================================

p = (0.1:0.1:0.9)';
qx = quantile(X,p,1);
sqx = stdboot(X,'quantile',200,p);
plot([p p p],[qx-1.64*sqx, qx, qx+1.64*sqx])
grid

pause % Strike any key to continue. 
clc
%	==========================================================
%	THE BOOTSTRAP IS VECTORIZED
%	However, there are fancier methods than normal approximations.
%	Let us redo the quantile example with full fledged bootstrap
%	confidence intervals based on 300 resamples. (The low number
%	is for student version of Matlab. Use 2000 or so if you
%	bootstrap your own data)
%	==========================================================

flops(0)
Imb = ciboot(X,'quantile',[],0.9,300,p);
clf
plot([p p p],Imb)
grid
flops
%	Great fun, isn't it?

pause % Strike any key to continue. 
clc
%	==========================================================
%	THE BOOTSTRAP DISTRIBUTION
%	A bootstrap confidence interval is based on the bootstrap 
%	distribution for some quantity. One might have a look at the 
%	distribution for it. The confidence interval for the standard 
%	deviation of X will serve as an example.
%	A histogram of the bootstrapped distribution of T (=std(X)) 
%	and a kernel density estimate looks like this.
%	==========================================================

[Imb, T] = ciboot(X,'std',[],0.9,300);
Imb
subplot(211)
histo(T);
subplot(212)
plotdens(T);

pause % Strike any key to continue. 
clc
%	==========================================================
%	One might plot the histogram on top of the kernel density 
%	estimate also.
%	==========================================================

hold on
histo(T,[],0,1)
hold off

pause % Strike any key to continue. 
clc
%	==========================================================
%	Here is a function that estimates mixtures of normal
%	distributions.
%	==========================================================

X = [randn(200,1); randn(100,1)*1.5+5; randn(100,1)/2+9]; 
normmix(X,3,2,[],50,20)

pause % Strike any key to continue. 
clc
%	==========================================================
%	LINEAR REGRESSION
%	A standard linear regression looks like this.
%	You may identify observations here too.
%	Click with the mouse. End with middle button.
%	==========================================================

X = randn(30,1);
Y = 2 + 3*X + randn(30,1); 
clf
linreg(Y,X);
grid	
hold on
identify(X,Y, [])
hold off

pause % Strike any key to continue. 
clc
%	==========================================================
%	POLYNOMIAL REGRESSION
%	Exactly the same as last picture but now a second degree
%	fit instead. Click with the mouse. End with middle button
%	or space bar.
%	==========================================================

Y = 2 + 2*X + 1*X.^2 + randn(30,1); 
clf
linreg(Y,X, 0.9, [], 2);
grid	
hold on
identify(X,Y, [])
hold off

pause % Strike any key to continue. 
clc
%	==========================================================
%	DATA MATERIALS
%
%	There are some famous multivariate data materials included.
%	==========================================================

x = getdata;
plot(x(:,1),x(:,2),'o')

pause % Strike any key to continue. 
clc
%	==========================================================
%	FANCY PLOTTING
%	1. Plot with different symbols
%	==========================================================

clf
m = 12;
x = [randn(m,1); randn(m,1)+2; randn(m,1)+4];
y = [randn(m,1); randn(m,1)+4; randn(m,1)+3];
s = ones(m,1)*[1 2 3];
s = s(:);

plotsym(x,y,s,'stc','k')

pause % Strike any key to continue. 
clc
%	==========================================================
%	FANCY PLOTTING
%	2. Plot with different colors
%	==========================================================

z = (1:3*m)';

plotsym(x,y,s,'stc',z)

colormap(hot)

pause % Strike any key to continue. 
clc
%	==========================================================
%	FANCY PLOTTING
%	3. Plot with different sizes instead
%	==========================================================

z = z/max(z)*5;

plotsym(x,y,s,'stc','k',z)

pause % Strike any key to continue. 
clc
%	==========================================================
%	FANCY PLOTTING
%	4. Random place, form, color, and size. A really cool plot.
%	==========================================================

m = 100;
x = randn(m,1);
y = randn(m,1);
form = ceil(rand(m,1)*7); % note: 7 forms availible
color = rand(m,1);
ssize = rand(m,1)*4+1;

plotsym(x,y,form,color,ssize)

colormap(cool)

pause % Strike any key to continue. 
clc
% Thanks for your attention. Good bye.

echo off
