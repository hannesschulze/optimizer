icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
  install_data(
    join_paths('images', 'icons', i, 'com.github.hannesschulze.optimizer.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
  )
endforeach

desktop_file = i18n.merge_file(
  input: 'com.github.hannesschulze.optimizer.desktop.in',
  output: 'com.github.hannesschulze.optimizer.desktop',
  type: 'desktop',
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'applications')
)

desktop_utils = find_program('desktop-file-validate', required: false)
if desktop_utils.found()
  test('Validate desktop file', desktop_utils,
    args: [desktop_file]
  )
endif

appstream_file = i18n.merge_file(
  input: 'com.github.hannesschulze.optimizer.appdata.xml.in',
  output: 'com.github.hannesschulze.optimizer.appdata.xml',
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'appdata')
)

appstream_util = find_program('appstream-util', required: false)
if appstream_util.found()
  test('Validate appstream file', appstream_util,
    args: ['validate', appstream_file]
  )
endif

install_data('com.github.hannesschulze.optimizer.gschema.xml',
  install_dir: join_paths(get_option('datadir'), 'glib-2.0/schemas')
)

compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
  test('Validate schema file', compile_schemas,
    args: ['--strict', '--dry-run', meson.current_source_dir()]
  )
endif