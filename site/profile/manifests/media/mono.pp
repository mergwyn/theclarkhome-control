#
# TODO: 

class profile::media::mono () {

  $distro= $::facts['os']['distro']['codename']
  apt::source { 'mono-official-stable':
    location => 'https://download.mono-project.com/repo/ubuntu',
    release  => "stable-${distro}",
    repos    => 'main',
    key      => {
      'id'     => '3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF',
      'server' => 'keyserver.ubuntu.com',
    },
  }
  package { [ 'mono-complete' ] : }

}
# vim: sw=2:ai:nu expandtab
