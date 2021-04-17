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
 
 denominador = (1 + (2/5) + ((2/5)*(20/10)) + ((2/5)*(20/10)*(40/20)) + ((2/5)*(20/10)*(40/20)*(180)));
 
 s2 = 1 / denominador;
 s3 = (2/5) / denominador;
 s4 = ((2/5)*(20/10)) / denominador; 
 s5 = ((2/5)*(20/10)*(40/20)) / denominador;
 s6 = ((2/5)*(20/10)*(40/20)*(180)) / denominador;
 
 p_states = [s6 s5 s4 s3 s2]
 

 %%
 % b)
 % a prob de cada de estado tb é a percentagem de tempo em cada estado

%%
% c)

ber = [10^-6 10^-5 10^-4 10^-3 10^-2];
avgBer = sum(p_states .* ber)


%% 
% d)

 % tempo em cada estado =  1 / (soma "do que sai") 
t2 = 2;
t3 = 25;
t4 = 50;
t5 = 200;
t6 = 1;

t_states = 1 ./ [t6 t5 t4 t3 t2]

% é só mult por 60


%% 
% e)
interferencia = s2 + s3

%%
% f)
interBer = [10^-3 10^-2];
interStates = [s3  s2];
avgBerInter = sum(interStates .* interBer) / interferencia
