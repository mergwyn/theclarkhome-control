#

class profile::platform::baseline::windows {

  include profile::os::windows::tasks
  include profile::os::windows::base
# TODO: review included profiles
  #include profile::zabbix::agent


#  include ::profile::platform::baseline::windows::bootstrap
#  include ::profile::platform::baseline::windows::common
#  include ::profile::platform::baseline::windows::motd
#  include ::profile::platform::baseline::windows::firewall
#  include ::profile::platform::baseline::windows::packages
#  include ::profile::platform::baseline::users::windows

}