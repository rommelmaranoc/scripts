node "rpmaranoc.domain.com" {

package { vim-enhanced :ensure => installed,}
package { curl:ensure => installed,}
package { git :ensure => installed,}

user { 'monitor':
    ensure => present,
    comment => 'User Monitor',
    home => '/home/monitor',
        managehome => true,
        shell   => '/bin/bash',
     }

file { '/home/monitor/scripts':
    ensure => 'directory',
  }

exec{'retrieve_github':
    command => "/usr/bin/wget -q https://raw.githubusercontent.com/rommelmaranoc/scripts/master/memory_check.sh -O /home/monitor/scripts/memory_check.sh",
    creates => "/home/monitor/scripts/memory_check.sh",
  }

file { '/home/monitor/scripts/memory_check.sh':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '777',
}

file { '/home/monitor/src':
    ensure => 'directory',
  }

file { '/home/monitor/src/my_memory_check':
  ensure => 'link',
  target => '/home/monitor/scripts/memory_check.sh',
}

cron { "shell script":
        command => "sh /home/monitor/src/my_memory_check -c 90 -w 85 -e rpmaranoc@chikka.com",
        user => "root",
        minute => '*/10',
        ensure => present,
}

package {'tzdata':
  ensure  => 'present'
}

file {'/etc/localtime':
  require => Package['tzdata'],
  source  => 'file:///usr/share/zoneinfo/Asia/Manila',
}

file {'/etc/timezone':
  content => 'Asia/Manila',
}

}
