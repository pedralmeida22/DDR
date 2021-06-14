lambda = [1500, 1600, 1700, 1800, 1900, 2000];
C = 10;
P = 10000;
f = 10000000;
b = 0; % b)
%b = 1e-5; % g

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
mediaMPD = size(lambda, 2);
termMPD = size(lambda, 2);
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
disp('Simulation started');

lambda = [1500, 1600, 1700, 1800, 1900, 2000];
C = 10 * 1e6;
P = 10000;
f = 10000000;
b = 0;

% number of simulations
%N = 20; % a
N = 40; % b
N = 5;

APD = zeros(1,N);
TT = zeros(1,N);

mediaAPD = size(lambda, 2);
mediaTT = size(lambda, 2);

for i=1:size(lambda, 2)
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator2(lambda(i), 10, f, P, b);
    end

    % 90confidence interval %
    alfa= 0.1; 

    mediaAPD(i) = mean(APD);
    mediaTT(i) = mean(TT);
end


% M/M/1 queueing model
disp('M/M/1 started');

tam= [65:109 111:1517];
pres = ((100 - (16+25+20)) / length(tam)) / 100;

p64 = 64 * 0.16;
p110 = 110 * 0.25;
p1518 = 1518 * 0.20;

% B - tamanho medio de pacotes
B = p64 + p110 + p1518;
for i=1:length(tam)
    B = B + (tam(i) * pres);
end
miu = (C) / (B * 8);

APD_mm1 = zeros(1, size(lambda, 2));
TT_mm1 = zeros(1, size(lambda, 2));

for i=1:size(lambda, 2)
    APD_mm1(i) = 1000 / (miu - lambda(i));
    TT_mm1(i) = (lambda(i) * (B * 8)) / 1e6;
end


% M/G/1 queueing model
disp('M/G/1 started');
b = 0; % ber

P64 = (1 - b)^(8*64);
P110 = (1 - b)^(8*110);
P1518 = (1 - b)^(8*1518);

% avg packet delay
es64 = 0.16 * ((8 * 64) / C);
es110 = 0.25 * ((8 * 110) / C);
es1518 = 0.20 * ((8 * 1518) / C);
ess64 = 0.16 * ((8 * 64) / C)^2;
ess110 = 0.25 * ((8 * 110) / C)^2;
ess1518 = 0.20 * ((8 * 1518) / C)^2;

es = es64 + es110 + es1518;
ess = ess64 + ess110 + ess1518;

for i=1:length(tam)
    es = es + (pres * ((8 * tam(i)) / C));
    ess = ess + (pres * ((8 * tam(i)) / C)^2);
end


APD_mg1 = zeros(1, size(lambda, 2));
TT_mg1 = zeros(1, size(lambda, 2));

for i=1:size(lambda, 2)
    wq = (lambda(i) * ess) / (2 * (1 - lambda(i) * es));
    
    wi64 = wq + ((8*64)/C);
    wi110 = wq + ((8*110)/C);
    wi1518 = wq + ((8*1518)/C);

    apdUp64 = 0.16 * P64 * wi64;
    apdUp110 = 0.25 * P110 * wi110;
    apdUp1518 = 0.20 * P1518 * wi1518;
    apdDown64 = 0.16 * P64;
    apdDown110 = 0.25 * P110;
    apdDown1518 = 0.20 * P1518;

    apdUp = apdUp64 + apdUp110 + apdUp1518;
    apdDown = apdDown64 + apdDown110 + apdDown1518;

    for it=1:length(tam)
        Pi = (1 - b)^(8*tam(it));
        wi = wq + ((8*tam(it))/C);
        apdUp = apdUp + pres * Pi * wi;
        apdDown = apdDown + pres * Pi;
    end

    APD_mg1(i) = 1e3 * (apdUp / apdDown);
    
    % total throughput
    T64= 0.16 * P64 * lambda(i)*8*64;
    T110= 0.25 * P110 * lambda(i)*8*110;
    T1518= 0.20 * P1518 * lambda(i)*8*1518;
    TT_mg1(i)= (T64 + T110 + T1518);

    for it=1:length(tam)
        Pi = (1 - b)^(8*tam(it));
        TT_mg1(i)= (TT_mg1(i) + (pres * Pi * lambda(i) * (8*tam(it))));
    end
    TT_mg1(i)= TT_mg1(i) / 1e6;
end

% plots
figure(4)
subplot(2,1,1)
bar(lambda, [mediaAPD; APD_mm1; APD_mg1])
title('Average Packet Delay')
xlabel('Request/Hour')
ylabel('(ms)')
legend('Sim', 'MM1', 'MG1', 'Location', 'northwest')
grid on

subplot(2,1,2)
bar(lambda, [mediaTT; TT_mm1; TT_mg1])
title('Total Throughput')
xlabel('Request/Hour')
ylabel('(Mbps)')
legend('Sim', 'MM1', 'MG1', 'Location', 'northwest')
grid on


%%
% d)
lambda = 1800;
C = 10;
P = 10000;
f = [2500, 5000, 7500, 10000, 12500, 15000, 17500, 20000];
b = 0; % d)
% b = 1e-5; % f)

% number of simulations
N = 40;

PL = zeros(1,N); 
APD = zeros(1,N);
MPD = zeros(1,N);
TT = zeros(1,N);

mediaPL = size(f, 2);
termPL = size(f, 2);
mediaAPD = size(f, 2);
termAPD = size(f, 2);
mediaTT = size(f, 2);
termTT = size(f, 2);

for i=1:size(f, 2)
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator2(lambda, C, f(i), P, b);
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
bar(f, mediaAPD)
title('Average Packet Delay')
xlabel('Queue size (Bytes)')
ylabel('(ms)')
hold on
er = errorbar(f, mediaAPD, termAPD, termAPD);
er.LineStyle = 'none';  
hold off
grid on

figure(2)
bar(f, mediaMPD)
title('Maximum Packet Delay')
xlabel('Queue size (Bytes)')
ylabel('(ms)')
hold on
er = errorbar(f, mediaMPD, termMPD, termMPD);
er.LineStyle = 'none';  
hold off
grid on

figure(3)
bar(f, mediaTT)
title('Total Throughput')
xlabel('Queue size (Bytes)')
ylabel('(Mbps)')
hold on
er = errorbar(f, mediaTT, termTT, termTT);
er.LineStyle = 'none';  
hold off
grid on


%%
% e)

