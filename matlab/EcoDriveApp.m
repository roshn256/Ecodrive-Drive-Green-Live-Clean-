classdef EcoDriveApp < matlab.apps.AppBase
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        InputPanel             matlab.ui.container.Panel
        ResultsPanel           matlab.ui.container.Panel
        StartLocationEditField matlab.ui.control.EditField
        EndLocationEditField   matlab.ui.control.EditField
        VehicleTypeDropDown    matlab.ui.control.DropDown
        CalculateButton        matlab.ui.control.Button
        GainTokensButton       matlab.ui.control.Button
        MapAxes                matlab.graphics.axis.GeographicAxes
        DistanceLabel          matlab.ui.control.Label
        EmissionsLabel         matlab.ui.control.Label
        TokensLabel            matlab.ui.control.Label
    end

    methods (Access = private)
        function createComponents(app)
            % Main Figure
            app.UIFigure = uifigure('Name', 'EcoDrive - Carbon Calculator', ...
                'Position', [100 100 850 600], ...
                'Color', [0.95 0.95 1]);

            % Input Panel
            app.InputPanel = uipanel(app.UIFigure, ...
                'Position', [20 20 340 560], ...
                'Title', 'Trip Details', ...
                'BackgroundColor', [0.9 0.9 1], ...
                'FontSize', 14);

            % Location Controls
            uilabel(app.InputPanel, 'Text','🏁 Start:', ...
                'Position',[20 510 120 22], 'FontWeight','bold');
            app.StartLocationEditField = uieditfield(app.InputPanel, 'text', ...
                'Position',[150 510 150 22], 'Value','Mumbai');

            uilabel(app.InputPanel, 'Text','📍 Destination:', ...
                'Position',[20 480 120 22], 'FontWeight','bold');
            app.EndLocationEditField = uieditfield(app.InputPanel, 'text', ...
                'Position',[150 480 150 22], 'Value','Pune');

            % Vehicle Controls
            uilabel(app.InputPanel, 'Text','🚗 Vehicle Type:', ...
                'Position',[20 450 120 22], 'FontWeight','bold');
            app.VehicleTypeDropDown = uidropdown(app.InputPanel, ...
                'Items', {'Petrol Car', 'Diesel Car', 'Electric Vehicle'}, ...
                'Position',[150 450 150 22], 'Value','Petrol Car');

            % Action Buttons
            app.CalculateButton = uibutton(app.InputPanel, 'push', ...
                'Text','Calculate Emissions', ...
                'Position',[120 400 150 30], ...
                'BackgroundColor', [0.2 0.6 0.8], ...
                'FontColor', 'white', ...
                'ButtonPushedFcn', @app.CalculateButtonPushed);

            app.GainTokensButton = uibutton(app.InputPanel, 'push', ...
                'Text','Eco Tips', ...
                'Position',[120 350 150 30], ...
                'BackgroundColor', [0.2 0.8 0.2], ...
                'FontColor', 'white', ...
                'ButtonPushedFcn', @app.GainTokensButtonPushed);

            % Results Panel
            app.ResultsPanel = uipanel(app.UIFigure, ...
                'Position', [340 20 440 560], ...
                'Title', 'Results', ...
                'BackgroundColor', [0.95 1 0.95], ...
                'FontSize', 14);

            % Map Display
            app.MapAxes = geoaxes(app.ResultsPanel, ...
                'Position', [20 300 400 240]);
            geobasemap(app.MapAxes, 'streets');

            % Result Labels
            app.DistanceLabel = uilabel(app.ResultsPanel, ...
                'Position', [20 260 400 22], ...
                'Text', '📏 Distance: 0 km', ...
                'FontSize', 12, 'FontWeight', 'bold');

            app.EmissionsLabel = uilabel(app.ResultsPanel, ...
                'Position', [20 230 400 22], ...
                'Text', '🌍 CO₂ Emissions: 0 kg', ...
                'FontSize', 12, 'FontWeight', 'bold');

            app.TokensLabel = uilabel(app.ResultsPanel, ...
                'Position', [20 200 400 22], ...
                'Text', '🪙 Eco Points: 0', ...
                'FontSize', 12, 'FontWeight', 'bold');
        end

        function CalculateButtonPushed(app, ~, ~)
            try
                % Get coordinates
                start_coords = app.geocodeLocation(app.StartLocationEditField.Value);
                end_coords = app.geocodeLocation(app.EndLocationEditField.Value);
                
                % Calculate route
                [distance_km, duration_mins] = app.getRouteDistance(start_coords, end_coords);
                
                % Calculate emissions
                emissions_kg = app.calculateEmissions(distance_km);
                
                % Update display
                app.updateDisplay(distance_km, emissions_kg);
                app.plotRoute(start_coords, end_coords);
                
            catch ME
                uialert(app.UIFigure, ME.message, 'Calculation Error');
            end
        end

        function coords = geocodeLocation(~, location)
            % Simplified geocoding
            locations = containers.Map(...
                {'mumbai', 'pune', 'delhi', 'bangalore'}, ...
                {[19.0760, 72.8777], [18.5204, 73.8567], ...
                 [28.7041, 77.1025], [12.9716, 77.5946]});
            
            if isKey(locations, lower(location))
                coords = locations(lower(location));
            else
                error('Location not supported: %s', location);
            end
        end

        function [distance_km, duration_mins] = getRouteDistance(~, start_coords, end_coords)
            % Simplified distance calculation using Haversine formula
            lat1 = deg2rad(start_coords(1));
            lon1 = deg2rad(start_coords(2));
            lat2 = deg2rad(end_coords(1));
            lon2 = deg2rad(end_coords(2));
            
            dlat = lat2 - lat1;
            dlon = lon2 - lon1;
            
            a = sin(dlat/2)^2 + cos(lat1)*cos(lat2)*sin(dlon/2)^2;
            c = 2 * atan2(sqrt(a), sqrt(1-a));
            
            distance_km = 6371 * c; % Earth radius in km
            duration_mins = distance_km * 1.2; % Simplified time estimation
        end

        function emissions_kg = calculateEmissions(app, distance_km)
            % Emission factors (kg/km)
            factors = containers.Map(...
                {'Petrol Car', 'Diesel Car', 'Electric Vehicle'}, ...
                [0.170, 0.150, 0.050]);
            
            emissions_kg = distance_km * factors(app.VehicleTypeDropDown.Value);
        end

        function updateDisplay(app, distance, emissions)
            app.DistanceLabel.Text = sprintf('📏 Distance: %.1f km', distance);
            app.EmissionsLabel.Text = sprintf('🌍 CO₂ Emissions: %.1f kg', emissions);
            app.TokensLabel.Text = sprintf('🪙 Eco Points: %d', round(100 - emissions*10));
        end

        function plotRoute(app, start_coords, end_coords)
            % Clear previous plot
            cla(app.MapAxes)
            
            % Plot route
            geoplot(app.MapAxes, [start_coords(1) end_coords(1)], ...
                               [start_coords(2) end_coords(2)], ...
                               'r-o', 'LineWidth', 2);
                           
            % Configure map labels
            app.MapAxes.LatitudeLabel.String = 'Latitude';
            app.MapAxes.LongitudeLabel.String = 'Longitude';
            
            % Set map limits
            lat_lim = sort([start_coords(1) end_coords(1)]) + [-0.1 0.1];
            lon_lim = sort([start_coords(2) end_coords(2)]) + [-0.1 0.1];
            geolimits(app.MapAxes, lat_lim, lon_lim)
        end

        function GainTokensButtonPushed(app, ~, ~)
            % Eco tips content
            tips = {
                '1. Maintain steady speeds between 50-80 km/h'
                '2. Avoid rapid acceleration and braking'
                '3. Keep tires properly inflated'
                '4. Remove unnecessary weight from vehicle'
                '5. Use air conditioning sparingly'
            };
            
            uialert(app.UIFigure, strjoin(tips, newline), 'Eco Driving Tips');
        end
    end

    methods (Access = public)
        function app = EcoDriveApp
            createComponents(app)
            app.UIFigure.Visible = 'on';
        end
    end
end