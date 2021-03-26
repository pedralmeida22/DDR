% a)
% n erros num pacote -> variavel aleatoria binomial
% sucesso é o BER
% n experiencias de Bernoulli é o n de bits do pacote

% f(0) = (n 0) * p^0 * (1-p)^(n-0)
n = 8 * 100;
p = 10^(-2);
f = (nchoosek(n, 0) * p^0 * (1-p)^(n-0)) * 100


%%
% b)
n = 8 * 1000;
p = 10^(-3);
f = (nchoosek(n, 1) * p^1 * (1-p)^(n-1)) * 100


%%
% c)
n = 8 * 200;
p = 10^(-4);

% 1 ou mais erros = 1 - f(0)
f = (1 - (nchoosek(n, 0) * p^0 * (1-p)^(n-0))) * 100 


%%
% d)
i = 0; % sem erros
p = logspace(-8, -2);

% 100 bytes
n = 8 * 100;
f_100 = nchoosek(n, i) .* p.^i .* (1-p).^(n-i);

% 200 bytes
n = 8 * 200;
f_200 = nchoosek(n, i) .* p.^i .* (1-p).^(n-i);

% 1000 bytes
n = 8 * 1000;
f_1000 = nchoosek(n, i) .* p.^i .* (1-p).^(n-i);

% plot(p, f_100 * 100, 'b-')
figure(1)
semilogx(p, f_100 * 100, 'b-', p, f_200 * 100, 'r--', p, f_1000 * 100, 'g:')
title('Probability of packet reception without errors (%)')
xlabel('Bit Error Rate')
legend('100 bytes', '200 bytes', '1000 bytes', 'location', 'SouthWest')
grid on


%%
% e)
i = 0; % sem erros
n = linspace(64*8, 1518*8);

p = 10^(-4);
f_4 = 1 * p^i * (1-p).^(n-i);

p = 10^(-3);
f_3 = 1 * p^i * (1-p).^(n-i);

p = 10^(-2);
f_2 = 1 * p^i * (1-p).^(n-i);

figure(2)
semilogy(n, f_4, 'b-', n, f_3, 'r--', n, f_2, 'g')
title('Probability of packet reception without errors')
xlabel('Packet Size (Bytes)')
legend('ber=1e-4', 'ber=1e-3', 'ber=1e-2', 'location', 'SouthWest')
grid on
