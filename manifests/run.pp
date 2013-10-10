# TODO add stop on runlevel back
define docker::run(
  $image,
  $command = false,
  $memory_limit = '0',
  $ports = [],
  $volumes = [],
  $running = true,
  $volumes_from = false,
  $username = false,
  $hostname = false,
  $env = [],
  $dns = [],
  $respawn = true,
  $should_daemonize = true,
  $start_on_runlevel = '[2345]',
  $prestop = false,
) {

  validate_re($image, '^[\S]*$')
  validate_re($title, '^[\S]*$')
  validate_re($memory_limit, '^[\d]*$')
  #validate_string($command, $username, $hostname)
  validate_bool($running)

  $ports_array = any2array($ports)
  $volumes_array = any2array($volumes)
  $env_array = any2array($env)
  $dns_array = any2array($dns)

  file { "/etc/init/docker-${title}.conf":
    ensure  => present,
    content => template('docker/etc/init/docker-run.conf.erb')
  }

  service { "docker-${title}":
    ensure     => $running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    provider   => upstart,
    require    => File["/etc/init/docker-${title}.conf"],
  }

}
