% INPUT PARAMETERS:
lambda = 1800;  % lambda - packet rate (packets/sec)
C = 10;         % link bandwidth (Mbps)
%f = 1000000;    % a)   % queue size (Bytes)
f = 10000;      % b)
P = 1000;       % number of packets (stopping criterium)

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
    [PL(it), APD(it), MPD(it), TT(it)] = simulator1(lambda, C, f, P);
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
    
fprintf('\nPacket Loss (%): %.4f + %.4f\n', mediaPL, termPL);
fprintf('Avg packet delay (ms): %.4f + %.4f\n', mediaAPD, termAPD);
fprintf('Max packet delay (ms): %.4f + %.4f\n', mediaMPD, termMPD);
fprintf('Throughtput (Mbps): %.4f +- %.4f\n', mediaTT, termTT);


%%
% c) M/M/1 queueing model
lambda = 1800;
C = 10;     %(Mbps)

% B - tamanho medio de pacotes
tam= [65:109 111:1517];
pres = ((100 - (16+25+20)) / length(tam)) / 100 ;

p64 = 64 * 0.16;
p110 = 110 * 0.25;
p1518 = 1518 * 0.20;

B = p64 + p110 + p1518;
for i=1:length(tam)
    B = B + (tam(i) * pres);
end
miu = (C *1e6) / (B * 8);
APD = 1000 / (miu - lambda);

TT = (1800 * (B * 8)) / 1e6;

fprintf('\nPacket Loss: %.f\n', 0);
fprintf('Avg packet delay (ms): %.4f\n', APD);
fprintf('Throughtput (Mbps): %.4f\n', TT);

