function varargout = FMReceiverExampleApp
%FMReceiverExampleApp  App based FM receiver example

% Copyright 2017-2018 The MathWorks, Inc.

% Top-level figure:
figureHandle = figure('Visible', 'off', ...
    'HandleVisibility', 'on', ...
    'NumberTitle', 'off', ...
    'IntegerHandle', 'off', ...
    'MenuBar', 'none', ...
    'Name', 'Broadcast FM Receiver Explorer', ...
    'Tag', 'FMAppFigure');

% Create the main container
mainContainer = uigridcontainer('v0', 'Parent', figureHandle, ...
 'GridSize', [2 1], 'VerticalWeight', [15 2], ...
    'Tag', 'FMAppMainContainer');

% Create the container for the controller and the viewer
controllerPanel = uipanel('Parent', mainContainer, ...
  'Tag', 'FMAppCtrlPanel', ...
  'Units', 'pixels');
viewerPanel = uipanel('Parent', mainContainer, ...
  'Tag', 'FMAppViewerPanel', ...
  'Units', 'pixels');

% Instantiate the viewer and controller
viewer = helperFMViewer('ParentHandle', viewerPanel, 'isInApp', true);
controller = helperFMReceiverController('ParentHandle', controllerPanel, ...
  'Viewer', viewer);
render(controller);

figureHandle.Position(3) = 370;
figureHandle.Position(4) = 470;
movegui(figureHandle, 'center');
figureHandle.Visible = 'on';

if nargout > 0
    varargout{1} = controller;
end
if nargout > 1
    varargout{2} = viewer;
end

end