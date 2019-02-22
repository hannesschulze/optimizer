project('com.github.hannesschulze.optimizer', ['c', 'vala'],        version: '0.1.0',
  meson_version: '>= 0.40.0',
)

i18n = import('i18n')

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

c_args = [
  '-include', 'config.h'
]

subdir('data')
subdir('po')
subdir('src')

optimizer_deps = [
  dependency('gobject-2.0'),
  dependency('glib-2.0'),
  dependency('granite'),
  dependency('gtk+-3.0'),
  dependency('libgtop-2.0'),
]

gnome = import('gnome')

optimizer_sources += gnome.compile_resources('optimizer-resources',
  'data/com.github.hannesschulze.optimizer.gresource.xml',
  source_dir: 'data',
  c_name: 'optimizer'
)

executable('com.github.hannesschulze.optimizer', optimizer_sources,
  dependencies: optimizer_deps,
  install: true,
  c_args: c_args,
  vala_args: [
    '--vapidir=' + meson.source_root() + '/vapi/',
    '--target-glib=2.50'
  ]
)

meson.add_install_script('build-aux/meson/postinstall.py')