function tokens = manageTokens(distance, emissions, action)
    db = sqlite('tokens.db','create'); 

    % Token Awarding Logic (e.g., 1 token per 5 kg CO₂ saved)
    tokensEarned = floor(emissions / 5);

    % Fetch Current Token Balance
    result = fetch(db, "SELECT tokens FROM user_tokens WHERE id = 1");
    if isempty(result)
        exec(db, "INSERT INTO user_tokens (id, tokens) VALUES (1, 0)");
        currentTokens = 0;
    else
        currentTokens = result{1};
    end

    % Action Handling
    if action == "gain"
        newTokens = currentTokens + tokensEarned;
        exec(db, "UPDATE user_tokens SET tokens = ? WHERE id = 1", newTokens);
    elseif action == "redeem"
        if currentTokens >= tokensEarned
            newTokens = currentTokens - tokensEarned;
            exec(db, "UPDATE user_tokens SET tokens = ? WHERE id = 1", newTokens);
        else
            newTokens = currentTokens; % Not enough tokens to redeem
        end
    end

    % Return Updated Tokens
    tokens = newTokens;
    close(db);
end