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

% b
lambda = [10 15 20 25 30 35 40]; 
C = 100;
M = 4;
R = 500;
fname = 'movies.txt';

%c
lambda = [10 15 20 25 30 35 40]; 
C = 100;
M = 4;
R = 5000;

%d change valuesss
lambda = [100 150 200 250 300 350 400];
C = 1000;
M = 4;
R = 5000;

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
er = errorbar(lambda, mediaBlock, term, term)
er.LineStyle = 'none';  
hold off
grid on

figure(2)
bar(lambda, mediaOcup)
hold on
er = errorbar(lambda, mediaOcup, term, term)
er.LineStyle = 'none';  
hold off
grid on

