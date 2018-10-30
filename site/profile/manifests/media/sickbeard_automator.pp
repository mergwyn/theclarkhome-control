#
class profile::media::sickbeard_automator {

  include profile::git
  include profile::scripts

  $packages = [ 'nfs-common' ]
  package { $packages: ensure => present }

  $codedir='/opt/'
  $target="${codedir}/sickbeard_mp4_automator"

  apt::ppa { 'ppa:jonathonf/ffmpeg-4':
    package_manage => true
  }
  package { 'ffmpeg':
    ensure  => present,
    require => Apt::Ppa['ppa:jonathonf/ffmpeg-4'],
  }

  vcsrepo { $target:
    ensure   => latest,
    provider => git,
    require  => [
      Class['profile::git'],
      Package['ffmpeg'],
    ],
    source   => 'https://github.com/mdhiggins/sickbeard_mp4_automator',
    revision => 'master',
  }
  #TODO install dependencies
  #TODO install plex.ini
  #TODO change logging parameters?
  $logpath = '/var/log/sickbeard_mp4_automator'
  file { $logpath:
    ensure => directory,
    mode   => '0777',
  }
  file { "${logpath}/index.log":
    ensure => file,
    mode   => '0666',
    require => File[$logpath],
  }
}

# vim: sw=2:ai:nu expandtab
