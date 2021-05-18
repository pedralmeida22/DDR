function [b_hd b_4k]= simulator2(lambda, p, n, S, W, R, fname)
    % lambda - movies request rate (in requests/hour)
    % p - percentage of requests for 4K movies (in %)
    % n - number of servers
    % S - interface capacity of each server(in Mbps)
    % W - resource reservation for 4Kmovies(in Mbps)
    % R - number of movie requests to stop simulation
    % fname - file name with the duration (in minutes) of the items
    
    C = n * S;
    
    invlambda= 60/lambda;     %average time between requests (in minutes)
    invmiu= load(fname);     %duration (in minutes) of each movie
    Nmovies= length(invmiu); % number of movies
    
    %Events definition:
    ARRIVAL= 0;        %movie request
    DEPARTURE_HD = 1;  %termination of a HD movie transmission
    DEPARTURE_4K = 2;  %termination of a 4K movie transmission
    
    %State variables initialization:
    STATE= zeros(1, n);
    STATE_HD= 0;
    
    %Statistical counters initialization:
    NARRIVALS= 0;   % total number of movie requests up to current time instant
    REQUESTS_HD= 0; % number of HD movie requests up to current time instant
    REQUESTS_4K= 0; % number of 4K movie requests up to current time instant
    BLOCKED_HD= 0;  % number of blocked HD movie requests up to current time instant
    BLOCKED_4K= 0;  % number of blocked 4K movie requests up to current time instant
    
     %Simulation Clock and initial List of Events:
    Clock= 0;
    EventList= [ARRIVAL exprnd(invlambda) 0];

     while NARRIVALS < R
        event= EventList(1,1);
        Clock= EventList(1,2);
        server_id = EventList(1,3);
        EventList(1,:)= [];
        
        % chegou um filme
        if event == ARRIVAL
            EventList= [EventList; ARRIVAL Clock+exprnd(invlambda) 0];
            NARRIVALS= NARRIVALS + 1;
            % filme 4k
            if rand() <= p/100
                [valor, index] = min(STATE);
                REQUESTS_4K = REQUESTS_4K + 1;
                if valor + 25 <= S
                    EventList= [EventList; DEPARTURE_4K Clock+invmiu(randi(Nmovies)) index];
                    STATE(index) = STATE(index) + 25;
                else
                    BLOCKED_4K= BLOCKED_4K + 1;
                end
            % filme HD    
            else
                [valor, index] = min(STATE);
                REQUESTS_HD=REQUESTS_HD + 1;
                if (valor + 5 <= S) && (STATE_HD + 5 <= C - W)
                    EventList= [EventList; DEPARTURE_HD Clock+invmiu(randi(Nmovies)) index];
                    STATE_HD = STATE_HD + 5;
                    STATE(index) = STATE(index) + 5;
                else
                    BLOCKED_HD = BLOCKED_HD + 1;
                end
            end
        % filme terminou, libertar recursos
        else
            if event == DEPARTURE_HD
                STATE(server_id) = STATE(server_id) - 5;
                STATE_HD = STATE_HD - 5;
            elseif event == DEPARTURE_4K
                STATE(server_id) = STATE(server_id) - 25;
            end
        end
        EventList= sortrows(EventList,2);
     end
    
    b_hd= 100*(BLOCKED_HD/REQUESTS_HD);    % blocking probability of HD movie requests %
    b_4k= 100*(BLOCKED_4K/REQUESTS_4K);    % blocking probability of 4K movie requests %
end
