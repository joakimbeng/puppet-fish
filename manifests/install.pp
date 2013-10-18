define fish::install($path = '/usr/bin/fish') {

  if(!defined(Package['git-core'])) {
    package { 'git-core':
      ensure => present,
    }
  }

  exec { "chsh -s $path $name":
    path    => '/bin:/usr/bin',
    unless  => "grep -E '^${name}.+:${$path}$' /etc/passwd",
    require => Package['fish']
  }

  package { 'fish':
    ensure => latest,
  }

  if(!defined(Package['curl'])) {
    package { 'curl':
      ensure => present,
    }
  }

  exec { 'copy-fish-config':
    path    => '/bin:/usr/bin',
    cwd     => "/home/$name",
    user    => $name,
    command => 'mkdir -p .config/fish && cp .oh-my-fish/templates/config.fish .config/fish/config.fish',
    unless  => 'ls .config/fish/config.fish',
    require => Exec['clone_oh_my_fish'],
  }

  exec { 'clone_oh_my_fish':
    path    => '/bin:/usr/bin',
    cwd     => "/home/$name",
    user    => $name,
    command => "git clone http://github.com/bpinto/oh-my-fish.git /home/$name/.oh-my-fish",
    creates => "/home/$name/.oh-my-fish",
    require => [Package['git-core'], Package['fish'], Package['curl']]
  }

}

