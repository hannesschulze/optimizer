project('com.github.hannesschulze.optimizer', 'c', 'vala', version: '1.2.1')

i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

c_args = [
  '-DWNCK_I_KNOW_THIS_IS_UNSTABLE'
]

use_fallback_theme = get_option ('use_fallback_theme')

subdir('src')

optimizer_deps = [
  dependency('gobject-2.0'),
  dependency('glib-2.0'),
  dependency('granite'),
  dependency('gtk+-3.0'),
  dependency('gdk-x11-3.0'),
  dependency('libgtop-2.0'),
  dependency('libwnck-3.0'),
  meson.get_compiler('c').find_library('m'),
  meson.get_compiler('vala').find_library('posix'),
]

gnome = import('gnome')

optimizer_sources += gnome.compile_resources(
  'optimizer-resources',
  join_paths('data', meson.project_name() + '.gresource.xml'),
  source_dir: 'data',
  c_name: 'optimizer'
)

executable(
  meson.project_name(),
  optimizer_sources,
  dependencies: optimizer_deps,
  install: true,
  c_args: c_args,
  vala_args: [
    '--vapidir=' + meson.source_root() + '/vapi/',
    '--target-glib=2.50'
  ]
)

subdir('data')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')
