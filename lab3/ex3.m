lambda = [1500, 1600, 1700, 1800, 1900, 2000];
C = 10;
P = 10000;
f = 10000000;
b = 0;

% number of simulations
%N = 20; % a
N = 40; % b

PL = zeros(1,N); 
APD = zeros(1,N);
MPD = zeros(1,N);
TT = zeros(1,N);

mediaPL = size(lambda, 2);
termPL = size(lambda, 2);
mediaAPD = size(lambda, 2);
termAPD = size(lambda, 2);
mediaTT = size(lambda, 2);
termTT = size(lambda, 2);

for i=1:size(lambda, 2)
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator2(lambda(i), C, f, P, b);
    end

    % 90confidence interval %
    alfa= 0.1; 

    mediaPL(i) = mean(PL);
    termPL(i) = norminv(1-alfa/2)*sqrt(var(PL)/N);

    mediaAPD(i) = mean(APD);
    termAPD(i) = norminv(1-alfa/2)*sqrt(var(APD)/N);

    mediaMPD(i) = mean(MPD);
    termMPD(i) = norminv(1-alfa/2)*sqrt(var(MPD)/N);

    mediaTT(i) = mean(TT);
    termTT(i) = norminv(1-alfa/2)*sqrt(var(TT)/N);
end

figure(1)
bar(lambda, mediaAPD)
title('Average Packet Delay')
xlabel('Request/Hour')
ylabel('(ms)')
hold on
er = errorbar(lambda, mediaAPD, termAPD, termAPD);
er.LineStyle = 'none';  
hold off
grid on

figure(2)
bar(lambda, mediaMPD)
title('Maximum Packet Delay')
xlabel('Request/Hour')
ylabel('(ms)')
hold on
er = errorbar(lambda, mediaMPD, termMPD, termMPD);
er.LineStyle = 'none';  
hold off
grid on

figure(3)
bar(lambda, mediaTT)
title('Total Throughput')
xlabel('Request/Hour')
ylabel('(Mbps)')
hold on
er = errorbar(lambda, mediaTT, termTT, termTT);
er.LineStyle = 'none';  
hold off
grid on

%%
% c) 
% simulation values
% M/M/1 queueing model
% M/G/1 queueing model
% plots


