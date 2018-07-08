#

class profile::puppet_master {

  #include '::puppet'
  #include '::puppet::master'


  class { 'r10k':
    cachedir => '/var/cache/r10k',
    sources  => {
    'mergwyn' => {
      'remote'  => 'https://github.com/mergwyn/theclarkhome-control',
      'basedir' => "${::settings::codedir}/environments",
      },
    },
  }

  # Configure puppetdb and its underlying database
  class { 'puppetdb': }
  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }

  # Configure Apache on this server
  class { 'apache': }
  class { 'apache::mod::wsgi': }
  # Configure Puppetboard
  class { 'puppetboard':
    manage_git          => true,
    manage_virtualenv   => true,
    default_environment => '*',
  }
  # Access Puppetboard through pboard.example.com
  class { 'puppetboard::apache::vhost':
    vhost_name => 'echo.theclarkhome.com',
    port       => 80,
    }
}
# vim: sw=2:ai:nu expandtab
