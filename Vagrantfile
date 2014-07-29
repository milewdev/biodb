#
# Vagrantfile for a generic rails 4.1 development environment vm.
#


VAGRANTFILE_API_VERSION   = "2"
BOX                       = "OSX109"
PROVIDER_NAME             = "vmware_fusion"
PROJECT_NAME              = "biodb"
VM_NAME                   = PROJECT_NAME
HOST_HOME_DIR             = { host: "~/", guest: "/.vagrant_host_home" }
PROJECT_GITHUB_URL        = "https://github.com/milewgit/#{PROJECT_NAME}.git"
PROJECT_VM_DIR            = "/Users/vagrant/Documents/#{PROJECT_NAME}"
PROVISIONER_URL           = "https://raw.githubusercontent.com/milewgit/vm-provisioner/master/Provisioner.rb"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |vagrant_config|
  with vagrant_config do
    Setup     :Box, BOX
    Setup     :Provider, PROVIDER_NAME, VM_NAME
    Setup     :SyncedFolder, HOST_HOME_DIR                # easy way to copy gpg keys and git config from host to vm
    Install   :OsxCommandLineToolsMavericks               # needed by git, ruby
    Install   :TextMate
    Install   :Gpg                                        # needed to sign git commits
    Install   :Git                                        # source is on github
    Install   :GitHubForMac
    Install   :Homebrew                                   # needed to install ruby
    Install   :PostgreSQL, "92"                           # must be installed before Bundle :Install is run
    Install   :Ruby, "2.1.2"
    Install   :Bundler
    Git       :Clone, PROJECT_GITHUB_URL, PROJECT_VM_DIR    
    Bundle    :Install, PROJECT_VM_DIR
    Reboot    :Vm
  end
end


def with(vagrant_config, &block)
  require "open-uri"
  File.write "Provisioner.rb", open(PROVISIONER_URL).read
  require_relative "Provisioner"
  Provisioner.provision(vagrant_config, &block)
  File.delete "Provisioner.rb"
end
