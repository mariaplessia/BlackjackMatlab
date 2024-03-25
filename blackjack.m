clear all; close all; clc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Deck%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%creating the deck
%1 = ace, 11 = jack, 12 = queen, 13 = king. All others as indicated
%'Top' of the deck (next card to be drawn) is the first element
deck = [1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4;5;5;5;5;6;6;6;6;7;7;7;7;8;8;8;8;...
    9;9;9;9;10;10;10;10;11;11;11;11;12;12;12;12;13;13;13;13];

% Creating the suits: They are signle letters for convenience because of
% the limitations of using "==" with strings. The will be changed to
% proper, printable words later in the code.
suits = ['d';'c';'h';'s';'d';'c';'h';'s';'d';'c';'h';'s';'d';'c';'h';'s';...
    'd';'c';'h';'s';'d';'c';'h';'s';'d';'c';'h';'s';'d';'c';'h';'s';...
    'd';'c';'h';'s';'d';'c';'h';'s';'d';'c';'h';'s';'d';'c';'h';'s';...
    'd';'c';'h';'s';];

%Shuffling the deck via randomization of the elements of the vector
deck = deck(randperm(length(deck)));
suits = suits(randperm(length(suits)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%Dealing the cards%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:2
    player(i,1) = deck(1);
    % playerhand(i) is a duplicate of player(i,1) because we will need to
    % change the rank to the actual name for the royal cards and the ace
    % later so we need to change the numbers to strings but want to keep
    % player separate as floats because we will sum it up to get the score
    playerhand(i) = deck(1); 
    psuit(i,1) = suits(1);
    deck = deck(2:end);%removing dealt card from the deck
    suits = suits(2:end);%removing dealt suit from the deck
    
    dealer(i,1) = deck(1);
    dealerhand(i) = deck(1); % same as playerhand(i)
    dsuit(i,1) = suits(1);
    deck = deck(2:end);%removing dealt card from the deck
    suits = suits(2:end);%removing dealt suit from the deck
    %converting royal cards (jack etc.) into point values
    if player(i,1) > 10%does the player have royal cards?
        player(i,1)=10;%setting the value of the royal card to 10
    end
    if dealer(i,1)>10%does the dealer have royal cards?
        dealer(i,1)=10;%setting the value of the royal card to 10
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%GRAPHICS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The graphics section creates a uifigure with multiple layers of images
% (the table and the dealer hands) and two uibuttons representing the two
% choices in the game. The buttons work through functions written at the
% bottom of this script

fig = uifigure('Name','Blackjack Game');
% Create a UI axes
axes = uiaxes('Parent',fig,'Units','pixels','Position', [104, 200, 300, 201]);
set(fig,'color','k');
background = uiimage(fig);
background.ImageSource = 'table.png';
background.Position = [-17 20 600 600];
dealerimg = uiimage(fig);
dealerimg.ImageSource = 'dealer.png';
dealerimg.Position = [200 305 150 160];

hitbutton = uibutton(fig,'push','Text', 'Hit', 'Position',[300,10,50,25],...
    'ButtonPushedFcn', @(btn,event) hitButtonPushed(btn,axes,fig));
set(hitbutton,'Backgroundcolor','#D7BE69'); hitbutton.FontSize = 14;
hitbutton.FontName = 'Century'; hitbutton.FontWeight = 'bold';

staybutton = uibutton(fig,'push','Text','Stay','Position',[225,10,50,25],...
    'ButtonPushedFcn', @(btn,event) stayButtonPushed(btn,axes,fig));
set(staybutton,'Backgroundcolor','#D7BE69'); staybutton.FontSize = 14;
staybutton.FontName = 'Century'; staybutton.FontWeight = 'bold';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PLAYER LOGIC%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following for-loop uses playerhand(i) to change the royal cards' rank
% into a string with their names. It is also taking the first letter of the
% suit that has been dealt for the player and the dealer and it is turning
% it into a string that will be used for the fprintf statements. Lastly,
% the last group of if-statements prints the first two cards of the player
% on the screen. Image source: http://acbl.mybigcommerce.com/52-playing-cards/


for i=1:2
    player2 = (playerhand(i));
    dealer2 = (dealerhand(i));
    
    if psuit(i,1) == 'd'
        playersuit = 'of Diamonds';
    elseif psuit(i,1) == 'c'
        playersuit = 'of Clubs';
    elseif psuit(i,1) == 'h'
        playersuit = 'of Hearts';
    else
        playersuit = 'of Spades';
    end
    
    if dsuit(i,1) == 'd'
        dealersuit = 'of Diamonds';
    elseif dsuit(i,1) == 'c'
        dealersuit = 'of Clubs';
    elseif dsuit(i,1) == 'h'
        dealersuit = 'of Hearts';
    else
        dealersuit = 'of Spades';
    end
    
    
    if player2 == 11
        player2 = 'Jack';
    elseif player2 == 12
        player2 = 'Queen';
    elseif player2 == 13
        player2 = 'King';
    elseif player2 == 1
        player2 = 'Ace';
    else
        player2 = num2str(player2);
    end
    
    
    if dealer2 == 11
        dealer2 = 'Jack';
    elseif dealer2 == 12
        dealer2 = 'Queen';
    elseif dealer2 == 13
        dealer2 = 'King';
    elseif dealer2 == 1
        dealer2 = 'Ace';
    else
        dealer2 = num2str(dealer2);
    end
    
    fprintf('Player Card %d: %s %s\n',i,player2,playersuit)
    fprintf('Dealer Card %d: %s %s\n\n',i,dealer2,dealersuit)
    
    % The following lines print the images of the random 2 cards handed to
    % the player in the beginning of the game in the uifigure. The strcmp
    % is used because of the limitations of using '==' with strings
    
    if strcmp(playersuit,'of Diamonds')
        if strcmp(player2,'Ace')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'AD.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'2')
            pc(i) = uiimage(fig); pc(i).ImageSource = '2D.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'3')
            pc(i) = uiimage(fig); pc(i).ImageSource = '3D.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'4')
            pc(i) = uiimage(fig); pc(i).ImageSource = '4D.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'5')
            pc(i) = uiimage(fig); pc(i).ImageSource = '5D.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'6')
            pc(i) = uiimage(fig); pc(i).ImageSource = '6D.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'7')
            pc(i) = uiimage(fig); pc(i).ImageSource = '7D.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'8')
            pc(i) = uiimage(fig); pc(i).ImageSource = '8D.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'9')
            pc(i) = uiimage(fig); pc(i).ImageSource = '9D.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'10')
            pc(i) = uiimage(fig); pc(i).ImageSource = '10D.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'Jack')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'JD.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'Queen')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'QD.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'King')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'KD.png'; pc(i).Position = [(100+100*i) 60 80 80];
        end
        
    elseif strcmp(playersuit,'of Hearts')
        if strcmp(player2,'Ace')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'AH.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'2')
            pc(i) = uiimage(fig); pc(i).ImageSource = '2H.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'3')
            pc(i) = uiimage(fig); pc(i).ImageSource = '3H.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'4')
            pc(i) = uiimage(fig); pc(i).ImageSource = '4H.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'5')
            pc(i) = uiimage(fig); pc(i).ImageSource = '5H.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'6')
            pc(i) = uiimage(fig); pc(i).ImageSource = '6H.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'7')
            pc(i) = uiimage(fig); pc(i).ImageSource = '7H.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'8')
            pc(i) = uiimage(fig); pc(i).ImageSource = '8H.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'9')
            pc(i) = uiimage(fig); pc(i).ImageSource = '9H.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'10')
            pc(i) = uiimage(fig); pc(i).ImageSource = '10H.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'Jack')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'JH.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'Queen')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'QH.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'King')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'KH.png'; pc(i).Position = [(100+100*i) 60 80 80];
        end
        
    elseif strcmp(playersuit,'of Spades')
        if strcmp(player2,'Ace')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'AS.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'2')
            pc(i) = uiimage(fig); pc(i).ImageSource = '2S.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'3')
            pc(i) = uiimage(fig); pc(i).ImageSource = '3S.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'4')
            pc(i) = uiimage(fig); pc(i).ImageSource = '4S.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'5')
            pc(i) = uiimage(fig); pc(i).ImageSource = '5S.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'6')
            pc(i) = uiimage(fig); pc(i).ImageSource = '6S.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'7')
            pc(i) = uiimage(fig); pc(i).ImageSource = '7S.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'8')
            pc(i) = uiimage(fig); pc(i).ImageSource = '8S.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'9')
            pc(i) = uiimage(fig); pc(i).ImageSource = '9S.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'10')
            pc(i) = uiimage(fig); pc(i).ImageSource = '10S.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'Jack')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'JS.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'Queen')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'QS.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'King')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'KS.png'; pc(i).Position = [(100+100*i) 60 80 80];
        end
        
    elseif strcmp(playersuit,'of Clubs')
        if strcmp(player2,'Ace')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'AC.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'2')
            pc(i) = uiimage(fig); pc(i).ImageSource = '2C.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'3')
            pc(i) = uiimage(fig); pc(i).ImageSource = '3C.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'4')
            pc(i) = uiimage(fig); pc(i).ImageSource = '4C.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'5')
            pc(i) = uiimage(fig); pc(i).ImageSource = '5C.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'6')
            pc(i) = uiimage(fig); pc(i).ImageSource = '6C.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'7')
            pc(i) = uiimage(fig); pc(i).ImageSource = '7C.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'8')
            pc(i) = uiimage(fig); pc(i).ImageSource = '8C.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'9')
            pc(i) = uiimage(fig); pc(i).ImageSource = '9C.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'10')
            pc(i) = uiimage(fig); pc(i).ImageSource = '10C.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'Jack')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'JC.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'Queen')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'QC.png'; pc(i).Position = [(100+100*i) 60 80 80];
        elseif strcmp(player2,'King')
            pc(i) = uiimage(fig); pc(i).ImageSource = 'KC.png'; pc(i).Position = [(100+100*i) 60 80 80];
        end
    end
    
end

% Printing the two possible scores of the player after they get their first
% two cards
playerscore(1) = sum(player);
playerscore(2) = sum(player+ismember(player,1)*10);
fprintf('Player Score: %3.0d\n',playerscore(1))
fprintf('Player Score counting Aces as 11: %3.0d\n\n',playerscore(2))

% The following while-loop lasts as long as the score of the player is less
% than 21. The uiwait(fig) makes the program wait for an input (the push of
% one of the buttons), and then resumes through running the functions at
% the bottom of the script that activate the buttons. The loop breaks when
% the player stays and the figure closes. If the player hits stay, another
% card is dealt. Multiple cards can be dealt (the hit button can be pushed
% multiple times) as long as the score of the player is less than 21

while playerscore < 21
    uiwait(fig)
    if staybutton.UserData == 1
        playerscore(1) = sum(player);
        playerscore(2) = sum(player+ismember(player,1)*10);
        fprintf('Player Score: %3.0d\n',playerscore(1))
        fprintf('Player Score counting Aces as 11: %3.0d\n\n',playerscore(2))
        fig.delete;
        break
    elseif hitbutton.UserData == 1
        player = [player;deck(1)]; % Dealing another card
        psuit(i,1) = suits(1); % Dealing another suit
        if player(end)>10 % Checking drawn cards for face values
            player(end)=10;
        end
        
        if psuit(i,1) == 'd'
            playersuit2 = 'of Diamonds';
        elseif psuit(i,1) == 'c'
            playersuit2 = 'of Clubs';
        elseif psuit(i,1) == 'h'
            playersuit2 = 'of Hearts';
        else
            playersuit2 = 'of Spades';
        end

        
        % Printing each dealt card and the new scores
        fprintf('Player Card: %d %s\n',player(end,1),playersuit2)
        playerscore(1) = sum(player);
        playerscore(2) = sum(player+ismember(player,1)*10);
        deck = deck(2:end);
        suits = suits(2:end);
        fprintf('Player Score: %3.0d\n',playerscore(1))
        fprintf('Player Score counting Aces as 11: %3.0d\n\n',playerscore(2))
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%DEALER LOGIC DO NOT MODIFY%%%%%%%%%%%%%%%%%%%%%%%%%%
%Dealer logic - the dealer has strict rules to play by
%Checking if there are aces which can be 11 or 1

if sum(ismember(dealer,1))>0%checks if there are aces via logical test
    dealerscore(1) = sum(dealer);%couting ace as 1
    dealerscore(2) = sum(dealer+ismember(dealer,1)*10);%counting aces as 11=1+10
    fprintf('Dealer Score: %3.0d\n',dealerscore(1))
    fprintf('Dealer Score counting Aces as 11: %3.0d\n\n',dealerscore(2))
    %Checking did the dealer get blackjack? Only can happen when ace is 11
    if dealerscore(2)==21
        dealerscore=[];%clear the vector of scores b/c have blackjack
        dealerscore = 21;
        fprintf('Dealer Has 21!\n')
    elseif dealerscore(1)>=17%Dealer will sit on this value
        dealerscore(2)=[];
    elseif dealerscore(2)>=17%Dealer will sit on this value
        dealerscore(1)=[];
    else
        %Process for the dealer to get extra cards
        while dealerscore(1) <17%don't know how many cards, so use while loop
            dealer = [dealer;deck(1)];
            if dealer(end)>10%checking drawn cards for face values
                dealer(end)=10;
            end
            dealerscore(1) = sum(dealer);
            fprintf('Dealer Score: %3.0d\n',dealerscore(1))
            deck = deck(2:end);
        end
    end
else
    %Process for the dealer to get extra cards
    dealerscore = sum(dealer);%score of the dealer
    while dealerscore <17%don't know how many cards, so use while loop
        dealer = [dealer;deck(1)];
        if dealer(end)>10
            dealer(end)=10;
        end
        dealerscore = sum(dealer);
        deck = deck(2:end);
        fprintf('Dealer Score: %3.0d\n\n',dealerscore)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%WIN CONDITIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choosing the most favorable score in the playerscore and dealerscore matrices 
if max(playerscore) <= 21
    playerscore = max(playerscore);
else
    playerscore = min(playerscore);
end

if max(dealerscore) <= 21
    dealerscore = max(dealerscore);
else
    dealerscore = min(dealerscore);
end

fprintf('Dealer Final Score: %3.0d\n\n',dealerscore)

% Checking for the right order of win conditions
if dealerscore == 21
    fig.delete;
    load gong;
    loser_sound = audioplayer(y,Fs);
    play(loser_sound);
    fprintf('Dealer has 21! Dealer wins!\n')
    web('https://drmichellecleere.com/blog/how-to-deal-with-losing/');
elseif playerscore > 21
    fig.delete;
    load gong;
    loser_sound = audioplayer(y,Fs);
    play(loser_sound);
    fprintf('Player score > 21, player has busted. Dealer wins!\n')
    web('https://drmichellecleere.com/blog/how-to-deal-with-losing/');
elseif dealerscore > 21
    fig.delete;
    load handel;
    winner_sound = audioplayer(y,Fs);
    play(winner_sound);
    fprintf('Dealer score > 21, dealer has busted. Player wins!\n')
elseif playerscore == 21
    fig.delete;
    load handel;
    winner_sound = audioplayer(y,Fs);
    play(winner_sound);
    fprintf('Player has 21! Player wins!\n')
elseif playerscore == dealerscore
        fig.delete;
        load gong;
        loser_sound = audioplayer(y,Fs);
        play(loser_sound);
        fprintf('Dealer wins!\n')
        web('https://drmichellecleere.com/blog/how-to-deal-with-losing/');
elseif playerscore < 21 & dealerscore < 21
    if playerscore > dealerscore
        fig.delete;
        load handel;
        winner_sound = audioplayer(y,Fs);
        play(winner_sound);
        fprintf('Player is closer to 21. Player wins!\n')
    elseif playerscore < dealerscore
        fig.delete;
        load gong;
        loser_sound = audioplayer(y,Fs);
        play(loser_sound);
        fprintf('Dealer is closer to 21. Dealer wins!\n')
        web('https://drmichellecleere.com/blog/how-to-deal-with-losing/');
    elseif playerscore == dealerscore
        fig.delete;
        load gong;
        loser_sound = audioplayer(y,Fs);
        play(loser_sound);
        fprintf('Dealer wins!\n')
        web('https://drmichellecleere.com/blog/how-to-deal-with-losing/');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FUNCTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions for the ButtonPushedFcn callbacks: The hitbutton.UserData = 1
% and staybutton.UserData = 1 are set to one so that a specific value is
% returned with the push of a button and can be used as an output in the
% while-loop earlier in the code to create the conditions for pushing each
% button

function hitbutton = hitButtonPushed(btn,axes,fig)
hitbutton = btn;
hitbutton.UserData = 1; 
uiresume(fig) % Resuming the program after the push of the button
end

function staybutton = stayButtonPushed(btn,axes,fig)
staybutton = btn;
staybutton.UserData = 1;
uiresume(fig) % Resuming the program after the push of the button
end

