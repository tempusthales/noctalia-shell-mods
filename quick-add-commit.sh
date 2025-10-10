mkdir -p Services Modules/Bar/Widgets Modules/SettingsPanel/Bar/WidgetSettings

$EDITOR Services/BarWidgetRegistry.qml
$EDITOR Modules/Bar/Widgets/CavaVisualizer.qml
$EDITOR Modules/SettingsPanel/Bar/WidgetSettings/CavaVisualizerSettings.qml

git add Services/BarWidgetRegistry.qml \
        Modules/Bar/Widgets/CavaVisualizer.qml \
        Modules/SettingsPanel/Bar/WidgetSettings/CavaVisualizerSettings.qml
git commit -m "Bar: add CavaVisualizer widget + registry + settings UI"

exit 0
