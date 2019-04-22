conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
conf_data.set_quoted('VERSION', meson.project_version())
if use_fallback_theme
  conf_data.set('USE_FALLBACK_THEME', 'true')
else
  conf_data.set('USE_FALLBACK_THEME', 'false')
endif

constants_header = configure_file(
  input: 'configs/Constants.vala',
  output: 'Constants.vala',
  configuration: conf_data
)

optimizer_sources = files(
  'configs/Settings.vala',
  'controllers/AppController.vala',
  'utils/DiskSpace.vala',
  'utils/Process.vala',
  'utils/ProcessManager.vala',
  'utils/Resources.vala',
  'views/DashboardView.vala',
  'views/SystemCleanerView.vala',
  'views/ProcessesView.vala',
  'views/AppView.vala',
  'widgets/HeaderBar.vala',
  'widgets/CircularProgressBar.vala',
  'widgets/SystemInfo.vala',
  'widgets/CustomStorageBar.vala',
  'Application.vala',
  'Main.vala',
  'Window.vala',
)

optimizer_sources += constants_header
