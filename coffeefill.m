% Better Cup Filling Animation in MATLAB

% Cup parameters
cup_height = 6;
cup_top_radius = 2;
cup_bottom_radius = 1;
cup_center_x = 0;
cup_center_y = 1;
n_profile = 100;
coffee_color = [0.4 0.2 0];

figure('Color','w');
axis equal
hold on
axis([-4 6 0 8]);
set(gca, 'xtick', [], 'ytick', []);

% Cup profile (right side)
y_profile = linspace(cup_center_y, cup_center_y+cup_height, n_profile);
r_profile = cup_bottom_radius + (cup_top_radius-cup_bottom_radius) * ...
            ((y_profile-cup_center_y)/cup_height).^1.5; % Smooth curve
x_profile = cup_center_x + r_profile;

% Cup outline (right and left, plus bottom arc)
theta_bottom = linspace(pi, 0, 30);
x_bottom = cup_center_x + cup_bottom_radius*cos(theta_bottom);
y_bottom = cup_center_y + cup_bottom_radius*sin(theta_bottom);

cup_x = [flip(-x_profile) x_bottom x_profile];
cup_y = [flip(y_profile) y_bottom y_profile];

% Draw cup outline
plot(cup_x, cup_y, 'k', 'LineWidth', 2);

% Draw cup handle (ellipse)
th = linspace(-pi/2, pi/2, 50);
handle_r1 = 1.3; % horizontal radius
handle_r2 = 2;   % vertical radius
handle_x = cup_center_x + cup_top_radius + 0.4 + handle_r1*cos(th);
handle_y = cup_center_y + cup_height/2 + handle_r2*sin(th);
plot(handle_x, handle_y, 'k', 'LineWidth', 2);

% Animation loop
nFrames = 60;
for k = 1:nFrames
    fill_level = cup_center_y + (cup_height-0.2)*(k/nFrames);
    % Find width at the current fill level
    r_fill = cup_bottom_radius + (cup_top_radius-cup_bottom_radius) * ...
             ((fill_level-cup_center_y)/cup_height).^1.5;
    % Coffee surface (ellipse)
    theta_fill = linspace(pi, 0, 50);
    coffee_x = [cup_center_x - r_fill*cos(theta_fill) cup_center_x + r_fill*cos(theta_fill)];
    coffee_y = [fill_level*ones(1,50) fill_level*ones(1,50)];
    % Coffee sides (vertical from bottom to fill level)
    bottom_x = [cup_center_x - r_profile(1) cup_center_x + r_profile(1)];
    bottom_y = [cup_center_y cup_center_y];
    coffee_x = [coffee_x bottom_x];
    coffee_y = [coffee_y bottom_y];
    % Remove previous coffee
    if k > 1
        delete(h_coffee);
    end
    % Draw coffee
    h_coffee = fill(coffee_x, coffee_y, coffee_color, 'EdgeColor', 'none');
    uistack(h_coffee, 'bottom');
    pause(0.05);
end

title('Cup Filling with Coffee', 'FontSize', 14)
hold off