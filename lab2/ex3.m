G= [ 1 2
 1 3
 1 4
 1 5
 1 6
 1 14
 1 15
 2 3
 2 4
 2 5
 2 7
 2 8
 3 4
 3 5
 3 8
 3 9
 3 10
 4 5
 4 10
 4 11
 4 12
 4 13
 5 12
 5 13
 5 14
 6 7
 6 16
 6 17
 6 18
 6 19
 7 19
 7 20
 8 9
 8 21
 8 22
 9 10
 9 22
 9 23
 9 24
 9 25
 10 11
 10 26
 10 27
 11 27
 11 28
 11 29
 11 30
 12 30
 12 31
 12 32
 13 14
 13 33
 13 34
 13 35
 14 36
 14 37
 14 38
 15 16
 15 39
 15 40
 20 21];

g = graph(G(:,1), G(:,2));

II = [];

for i = 1:40
    I = [];
    for j = 1:40
        [p, d] = shortestpath(g, i, j);
        if (d == 0) || (d ==1) || (d == 2)
            I = [I j];
        end
    end
    II{i} = [I];
end

display(II)

%%
g = graph(G(:,1), G(:,2));

fid = fopen('ex3.lp', 'wt');

fprintf(fid, 'Minimize\n');
for i= 6:40
   if i <= 15
       fprintf(fid, ' + %f x%d', 12, i);    % tier2
   else
       fprintf(fid, ' + %f x%d', 8, i);     % tier3
   end
end

fprintf(fid, '\nSubject To\n');
for j = 6:40
    for i = 6:40
        [p, d] = shortestpath(g, j, i);
        if (d <= 2)
            fprintf(fid, ' + x%d', i);
        end
    end
    fprintf(fid, ' >= %f\n', 1);
end


fprintf(fid,'Binary\n');
for i = 6:40
    fprintf(fid, ' x%d', i);
end

fprintf(fid,'\nEnd\n');
fclose(fid);

%% b)

r_tier2 = 10 * 5000;    % numero de AS tier2 * subscribers
r_tier3 = 25 * 2500;    % numero de AS tier3 * subscribers

lambda = ((r_tier2 + r_tier3) / 24);    % lambda - movies request rate (in requests/hour)
p = 30;                                 % p - percentage of requests for 4K movies (in %)
n = 76;                                 % n - number of servers
S = 1000;                               % S - interface capacity of each server(in Mbps)
W = 52150;                              % W - resource reservation for 4Kmovies(in Mbps)
R = 50000;                              % R - number of movie requests to stop simulation
fname = 'movies.txt';                   % fname - file name with the duration (in minutes) of the items

N = 5;  % number of simulations

block_hd = zeros(1,N); 
block_4k = zeros(1,N);

for it= 1:N
    [block_hd(it), block_4k(it)] = simulator2(lambda, p, n, S, W, R, fname);
end

% 90confidence interval %
alfa= 0.1; 

mediaBlock_hd = mean(block_hd);
termBlock_hd = norminv(1-alfa/2)*sqrt(var(block_hd)/N);

mediaBlock_4k = mean(block_4k);
termBlock_4k = norminv(1-alfa/2)*sqrt(var(block_4k)/N);
    
fprintf('\nNumber of servers: %.0f\n', n);
fprintf('Reservation for 4K: %.0f\n', W);
fprintf('block_hd: %.4f +- %.4f\n', mediaBlock_hd, termBlock_hd);
fprintf('block_4k: %.4f +- %.4f\n', mediaBlock_4k, termBlock_4k);

%%

r_tier2 = 10 * 5000;    % numero de AS tier2 * subscribers
r_tier3 = 25 * 2500;    % numero de AS tier3 * subscribers

lambda = ((r_tier2 + r_tier3) / 24);    % lambda - movies request rate (in requests/hour)
p = 30;                                 % p - percentage of requests for 4K movies (in %)
S = 1000;                               % S - interface capacity of each server(in Mbps)
W = 52150;                              % W - resource reservation for 4Kmovies(in Mbps)
R = 50000;                              % R - number of movie requests to stop simulation
fname = 'movies.txt';                   % fname - file name with the duration (in minutes) of the items

block_hd = zeros(1,5); 
block_4k = zeros(1,5);

n = [74 75 76 77 78];
for i=1:5
    [block_hd(i), block_4k(i)] = simulator2(lambda, p, n(i), S, W, R, fname);
end

figure(1)
bar(n, [block_hd; block_4k])
title('Blocking probability for n servers - W = 52150')
xlabel('Number of servers')
legend('HD', '4K')
grid on


