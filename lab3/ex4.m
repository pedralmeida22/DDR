% INPUT PARAMETERS:
lambda = 1800;  % lambda - packet rate (packets/sec)
C = 10;         % link bandwidth (Mbps)
f = 10e6; % a
% f = 10e4 % b
P = 100000;     % number of packets (stopping criterium)
b = 0;

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
    
fprintf('\nPacket Loss: %.4f + %.4f\n', mediaPL, termPL);
fprintf('Avg packet delay (ms): %.4f + %.4f\n', mediaAPD, termAPD);
fprintf('Max packet delay (ms): %.4f + %.4f\n', mediaMPD, termMPD);
fprintf('Throughtput (Mbps): %.4f +- %.4f\n', mediaTT, termTT);