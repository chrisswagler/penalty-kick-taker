classdef soccergame < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        Label                     matlab.ui.control.Label
        Slider                    matlab.ui.control.Slider
        Slider_2Label             matlab.ui.control.Label
        Slider_2                  matlab.ui.control.Slider
        TakeKickButton            matlab.ui.control.Button
        UIAxes                    matlab.ui.control.UIAxes
        Label_2                   matlab.ui.control.Label
        Label_3                   matlab.ui.control.Label
        GoalCounterLabel          matlab.ui.control.Label
        StreakCounterLabel        matlab.ui.control.Label
        PenaltyKickTakerAppLabel  matlab.ui.control.Label
        ButtonGroup               matlab.ui.container.ButtonGroup
        EasyButton                matlab.ui.control.RadioButton
        MediumButton              matlab.ui.control.RadioButton
        HardButton                matlab.ui.control.RadioButton
        ResetButton               matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %load in the goal background
            goalimage = imread('soccergoal.png');
            image(goalimage,'parent',app.UIAxes);
            %disable scrolling on the axes
            disableDefaultInteractivity(app.UIAxes);
            %create global variables for the slider values
            global xvalue;
            xvalue = 250;
            global yvalue;
            yvalue = 300;
            %create global variables for the goal and streak counters
            global goals;
            goals = 0;
            global streak;
            streak = 0;
            %update the label texts for the goal and streak counters
            app.GoalCounterLabel.Text = strcat('Goals:',{' '},num2str(goals));
            app.StreakCounterLabel.Text = strcat('Streak:',{' '},num2str(streak));
        end

        % Value changing function: Slider_2
        function Slider_2ValueChanging(app, event)
            changingValue2 = event.Value;
            global xvalue;
            global yvalue;
            %set the global x value to this slider's value
            xvalue = changingValue2;
            %plot the goal first
            goalimage = imread('soccergoal.png');
            image(goalimage,'parent',app.UIAxes);
            %plot the positional marker based on the slider input
            plot(app.UIAxes,xvalue,yvalue,'ow','MarkerSize',40,'LineWidth',5);
        end

        % Value changing function: Slider
        function SliderValueChanging(app, event)
            changingValue1 = event.Value;
            global xvalue;
            global yvalue;
            %set the global y value to this slider's value
            yvalue = changingValue1;
            %plot the goal first
            goalimage = imread('soccergoal.png');
            image(goalimage,'parent',app.UIAxes);
            %plot the positional marker based on the slider input
            plot(app.UIAxes,xvalue,yvalue,'ow','MarkerSize',40,'LineWidth',5);
        end

        % Button pushed function: TakeKickButton
        function TakeKickButtonPushed(app, event)
            global xvalue;
            global yvalue;
            global goals;
            global streak;
            %goal bounds are 210, 1530 for x and 260, 710 for y
            %generate buffer value based on selected difficulty
            if app.EasyButton.Value
                savebuffer = 200;
            elseif app.MediumButton.Value
                savebuffer = 300;
            elseif app.HardButton.Value
                savebuffer = 400;
            end
            %generate a random number between the range as a lower x bound
            xlower = randi([210 1530-savebuffer]);
            %add buffer to the lower bound to make an upper x bound
            xupper = xlower + savebuffer;
            %generate a random number between the range as a lower y bound
            ylower = randi([260 710-savebuffer]);
            %add buffer to the lower bound to make an upper y bound
            yupper = ylower + savebuffer;
            %create arrays for the plot ranges for the 'saves'
            xplot = [xlower xlower xupper xupper];
            yplot = [ylower yupper yupper ylower];
            %plot the goal first
            goalimage = imread('soccergoal.png');
            image(goalimage,'parent',app.UIAxes);
            %create ranges for the user's hit box (circle) based on its center
            userbuffer = 45;
            userxlower = xvalue - userbuffer;
            userxupper = xvalue + userbuffer;
            userylower = yvalue - userbuffer;
            useryupper = yvalue + userbuffer;
            %if the areas overlap, the shot was saved
            if (((userxupper >= xlower) && (userxlower <= xupper)) && ((useryupper >= ylower) && (userylower <= yupper)))
                app.Label_3.Text = 'NO GOAL! The keeper saved your shot!';
                %reset the streak counter
                streak = 0;
                %change the circle color to red
                plot(app.UIAxes,xvalue,yvalue,'or','MarkerSize',40,'LineWidth',5);
                %plot the saved area in red
                patch(app.UIAxes,xplot,yplot,'red')
                %update counters
                app.GoalCounterLabel.Text = strcat('Goals:',{' '},num2str(goals));
                app.StreakCounterLabel.Text = strcat('Streak:',{' '},num2str(streak));
                %play crowd disappointment sound
                [y, Fs] = audioread('crowdsound.m4a');
                sound(y, Fs)
            %else the shot went in
            else
                app.Label_3.Text = 'GOAL! Nice work, you beat the keeper!';
                %add one to the goal and streak values
                goals = goals + 1;
                streak = streak + 1;
                %change the circle color to green
                plot(app.UIAxes,xvalue,yvalue,'og','MarkerSize',40,'LineWidth',5);
                %plot the saved area in red
                patch(app.UIAxes,xplot,yplot,'red')
                %update counters
                app.GoalCounterLabel.Text = strcat('Goals:',{' '},num2str(goals));
                app.StreakCounterLabel.Text = strcat('Streak:',{' '},num2str(streak));
                %play ref whistle sound
                [y, Fs] = audioread('whistlesound.m4a');
                sound(y, Fs)
            end
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            global goals;
            global streak;
            %reset the variables
            goals = 0;
            streak = 0;
            %update counters
            app.GoalCounterLabel.Text = strcat('Goals:',{' '},num2str(goals));
            app.StreakCounterLabel.Text = strcat('Streak:',{' '},num2str(streak));
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

            % Create PenaltyKickTakerAppLabel
            app.PenaltyKickTakerAppLabel = uilabel(app.UIFigure);
            app.PenaltyKickTakerAppLabel.FontName = 'Krungthep';
            app.PenaltyKickTakerAppLabel.FontSize = 30;
            app.PenaltyKickTakerAppLabel.Position = [157 416 378 46];
            app.PenaltyKickTakerAppLabel.Text = 'Penalty Kick Taker App';

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.UIFigure);
            app.ButtonGroup.BorderType = 'none';
            app.ButtonGroup.TitlePosition = 'centertop';
            app.ButtonGroup.FontName = 'Krungthep';
            app.ButtonGroup.FontSize = 10;
            app.ButtonGroup.Position = [38 48 217 36];

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

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = soccergame

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
