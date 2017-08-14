/* ******************************************************************** */
/* AUTHOR	OS							*/
/* DATE		NOV 16, 1999						*/
/* FILE		amr_rbf_powell.c					*/
/* MES		compute rbf in Matlab using powell's fit		*/
/* How to compile: >> mex amr_rbf_powell.c nrutil.c			*/
/* Syntax:								*/
/*									*/
/* ******************************************************************** */

/* DOUBLE rbf_arr = rbf_powell(DOUBLE in_arr, DOUBLE init_params,DOUBLE min_max_params,DOUBLE defaults)
   in_arr is 2D:      dim[0] = nb time points (fastest varying)
                      dim[1] = nb pixels
   init_params is 2D: dim[0] = IN_PAR (# of params)
                      dim[1] = nb pixels
   min_max_params is 1D: dim[0] = IN_PAR*2 (# of params *2 - min and max)
		      params are: alpha, beta, (ma-mi)/ma*100, at, skip
   defaults is 1D:    other parameters (S0_start,S0_stop,SE_int,W_START,W_SIG,NOISE,TE)
   rbf_arr is 2D:     dim[0] = NPAR (# of output parameter)
                      dim[1] = nb pixels
*/

/* Input Arguments */
#define	IN_ARR		prhs[0]
#define	INIT_PARAMS	prhs[1]
#define	MIN_MAX_PARAMS	prhs[2]
#define	DEFAULTS	prhs[3]

/* Output Arguments */
#define	OUT_ARR		plhs[0]

/* fit parameter */
#define DIR1		0.5	/* initial seach steps alpha */
#define DIR2		0.2	/* initial search steps beta */
#define DIR3		10	/* initial search steps rcbv */
#define DIR4		1	/* initial search steps arrival time */
#define konst		1	/* prop const contr. agent*/



void powell(double p[], double **xi, int n, double *ftol,
	    int *iter, double *fret, double (*func)(double []));
double brent(double *ax, double *bx, double *cx,
	     double (*f)(double *), double *tol, double *xmi);
double f1dim(double *x);
void mnbrak(double *ax, double *bx, double *cx, double *fa, double *fb,
	    double *fc, double (*func)(double *));
double gamma_fct(double A[]);
double cool_gamma(double xx);

#include <stdio.h>
#include <math.h>
#define NRANSI
#include "nrutil.h"
#include "mex.h"

#define IN_NPAR		5
#define NPAR		4

static double rbf_S0, rbf_SE, bug, *W; int xmin, nbtim, k;
static double S0_start, S0_stop, SE_int, noise, TE;
static double *src;
static double alphamin, alphamax, betamin, betamax, atmin, atmax;
double *pcom,*xicom,(*nrfunc)(double []);

/* ###################################################################### */
void mexFunction(
		int		nlhs,
		mxArray		*plhs[],
		int		nrhs,
		const mxArray	*prhs[]
		)
{
  double *init_par, **dir, *dest, *par, **id, fret, *pptr, Wsig, Wstart, sd_S0, sd_SE;
  double ftol, mean, S0_int, *limit, *defaults, noise;
  int nbpts, nbpar, i, j, k, iter;

  /* Check for proper number of arguments,types and sizes */
  if (nrhs != 4 || nlhs !=1)
    mexErrMsgTxt("USAGE: double rbf_arr = rbf_powell(double "
	     "in_arr, double init_params, double min_max_params, double defaults)\n");
  if (!mxIsDouble(prhs[0]))
    mexErrMsgTxt("in_arr must be of type DOUBLE\n");
  if (!mxIsDouble(prhs[1]))
    mexErrMsgTxt("init_params must be of type DOUBLE\n");
  if (!mxIsDouble(prhs[2]))
    mexErrMsgTxt("min_max_params must be of type DOUBLE\n");
  if (!mxIsDouble(prhs[3]))
    mexErrMsgTxt("defaults must be of type DOUBLE\n");
  if (mxGetNumberOfDimensions(prhs[0]) != 2)
    mexErrMsgTxt("in_arr must have dimension 2\n");
  if (mxGetNumberOfDimensions(prhs[1]) != 2)
    mexErrMsgTxt("init_params must have dimension 2\n");
  if (mxGetNumberOfDimensions(prhs[2]) != 2 || 
	mxGetM(prhs[2]) != 1 || mxGetN(prhs[2]) != 6)
    mexErrMsgTxt("fit_limit must be 1D-vector(6)\n");
  if (mxGetNumberOfDimensions(prhs[3]) != 2 || 
	mxGetM(prhs[3]) != 1 || mxGetN(prhs[3]) != 7)
    mexErrMsgTxt("defaults must be 1D-vector(7)\n");
  nbtim = mxGetM(prhs[0]);
  nbpts = mxGetN(prhs[0]);
  nbpar = mxGetM(prhs[1]);
  if (nbpts != mxGetN(prhs[1]))
    mexErrMsgTxt("inputs must have same nb pixels\n");
  if (nbpar != IN_NPAR) 
  {
    fprintf(stderr, "Number of parameters must be %d\n",IN_NPAR);
  return;
  }
  
  src = (double *) mxGetData(prhs[0]); /* src: data source */
  limit = mxGetPr(MIN_MAX_PARAMS);
  alphamin = *limit++;
  alphamax = *limit++;
  betamin = *limit++;
  betamax = *limit++;
  atmin = *limit++;
  atmax = *limit++;
  defaults = mxGetPr(DEFAULTS);
  S0_start = *defaults++;	/* scan# start of baseline */
  S0_stop = *defaults++;	/* scan# end of baseline */
  SE_int = *defaults++;		/* # of scans to determine post bolus int. */
  Wstart = *defaults++;	        /* scan# for start of gaussian weighting */
  Wsig = *defaults++;		/* sigma for gaussian weighting */
  noise	= *defaults++;		/* fit only voxel with less noise */
  TE	= *defaults++;
#ifdef DEBUG
  fprintf(stderr,"nbtim %d nbpts %d nbpar %d\n",
    nbtim,nbpts,nbpar);
  fprintf(stderr,"amin %f amax %f bmin %f bmax %f atmin %f atmax %f noise %f\n",
    alphamin,alphamax,betamin,betamax,atmin,atmax,noise);
#endif
  
printf("Calculating maps now: processing %d pixels with %d timepoints\n Processing Pixel: ",nbpts,nbtim);
mexEvalString("drawnow");
  /* init powell identity dmatrix */
  dir = dmatrix(1, NPAR, 1, NPAR);
  id = dmatrix(1, NPAR, 1, NPAR);
  for (j = 1; j <= NPAR; j ++)   /* !!what about xi's!! */
    for (k = 1; k <= NPAR; k ++)
      if (j == k) id[j][k] = 1.0;
      else id[j][k] = 0.0;  
    
  /* initialize destination array */
  OUT_ARR = mxCreateDoubleMatrix(NPAR,nbpts,mxREAL);
  dest = mxGetPr(OUT_ARR);
  pptr = mxGetPr(INIT_PARAMS);

  /* init weights */
  W = dvector(0, nbtim-1);
  for (i = 0; i < Wstart; i ++) 
     W[i] = 1.0;  /* !!1 before Wstart!! */
  for (i = Wstart; i < nbtim; i ++) 
     W[i]=exp(-(i-Wstart)*(i-Wstart)/(2*Wsig*Wsig));
  ftol = 1.0e-3;
  pcom = dvector(1,NPAR); xicom=dvector(1,NPAR); nrfunc=gamma_fct;

    /* fit all pixels */
  for (i = 0; i < nbpts; i ++) 
  {
    if (i % 200 == 0) 
	  {
		printf(" .. %d", i);
	 	mexEvalString("drawnow");
	  }
    for (j=1;j<=NPAR;j++) for (k=1;k<=NPAR;k++) dir[j][k]=id[j][k];
    dir[1][1] = DIR1;    /* !!what about xi's!! */
    dir[2][2] = DIR2;
    dir[3][3] = DIR3;
    dir[4][4] = DIR4;
    par = dest - 1;
    for (j = 1; j<=NPAR; j ++) par[j] = *pptr++;
    xmin = (int)(*pptr++);

#ifdef DEBUG
    printf("data=[");for (j=0;j<nbtim;j++)printf("%f ",src[j]);printf("\n");
#endif
    
    /* compute rbf_S0 and sd_S0 */
    rbf_S0 = 0.0; 
    sd_S0 = 0.0;
    S0_int = (double)(S0_stop - S0_start+1);
    
    for (j = S0_start; j <= S0_stop; j ++)
    {
      rbf_S0 += src[j];
      sd_S0 += src[j]*src[j];
    }
    rbf_S0 /= S0_int;
    sd_S0 = sqrt(sd_S0/(S0_int-1.0) - S0_int/(S0_int-1.0)*rbf_S0*rbf_S0);

    /* compute rbf_SE and sd_SE */
    rbf_SE = 0.0; 
    sd_SE = 0.0;
    for (j = nbtim - SE_int; j < nbtim; j ++)
    {
       rbf_SE += src[j];
       sd_SE  += src[j]*src[j];
    }
    rbf_SE /= (double)SE_int;
    sd_SE = sqrt(sd_SE/(SE_int-1.0) - SE_int/(SE_int-1.0)*rbf_SE*rbf_SE);

    /* compute bug as rms to mean: use E[(X-E[X])^2]=E[X^2]-(E[X])^2 */
    mean = 0.0; bug = 0.0;
    for (j = xmin; j < nbtim; j ++) 
    {
      mean += src[j]; 
      bug += src[j] * src[j];
    }
    bug -= mean * mean / (double)(nbtim - xmin);
    
#ifdef DEBUG
    printf("%f %f %f\n",rbf_S0,rbf_SE,bug);
#endif 
    
    /* execution of fit routine */
    if (sd_SE/rbf_SE < noise)
      powell(par, dir, NPAR, &ftol, &iter, &fret, gamma_fct); 
    if (dest[2] < 1.0e-6) dest[3] = 14.0;
    src += nbtim; dest += NPAR;
  }
  free_dmatrix(id,1,NPAR,1,NPAR);
  free_dmatrix(dir,1,NPAR,1,NPAR);
  free_dvector(W, 0, nbtim-1); 
  free_dvector(pcom,1,NPAR);
  free_dvector(xicom,1,NPAR);
}

/* ###################################################################### */
double gamma_fct(double A[])
{
  double err, btoa, tat, etatb, gamalpha, gogo, rbf_SS,
        dil, Ct, y, dil_rate, tmin;
  int i;

#ifdef DEBUG
  printf("par=[%f %f %f %f]\n",A[1],A[2],A[3],A[4]);
#endif
  err = 0.0;
  if (A[1] < 0.05) err += 1.0e2*(A[1]-1.0)*(A[1]-1.0);
  if (A[2] < 0.2) err += 1.0e2*(A[2]-1.0)*(A[2]-1.0);
  if (A[3] < 0.0) err += 1.0e2*(A[3]+1.0)*(A[3]+1.0);
  if (A[4] < 5.0) err += (6.0-A[4])*(6.0-A[4]);
  if (err != 0.0) return bug*(1.0+err);

  /*	calculate function values y  */
  k = konst;	  			/* proportionality: signal vs. concentration */
  btoa = pow(A[2], -A[1]-1.0);
  gamalpha = cool_gamma(A[1]+1.0);
  dil_rate = 10.0;			/* dilution const.  */
  rbf_SS = rbf_S0-rbf_SE; 
  if (rbf_SS < 0.0) rbf_SS = 0.0;

  /* prevent from very small intensity values */
  tmin = A[1] * A[2];           	/* time of min. intensity (after arrival) */
  tat = pow(tmin, A[1]);
  etatb = exp(-tmin/A[1]);
  Ct = A[3]*btoa*tat*etatb/gamalpha;
  gogo = rbf_S0*exp(-k*TE*Ct)+0.00001;
  if (gogo < 1.0) err += 1.0e2/gogo;
  if (err != 0.0) return bug*(1.0+err);

  for (i = xmin; i < nbtim; i ++)
  {
    gogo = ((double)i)-A[4]; 
    if (gogo < 0.0) gogo = 0.0;
    tat = pow(gogo, A[1]); etatb = exp(-gogo / A[2]);
    Ct = A[3]*btoa*tat*etatb/gamalpha;
    y = rbf_S0*exp(-k*TE*Ct); /*  orig. gammafkt.  */
    /* add dilution term for lower baseline at end  */
    dil = (1.0 - exp(-gogo/dil_rate))*rbf_SS;
    y = y - dil;
/* #ifdef DEBUG
printf("%f %f %f %f %f %f %f %f\n",btoa,gamalpha,rbf_SS,tat,etatb,Ct,y,dil);
#endif */
    err += (src[i]-y)*(src[i]-y)*W[i];
  }
  /* set penalty for parameters out of reasonable range  */
  if (A[1] > alphamax)  err = err * (1.0 + 0.5*(A[1]-3.0)*(A[1]-3.0));
  if (A[1] < alphamin)  err = err * (1.0 + 0.1/(A[1]+.05));
  if (A[2] > betamax)  err = err * (1.0 + 0.1*(A[2]-7.0)*(A[2]-7.0));
  if (A[2] < betamin)  err = err * (1.0+ 0.5/(A[2]*A[2]+.05));
  if (A[3] < 0.4) err = err * (1+ 0.1*((1/(A[3] + 0.1))-0.5));
  if (A[1] < 0.2 && A[2] < 0.5) err = err*(1.0+0.1/(A[1]+.05)/(A[2]+.05));
  if (A[4] > atmax)  err = err * (1.0 + 1.0*(A[4]-25.0)*(A[4]-25.0));
  if (A[4] < atmin)  err = err * (1.0 + 0.1*(A[4]-9.0)*(A[4]-9.0));
  /* prefer smaller A[2] in general  */
  err = err * (1.0+0.05*A[2]);
  return err;
}

/* ###################################################################### */
#define ITMAX 200
static double sqrarg;
#define SQR(a) ((sqrarg=(a)) == 0.0 ? 0.0 : sqrarg*sqrarg)

void powell(double p[], double **xi, int n, double *ftol,
	    int *iter, double *fret, double (*func)(double []))
{
  void linmin(double p[], double xi[], int n, double *fret,
	      double (*func)(double []));
  int i,ibig,j;
  double del,fp,fptt,t,*pt,*ptt,*xit;

  pt=dvector(1,n); 
  ptt=dvector(1,n); 
  xit=dvector(1,n); 
  *fret=(*func)(p);
  for (j=1;j<=n;j++) pt[j]=p[j];
  for (*iter=1;;++(*iter)) 
  {
    fp=(*fret); 
    ibig=0; 
    del=0.0;
    for (i=1;i<=n;i++) 
    {
      for (j=1;j<=n;j++) xit[j]=xi[j][i];
      fptt=(*fret); 
      linmin(p,xit,n,fret,func);
      if (fabs(fptt-(*fret)) > del) 
      { del=fabs(fptt-(*fret)); 
      ibig=i; 
      }
    }
    if (2.0*fabs(fp-(*fret)) <= (*ftol)*(fabs(fp)+fabs(*fret))) 
    {
      /*fprintf(stderr,"Powell final: ");
	for (i = 1;i<=n;i++) fprintf(stderr,"%lf ",p[i]);
	fprintf(stderr,"\n");*/
      free_dvector(xit,1,n); 
      free_dvector(ptt,1,n); 
      free_dvector(pt,1,n);
      return;
    }
    if (*iter == ITMAX) nrerror("powell exceeding maximum iterations.");
    for (j=1;j<=n;j++) 
    {
      ptt[j]=2.0*p[j]-pt[j]; 
      xit[j]=p[j]-pt[j]; 
      pt[j]=p[j];
    }
    fptt=(*func)(ptt);
    if (fptt < fp) 
    {
      t=2.0*(fp-2.0*(*fret)+fptt)*SQR(fp-(*fret)-del)-del*SQR(fp-fptt);
      if (t < 0.0) 
      {
	linmin(p,xit,n,fret,func);
	for (j=1;j<=n;j++) 
	{ 
	xi[j][ibig]=xi[j][n]; 
	xi[j][n]=xit[j]; 
	}
      }
    }
  }
}
#undef ITMAX

/* ###################################################################### */
#define ITMAX 500
#define CGOLD 0.3819660
#define ZEPS 1.0e-10
#define SHFT(a,b,c,d) (a)=(b);(b)=(c);(c)=(d);
#define SIGN(a,b) ((b)>0.0 ? fabs(a) : -fabs(a))


double brent(double *ax, double *bx, double *cx, double (*f)(double *),
	     double *tol, double *xmi)
{
  int iter;
  double a,b,d,etemp,fu,fv,fw,fx,p,q,r,tol1,tol2,u,v,w,x,xm;
  double e=0.0;
  
  a=(*ax < *cx ? *ax : *cx);
  b=(*ax > *cx ? *ax : *cx);
  x=w=v=*bx; 
  fw=fv=fx=(*f)(&x);
  for (iter=1;iter<=ITMAX;iter++) 
  {
    xm=0.5*(a+b);
    tol2=2.0*(tol1=(*tol)*fabs(x)+ZEPS);
    if (fabs(x-xm) <= (tol2-0.5*(b-a))) 
    { 
      *xmi=x; 
      return fx; 
    }
    if (fabs(e) > tol1) 
    {
      r=(x-w)*(fx-fv); 
      q=(x-v)*(fx-fw); 
      p=(x-v)*q-(x-w)*r;
      q=2.0*(q-r); 
      if (q > 0.0) 
      p = -p;
      q=fabs(q); 
      etemp=e; 
      e=d;
      if (fabs(p) >= fabs(0.5*q*etemp) || p <= q*(a-x) || p >= q*(b-x))
	d=CGOLD*(e=(x >= xm ? a-x : b-x));
      else 
      { 
        d=p/q; 
	u=x+d; 
	if (u-a < tol2 || b-u < tol2) d=SIGN(tol1,xm-x);
      }
    } 
    else 
    { 
      d=CGOLD*(e=(x >= xm ? a-x : b-x)); 
    }
    u=(fabs(d) >= tol1 ? x+d : x+SIGN(tol1,d));
    fu=(*f)(&u);
    if (fu <= fx) 
    { 
      if (u >= x) a=x; 
      else b=x;
      SHFT(v,w,x,u);
      SHFT(fv,fw,fx,fu);
    } 
    else 
    {
      if (u < x) a=u; else b=u;
      if (fu <= fw || w == x) 
      { 
        v=w; w=u; fv=fw; fw=fu;
      }
      else if (fu <= fv || v == x || v == w)
      { 
        v=u; 
	fv=fu; 
      }
    }
  }
  nrerror("Too many iterations in brent"); *xmi=x; return fx;
}
#undef ITMAX
#undef CGOLD
#undef ZEPS
#undef SHFT

/* ###################################################################### */
#define GOLD 1.618034
#define GLIMIT 100.0
#define TINY 1.0e-20
#define SHFT(a,b,c,d) (a)=(b);(b)=(c);(c)=(d);

static double mxa1, mxa2;
#define DMAX(a,b) (mxa1=(a),mxa2=(b),(mxa1)>(mxa2)?(mxa1):(mxa2))
#define SIGN(a,b) ((b)>0.0 ? fabs(a) : -fabs(a))


void mnbrak(double *ax, double *bx, double *cx, double *fa, double *fb,
	    double *fc, double (*func)(double *))
{
  double ulim,u,r,q,fu,dum;
  
  (*fa)=(*func)(ax); 
  (*fb)=(*func)(bx);
  if ((*fb) > (*fa)) 
  { 
    SHFT(dum,(*ax),(*bx),dum); 
    SHFT(dum,(*fb),(*fa),dum); 
  }
  (*cx)=(*bx)+GOLD*((*bx)-(*ax)); 
  (*fc)=(*func)(cx);
  while ((*fb) > (*fc)) 
  {
    r=((*bx)-(*ax))*((*fb)-(*fc)); 
    q=((*bx)-(*cx))*((*fb)-(*fa));
    u=(*bx)-(((*bx)-(*cx))*q-((*bx)-(*ax))*r)/(2.0*SIGN(DMAX(fabs(q-r),TINY),q-r));
    ulim=(*bx)+GLIMIT*((*cx)-(*bx));
    if (((*bx)-u)*(u-(*cx)) > 0.0) 
    {
      fu=(*func)(&u);
      if (fu < (*fc)) 
      { 
        (*ax)=(*bx); 
        (*bx)=u; 
        (*fa)=(*fb); 
        (*fb)=fu; 
      return; 
      }
      else if (fu > (*fb)) 
      { 
        (*cx)=u;
        (*fc)=fu; 
      return; 
      }
      u=(*cx)+GOLD*((*cx)-(*bx));
      fu=(*func)(&u);
    } 
    else if (((*cx)-u)*(u-ulim) > 0.0) 
    {
      fu=(*func)(&u);
      if (fu < (*fc)) 
      {
	SHFT((*bx),(*cx),u,(*cx)+GOLD*((*cx)-(*bx)));
	SHFT((*fb),(*fc),fu,(*func)(&u));
      }
    } 
    else if ((u-ulim)*(ulim-(*cx)) >= 0.0) 
    {
      u=ulim; fu=(*func)(&u);
    } 
    else 
    { 
      u=(*cx)+GOLD*((*cx)-(*bx)); 
      fu=(*func)(&u); 
    }
    SHFT((*ax),(*bx),(*cx),u);
    SHFT((*fa),(*fb),(*fc),fu);
  }
}
#undef GOLD
#undef GLIMIT
#undef TINY
#undef SHFT

/* ###################################################################### */
extern int ncom;
extern double *pcom,*xicom,(*nrfunc)(double []);

double f1dim(double *x)
{
  int j; double f,*xt;
  xt=(double *)dvector(1,ncom);
  for (j=1;j<=ncom;j++) xt[j]=pcom[j]+(*x)*xicom[j];
  f=(*nrfunc)(xt); 
  free_dvector(xt,1,ncom); 
  return f;
}

/* ###################################################################### */
#define TOL 2.0e-2
int ncom;

void linmin(double p[], double xi[], int n, double *fret,
	    double (*func)(double []))
{
  int j; double xx,xmi,fx,fb,fa,bx,ax, tol;
  
  tol=TOL; 
  ncom=n;
  
  for (j=1;j<=n;j++) 
  {
    pcom[j]=p[j]; 
    xicom[j]=xi[j]; 
  }
  ax=0.0; xx=1.0;
  mnbrak(&ax,&xx,&bx,&fa,&fx,&fb,f1dim);
  *fret=brent(&ax,&xx,&bx,f1dim,&tol,&xmi);
  
  for (j=1;j<=n;j++) 
  { 
    xi[j] *= xmi;
    p[j] += xi[j]; 
  }    
}
#undef TOL

/* ###################################################################### */
double cool_gamma(double xx)
{
  double x,y,tmp,ser;
  static double cof[6]={76.18009172947146,-86.50532032941677,
			24.01409824083091,-1.231739572450155,
			0.1208650973866179e-2,-0.5395239384953e-5};
  int j;
  y = x = xx; 
  tmp = x + 5.5; 
  tmp -= (x+0.5)*log(tmp); 
  ser = 1.000000000190015;
  for (j=0;j<=5;j++) ser += cof[j]/++y;
  return exp(-tmp)*2.5066282746310005*ser/x;
}
