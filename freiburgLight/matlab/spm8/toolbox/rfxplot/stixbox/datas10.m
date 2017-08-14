function x = datas10
%*********************** Cost-of-Living Data *********************** 
%
%Source:      Beck, J.H. and Quan, N.T. (1983)
%
%Taken From:  Quan, N.T. (1988), JBES, 6, 4, 501-504.
%
%Dimension:   38 observations on 8 variables
%
%Description: A study of the effects of right-to-work laws and geographic
%             differences on the cost of living.  Observations are for the
%             following cities:
%        1 Atlanta             14 Dayton                  27 New York
%        2 Austin              15 Denver                  28 Orlando
%        3 Bakersfield         16 Detroit                 29 Philadelphia
%        4 Baltimore           17 Green Bay               30 Pittsburgh
%        5 Baton Rouge         18 Hartford                31 Portland
%        6 Boston              19 Houston                 32 St. Louis
%        7 Buffalo             20 Indianapolis            33 San Diego
%        8 Champaign-Urbana    21 Kansas City             34 San Francisco
%        9 Cedar Rapids        22 Lancaster, PA           35 Seattle
%       10 Chicago             23 Los Angeles             36 Washington
%       11 Cincinnati          24 Milwaukee               37 Wichita
%       12 Cleveland           25 Minneapolis, St. Paul   38 Raleigh-Durham
%       13 Dalas               26 Nashville
%
%Column       Definition
%  1     Population density in the ith SMSA, in 1975, in terms of persons
%        per square mile. From U. S. Bureau of the Census, 1978, County and
%        City Data Book, 1977.
%  2     State Unionization rate in 12978.  From the U. S. Bureau of Labor
%        Statistics, Handbook of Labor Statistics, December 1980, p. 414.
%  3     Total population in the ith SMSA, in 1975.  From the US Bureau of
%        the Census, 1978, County and City Data Book, 1977.
%  4     The average cost of living for a four-person family living on an
%        intermediate budget in the ith SMSA in 1978.  From the US Bureau
%        of the Census, Statistical Abstract of the United States, 1979.
%  5     The 1972 per capita level of property taxes in the ith SMSA.  From
%        the US Bureau of the Census, 1978, County and City Data Book, 1977.
%        Except New York and Washington, DC, data were from the U.S. Bureau
%        of Census, 1974.
%  6     The 1974 per capita income in the ith SMSA.  From the US Bureau of
%        the Census, 1978, County and City Data Book, 1977.
%  7     Temperature is measured as average annual degree days, 1931-1960.
%        From the US Weather Bureau, 1962, Decennial Census of United States
%        Climate - Monthly Normals of Temperature, Precipitation, and
%        Heating Degree Days.
%        (Due to lack of published data for Champaign, IL, Cedar Rapids, IA,
%        and Lancaster, PA, degree days for Springfield, IL, Waterloo, IA,
%        and Harrisburg, PA, respectively, were used for the missing data.)
%  8     A dummy variable with a value of 1, if there is right-to-work
%        legislation in the state where the ith SMSA is located, 0 otherwise
%        From the US Bureau of Labor Statistics, 1980, Handbook of Labor
%        Statistics, December 1980, p. 414.

x = [
     414    13.6  1790128        169       5128       2961     1      16897
     239    11     396891        143       4303       1711     1      16221
      43    23.7   349874        339       4166       2122     0      17168
     951    21    2147850        173       5001       4654     0      18699
     255    16     411725         99       3965       1620     1      16806
    1257    24.4  3914071        363       4928       5634     0      22117
     834    39.2  1326848        253       4471       7213     0      19517
     162    31.5   162304        117       4813       5535     0      19076
     229    18.2   164145        294       4839       7224     1      18224
    1886    31.5  7015251        291       5408       6113     0      18794
     643    29.5  1381196        170       4637       4806     0      18354
    1295    29.5  1966725        239       5138       6432     0      18987
     302    11    2527224        174       4923       2363     1      16714
     489    29.5   835708        183       4787       5606     0      17430
     304    15.2  1413318        227       5386       5982     0      18565
    1130    34.6  4424382        255       5246       6275     0      19145
     323    27.8   169467        249       4289       8214     0      18490
     696    21.9  1062565        326       5134       6235     0      19392
     337    11    2286247        194       5084       1278     1      17114
     371    29.3  1138753        251       4837       5699     0      18193
     386    30    1290110        201       5052       4868     0      18262
     362    34.2   342797        124       4377       5205     0      17982
    1717    23.7  6986898        340       5281       1349     0      17722
     968    27.8  1409363        328       5176       7635     0      20025
     433    24.4  2010841        265       5206       8392     0      19389
     183    17.7   748493        120       4454       3578     1      16627
    6908    39.2  9561089        323       5260       4862     0      21587
     230    11.7   582664        117       4613        782     1      16334
    1353    34.2  4807001        182       4877       5144     0      19416
     762    34.2  2322224        169       4677       5987     0      18008
     201    23.1   228417        267       4123       7511     0      19186
     480    30    2366542        184       4721       4809     0      17897
     372    23.7  1584583        256       4837       1458     0      17707
    1266    23.7  3140306        381       5940       3015     0      19427
     333    33.1  1406746        195       5416       4424     0      18671
    1073    21    3021801        205       6404       4224     0      20105
     157    12.8   384920        206       4796       4620     1      17783
     302     6.5   468512        126       4614       3393     1      18074
];