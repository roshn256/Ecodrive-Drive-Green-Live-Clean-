function install_dependencies()
    % Check for SQLite support
    if ~exist('sqlite', 'file')
        error('SQLite support requires MATLAB R2022b or later');
    end
end