classdef ecodriveapii < handle
    methods
        function response = handleRequest(~, request)
            try
                % Extract JSON data from request body
                jsonData = char(request.Body.Data);
                params = jsondecode(jsonData);

                % Extract request parameters
                origin = params.origin;
                destination = params.destination;
                vehicleType = params.vehicleType;

                % Simulate distance calculation (Fixed value)
                distance = 100; % Assume 100 km for testing

                % Compute carbon footprint
                footprint = ecodriveapii.calculateFootprint(distance, vehicleType);

                % Compute reward tokens
                tokens = ecodriveapii.manageTokens(footprint);

                % Format response JSON
                responseData = struct('distance', distance, 'footprint', footprint, 'tokens', tokens);
                response = matlab.net.http.ResponseMessage(200, ...
                    matlab.net.http.HeaderField("Content-Type", "application/json"), ...
                    jsonencode(responseData));

            catch ME
                response = matlab.net.http.ResponseMessage(500, ...
                    matlab.net.http.HeaderField("Content-Type", "application/json"), ...
                    jsonencode(struct('error', ME.message)));
            end
        end

        function distance = getDistance(~, ~, ~)
            % Dummy function (No API Call)
            distance = 100; % Fixed distance value for testing
        end

        function footprint = calculateFootprint(~, distance, vehicleType)
            % Function to calculate carbon footprint
            emissionFactors = containers.Map(...
                {'petrol', 'diesel', 'electric', 'hybrid', 'bike'}, ...
                [0.2, 0.25, 0.05, 0.1, 0]); % kg CO2 per km

            if isKey(emissionFactors, vehicleType)
                footprint = distance * emissionFactors(vehicleType);
            else
                error('Invalid vehicle type');
            end
        end

        function tokens = manageTokens(~, footprint)
            % Function to convert carbon savings into reward tokens
            if footprint < 2
                tokens = 5;
            elseif footprint < 5
                tokens = 10;
            else
                tokens = 20;
            end
        end
    end
end
