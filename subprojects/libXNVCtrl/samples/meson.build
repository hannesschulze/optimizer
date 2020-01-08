samples_files = [
  'nv-control-3dvisionpro.c',
  'nv-control-dpy.c',
  'nv-control-dvc.c',
  'nv-control-events.c',
  'nv-control-framelock.c',
  'nv-control-info.c',
  'nv-control-targets.c',
  'nv-control-warpblend.c'
]

foreach sample_file : samples_files
    sample_name = sample_file.split('.')[0]
    executable (sample_name,
      sample_file,
      dependencies: [ libXNCtrl_dependency ],
      install: false)
endforeach
