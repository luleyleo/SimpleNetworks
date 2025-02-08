simple_networks_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
]

simple_networks_blueprints = [
  'gtk/help-overlay.blp',
  'window.blp',
]

simple_networks_deps = [
  config_dep,
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('libnm', version: '>= 1.50'),
]

simple_networks_compiled_blueprints = custom_target('blueprints',
  input: simple_networks_blueprints,
  output: '.',
  command: [find_program('blueprint-compiler'), 'batch-compile', '@OUTPUT@', '@CURRENT_SOURCE_DIR@', '@INPUT@'],
)

simple_networks_sources += gnome.compile_resources('simple-networks-resources',
  'simple-networks.gresource.xml',
  c_name: 'simple_networks',
  dependencies: [simple_networks_compiled_blueprints]
)

executable('simple-networks', simple_networks_sources,
  vala_args: [
    '--gresourcesdir=src/',
  ],
  dependencies: simple_networks_deps,
  include_directories: config_inc,
  install: true,
)
