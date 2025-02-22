classdef EcoDriveRewards < handle
    properties
        UserData % Stores user emissions, tokens, and rewards
        UI % GUI Components
    end
    
    methods
        function obj = EcoDriveRewards()
            obj.createUI();
        end
        
        function createUI(obj)
            obj.UI.Figure = uifigure('Name', 'EcoDrive Rewards', 'Color', [0.8 0.9 0.95]);
            
            obj.UI.DistanceLabel = uilabel(obj.UI.Figure, 'Text', 'Distance (km):', 'Position', [20, 300, 100, 20], 'FontSize', 12, 'FontWeight', 'bold', 'ForegroundColor', [0 0 0.5]);
            obj.UI.DistanceInput = uieditfield(obj.UI.Figure, 'numeric', 'Position', [130, 300, 100, 20], 'Editable', 'off', 'BackgroundColor', [1 1 1]);
            
            obj.UI.VehicleLabel = uilabel(obj.UI.Figure, 'Text', 'Vehicle Type:', 'Position', [20, 260, 100, 20], 'FontSize', 12, 'FontWeight', 'bold', 'ForegroundColor', [0 0 0.5]);
            obj.UI.VehicleDropdown = uidropdown(obj.UI.Figure, 'Items', {'Petrol', 'Diesel', 'Electric', 'Hybrid'}, 'Position', [130, 260, 100, 20], 'BackgroundColor', [1 1 1]);
            
            obj.UI.StartLabel = uilabel(obj.UI.Figure, 'Text', 'Start Location:', 'Position', [20, 220, 100, 20], 'FontSize', 12, 'FontWeight', 'bold', 'ForegroundColor', [0 0.5 0]);
            obj.UI.StartInput = uieditfield(obj.UI.Figure, 'text', 'Position', [130, 220, 200, 20], 'BackgroundColor', [1 1 1]);
            
            obj.UI.EndLabel = uilabel(obj.UI.Figure, 'Text', 'End Location:', 'Position', [20, 190, 100, 20], 'FontSize', 12, 'FontWeight', 'bold', 'ForegroundColor', [0 0.5 0]);
            obj.UI.EndInput = uieditfield(obj.UI.Figure, 'text', 'Position', [130, 190, 200, 20], 'BackgroundColor', [1 1 1]);
            
            obj.UI.MapButton = uibutton(obj.UI.Figure, 'Text', 'Show Route on Map', 'Position', [20, 160, 200, 30], 'BackgroundColor', [0.2 0.6 1], 'FontSize', 12, 'FontWeight', 'bold', 'FontColor', [1 1 1], 'ButtonPushedFcn', @(~,~) obj.showMap());
            
            obj.UI.CalculateButton = uibutton(obj.UI.Figure, 'Text', 'Calculate Emission', 'Position', [20, 130, 200, 30], 'BackgroundColor', [0 0.7 0], 'FontSize', 12, 'FontWeight', 'bold', 'FontColor', [1 1 1], 'ButtonPushedFcn', @(~,~) obj.calculateEmission());
            
            obj.UI.EmissionLabel = uilabel(obj.UI.Figure, 'Text', 'Emissions: 0 kg CO2', 'Position', [20, 100, 200, 20], 'FontSize', 12, 'FontWeight', 'bold', 'ForegroundColor', [0.5 0 0]);
            
            obj.UI.TokenLabel = uilabel(obj.UI.Figure, 'Text', 'Tokens: 0', 'Position', [20, 70, 200, 20], 'FontSize', 12, 'FontWeight', 'bold', 'ForegroundColor', [0.3 0.3 0.3]);
            obj.UI.RedeemButton = uibutton(obj.UI.Figure, 'Text', 'Redeem Rewards', 'Position', [20, 40, 200, 30], 'BackgroundColor', [1 0.5 0], 'FontSize', 12, 'FontWeight', 'bold', 'FontColor', [1 1 1], 'ButtonPushedFcn', @(~,~) obj.redeemReward());
        end
    end
end
