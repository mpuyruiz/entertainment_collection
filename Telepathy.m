function Telepathy(num_players)

num_levels = getNumLevels(num_players);

cards = getCards(num_players, num_levels);

% Save content in separate text files, one per player.
for player = 1:num_players
    fid = fopen(['Telepathy_' datestr(now, 'yyyymmdd_HHMMSS')...
        '_Player' num2str(player) '.txt'], 'w');
    try
        printHeader(fid, num_players);
        % Print card numbers sorted from low to high for each level.
        for level = 1:num_levels
            fprintf(fid, 'Level %d:\t', level);
            fprintf(fid, '%d ', sort(cards{player, level}));
            fprintf(fid, '\n');
        end
        printInstructions(fid);
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

function printHeader(fid, num_players)

fprintf(fid, [...
    'TELEPATHY - a cooperative game for mind-readers\n\n'...
    'Please use the section below to keep track of your lives, shurikens and the numbers to be played.\n'...
    'How to play this game is described at the bottom.\n\n'...
    '###\n\n'...
    'Number of lives: %d\n\n'...
    'Number of shurikens: 1\n\n'...
    'Numbers to be played:\n'], num_players);

end

function printInstructions(fid)

fprintf(fid, [...
    '\n###\n\n'...
    'How to play:\n'...
    'Collectively you must say all your numbers in ascending order, but you can''t communicate with one\n'...
    'another in any way. So, when you feel the time is right, you say your lowest number.\n'...
    'If there was at least one lower number than which was said, you lose one life and all numbers that\n'...
    'were skipped are discarded.\n'...
    'When using a shuriken, all players openly discard their lowest number, giving everyone valuable\n'...
    'information and getting you closer to completing the level.\n'...
    'You might receive a reward when completing a level. In the list below you can find the rewards you\n'...
    'get at which level. Complete all the levels, and you win!\n\n'...
    'Level 2: shuriken\n'...
    'Level 3: life\n'...
    'Level 5: shuriken\n'...
    'Level 6: life\n'...
    'Level 8: shuriken\n'...
    'Level 9: life\n']);

end