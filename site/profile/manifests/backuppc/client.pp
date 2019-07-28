#
class profile::backuppc::client (
  $config   = '/etc/backuppc',
  $scripts  = "${config}/scripts",
  $preuser  = "${scripts}/DumpPreUser",
  $postuser = "${scripts}/DumpPostUser",
  ) {

  if !defined(File[$config]) {
    notice("Spotted File[${config}] not defined")
    file {$config:
      ensure  => directory,
    }
  } else {
    notice("spotted File[${config}] already defined")
  }

  file {[$scripts, $preuser, $postuser]:
    ensure  => directory,
    require => File[$config],
  }

  file { "${preuser}/S10dirsonly":
    ensure => present,
    source => 'puppet:///modules/profile/backuppc/S10dirsonly',
    mode   => '0555',
  }

  #package { 'rsync': ensure => installed }
  include backuppc::client

  if empty(hiera('backuppc::client::system_account'))
  {
    # Need to manage .ssh keys outside of backuupc module
    $system_account        = hiera('defaults::system_user')
    $system_home_directory = hiera('defaults::system_home_dir')
    $backuppc_hostname     = hiera('defaults::backuppc_server')

    file { "${system_home_directory}/.ssh":
      ensure => 'directory',
      mode   => '0700',
      owner  => $system_account,
      group  => $system_account,
    }
    Ssh_authorized_key <<| tag == "backuppc_${backuppc_hostname}" |>> {
      ensure  => present,
      user    => $system_account,
      require => File["${system_home_directory}/.ssh"]
    }
  }
}


# vim: sw=2:ai:nu expandtab
