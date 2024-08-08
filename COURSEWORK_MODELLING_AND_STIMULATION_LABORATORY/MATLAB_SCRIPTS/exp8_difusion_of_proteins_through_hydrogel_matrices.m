% % Define global variables for data sharing between functions
% global Time Diffusion_Fraction
% 
% % Data for Insulin from Table 1
% Time_Insulin = [0.09320175, 0.18725241, 0.48210243, 0.98687748, 1.48666525, 1.99197085]';
% Diffusion_Fraction_Insulin = [0.66315789, 0.86578947, 0.92894737, 0.97368421, 0.98947368, 0.99473684]';
% 
% % Data for Trypsin Inhibitor from Table 2
% Time_Trypsin = [0.109256962, 0.205797973, 0.511431829, 1.001904261, 1.50550607, 1.999862192]';
% Diffusion_Fraction_Trypsin = [0.64198895, 0.756906077, 0.913812155, 0.973480663, 0.991160221, 0.993370166]';
% 
% % Fit and plot for Insulin
% fit_and_plot(Time_Insulin, Diffusion_Fraction_Insulin, 'Insulin Diffusion in PEG 10000 Hydrogel');
% 
% % Fit and plot for Trypsin Inhibitor
% fit_and_plot(Time_Trypsin, Diffusion_Fraction_Trypsin, 'Trypsin Inhibitor Diffusion in PEG 10000 Hydrogel');
% 
% function fit_and_plot(Time, Diffusion_Fraction, plot_title)
%     global Time Diffusion_Fraction
% 
%     % Ensure Time and Diffusion_Fraction are column vectors
%     Time = Time(:);
%     Diffusion_Fraction = Diffusion_Fraction(:);
% 
%     % Optimization settings
%     A = [];
%     b = [];
%     Aeq = [];
%     beq = [];
%     lb = 1e-8; % Lower bound for D
%     ub = 1e-4; % Upper bound for D
%     nonlcon = [];
%     options = optimoptions('fmincon', 'Display', 'iter');
% 
%     % Initial guess for D
%     D0 = 1.15e-6; % Initial guess closer to 1.15e-6 cm^2/s
% 
%     % Perform optimization to find the best fit for D
%     D = fmincon(@costfun, D0, A, b, Aeq, beq, lb, ub, nonlcon, options);
% 
%     % Define the symbolic variables and expression for Mt/M∞
%     syms n t
%     L = 0.04; % Characteristic length
%     f_1(t) = (8 / ((2 * n + 1)^2 * pi^2)) * exp((-D * (2 * n + 1)^2 * pi^2 * t) / (4 * L^2));
%     M_1(t) = 1 - symsum(f_1(t), n, 0, 100); % Limited to 100 terms for practical evaluation
% 
%     % Define a time vector for plotting (in seconds, hence the conversion)
%     T = 0:0.2:max(Time)*3600; % Time vector in seconds, exponential spacing
% 
%     % Evaluate M(t)/M∞ using the optimized D
%     mt_minf_1 = double(M_1(T)); % Evaluate symbolic expression
% 
%     % Create a figure for plotting
%     figure()
%     xlabel('Time (hours)', 'Interpreter', 'latex')
%     ylabel('$$M_{t}/M_{\infty} (\%)$$', 'Interpreter', 'latex')
%     title(plot_title, 'Interpreter', 'latex')
%     set(gca, 'FontSize', 16)
%     hold on
% 
%     % Plot the experimental data
%     p = plot(Time, 100 * Diffusion_Fraction, 'ko');
% 
%     % Check if plot object p is empty
%     if isempty(p)
%         error('Plot object is empty. Please check the data and plot command.');
%     else
%         p.MarkerFaceColor = [0 0 0];
%         p.MarkerSize = 8;
%     end
% 
%     % Plot the fitted data
%     plot(T / 3600, 100 * mt_minf_1, 'r', 'LineWidth', 1)
% 
%     % Add legend and text
%     legend('Experimental Data', 'Fitted Data', 'Interpreter', 'latex')
%     text_show = ['$$D = ' num2str(round(D / 1e-6, 2)) ' \times 10^{-6} cm^{2}/s$$'];
%     text(1, 30, text_show, 'Interpreter', 'latex', 'FontSize', 16)
% 
%     % Finalize the plot
%     box on;
%     hold off
% end
% 
% % Cost function definition for optimization
% function cost = costfun(D)
%     global Time Diffusion_Fraction
%     syms n t
%     L = 0.04;
%     f_1(t) = (8 / ((2 * n + 1)^2 * pi^2)) * exp((-D * (2 * n + 1)^2 * pi^2 * t) / (4 * L^2));
%     M_1(t) = 1 - symsum(f_1(t), n, 0, 100); % Limited to 100 terms for practical evaluation
%     T = 3600 * Time; % Convert Time to seconds
%     mt_minf_1 = double(M_1(T)); % Evaluate symbolic expression
%     output = mt_minf_1(:); % Ensure it is a column vector
%     cost = sum((Diffusion_Fraction - output).^2); % Sum of squared differences
% end
% %Error in exp8_difusion_of_proteins_through_hydrogel_matrices (line 13)
% %fit_and_plot(Time_Insulin, Diffusion_Fraction_Insulin, 'Insulin Diffusion in PEG 10000 Hydrogel');
% 
% Define the data for Insulin and Trypsin Inhibitor
Time_Insulin = [0.09320175, 0.18725241, 0.48210243, 0.98687748, 1.48666525, 1.99197085]'; % hours
Diffusion_Fraction_Insulin = [0.66315789, 0.86578947, 0.92894737, 0.97368421, 0.98947368, 0.99473684]';

Time_Trypsin = [0.109256962, 0.205797973, 0.511431829, 1.001904261, 1.50550607, 1.999862192]'; % hours
Diffusion_Fraction_Trypsin = [0.64198895, 0.756906077, 0.913812155, 0.973480663, 0.991160221, 0.993370166]';

% Characteristic length of the hydrogel (cm)
L = 0.04; 

% Perform fit and plot for both cases
fit_and_plot(Time_Insulin, Diffusion_Fraction_Insulin, 'Insulin Diffusion in PEG 10000 Hydrogel', L);
fit_and_plot(Time_Trypsin, Diffusion_Fraction_Trypsin, 'Trypsin Inhibitor Diffusion in PEG 10000 Hydrogel', L);

function fit_and_plot(Time, Diffusion_Fraction, plot_title, L)
    % Ensure Time and Diffusion_Fraction are column vectors
    Time = Time(:); 
    Diffusion_Fraction = Diffusion_Fraction(:); 

    % Optimization settings
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = 1e-8; % Lower bound for D
    ub = 1e-4; % Upper bound for D
    nonlcon = [];
    options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'interior-point');

    % Initial guess for D
    D0 = 1.15e-6; % Initial guess in cm²/s
    
    % Perform optimization to find the best fit for D
    D = fmincon(@(D) costfun(D, Time, Diffusion_Fraction, L), D0, A, b, Aeq, beq, lb, ub, nonlcon, options);
    
    % Define the symbolic variables and expression for Mt/M∞
    syms n t
    f_1(t) = (8 / ((2 * n + 1)^2 * pi^2)) * exp((-D * (2 * n + 1)^2 * pi^2 * t) / (4 * L^2));
    M_1(t) = 1 - symsum(f_1(t), n, 0, 100); % Summation limited to 100 terms for practical evaluation
    
    % Define a time vector for plotting (in seconds)
    T = linspace(0, max(Time) * 3600, 1000); % Time vector in seconds
    
    % Evaluate M(t)/M∞ using the optimized D
    mt_minf_1 = double(M_1(T)); % Evaluate symbolic expression
    
    % Create a figure for plotting
    figure()
    hold on;
    xlabel('Time (hours)', 'Interpreter', 'latex')
    ylabel('$$M_{t}/M_{\infty} (\%)$$', 'Interpreter', 'latex')
    title(plot_title, 'Interpreter', 'latex')
    set(gca, 'FontSize', 16)
    grid on;
    
    % Plot the experimental data
    plot(Time, 100 * Diffusion_Fraction, 'ko', 'MarkerFaceColor', [0 0 0], 'MarkerSize', 8);
    
    % Plot the fitted data
    plot(T / 3600, 100 * mt_minf_1, 'r', 'LineWidth', 1.5)
    
    % Add legend and text
    legend('Experimental Data', 'Fitted Data', 'Interpreter', 'latex', 'Location', 'southeast')
    text(0.1, 30, sprintf('$$D = %.2f \\times 10^{-6} \\ cm^{2}/s$$', D * 1e6), 'Interpreter', 'latex', 'FontSize', 16)
    
    % Finalize the plot
    box on;
    hold off;
end

% Cost function definition for optimization
function cost = costfun(D, Time, Diffusion_Fraction, L)
    syms n t
    f_1(t) = (8 / ((2 * n + 1)^2 * pi^2)) * exp((-D * (2 * n + 1)^2 * pi^2 * t) / (4 * L^2));
    M_1(t) = 1 - symsum(f_1(t), n, 0, 100); % Summation limited to 100 terms for practical evaluation
    
    % Convert Time to seconds and evaluate M(t)/M∞
    T = 3600 * Time; % Convert Time to seconds
    mt_minf_1 = double(M_1(T)); % Evaluate symbolic expression
    
    % Calculate the cost as the sum of squared differences
    cost = sum((Diffusion_Fraction - mt_minf_1(:)).^2); 
end
