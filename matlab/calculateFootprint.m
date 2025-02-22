function emissions = calculateFootprint(distance, vehicle)
    % Validate inputs
    if ~isnumeric(distance) || distance < 0
        error('Distance must be a non-negative number.');
    end
    
    emissionFactors = containers.Map(...
        {'petrol', 'electric', 'hybrid', 'bike'},...
        [0.2, 0.05, 0.1, 0]);
    
    if ~isKey(emissionFactors, vehicle)
        error('Invalid vehicle type');
    end
    
    emissions = distance * emissionFactors(vehicle);
    fprintf('Emissions: %f kg\n', emissions);
end