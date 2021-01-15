classdef penaltykick < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        Label                  matlab.ui.control.Label
        Slider                 matlab.ui.control.Slider
        Slider_2Label          matlab.ui.control.Label
        Slider_2               matlab.ui.control.Slider
        TakeKickButton         matlab.ui.control.Button
        UIAxes                 matlab.ui.control.UIAxes
        Label_2                matlab.ui.control.Label
        Label_3                matlab.ui.control.Label
        GoalCounterLabel       matlab.ui.control.Label
        StreakCounterLabel     matlab.ui.control.Label
        PenaltyKickTakerLabel  matlab.ui.control.Label
        ButtonGroup            matlab.ui.container.ButtonGroup
        EasyButton             matlab.ui.control.RadioButton
        MediumButton           matlab.ui.control.RadioButton
        HardButton             matlab.ui.control.RadioButton
        ResetButton            matlab.ui.control.Button
        Switch                 matlab.ui.control.Switch
    end

    properties (Access = private)
        % variables for slider values
        xvalue = 250;
        yvalue = 300;
        % variables for goal and streak counters
        goals = 0;
        streak = 0;
        % images
        goalimage = imread('soccergoal.png')
        goalbkg;
        % variable for animatedline (moving positional marker)
        aim;
        % variable for animated line (goal/save color)
        goalmark;
        savemark;
        % variables for goalie box
        egoalie;
        mgoalie;
        hgoalie;
    end
    methods (Access = private)
        
        function clearallpoints(app)
            %clears all instances of points
            clearpoints(app.aim)
            clearpoints(app.goalmark)
            clearpoints(app.savemark)
            clearpoints(app.egoalie)
            clearpoints(app.mgoalie)
            clearpoints(app.hgoalie)
        end
        
        function plotgoalie(app,xc,yc)
            %based on the selected difficulty, plots the corresponding
            %goalie box with the x and y center values
            if app.EasyButton.Value
                addpoints(app.egoalie,xc,yc)
            elseif app.MediumButton.Value
                addpoints(app.mgoalie,xc,yc)
            elseif app.HardButton.Value
                addpoints(app.hgoalie,xc,yc)
            end
        end
        
        function returnval = checkbounds(app,uxl,uxu,uyl,uyu,xl,xu,yl,yu)
            %checks the bounds of the user and goalie hitboxes for overlap
            %This statement checks if the hitboxes are either to the left
            %or above one another and if so, it returns false
            if ((uxl > xu) || (xl > uxu)) || ((uyu < yl) || (yu < uyl))
                returnval = false;
            else
                returnval = true;
            end
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %load in the goal background and soccer ball
            app.goalbkg = image(app.goalimage,'parent',app.UIAxes);
            %disable scrolling on the axes
            disableDefaultInteractivity(app.UIAxes);
            %create animatedline for the positional marker
            app.aim = animatedline(app.UIAxes,'Marker','o','Color','w','MarkerSize',40,'LineWidth',5);
            %create animatedline for goal/save markers
            app.goalmark = animatedline(app.UIAxes,'Marker','o','Color','g','MarkerSize',40,'LineWidth',5);
            app.savemark = animatedline(app.UIAxes,'Marker','o','Color','r','MarkerSize',40,'LineWidth',5);
            %created animatedline for different goalie hitboxes
            app.egoalie = animatedline(app.UIAxes,'Marker','s','MarkerFaceColor','r','MarkerSize',60);
            app.mgoalie = animatedline(app.UIAxes,'Marker','s','MarkerFaceColor','r','MarkerSize',80);
            app.hgoalie = animatedline(app.UIAxes,'Marker','s','MarkerFaceColor','r','MarkerSize',120);
            %update the label texts for the goal and streak counters
            app.GoalCounterLabel.Text = strcat('Goals:',{' '},num2str(app.goals));
            app.StreakCounterLabel.Text = strcat('Streak:',{' '},num2str(app.streak));
        end

        % Value changing function: Slider_2
        function Slider_2ValueChanging(app, event)
            %set the global x value to this slider's value
            app.xvalue = event.Value;
            %clear any previous points of the animatedline
            clearallpoints(app)
            %add the current point with the updated x and y value
            addpoints(app.aim,app.xvalue,app.yvalue)
        end

        % Value changing function: Slider
        function SliderValueChanging(app, event)
            %set the global y value to this slider's value
            app.yvalue = event.Value;
            %clear any previous points of the animatedline
            clearallpoints(app)
            %add the current point with the updated x and y value
            addpoints(app.aim,app.xvalue,app.yvalue)
        end

        % Button pushed function: TakeKickButton
        function TakeKickButtonPushed(app, event)
            %goal bounds are 210, 1530 for x and 260, 710 for y
            %generate buffer value based on selected difficulty
            if app.EasyButton.Value
                savebuffer = 60;
            elseif app.MediumButton.Value
                savebuffer = 80;
            elseif app.HardButton.Value
                savebuffer = 120;
            end
            %generate random x centerpoint for goalie hitbox and use
            %savebuffer to get the upper and lower bounds
            xcenter = randi([210+savebuffer 1530-savebuffer]);
            xlower = xcenter - savebuffer;
            xupper = xcenter + savebuffer;
            %generate random y centerpoint for goalie hitbox and use
            %savebuffer to get the upper and lower bounds
            ycenter = randi([260+savebuffer 710-savebuffer]);
            ylower = ycenter - savebuffer;
            yupper = ycenter + savebuffer;
            %use the userbuffer to get the upper and lower bounds for the
            %user hitbox
            userbuffer = 80;
            userxlower = app.xvalue - userbuffer;
            userxupper = app.xvalue + userbuffer;
            userylower = app.yvalue - userbuffer;
            useryupper = app.yvalue + userbuffer;
            clearallpoints(app)
            plotgoalie(app,xcenter,ycenter)
            %if the areas overlap, the shot was saved
            if checkbounds(app,userxlower,userxupper,userylower,useryupper,xlower,xupper,ylower,yupper)
                app.Label_3.Text = 'NO GOAL! The keeper saved your shot!';
                %reset the streak counter
                app.streak = 0;
                %change the circle color to red
                addpoints(app.savemark,app.xvalue,app.yvalue)
                %update counters
                app.GoalCounterLabel.Text = strcat('Goals:',{' '},num2str(app.goals));
                app.StreakCounterLabel.Text = strcat('Streak:',{' '},num2str(app.streak));
                %play crowd disappointment sound if unmuted
                if app.Switch.Value == "Unmute"
                    [y, Fs] = audioread('crowdsound.m4a');
                    sound(y, Fs)
                end
                %else the shot went in
            else
                app.Label_3.Text = 'GOAL! Nice work, you beat the keeper!';
                %add one to the goal and streak values
                app.goals = app.goals + 1;
                app.streak = app.streak + 1;
                %change the circle color to green
                addpoints(app.goalmark,app.xvalue,app.yvalue)
                %update counters
                app.GoalCounterLabel.Text = strcat('Goals:',{' '},num2str(app.goals));
                app.StreakCounterLabel.Text = strcat('Streak:',{' '},num2str(app.streak));
                %play ref whistle sound if unmuted
                if app.Switch.Value == "Unmute"
                    [y, Fs] = audioread('whistlesound.m4a');
                    sound(y, Fs)
                end
            end
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            %reset the variables
            app.goals = 0;
            app.streak = 0;
            %update counters
            app.GoalCounterLabel.Text = strcat('Goals:',{' '},num2str(app.goals));
            app.StreakCounterLabel.Text = strcat('Streak:',{' '},num2str(app.streak));
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.9412 0.9412 0.9412];
            app.UIFigure.Position = [100 100 647 469];
            app.UIFigure.Name = 'UI Figure';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [14 191 25 22];
            app.Label.Text = '';

            % Create Slider
            app.Slider = uislider(app.UIFigure);
            app.Slider.Limits = [300 630];
            app.Slider.MajorTicks = [];
            app.Slider.Orientation = 'vertical';
            app.Slider.ValueChangingFcn = createCallbackFcn(app, @SliderValueChanging, true);
            app.Slider.MinorTicks = [];
            app.Slider.Position = [28 212 3 93];
            app.Slider.Value = 300;

            % Create Slider_2Label
            app.Slider_2Label = uilabel(app.UIFigure);
            app.Slider_2Label.HorizontalAlignment = 'right';
            app.Slider_2Label.Position = [99 104 25 22];
            app.Slider_2Label.Text = '';

            % Create Slider_2
            app.Slider_2 = uislider(app.UIFigure);
            app.Slider_2.Limits = [280 1450];
            app.Slider_2.MajorTicks = [];
            app.Slider_2.ValueChangingFcn = createCallbackFcn(app, @Slider_2ValueChanging, true);
            app.Slider_2.MinorTicks = [];
            app.Slider_2.Position = [145 113 384 3];
            app.Slider_2.Value = 280;

            % Create TakeKickButton
            app.TakeKickButton = uibutton(app.UIFigure, 'push');
            app.TakeKickButton.ButtonPushedFcn = createCallbackFcn(app, @TakeKickButtonPushed, true);
            app.TakeKickButton.Icon = 'soccerballimage.png';
            app.TakeKickButton.IconAlignment = 'right';
            app.TakeKickButton.FontName = 'Krungthep';
            app.TakeKickButton.Position = [480 15 100 23];
            app.TakeKickButton.Text = 'Take Kick!';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.PlotBoxAspectRatio = [1.81063122923588 1 1];
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.NextPlot = 'add';
            app.UIAxes.Position = [49 125 594 345];

            % Create Label_2
            app.Label_2 = uilabel(app.UIFigure);
            app.Label_2.VerticalAlignment = 'top';
            app.Label_2.FontName = 'Krungthep';
            app.Label_2.FontSize = 14;
            app.Label_2.Position = [12 83 626 22];
            app.Label_2.Text = 'Instructions: Adjust the sliders to aim your shot and press the button when ready!';

            % Create Label_3
            app.Label_3 = uilabel(app.UIFigure);
            app.Label_3.FontName = 'Krungthep';
            app.Label_3.FontSize = 17;
            app.Label_3.Position = [38 10 378 39];
            app.Label_3.Text = '';

            % Create GoalCounterLabel
            app.GoalCounterLabel = uilabel(app.UIFigure);
            app.GoalCounterLabel.HorizontalAlignment = 'center';
            app.GoalCounterLabel.FontName = 'Krungthep';
            app.GoalCounterLabel.FontWeight = 'bold';
            app.GoalCounterLabel.Position = [481 62 162 22];
            app.GoalCounterLabel.Text = 'Goal Counter';

            % Create StreakCounterLabel
            app.StreakCounterLabel = uilabel(app.UIFigure);
            app.StreakCounterLabel.HorizontalAlignment = 'center';
            app.StreakCounterLabel.FontName = 'Krungthep';
            app.StreakCounterLabel.FontWeight = 'bold';
            app.StreakCounterLabel.Position = [481 41 162 22];
            app.StreakCounterLabel.Text = 'Streak Counter';

            % Create PenaltyKickTakerLabel
            app.PenaltyKickTakerLabel = uilabel(app.UIFigure);
            app.PenaltyKickTakerLabel.HorizontalAlignment = 'center';
            app.PenaltyKickTakerLabel.FontName = 'Krungthep';
            app.PenaltyKickTakerLabel.FontSize = 30;
            app.PenaltyKickTakerLabel.Position = [157 416 378 46];
            app.PenaltyKickTakerLabel.Text = 'Penalty Kick Taker';

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.UIFigure);
            app.ButtonGroup.BorderType = 'none';
            app.ButtonGroup.TitlePosition = 'centertop';
            app.ButtonGroup.FontName = 'Krungthep';
            app.ButtonGroup.FontSize = 10;
            app.ButtonGroup.Position = [217 48 217 36];

            % Create EasyButton
            app.EasyButton = uiradiobutton(app.ButtonGroup);
            app.EasyButton.Text = 'Easy';
            app.EasyButton.FontName = 'Krungthep';
            app.EasyButton.Position = [11 10 52 22];
            app.EasyButton.Value = true;

            % Create MediumButton
            app.MediumButton = uiradiobutton(app.ButtonGroup);
            app.MediumButton.Text = 'Medium';
            app.MediumButton.FontName = 'Krungthep';
            app.MediumButton.Position = [72 10 74 22];

            % Create HardButton
            app.HardButton = uiradiobutton(app.ButtonGroup);
            app.HardButton.Text = 'Hard';
            app.HardButton.FontName = 'Krungthep';
            app.HardButton.Position = [154 10 52 22];

            % Create ResetButton
            app.ResetButton = uibutton(app.UIFigure, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.BackgroundColor = [0.9412 0.9412 0.9412];
            app.ResetButton.FontName = 'Krungthep';
            app.ResetButton.Position = [597 15 46 23];
            app.ResetButton.Text = 'Reset';

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'slider');
            app.Switch.Items = {'Unmute', 'Mute'};
            app.Switch.FontName = 'Krungthep';
            app.Switch.Position = [101 61 22 10];
            app.Switch.Value = 'Mute';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = penaltykick

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
