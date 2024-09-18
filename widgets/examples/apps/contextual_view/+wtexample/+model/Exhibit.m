classdef Exhibit < wt.model.BaseModel
    % Implements the model class for an exhibit


    %% Public Properties
    properties (AbortSet, SetObservable)

        % Point location of the exhibit on the map
        Location (1,2) double

        % Enclosures within this exhibit
        Enclosure (1,:) wtexample.model.Enclosure

    end %properties


    % Accessors
    % methods
    %     function set.Enclosure(obj,value)
    %         obj.Enclosure = value;
    %         obj.attachModelListeners("Enclosure");
    %     end
    % end %methods


    %% Constructor
    methods
        function obj = Exhibit(varargin)
            % Constructor

            % Call superclass method
            % obj@wt.model.BaseModel(varargin{:});

            % Debug instead
            obj@wt.model.BaseModel(varargin{:},"Debug",true);

        end %function
    end %methods

end %classdef