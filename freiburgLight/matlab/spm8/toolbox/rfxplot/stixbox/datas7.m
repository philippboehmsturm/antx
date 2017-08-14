function x = datas7
%*********************** Colon Cancer Data ***********************
%
%Source:      Carmeron and Pauling(1978)
%
%Taken From:  Rawlings (1988), Applied Regression Analysis, Wadsworth, 
%	      p. 83.
%
%Dimension:   22 observations on 4 variables.
%
%Description: A study of the effects of supplemental ascorbate, vitamin C
%             on the treatment of colon cancer
%
%Column    Description
%  1       Sex(female=1, male=-1)
%  2       Age
%  3       Days(Number of days survival after date of untreatability)
%  4       Control(Average number of days survival of ten control patients
%          for each case)

x = [
    1    76   135    18
    1    58    50    30
   -1    49   189    65
   -1    69  1267    17
    1    70   155    57
    1    68   534    16
   -1    50   502    25
    1    74   126    21
   -1    66    90    17
    1    76   365    42
    1    56   911    40
   -1    65   743    14
    1    74   366    28
   -1    58   156    31
    1    60    99    28
   -1    77    20    33
   -1    38   274    80
];