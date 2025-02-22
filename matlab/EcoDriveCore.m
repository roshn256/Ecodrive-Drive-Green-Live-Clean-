classdef EcoDriveCore
    %ECODRIVECORE Simplified file-based storage
    
    methods        
        function [trip_report, reward_status] = calculate_trip(~, varargin)
            [trip_report, reward_status] = EcoDrive_Advanced_Backend(varargin{:});
            EcoDriveCore.save_to_file(trip_report);
        end
        
        function history = get_history(~, days)
            if exist('trip_history.mat', 'file')
                load('trip_history.mat', 'history');
                cutoff = datetime('now') - days;
                history = history(history.date >= cutoff, :);
            else
                history = table();
            end
        end
    end
    
    methods (Static)
        function save_to_file(report)
            new_entry = table(datetime('now'), report.Distance_km, ...
                report.CO2_Emissions_kg, report.Driving_Score, ...
                'VariableNames', {'date', 'distance', 'emissions', 'score'});
            
            if exist('trip_history.mat', 'file')
                load('trip_history.mat', 'history');
                history = [history; new_entry];
            else
                history = new_entry;
            end
            
            save('trip_history.mat', 'history');
        end
    end
end