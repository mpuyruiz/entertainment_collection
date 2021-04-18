function Telepathy(num_players)

num_levels = getNumLevels(num_players);

cards = getCards(num_players, num_levels);

% Save content in separate text files, one per player.
for player = 1:num_players
    fid = fopen(['Telepathy_' datestr(now, 'yyyymmdd_HHMMSS')...
        '_Player' num2str(player) '.txt'], 'w');
    try
        printHeader(fid);
        % Print card numbers sorted from low to high for each level.
        for level = 1:num_levels
            fprintf(fid, 'Level %d:\t', level);
            fprintf(fid, '%d ', sort(cards{player, level}));
            fprintf(fid, '\n');
        end
        printInstructions(fid, num_players);
        fclose(fid);
    catch ME
        fclose(fid);
        rethrow(ME);
    end
end

end

function num_levels = getNumLevels(num_players)

if num_players == 2
    num_levels = 12;
elseif num_players == 3
    num_levels = 10;
elseif num_players == 4
    num_levels = 8;
else
    error('Number of players must be 2, 3 or 4.');
end

end

function cards = getCards(num_players, num_levels)

cards = cell(num_players, num_levels);
% Cards are shuffled and dealt out per level.
for level = 1:num_levels
    cards(:, level) = getCardsForLevel(num_players, level);
end

end

function cards = getCardsForLevel(num_players, level)

cards = cell(num_players, 1);
cards_shuffled = randperm(100);
% Hand out all cards to each player.
for player = 1:num_players
    first = (player - 1) * level + 1;
    last = first + level - 1;
    cards{player, 1} = cards_shuffled(first:last);
end

end

function printHeader(fid)

fprintf(fid, [...
    'Telepathy\n\n'...
    'Numbers:\n']);

end

function printInstructions(fid, num_players)

fprintf(fid, [...
    '\nHow to play:\n'...
    'Collectively you must say these numbers in ascending order, but\n'...
    'you can''t communicate with one another in any way. You simply\n'...
    'stare into one another''s eyes, and when you feel the time is\n'...
    'right, you say your lowest number. If no one has a number lower\n'...
    'than what you said: great, the game continues! However, if someone\n'...
    'does, all players discard all numbers lower than what you said and\n'...
    'you lose one life.\n'...
    'When using a shuriken, all players openly discard their lowest\n'...
    'number, giving everyone valuable information and getting you\n'...
    'closer to completing the level.\n'...
    'As you complete levels, you might receive a reward: a shuriken or\n'...
    'an extra life. Complete all the levels, and you win!\n\n'...
    'Initial number of lives: %d\n'...
    'Initial number of shuriken: 1\n\n'...
    'Rewards:\n'...
    'Level 2:\tshuriken\n'...
    'Level 3:\tlife\n'...
    'Level 5:\tshuriken\n'...
    'Level 6:\tlife\n'...
    'Level 8:\tshuriken\n'...
    'Level 9:\tlife\n'], num_players);

end