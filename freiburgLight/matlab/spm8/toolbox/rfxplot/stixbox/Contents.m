% A statistics toolbox for Matlab and Octave.
% Version 1.29, 10-May-2000
% GNU Public Licence Copyright (c) Anders Holtsberg.
% Comments and suggestions to andersh@maths.lth.se.
%
% Distribution functions.
%   dbeta     - Beta density function.
%   dbinom    - Binomial probability function.
%   dchisq    - Chisquare density function.
%   df        - F density function.
%   dgamma    - Gamma density function.
%   dhypg     - Hypergeometric probability function.
%   dlognorm  - The log-normal density function.
%   dnorm     - Normal density function.
%   dt        - Student t density function.
%   dweib     - The Weibull density function.
%   dgumbel   - The Gumbel density function.
%
%   pbeta     - Beta distribution function.
%   pbinom    - Binomial cumulative probability function.
%   pchisq    - Chisquare distribution function.
%   pf        - F distribution function.
%   pgamma    - Gamma distribution function.
%   phypg     - Hypergeometric cumulative probability function.
%   plognorm  - The log-normal distribution function.
%   pnorm     - Normal distribution function.
%   pt        - Student t cdf.
%   pweib     - The Weibull distribution function.
%   pgumbel   - The Gumbel distribution function.
%
%   qbeta     - Beta inverse distribution function.
%   qbinom    - Binomial inverse cdf.
%   qchisq    - Chisquare inverse distribution function.
%   qf        - F inverse distribution function.
%   qgamma    - Gamma inverse distribution function.
%   qhypg     - Hypergeometric inverse cdf.
%   qlognorm  - The inverse log-normal distribution function.
%   qnorm     - Normal inverse distribution function.
%   qt        - Student t inverse distribution function.
%   qweib     - The Weibull inverse distribution function.
%   qgumbel   - The Gumbel inverse distribution function.
%
%   rbeta     - Random numbers from the beta distribution.
%   rbinom    - Random numbers from the binomial distribution.
%   rchisq    - Random numbers from the chisquare distribution.
%   rf        - Random numbers from the F distribution
%   rgamma    - Random numbers from the gamma distribution.
%   rhypg     - Random numbers from the hypergeometric distribution.
%   rlognorm  - Log-normal random numbers.
%   rnorm     - Normal random numbers (use randn instead).
%   rt        - Random numbers from the student t distribution.
%   rweib     - Random numbers from the Weibull distribution.
%   rgumbel   - Random numbers from the Gumbel distribution.
%
% Logistic regression.
%   ldiscrim  - Compute a linear discriminant and plot the result. 
%   logitfit  - Fit a logistic regression model.
%   lodds     - Log odds function.
%   loddsinv  - Inverse of log odds function.
%
% Various functions.
%   bincoef   - Binomial coefficients.
%   cat2tbl   - Take category data and produce a table of counts.
%   getdata   - Some famous multivariate data sets.
%   quantile  - Empirical quantile (percentile).
%   ranktrf   - Rank transform data.
%   spearman  - Spearman's rank correlation coefficient.
%   stdize    - Standardize columns to have mean 0 and standard deviation 1.
%   corr      - Correlation coefficient.
%   cvar      - Covariance.
%
% Resampling methods.
%   covjack   - Jackknife estimate of the variance of a parameter estimate.
%   covboot   - Bootstrap estimate of the variance of a parameter estimate.
%   stdjack   - Jackknife estimate of the parameter standard deviation.
%   stdboot   - Bootstrap estimate of the parameter standard deviation.
%   rboot     - Simulate a bootstrap resample from a sample.
%   ciboot    - Bootstrap confidence interval.
%   test1b    - Bootstrap t test and confidence interval for the mean.
%
% Tests, confidence intervals, and model estimation.
%   cmpmod    - Compare small linear model versus large one.
%   contincy  - Test for contigency table row-column independence.
%   ciquant   - Nonparametric confidence interval for quantile.
%   lsfit     - Fit a least squares model.
%   lsselect  - Select a predictor subset for regression.
%   test1n    - Tests and confidence intervals, one normal sample.
%   test1r    - Test for median equals 0 using rank test.
%   test2n    - Tests and confidence intervals, two normal samples.
%   test2r    - Test for equal location of two samples using rank test.
%   normmix   - Estimate a mixture of normal distributions.
%
% Graphics.
%   qqgamma   - Gamma probability paper plot (and estimate).
%   qqnorm    - Normal probability paper plot.
%   qqplot    - Plot empirical quantile vs empirical quantile.
%   qqweib    - Weibull probability paper plot.
%   qqgumbel  - Gumbel probability paper plot.
%   kaplamai  - Plot Kaplan-Maier estimate of survivor function.
%   linreg    - Linear or polynomial regression, including plot.
%   histo     - Plot a histogram (alternative to hist).
%   plotsym   - Plot with symbols.
%   plotdens  - Draw a nonparametric density estimate.
%   plotempd  - Plot empirical distribution.
%   identify  - Identify points on a plot by clicking with the mouse.
%   pairs     - Pairwise scatter plots.
