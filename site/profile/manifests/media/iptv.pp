#

class profile::media::iptv {
  include cron
  include profile::scripts

  $codedir='/opt/code/scripts'

  $packages = [ 'curl', 'socat' ]
  package { $packages: ensure => present }

  #class{'::tvheadend':
    #release        => 'stable-4.2',
    #admin_password => 'L1nahswf.ve',
    #user           => 'media',
    #group          => '513',
  #} 
  #TODO cron

  cron::job::multiple { 'xmltv':
    jobs => [
      {
        command     => "test -x ${codedir}/iptv/get-epg && ${codedir}/iptv/get-epg",
        minute      => 30,
        hour        => '2',
      },
      {
        command     => "test -x ${codedir}/iptv/get-channels && ${codedir}/iptv/get-channels",
        minute      => 20,
        hour        => '4,12,16',
      },
    ],
    environment => [ 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' ],
  }

  #TODO tvhproxy
}

# vim: sw=2:ai:nu expandtab