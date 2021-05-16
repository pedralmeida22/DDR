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
for i = 6:40
    for j = 6:40
        [p, d] = shortestpath(g, i, j);
        if (d == 0) || (d ==1) || (d == 2)
            fprintf(fid, ' + y%d_%d', i, j);
        end
    end
    fprintf(fid, ' = %f\n', 1);
end

for i = 6:40
    for j = 6:40
        [p, d] = shortestpath(g, i, j);
        if (d == 0) || (d ==1) || (d == 2)
            fprintf(fid, ' + y%d_%d', i, j);
        end
    end
    fprintf(fid, ' = 0\n');
end

fprintf(fid,'Binary\n');
for i = 6:40
    fprintf(fid, ' x%d', i);
end
for i = 6:40
    for j = 6:40
        [p, d] = shortestpath(g, i, j);
        if (d == 0) || (d ==1) || (d == 2)
            fprintf(fid, ' y%d_%d', i, j);
        end
    end
    fprintf(fid, '\n');
end

fprintf(fid,'End\n');
fclose(fid);
