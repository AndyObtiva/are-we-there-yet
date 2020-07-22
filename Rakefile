require 'glimmer/rake_task'

## Use the following configuration if you would like to customize javapackager
## arguments for `glimmer package` command.
#
Glimmer::Package.javapackager_extra_args =
  " -native #{ENV['NATIVE'] || ('dmg' if OS.mac?) || ('msi' if OS.windows?)}" +
  " -Bwin.menuGroup='Are We There Yet'" 
#   " -BlicenseType=" +
#   " -Bmac.CFBundleIdentifier=" +
#   " -Bmac.category=" +
#   " -Bmac.signing-key-developer-id-app="
