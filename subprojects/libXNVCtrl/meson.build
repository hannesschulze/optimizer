project ('libXNCtrl', [ 'c' ],
  version: '0.1.0')

libXNCtrl_sources = [ 'src/NVCtrl.c' ]

libXNCtrl_dependencies = [
	dependency('xext'),
    dependency('x11')
]

libXNCtrl_static = static_library ('XNCtrl',
    libXNCtrl_sources,
    dependencies: libXNCtrl_dependencies
)

libXNCtrl_dependency = declare_dependency (
    link_with: libXNCtrl_static,
    include_directories: [ include_directories('./src') ]
)

subdir('samples')
subdir('test')
