function distance = getDistance(apiKey, origin, destination)
    baseURL = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    url = sprintf('%s?origins=%s&destinations=%s&key=%s', ...
                  baseURL, origin, destination, apiKey);
    try
        data = webread(url);
        if strcmp(data.status, 'OK')
            distance = data.rows(1).elements(1).distance.value / 1000; % Convert to km
        else
            error('Failed to retrieve distance: %s', data.status);
        end
    catch ME
        error('Failed to retrieve distance: %s', ME.message);
    end
end