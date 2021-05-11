% lambda - movies request rate (in requests/hour)
% p - percentage of requestsfor4Kmovies (in %)
% n - number of servers
% S - interface capacity of each server(in Mbps)
% W - resource reservation for 4Kmovies(in Mbps)
% R - number of movie requests to stop simulation
% fname - file name with the duration (in minutes) of the items

lambda = [100 120 140 160 180 200]; 
p = 20;
n = 10;
S = 100;
W = 0;
R = 10000;
fname = 'movies.txt';

% number of simulations
N = 10; 

% vectors with N simulation results
block_hd = zeros(1,N); 
block_4k = zeros(1,N);

mediaBlock_hd = zeros(1,size(lambda, 2));
termBlock_hd = zeros(1,size(lambda, 2));

mediaBlock_4k = zeros(1,size(lambda, 2));
termBlock_4k = zeros(1,size(lambda, 2));

for i = 1:size(lambda, 2)
    for it= 1:N
        [block_hd(it), block_4k(it)] = simulator2(lambda(i), p, n, S, W, R, fname);
    end
    
    %90% confidence interval%
    alfa= 0.1; 

    mediaBlock_hd(i) = mean(block_hd);
    termBlock_hd(i) = norminv(1-alfa/2)*sqrt(var(block_hd)/N);

    mediaBlock_4k(i) = mean(block_4k);
    termBlock_4k(i) = norminv(1-alfa/2)*sqrt(var(block_4k)/N);
    
end

figure(1)
bar(lambda, mediaBlock_hd)
hold on
er = errorbar(lambda, mediaBlock_hd, termBlock_hd, termBlock_hd);
er.LineStyle = 'none';  
hold off
grid on

figure(2)
bar(lambda, mediaBlock_4k)
hold on
er = errorbar(lambda, mediaBlock_4k, termBlock_4k, termBlock_4k);
er.LineStyle = 'none';  
hold off
grid on


%% 2.b) c) d)

lambda = [100 120 140 160 180 200]; 
p = 20;
n = 10;
S = 100;
% W = 0;    % b
% W = 400;  % c
 W = 600;  % d
R = 10000;
fname = 'movies.txt';

% number of simulations
N = 10; 

% vectors with N simulation results
block_hd = zeros(1,N); 
block_4k = zeros(1,N);
block_hd2 = zeros(1,N); 
block_4k2 = zeros(1,N);
block_hd3 = zeros(1,N); 
block_4k3 = zeros(1,N);

mediaBlock_hd = zeros(1,size(lambda, 2));
mediaBlock_hd2 = zeros(1,size(lambda, 2));
mediaBlock_hd3 = zeros(1,size(lambda, 2));

mediaBlock_4k = zeros(1,size(lambda, 2));
mediaBlock_4k2 = zeros(1,size(lambda, 2));
mediaBlock_4k3 = zeros(1,size(lambda, 2));

for i = 1:size(lambda, 2)
    for it= 1:N
        [block_hd(it), block_4k(it)] = simulator2(lambda(i), p, n, S, W, R, fname);
        [block_hd2(it), block_4k2(it)] = simulator2(lambda(i), p, 4, 250, W, R, fname);
        [block_hd3(it), block_4k3(it)] = simulator2(lambda(i), p, 1, 1000, W, R, fname);
    end
    
    %90% confidence interval%
    alfa= 0.1; 
    mediaBlock_hd(i) = mean(block_hd);
    mediaBlock_4k(i) = mean(block_4k);
    
    mediaBlock_hd2(i) = mean(block_hd2);
    mediaBlock_4k2(i) = mean(block_4k2);
    
    mediaBlock_hd3(i) = mean(block_hd3);
    mediaBlock_4k3(i) = mean(block_4k3);
    
end


figure(3)
bar(lambda,[mediaBlock_hd; mediaBlock_hd2; mediaBlock_hd3])
legend('HD1', 'HD2', 'HD3', 'Location', 'northwest')
ylim([0 100])
grid on

figure(4)
bar(lambda,[mediaBlock_4k; mediaBlock_4k2; mediaBlock_4k3])
legend('4k1', '4k2', '4k3', 'Location', 'northwest')
ylim([0 100])
grid on
