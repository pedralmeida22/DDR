%%
% a
p=0.6;
n=4;

f=p+(1-p)/n


%%
% b
p=0.7;
n=5;

g = p * n / (1 + (n - 1) * p)


%%
% c
p = linspace(0,1)

f3= p+(1-p)/3;
f4= p+(1-p)/4;
f5= p+(1-p)/5;

figure(1)
plot(p*100, f3*100, 'b-', p*100, f4*100, 'r--', p*100, f5*100, 'g:')
grid on
legend('n=3', 'n=4', 'n=5', 'location', 'NorthWest')
axis([0 100 0 100])
title('Probability of right answer (%)')
xlabel('p(%)')


%%
% d
figure(2)
g3 = p * 3 ./ (1 + (3 - 1) * p)
g4 = p * 4 ./ (1 + (4 - 1) * p)
g5 = p * 5 ./ (1 + (5 - 1) * p)

plot(p*100, g3*100, 'b-', p*100, g4*100, 'r--', p*100, g5*100, 'g:')
title('Probability of knowing answer (%)')
legend('n=3', 'n=4', 'n=5', 'location', 'NorthWest')
xlabel('p(%)')
axis([0 100 0 100])
grid on

