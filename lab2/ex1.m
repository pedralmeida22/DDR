% 1.a

lambda = 20;
C = 100;
M = 4;
R = 500;
fname = 'movies.txt';

% number of simulations
N = 10; 

% vectors with N simulation results
block = zeros(1,N); 
ocup = zeros(1,N);

for it= 1:N
    [block(it), ocup(it)] = simulator1(lambda, C, M, R, fname);
end

%90% confidence interval%
alfa= 0.1; 

mediaBlock = mean(block);
termBlock = norminv(1-alfa/2)*sqrt(var(block)/N);
fprintf('Blocking probability = %.2e +- %.2e\n',mediaBlock,termBlock)

mediaOcup = mean(ocup);
termOcup = norminv(1-alfa/2)*sqrt(var(ocup)/N);
fprintf('Average occupation = %.2e +- %.2e\n',mediaOcup,termOcup)


%%
% 1.b, 1.c, 1.d

fname = 'movies.txt';

% b
%lambda = [10 15 20 25 30 35 40]; 
%C = 100;
%M = 4;
%R = 500;


%c
lambda = [10 15 20 25 30 35 40]; 
C = 100;
M = 4;
R = 5000;

%d
%lambda = [100 150 200 250 300 350 400];
%C = 1000;
%M = 4;
%R = 5000;

% number of simulations
N = 10; 

% vectors with N simulation results
block = zeros(1,N); 
ocup = zeros(1,N);

mediaBlock = zeros(1,size(lambda, 2));
termBlock = zeros(1,size(lambda, 2));

mediaOcup = zeros(1,size(lambda, 2));
termOcup = zeros(1,size(lambda, 2));

for i = 1:size(lambda, 2)
    for it= 1:N
        [block(it), ocup(it)] = simulator1(lambda(i), C, M, R, fname);
    end
    
    %90% confidence interval%
    alfa= 0.1; 

    mediaBlock(i) = mean(block);
    termBlock(i) = norminv(1-alfa/2)*sqrt(var(block)/N);

    mediaOcup(i) = mean(ocup);
    termOcup(i) = norminv(1-alfa/2)*sqrt(var(ocup)/N);
    
end

figure(1)
bar(lambda, mediaBlock)
hold on
er = errorbar(lambda, mediaBlock, termBlock, termBlock)
er.LineStyle = 'none';  
hold off
grid on

figure(2)
bar(lambda, mediaOcup)
hold on
er = errorbar(lambda, mediaOcup, termOcup, termOcup)
er.LineStyle = 'none';  
hold off
grid on


%%
% 1.e
%lambda = [10 15 20 25 30 35 40]; 
%C = 100;
%M = 4;
%R = 5000;

% 1.f
lambda = [100 150 200 250 300 350 400];
C = 1000;
M = 4;
R = 5000;

% capacidade do servidor / ocupação de um filme
N = 100/4;  % 1.e
N = 1000/4; % 1.f

miu = 86.3/60;

block = zeros(1,N);
blockPercentagem = zeros(1, length(lambda));

% blocking probability
for i= 1:length(lambda)
    a= 1;
    block(i)= 1;
    ro = lambda(i) * miu;
    for n= N:-1:1
        a= a*n/ro;
        block(i)= block(i)+a;
    end
    block(i)= 1/block(i);
    blockPercentagem(i) = block(i)*100;
end

% mediaBlock -> valores da simulaçao
% blockPercentagem -> valores teoricos
figure(3)
bar(lambda,[mediaBlock; blockPercentagem])


% Average system occupation
ocupPercentagem = zeros(1, length(lambda));
numerator = zeros(1, length(lambda));
denominator = zeros(1, length(lambda));

for j= 1:length(lambda)
    a= N;
    ro = lambda(j) * miu;
    numerator(j)= a;
    for i= N-1:-1:1
        a= a*i/ro;
        numerator(j)= numerator(j) + a;
    end
    a= 1;
    denominator(j)= a;
    for i= N:-1:1
        a= a*i/ro;
        denominator(j)= denominator(j) + a;
    end
    ocupPercentagem(j)= numerator(j)/denominator(j) * 4;
end

% mediaOcup -> valores da simulaçao
% ocupPercentagem -> valores teoricos
figure(4)
bar(lambda,[mediaOcup; ocupPercentagem])