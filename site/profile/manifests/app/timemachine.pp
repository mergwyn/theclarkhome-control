#

class profile::app::timemachine {

  $path = '/srv/timemachine'

  if versioncmp($facts['samba_version'], '4.8') >= 0 {
# Use SMB for TimeMachine
    include profile::samba::member

    ::samba::share { 'timemachine':
        path    => $path,
        options => {
          'commment'           => 'Time Machine',
          'vfs objects'        => 'catia fruit streams_xattr',
          'fruit:time machine' => 'yes',
          'browseable'         => 'yes',
          'writeable'          => 'yes',
          'create mask'        => 0600,
          'directory mask'     => 0700,
        }
    }

  } else {
# Use AFP for TimeMachine
    file { $path:
      ensure => directory,
      owner  => 'timemachine',
    }

    package { [ 'netatalk' ] : }
    service { [ 'netatalk' ] : }

    file_line { 'default':
      ensure => present,
      path   => '/etc/netatalk/AppleVolumes.default',
      line   => ':DEFAULT: options:upriv,usedots,noadouble',
      match  => '^:DEFAULT:',
    }
    file_line { 'timemachine':
      ensure => present,
      path   => '/etc/netatalk/AppleVolumes.default',
      line   => '/srv/timemachine "Time Machine" cnidscheme:dbd options:usedots,upriv,tm',
      match  => '^/srv/timemachine',
    }

    #ini_setting {'default':
    #  ensure            => present,
    #  path              => '/etc/netatalk/AppleVolumes.default',
    #  section           => '',
    #  key_val_separator => ' ',
    #  setting           => ':DEFAULT:',
    #  value             => 'options:upriv,usedots,noadouble',
    #}

    #ini_setting {'tm':
    #  ensure            => present,
    #  path              => '/etc/netatalk/AppleVolumes.default',
    #  section           => '',
    #  key_val_separator => ' ',
    #  setting           => '/srv/timemachine',
    #  value             => '"Time Machine" cnidscheme:dbd options:usedots,upriv,tm',
    #}
  }


# Set quota
# TODO: use parameter for TM quota ?

  file { "${path}/.com.apple.TimeMachine.quota.plist":
    owner   => 'timemachine',
    mode    => '0600',
    require => File[$path],
    content => @("EOT"/)
               <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
               <plist version="1.0">
               <dict>
               <key>GlobalQuota</key>
               <integer>250000000000</integer>
               </dict>
               </plist>
               | EOT
  }

  file { "${path}/.com.apple.timemachine.supported":
    owner   => 'timemachine',
    mode    => '0600',
    require => File[$path],
  }

}
