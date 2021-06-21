% INPUT PARAMETERS:
lambda = 1800;  % lambda - packet rate (packets/sec)
C = 10;         % link bandwidth (Mbps)
P = 100000;     % number of packets (stopping criterium)
%f = 1e6; % a
%b = 0;   % a
f = 1e4; % b
b = 1e-5; % b

% OUTPUT PARAMETERS:
%  PL   - packet loss (%)
%  APD  - average packet delay (milliseconds)
%  MPD  - maximum packet delay (milliseconds)
%  TT   - transmitted throughput (Mbps)

N = 10;  % number of simulations

PL = zeros(1,N); 
APD = zeros(1,N);
MPD = zeros(1,N);
TT = zeros(1,N);

for it= 1:N
    [PL(it), APD(it), MPD(it), TT(it)] = simulator3(lambda, C, f, P, b);
end

% 90confidence interval %
alfa= 0.1; 

mediaPL = mean(PL);
termPL = norminv(1-alfa/2)*sqrt(var(PL)/N);

mediaAPD = mean(APD);
termAPD = norminv(1-alfa/2)*sqrt(var(APD)/N);

mediaMPD = mean(MPD);
termMPD = norminv(1-alfa/2)*sqrt(var(MPD)/N);

mediaTT = mean(TT);
termTT = norminv(1-alfa/2)*sqrt(var(TT)/N);
    
fprintf('\nPacket Loss: %.4e + %.4e\n', mediaPL, termPL);
fprintf('Avg packet delay (ms): %.4e + %.4e\n', mediaAPD, termAPD);
fprintf('Max packet delay (ms): %.4e + %.4e\n', mediaMPD, termMPD);
fprintf('Throughtput (Mbps): %.4e +- %.4e\n', mediaTT, termTT);

%%
% 4.c
lambda = [1500, 1600, 1700, 1800, 1900, 2000];  % lambda - packet rate (packets/sec)
C = 10;         % link bandwidth (Mbps)
P = 100000;     % number of packets (stopping criterium)
f = 1e7;
%b = 0; % c)
b = 1e-5; % e)

mediaPL = zeros(1, size(lambda, 2));
mediaAPD = zeros(1, size(lambda, 2));
mediaMPD = zeros(1, size(lambda, 2));
mediaTT = zeros(1, size(lambda, 2));

mediaPL3 = zeros(1, size(lambda, 2));
mediaAPD3 = zeros(1, size(lambda, 2));
mediaMPD3 = zeros(1, size(lambda, 2));
mediaTT3 = zeros(1, size(lambda, 2));

for i=1:size(lambda, 2)
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator2(lambda(i), C, f, P, b);
    end
    
    mediaPL(i) = mean(PL);
    mediaAPD(i) = mean(APD);
    mediaMPD(i) = mean(MPD);
    mediaTT(i) = mean(TT);
    
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator3(lambda(i), C, f, P, b);
    end
    
    mediaPL3(i) = mean(PL);
    mediaAPD3(i) = mean(APD);
    mediaMPD3(i) = mean(MPD);
    mediaTT3(i) = mean(TT);
end

% plots
figure(1)
bar(lambda, [mediaPL; mediaPL3])
title('Packet Loss')
xlabel('Request/Hour')
ylabel('(%%)')
legend('Sim2', 'Sim3', 'Location', 'northwest')
grid on

figure(2)
bar(lambda, [mediaAPD; mediaAPD3])
title('Average Packet Delay')
xlabel('Request/Hour')
ylabel('(ms)')
legend('Sim2', 'Sim3', 'Location', 'northwest')
grid on

figure(3)
bar(lambda, [mediaMPD; mediaMPD3])
title('Maximum Packet Delay')
xlabel('Request/Hour')
ylabel('(ms)')
legend('Sim2', 'Sim3', 'Location', 'northwest')
grid on

figure(4)
bar(lambda, [mediaTT; mediaTT3])
title('Throughput')
xlabel('Request/Hour')
ylabel('(Mbps)')
legend('Sim2', 'Sim3', 'Location', 'northwest')
grid on

%% 
% 4 d)
lambda = 1800;  % lambda - packet rate (packets/sec)
C = 10;         % link bandwidth (Mbps)
P = 100000;     % number of packets (stopping criterium)
f = [2500, 5000, 7500, 10000, 12500, 15000, 17500, 20000]; 
b = 0; % d)
%b = 1e-5; % f)

mediaPL = zeros(1, size(f, 2));
mediaAPD = zeros(1, size(f, 2));
mediaMPD = zeros(1, size(f, 2));
mediaTT = zeros(1, size(f, 2));

mediaPL3 = zeros(1, size(f, 2));
mediaAPD3 = zeros(1, size(f, 2));
mediaMPD3 = zeros(1, size(f, 2));
mediaTT3 = zeros(1, size(f, 2));

for i=1:size(f, 2)
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator2(lambda, C, f(i), P, b);
    end
    
    mediaPL(i) = mean(PL);
    mediaAPD(i) = mean(APD);
    mediaMPD(i) = mean(MPD);
    mediaTT(i) = mean(TT);
    
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator3(lambda, C, f(i), P, b);
    end
    
    mediaPL3(i) = mean(PL);
    mediaAPD3(i) = mean(APD);
    mediaMPD3(i) = mean(MPD);
    mediaTT3(i) = mean(TT);
end

% plots
figure(1)
bar(f, [mediaPL; mediaPL3])
title('Packet Loss')
xlabel('Queue size (Bytes)')
ylabel('(%%)')
legend('Sim2', 'Sim3', 'Location', 'northwest')
grid on

figure(2)
bar(f, [mediaAPD; mediaAPD3])
title('Average Packet Delay')
xlabel('Queue size (Bytes)')
ylabel('(ms)')
legend('Sim2', 'Sim3', 'Location', 'northwest')
grid on

figure(3)
bar(f, [mediaMPD; mediaMPD3])
title('Maximum Packet Delay')
xlabel('Queue size (Bytes)')
ylabel('(ms)')
legend('Sim2', 'Sim3', 'Location', 'northwest')
grid on

figure(4)
bar(f, [mediaTT; mediaTT3])
title('Throughput')
xlabel('Queue size (Bytes)')
ylabel('(Mbps)')
legend('Sim2', 'Sim3', 'Location', 'northwest')
grid on

