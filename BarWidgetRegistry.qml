// Widget registry object mapping widget names to components
  property var widgets: ({
    "CavaVisualizer": cavaVisualizerComponent,
    "Workspace": workspaceComponent
  })

property var widgetMetadata: ({
  "CavaVisualizer": {
      "allowUserSettings": true,
      "width": 300,
      "minHeight": 12,
      "maxHeight": 64,
      "bars": 48,
      "barWidth": 3,
      "barSpacing": 1,
      "framerate": 60,
      "mono": true
    },
    "Workspace": {
      "allowUserSettings": true,
      "labelMode": "index",
      "hideUnoccupied": false
    })

// Component definitions - these are loaded once at startup
property Component cavaVisualizerComponent: Component { CavaVisualizer {} }
