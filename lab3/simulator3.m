function [PL , APD , MPD , TT] = Simulator3(lambda,C,f,P,b)
% INPUT PARAMETERS:
%  lambda - packet rate (packets/sec)
%  C      - link bandwidth (Mbps)
%  f      - queue size (Bytes)
%  P      - number of packets (stopping criterium)
%  b      - Bit error rate
% OUTPUT PARAMETERS:
%  PL   - packet loss (%)
%  APD  - average packet delay (milliseconds)
%  MPD  - maximum packet delay (milliseconds)
%  TT   - transmitted throughput (Mbps)

 denominador = (1 + (10/5) + ((10/5)*(5/10)));
 
 % prob de cada estado
 s1 = 1 / denominador;
 s2 = (10/5) / denominador;
 s3 = ((10/5)*(5/10)) / denominador; 
 
 % tempo de permanencia em cada estado
 t1 = 1 / 10;
 t2 = 1 / (5 + 5);
 t3 = 1 / 10;

%Events:
ARRIVAL= 0;         % Arrival of a packet            
DEPARTURE= 1;       % Departure of a packet
TRANSITION= 2;      % transition of a state in the packet arriving Markov chain

%State variables:
STATE = 0;          % 0 - connection free; 1 - connection bysy
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TOTALPACKETS= 0;       % No. of packets arrived to the system
LOSTPACKETS= 0;        % No. of packets dropped due to buffer overflow
TRANSMITTEDPACKETS= 0; % No. of transmitted packets
TRANSMITTEDBYTES= 0;   % Sum of the Bytes of transmitted packets
DELAYS= 0;             % Sum of the delays of transmitted packets
MAXDELAY= 0;           % Maximum delay among all transmitted packets

%Auxiliary variables:
% Initializing the simulation clock:
Clock= 0;

rate = 0;   % "lambda" consoante o estado

temp = rand;
% escolhe estado inicial, atualiza o rate adequado ao estado e "agenda" o
% novo evento de transicao
if temp <= s1
    FlowState= 1;
    rate = lambda * 0.5;
    EventList = [TRANSITION, Clock + exprnd(t1), 0, 0];
elseif temp <= s1 + s2
    FlowState= 2;
    rate = lambda;
    EventList = [TRANSITION, Clock + exprnd(t2), 0, 0];
else
    FlowState= 3;
    rate = lambda * 1.5;
    EventList = [TRANSITION, Clock + exprnd(t3), 0, 0];
end

% Initializing the List of Events with the first ARRIVAL:
EventList = [EventList; ARRIVAL, Clock + exprnd(1/rate), GeneratePacketSize(), 0];


%Similation loop:
while TRANSMITTEDPACKETS<P               % Stopping criterium
    EventList= sortrows(EventList,2);    % Order EventList by time
    Event= EventList(1,1);               % Get first event and 
    Clock= EventList(1,2);               %   and
    PacketSize= EventList(1,3);          %   associated
    ArrivalInstant= EventList(1,4);      %   parameters.
    EventList(1,:)= [];                  % Eliminate first event
    switch Event
        case ARRIVAL                     % If first event is an ARRIVAL
            TOTALPACKETS= TOTALPACKETS+1;
            EventList = [EventList; ARRIVAL, Clock + exprnd(1/rate), GeneratePacketSize(), 0];
            if STATE==0
                STATE= 1;
                EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock];
            else
                if QUEUEOCCUPATION + PacketSize <= f
                    QUEUE= [QUEUE;PacketSize , Clock];
                    QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                else
                    LOSTPACKETS= LOSTPACKETS + 1;
                end
            end
            
        case DEPARTURE                    % If first event is a DEPARTURE
            error = rand() > ((1 - b)^(8*PacketSize));
            if error
                LOSTPACKETS= LOSTPACKETS + 1;
            else
                TRANSMITTEDBYTES= TRANSMITTEDBYTES + PacketSize;
                DELAYS= DELAYS + (Clock - ArrivalInstant);
                if Clock - ArrivalInstant > MAXDELAY
                    MAXDELAY= Clock - ArrivalInstant;
                end
                TRANSMITTEDPACKETS= TRANSMITTEDPACKETS + 1;
            end
            
            if QUEUEOCCUPATION > 0
                EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2)];
                QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                QUEUE(1,:)= [];
            else
                STATE= 0;
            end
            
        case TRANSITION     % If first event is a TRANSITION
            % se o estado é diferente do 2, entao o novo estado é o dois
            % atualiza o rate adequado ao estado 
            % e "agenda" novo evento de transicao
            if FlowState ~= 2   % transiçao para os estados 1 e 3
                % so pode ir para s2
                FlowState = 2;
                rate = lambda;
                EventList = [EventList; TRANSITION, Clock + exprnd(t2), 0, 0];
            
            else % FlowState == 2
                % decidir se vai para s1 ou s3
                temp = rand;
                if temp < 0.5   % taxa de transicao e igual para os dois estados possiveis (ou seja 50-50) 
                    FlowState = 1;
                    EventList = [EventList; TRANSITION, Clock + exprnd(t1), 0, 0];
                    rate = lambda * 0.5;
                else
                    FlowState = 3;
                    EventList = [EventList; TRANSITION, Clock + exprnd(t3), 0, 0];
                    rate = lambda * 1.5;
                end
            end
    end
end

%Performance parameters determination:
PL= 100*LOSTPACKETS/TOTALPACKETS;      % in %
APD= 1000*DELAYS/TRANSMITTEDPACKETS;   % in milliseconds
MPD= 1000*MAXDELAY;                    % in milliseconds
TT= 10^(-6)*TRANSMITTEDBYTES*8/Clock;  % in Mbps

end

function out= GeneratePacketSize()
    aux= rand();
    aux2= [65:109 111:1517];
    if aux <= 0.16
        out= 64;
    elseif aux <= 0.16 + 0.25
        out= 110;
    elseif aux <= 0.16 + 0.25 + 0.2
        out= 1518;
    else
        out = aux2(randi(length(aux2)));
    end
end


