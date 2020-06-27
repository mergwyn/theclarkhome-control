#

class profile::puppet::agent {

  include ::sudo
  include profile::puppet::repo

  # make sure we match server major version
  $ver = split($::serverversion, '\.')
  apt::pin { 'puppet':
    priority        => 501,
    packages        => 'puppet-agent',
    release_version => "${ver[0]}*"
  }
  package { 'puppetlabs-release-pc1': ensure => absent }

  file { '/etc/profile.d/puppet.sh':
    ensure  => present,
    content => "# Expand the PATH to include extra puppet binaries\nPATH=\$PATH:/opt/puppetlabs/puppet/bin\n"
  }

  include sudo
  sudo::conf { 'puppet':
    content => 'zabbix  ALL=(root)      NOPASSWD:       /opt/puppetlabs/puppet/bin/ruby'
  }

  $ruby = '/opt/puppetlabs/puppet/bin/ruby'
  $lastrunfile = "${settings::lastrunfile}" # TODO This gives the wrong value for some reason
  $lastrunfile = '/opt/puppetlabs/puppet/cache/state/last_run_summary.yaml'
  $cmd  = "${ruby} -rjson -ryaml -e \"puts JSON.pretty_generate(YAML.load_file('${lastrunfile}'))\""
  zabbix::userparameters { 'puppet-health':
    content => "UserParameter=puppet.health[*],sudo ${cmd}"
  }

}
