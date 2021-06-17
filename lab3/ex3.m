lambda = [1500, 1600, 1700, 1800, 1900, 2000];
C = 10;
P = 10000;
f = 10000000;
%b = 0; % b)
b = 1e-5; % g

% number of simulations
%N = 20; % a
N = 40; % b

PL = zeros(1,N); 
APD = zeros(1,N);
MPD = zeros(1,N);
TT = zeros(1,N);

mediaPL = zeros(1, size(lambda, 2));
termPL = zeros(1, size(lambda, 2));
mediaAPD = zeros(1, size(lambda, 2));
termAPD = zeros(1, size(lambda, 2));
mediaMPD = zeros(1, size(lambda, 2));
termMPD = zeros(1, size(lambda, 2));
mediaTT = zeros(1, size(lambda, 2));
termTT = zeros(1, size(lambda, 2));

for i=1:size(lambda, 2)
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator2(lambda(i), C, f, P, b);
    end

    % 90 confidence interval %
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

% graficos
figure(1)
bar(lambda, mediaPL)
title('Packet Loss')
xlabel('Request/Hour')
ylabel('(%%)')
hold on
er = errorbar(lambda, mediaPL, termPL, termPL);
er.LineStyle = 'none';  
hold off
grid on

figure(2)
bar(lambda, mediaAPD)
title('Average Packet Delay')
xlabel('Request/Hour')
ylabel('(ms)')
hold on
er = errorbar(lambda, mediaAPD, termAPD, termAPD);
er.LineStyle = 'none';  
hold off
grid on

figure(3)
bar(lambda, mediaMPD)
title('Maximum Packet Delay')
xlabel('Request/Hour')
ylabel('(ms)')
hold on
er = errorbar(lambda, mediaMPD, termMPD, termMPD);
er.LineStyle = 'none';  
hold off
grid on

figure(4)
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
N = 40; % b

APD = zeros(1,N);
TT = zeros(1,N);

mediaAPD = zeros(1, size(lambda, 2));
mediaTT = zeros(1, size(lambda, 2));

for i=1:size(lambda, 2)
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator2(lambda(i), 10, f, P, b);
    end

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
figure(1)
bar(lambda, [mediaAPD; APD_mm1; APD_mg1])
title('Average Packet Delay')
xlabel('Request/Hour')
ylabel('(ms)')
legend('Sim', 'MM1', 'MG1', 'Location', 'northwest')
grid on

figure(2)
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
%b = 0; % d)
b = 1e-5; % f)

% number of simulations
N = 40;

PL = zeros(1,N); 
APD = zeros(1,N);
MPD = zeros(1,N);
TT = zeros(1,N);

mediaPL = zeros(1, size(f, 2));
termPL = zeros(1, size(f, 2));
mediaAPD = zeros(1, size(f, 2));
termAPD = zeros(1, size(f, 2));
mediaTT = zeros(1, size(f, 2));
termTT = zeros(1, size(f, 2));

for i=1:size(f, 2)
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator2(lambda, C, f(i), P, b);
    end

    % 90 confidence interval %
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
bar(f, mediaPL)
title('Packet Loss')
xlabel('Queue size (Bytes)')
ylabel('(%%)')
hold on
er = errorbar(f, mediaPL, termPL, termPL);
er.LineStyle = 'none';  
hold off
grid on

figure(2)
bar(f, mediaAPD)
title('Average Packet Delay')
xlabel('Queue size (Bytes)')
ylabel('(ms)')
hold on
er = errorbar(f, mediaAPD, termAPD, termAPD);
er.LineStyle = 'none';  
hold off
grid on

figure(3)
bar(f, mediaMPD)
title('Maximum Packet Delay')
xlabel('Queue size (Bytes)')
ylabel('(ms)')
hold on
er = errorbar(f, mediaMPD, termMPD, termMPD);
er.LineStyle = 'none';  
hold off
grid on

figure(4)
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
lambda = 1800;
C = 10;
P = 10000;
f = [2500, 5000, 7500, 10000, 12500, 15000, 17500, 20000];
b = 0; 

disp('Simulation started');
% number of simulations
N = 40;

PL = zeros(1,N); 
APD = zeros(1,N);
MPD = zeros(1,N);
TT = zeros(1,N);

mediaPL = zeros(1, size(f, 2));
mediaAPD = zeros(1, size(f, 2));
mediaTT = zeros(1, size(f, 2));

for i=1:size(f, 2)
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator2(lambda, C, f(i), P, b);
    end

    mediaPL(i) = mean(PL);
    mediaAPD(i) = mean(APD);
    mediaTT(i) = mean(TT);
end


% M/M/1/m queueing model
disp('MM1m started')
PL_mm1m = zeros(1, size(f,2));
APD_mm1m = zeros(1, size(f,2));
TT_mm1m = zeros(1, size(f,2));

aux2= [65:109 111:1517];
pres = (1-(0.2+0.16+0.25))/length(aux2);

B = 0.16*64 + 0.25*110 + 0.20*1518;
for i = 1:length(aux2)
    B = B + (aux2(i)*pres);
end

for i=1:size(f, 2)    
    m = round(f(i)/B)+1;
    miu=(C*1e6)/(B*8);
    numerador = 0;
    denominador = 0;
    
    for j=0:m
        denominador = denominador + (lambda/miu)^j;
        numerador = numerador + j*((lambda/miu)^j);
    end
    
    PL_mm1m(i) = (((lambda/miu)^m)/denominador);
    L = numerador/denominador;
    APD_mm1m(i) = (L/(lambda*(1-PL_mm1m(i))));
    
    TT_mm1m(i) = 0.16*lambda*(8*64) + 0.25*lambda*(8*110) + 0.20*lambda*(8*1518); 
    for j = 1:length(aux2)
        TT_mm1m(i) = TT_mm1m(i) + pres*lambda*(8*aux2(j));
    end
    TT_mm1m(i) = TT_mm1m(i)*(1-PL_mm1m(i));
    
    PL_mm1m(i) = PL_mm1m(i) * 100;
    APD_mm1m(i) = APD_mm1m(i) * 1000;
    TT_mm1m(i) = TT_mm1m(i) / (1e6);
end


% plots
figure(6)
bar(f, [mediaPL; PL_mm1m])
title('Packet Loss')
legend('Sim', 'MM1M', 'Location', 'northeast')
xlabel('Queue size (Bytes)')
ylabel('(%%)')
grid on

figure(7)
bar(f, [mediaAPD; APD_mm1m])
title('Average Packet Delay')
xlabel('Queue size (Bytes)')
ylabel('(ms)')
legend('Sim', 'MM1M', 'Location', 'northwest')
grid on

figure(8)
bar(f, [mediaTT; TT_mm1m])
title('Total Throughput')
xlabel('Queue size (Bytes)')
ylabel('(Mbps)')
legend('Sim', 'MM1M', 'Location', 'northwest')
grid on

%%%%% juntos
% figure(5)
% subplot(3,1,1)
% bar(f, [mediaPL; PL_mm1m])
% title('Packet Loss')
% xlabel('Queue size (Bytes)')
% ylabel('(%%)')
% legend('Sim', 'MM1M', 'Location', 'northeast')
% grid on
% 
% subplot(3,1,2)
% bar(f, [mediaAPD; APD_mm1m])
% title('Average Packet Delay')
% xlabel('Queue size (Bytes)')
% ylabel('(ms)')
% legend('Sim', 'MM1M', 'Location', 'northwest')
% grid on
% 
% subplot(3,1,3)
% bar(f, [mediaTT; TT_mm1m])
% title('Total Throughput')
% xlabel('Queue size (Bytes)')
% ylabel('(Mbps)')
% legend('Sim', 'MM1M', 'Location', 'northwest')
% grid on

%%
%h
lambda = [1500, 1600, 1700, 1800, 1900, 2000];
C = 10 * 1e6;
P = 10000;
f = 10000000;
b = 1e-5; % g

% number of simulations
N = 40; % b

PL = zeros(1,N); 
APD = zeros(1,N);
MPD = zeros(1,N);
TT = zeros(1,N);

mediaPL = zeros(1, size(lambda, 2));
mediaAPD = zeros(1, size(lambda, 2));
mediaMPD = zeros(1, size(lambda, 2));
mediaTT = zeros(1, size(lambda, 2));

disp('Simulation started...');
for i=1:size(lambda, 2)
    for it=1:N
       [PL(it), APD(it), MPD(it), TT(it)] = simulator2(lambda(i), 10, f, P, b);
    end

    mediaPL(i) = mean(PL);
    mediaAPD(i) = mean(APD);
    mediaMPD(i) = mean(MPD);
    mediaTT(i) = mean(TT);

end

% M/G/1 queueing model
disp('M/G/1 started...');

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

% graficos
figure(1)
bar(lambda, [mediaAPD; APD_mg1])
title('Average Packet Delay')
xlabel('Request/Hour')
ylabel('(ms)')
legend('Sim', 'MG1', 'Location', 'northwest')
grid on

figure(2)
bar(lambda, [mediaTT; TT_mg1])
title('Total Throughput')
xlabel('Request/Hour')
ylabel('(Mbps)')
legend('Sim', 'MG1', 'Location', 'northwest')
grid on
