function plotTimeseries(tt, log, varargin)
%PLOTTIMESERIES Plots timeseries with subplots
%   Detailed explanation goes here

    n = size(log, 1);

    % Define default options
    opts = struct('Title', 'Timeseries', ...
        'LineType', 'line', ...
        'MultiType', 'subplot');

    % Parse name-value pairs
    for k = 1:2:length(varargin)
        name = varargin{k};
        value = varargin{k+1};
        if isfield(opts, name)
            opts.(name) = value;
        else
            error('Unknown option name: %s', name);
        end
    end

    % figure

    for c = 1:size(log, 1)
        if strcmp(opts.MultiType, 'overlay')
            hold on
        else
            subplot(n, 1, c)
        end
        if strcmp(opts.LineType, 'stairs')
            stairs(tt, log(c, :), 'LineWidth', 2)
        else
            plot(tt, log(c, :), 'LineWidth', 2)
        end
        if c < 2, title(opts.Title); end
        xlabel('$t$(s)','interpreter','latex')
        % ylabel(['$', char(inputs(c)), '$'],'interpreter','latex')
        grid on
    end

end

