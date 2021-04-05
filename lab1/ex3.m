% a)
% caso geral
A = [1  -180     0     0    0
     -1 180+20 -40     0    0
     0   -20   40+10  -20   0
     0    0     -10   20+5 -2
     0    0      0     -5   2
     1    1      1      1   1]
 
 B = [0
      0
      0
      0
      0
      1]
 
 % como é um processo de nascimento e morte
 % já temos as equações
 
 denominador = (1 + (20/10) + ((20/10)*(40/20)) + ((20/10)*(40/20)*(180)) + (5/2));
 
 P2 = (5/2) / denominador * 10
 P3 = 1 / denominador * 100
 P4 = (20/10) / denominador * 100 
 P5 = ((20/10) * (40/20)) / denominador * 10
 P6 = ((20/10) * (40/20) * (180)) / denominador
 

 %%
 % b)
 % tempo em cada estado =  1 / (soma "do que sai") 
T2 = 1/2
T3 = 1/25
T4 = 1/50
T5 = 1/200
T6 = 1/1


%%
% c)

