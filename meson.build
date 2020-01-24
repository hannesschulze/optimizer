project('com.github.hannesschulze.optimizer', 'c', 'vala', version: '1.2.1')

i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

c_args = [
  '-DWNCK_I_KNOW_THIS_IS_UNSTABLE'
]

use_fallback_theme = get_option ('use_fallback_theme')

# Nvidia support
libXNVCtrl_proj = subproject ('libXNVCtrl')
libXNVCtrl_dep = libXNVCtrl_proj.get_variable('libXNVCtrl_dependency')

# AMD GPU support
libradeontop_proj = subproject ('radeontop')
libradeontop_dep = libradeontop_proj.get_variable('libradeontop_dep')

subdir('src')

optimizer_deps = [
  dependency('gobject-2.0'),
  dependency('glib-2.0'),
  dependency('granite'),
  dependency('gtk+-3.0'),
  dependency('gdk-x11-3.0'),
  dependency('libgtop-2.0'),
  dependency('libwnck-3.0'),
  dependency('x11'),
  libXNVCtrl_dep,
  libradeontop_dep,
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
    '--target-glib=2.50',
    '--pkg=libXNCtrl',
    '--pkg=libradeontop'
  ]
)

subdir('data')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')
