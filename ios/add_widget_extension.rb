#!/usr/bin/env ruby
# Script to add the StandByHubWidgets extension target to the Xcode project
# Run: cd ios && ruby add_widget_extension.rb

require 'xcodeproj'

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Check if target already exists
if project.targets.any? { |t| t.name == 'StandByHubWidgets' }
  puts "Target 'StandByHubWidgets' already exists. Skipping."
  exit 0
end

# Create the extension target
target = project.new_target(:app_extension, 'StandByHubWidgets', :ios, '17.0')
target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.tmmr.standbyHub.StandByHubWidgets'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['INFOPLIST_FILE'] = 'StandByHubWidgets/Info.plist'
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'StandByHubWidgets/StandByHubWidgets.entitlements'
  config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = '$(inherited) @executable_path/Frameworks @executable_path/../../Frameworks'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'NO'
  config.build_settings['MARKETING_VERSION'] = '1.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
  config.build_settings['ASSETCATALOG_COMPILER_WIDGET_BACKGROUND_COLOR_NAME'] = 'WidgetBackground'
end

# Add Swift source files
widget_group = project.main_group.new_group('StandByHubWidgets', 'StandByHubWidgets')

dirs = {
  'Shared' => %w[
    WidgetSettingsReader.swift
    OLEDColors.swift
    WidgetTheme.swift
    ProStatusChecker.swift
    TimelineProviders.swift
  ],
  'Clocks' => %w[
    MinimalDigitalView.swift
    FlipClockView.swift
    AnalogClassicView.swift
    GradientClockView.swift
    BinaryClockView.swift
  ],
  'Ambient' => %w[
    AuroraView.swift
    LavaView.swift
    OceanView.swift
  ],
  'Dashboard' => %w[
    SmartDashboardView.swift
    CalendarSlotView.swift
    WeatherSlotView.swift
    BatterySlotView.swift
  ],
}

# Add files by directory
dirs.each do |dir_name, files|
  group = widget_group.new_group(dir_name, dir_name)
  files.each do |file_name|
    file_ref = group.new_reference("#{dir_name}/#{file_name}")
    target.source_build_phase.add_file_reference(file_ref)
  end
end

# Add root-level files
bundle_ref = widget_group.new_reference('StandByHubWidgetBundle.swift')
target.source_build_phase.add_file_reference(bundle_ref)

info_ref = widget_group.new_reference('Info.plist')
entitlements_ref = widget_group.new_reference('StandByHubWidgets.entitlements')

# Embed the widget extension in the host app
runner_target = project.targets.find { |t| t.name == 'Runner' }
if runner_target
  # Add "Embed App Extensions" build phase
  embed_phase = runner_target.new_copy_files_build_phase('Embed App Extensions')
  embed_phase.dst_subfolder_spec = '13' # PlugIns
  embed_phase.add_file_reference(target.product_reference)

  # Update Runner entitlements
  runner_target.build_configurations.each do |config|
    config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
  end
end

project.save
puts "Successfully added StandByHubWidgets extension target!"
puts "Open Runner.xcworkspace in Xcode to verify."
