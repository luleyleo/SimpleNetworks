simple_networks_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
]

simple_networks_deps = [
  config_dep,
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

simple_networks_sources += gnome.compile_resources('simple-networks-resources',
  'simple-networks.gresource.xml',
  c_name: 'simple_networks'
)

executable('simple-networks', simple_networks_sources,
  dependencies: simple_networks_deps,
  include_directories: config_inc,
       install: true,
)
