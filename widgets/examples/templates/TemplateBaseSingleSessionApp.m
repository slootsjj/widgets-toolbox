classdef TemplateBaseSingleSessionApp < wt.apps.BaseSingleSessionApp
    % Implements a template for a BaseSingleSessionApp

    % Copyright 2022-2025 The MathWorks Inc.


    %% Internal Components
    %   Create properties here for each control, layout, or view component
    %   that will be placed directly into the main app window.
    properties ( Transient, NonCopyable, SetAccess = protected )

        % Once the app is created and debugged, consider also protecting
        % get access to these properties. Leave them accessible to unit
        % tests, however. Use this example:
        % GetAccess = {?matlab.uitest.TestCase, ?wt.apps.BaseApp})

        % Grid Layouts
        % (BaseApp already brings "Grid", the main Grid layout in the window)
        Tab1Grid matlab.ui.container.GridLayout
        Tab2Grid matlab.ui.container.GridLayout
        SessionDescriptionPanelGrid matlab.ui.container.GridLayout
        Panel2Grid matlab.ui.container.GridLayout

        % Panels
        SessionDescriptionPanel matlab.ui.container.Panel
        Panel2 matlab.ui.container.Panel

        % Tabs
        TabGroup matlab.ui.container.TabGroup
        Tab1 matlab.ui.container.Tab
        Tab2 matlab.ui.container.Tab

        % Toolbar and sections
        Toolbar wt.Toolbar
        FileSection wt.toolbar.HorizontalSection
        HelpSection wt.toolbar.HorizontalSection

        % Toolbar buttons
        NewButton matlab.ui.control.Button
        OpenButton matlab.ui.control.Button
        SaveButton matlab.ui.control.Button
        SaveAsButton matlab.ui.control.Button
        ExportGTButton matlab.ui.control.Button
        HelpButton matlab.ui.control.Button

        % View Components
        %View1 namespace.ClassName
        %View2 namespace.ClassName

        % Session information components
        SessionDescription matlab.ui.control.TextArea

        % Temporary label components
        Panel1Text matlab.ui.control.Label
        Panel2Text matlab.ui.control.Label
        Tab1Text matlab.ui.control.Label
        Tab2Text matlab.ui.control.Label

    end %properties



    %% Setup and Configuration of the App
    methods  ( Access = protected )

        function setup(app)
            % Runs once on instantiation of the app

            % Set the name
            app.Name = "My App";

            % Configure the main grid
            app.Grid.ColumnWidth = {300,'1x'};
            app.Grid.RowHeight = {100,'1x',150};
            app.Grid.Padding = 5;

            % Create toolbar (split out for brevity)
            app.createToolbar()

            % Create a panel for session description
            app.SessionDescriptionPanel = uipanel(app.Grid);
            app.SessionDescriptionPanel.Title = "Session Description:";
            app.SessionDescriptionPanel.Layout.Row = [2 3];
            app.SessionDescriptionPanel.Layout.Column = 1;

            % Create a panel
            app.Panel2 = uipanel(app.Grid);
            app.Panel2.Title = "Panel 2";
            app.Panel2.Layout.Row = 3;
            app.Panel2.Layout.Column = 2;

            % Create a tab group
            app.TabGroup = uitabgroup(app.Grid);
            app.TabGroup.Layout.Row = 2;
            app.TabGroup.Layout.Column = 2;
            app.TabGroup.SelectionChangedFcn = @(h,e)onTabChanged(app,e);

            % Create Tabs, each with a grid
            app.Tab1 = uitab(app.TabGroup);
            app.Tab1.Title = 'Tab 1';

            app.Tab2 = uitab(app.TabGroup);
            app.Tab2.Title = 'Tab 2';

            % Create grid layouts to position content inside each container
            app.SessionDescriptionPanelGrid = uigridlayout(...
                app.SessionDescriptionPanel, [1,1],"Padding", 0);
            app.Panel2Grid = uigridlayout(app.Panel2, [1,1],"Padding", 0);
            app.Tab1Grid = uigridlayout(app.Tab1, [1,1],"Padding", 0);
            app.Tab2Grid = uigridlayout(app.Tab2, [1,1],"Padding", 0);

            % Put a description for the selected session
            app.SessionDescription = uitextarea(app.SessionDescriptionPanelGrid);
            app.SessionDescription.ValueChangedFcn = ...
                @(~,evt)onSessionDescriptionChanged(app,evt);

            % Place some temporary content in each container
            app.Panel2Text = uilabel(app.Panel2Grid);
            app.Panel2Text.Text = "Panel 2 Contents";
            app.Panel2Text.HorizontalAlignment = "center";
            app.Panel2Text.FontSize = 30;
            app.Panel2Text.Layout.Row = 1;
            app.Panel2Text.Layout.Column = 1;

            app.Tab1Text = uilabel(app.Tab1Grid);
            app.Tab1Text.Text = "Tab 1 Contents";
            app.Tab1Text.HorizontalAlignment = "center";
            app.Tab1Text.FontSize = 30;
            app.Tab1Text.Layout.Row = 1;
            app.Tab1Text.Layout.Column = 1;

            app.Tab2Text = uilabel(app.Tab2Grid);
            app.Tab2Text.Text = "Tab 2 Contents";
            app.Tab2Text.HorizontalAlignment = "center";
            app.Tab2Text.FontSize = 30;
            app.Tab2Text.Layout.Row = 1;
            app.Tab2Text.Layout.Column = 1;

            % Additional examples:
            % (add other views, layouts, and components here as needed)
            %app.View1 = namespace.ClassName( app.Tab1Grid );
            %app.View2 = namespace.ClassName( app.Tab2Grid );

        end %function


        function createToolbar(app)
            % Create the toolbar contents

            % (This method is optional if using a toolbar. It's split out
            % into the separate method here to keep the setup method
            % shorter)

            % Create the toolbar container
            app.Toolbar = wt.Toolbar(app.Grid);
            app.Toolbar.Layout.Row = 1;
            app.Toolbar.Layout.Column = [1 2];

            % File Section
            app.FileSection = wt.toolbar.HorizontalSection();
            app.FileSection.Title = "FILE";
            app.FileSection.ButtonPushedFcn = @(~,evt)onFileToolbarButtonPushed(app,evt);

            app.NewButton = app.FileSection.addButton('add_24.png','New Session');
            app.OpenButton = app.FileSection.addButton('folder_24.png','Open Session');
            app.SaveButton = app.FileSection.addButton('save_24.png','Save Session');
            app.SaveAsButton = app.FileSection.addButton("saveClean_24.png","Save As");
            app.FileSection.ComponentWidth(:) = 55;

            % Help Section
            app.HelpSection = wt.toolbar.HorizontalSection();
            app.HelpSection.Title = "HELP";
            app.HelpButton = app.HelpSection.addButton('help_24.png','Help');
            app.HelpButton.ButtonPushedFcn = @(h,e)onHelpButton(app);

            % Add all toolbar sections to the toolbar
            % This is done last for performance reasons
            app.Toolbar.Section = [
                app.FileSection
                app.HelpSection
                ];

        end %function


        function sessionObj = createNewSession(~)
            % Create and return a new session object for this app

            % The session should be a class that inherits wt.model.BaseSession
            %sessionObj = namespace.SessionClassName;

            % For example purposes, using this one:
            sessionObj = wt.model.BaseSession;

        end %function

    end %methods

    %% Update
    methods  ( Access = protected )

        function update(app)
            % Update the display of the app
            % For the main app, app.update() must be called explicitly
            % during callbacks or other changes that require contents to
            % refresh.

            % Update the session description text
            app.SessionDescription.Value = app.Session.Description;
            
            % Update toolbar button enables
            app.updateToolbarEnables()

            % Examples:
            %app.View1.Model = sessionObj;
            %app.View2.Model = sessionObj;

        end %function


        function updateToolbarEnables(app)

            % Get the session states
            hasDirtySession = isscalar(app.Session) && app.Session.Dirty;

            % File toolbar enables
            app.SaveButton.Enable = hasDirtySession;

        end %function

    end %methods


    %% Callbacks
    methods

        function onTabChanged(app,evt)
            % Triggered on changing tab

            % (this method is optional if using tabs)

            newTab = evt.NewValue;
            disp("Selected Tab: " + newTab.Title);

        end %function


        function onSessionDescriptionChanged(app,evt)
            % Triggered on editing a session description

            % Get the new value
            newValue = join(string(evt.Value), newline);

            % Update the session description
            app.Session.Description = newValue;

        end %function


        function onFileToolbarButtonPushed(app,evt)

            % Which button was pressed?
            switch evt.Button

                case app.NewButton

                    % Add a new session
                    app.newSession();

                case app.OpenButton

                    % Prompt and load a session
                    app.loadSession();

                case app.SaveButton

                    % Save the selected session
                    app.saveSession(false);

                case app.SaveAsButton

                    % Save the selected session as different file
                    app.saveSession(true);

            end %switch

        end %function


        function onHelpButton(app)
            % Triggered when the toolbar button is pressed

            % (this method is optional if using the toolbar)

            disp("Help Button Pushed!");

        end %function

    end %methods

end %classdef