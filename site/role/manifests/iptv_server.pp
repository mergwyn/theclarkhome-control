# vim: sw=2:ai:nu expandtab

class role::iptv_server {
  include profile::base  # All roles should have the base profile
  include profile::domain::member
  include profile::domain::sso
  include profile::media::iptv
}
