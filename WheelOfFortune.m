classdef WheelOfFortune < handle
    
    properties %(Access = private)
        fig
        lin
        txt
    end
    
    methods (Access = public)
        
        function obj = WheelOfFortune(fields)
            if nargin == 0
                fields = {'Yes', 'No', 'Maybe'};
            end
            
            obj.create(fields);
        end
        
        function turn(obj)
            % update_time is the time between frames. Here, the update rate
            % is 24 frames per second (FPS). The time that it takes to
            % execute the instructions in the WHILE loop is subtracted from
            % the update time.
            update_time = 1/24 - 0.005;  % s
            
            vel = 540;  % deg/s
            decel = 120;  % deg/s^2
            eps = vel * update_time;
            
            while eps >= 1
                obj.rotatePlot(eps);
                
                vel = vel - decel * update_time;
                eps = vel * update_time;
                
                pause(update_time);
            end
        end
        
    end
    
    methods (Access = private)
        
        function create(obj, fields)
            obj.fig = figure('Name', 'Wheel of fortune');
            hold on;
            axis off;
            obj.plotCircle();
            obj.plotStarAndFields(fields);
        end
        
        function plotStarAndFields(obj, fields)     
            nfields = length(fields);
            obj.lin = repmat(matlab.graphics.chart.primitive.Line, nfields, 1);
            obj.txt = repmat(matlab.graphics.primitive.Text, nfields, 1);
            delta = 360 / nfields;
            
            % Plot star.
            th = delta:delta:360;
            x = cosd(th);
            y = sind(th);
            for i = 1:nfields
                obj.lin(i) = plot([0 x(i)], [0 y(i)], 'k');
            end
            
            % Plot fields.
            th = th - (0.5*delta);
            x = 0.5*cosd(th);
            y = 0.5*sind(th);
            for i = 1:nfields
                obj.txt(i) = text(x(i), y(i), fields{i}, 'Rotation', th(i));
            end
        end
        
        function rotatePlot(obj, eps)
            rotate([obj.lin obj.txt], [0 0 1], eps);
            for i = 1:length(obj.txt)
                current = get(obj.txt(i), 'Rotation');
                set(obj.txt(i), 'Rotation', current + eps);
            end
        end
        
    end
    
    methods (Static, Access = private)
        
        function plotCircle()
            th = 0:5:360;
            x = cosd(th);
            y = sind(th);
            plot(x, y, 'k');
        end
        
    end
    
end
