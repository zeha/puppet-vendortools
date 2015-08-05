#Copyright (c) 2013-2014 Voalte Inc. All rights reserved.
class vendortools::hp::repo {
  case $::osfamily {
    'RedHat': {
      yumrepo { 'HP-MCP' :
        descr          => 'HP Software Delivery Repository for MCP',
        baseurl        => 'http://downloads.linux.hp.com/SDR/downloads/MCP/CentOS/$releasever/$basearch/current',
        gpgkey         => 'http://downloads.linux.hp.com/SDR/hpPublicKey1024.pub http://downloads.linux.hp.com/SDR/hpPublicKey2048.pub http://downloads.linux.hp.com/SDR/hpPublicKey2048_key1.pub',
        failovermethod => 'priority',
        enabled        => '1',
        gpgcheck       => '1',
        priority       => '10',
      }
    }
    'Debian': {
      file { '/etc/apt/HP-MCP.key':
        source     => 'puppet:///modules/vendortools/hp/HP-MCP-Debian.key',
      }

      apt::key { 'HP-MCP':
        key_source => '/etc/apt/HP-MCP.key',
        key        => '882F7199B20F94BD7E3E690EFADD8D64B1275EA3',
      }

      apt::source { 'HP-MCP':
        location    => 'http://downloads.linux.hp.com/SDR/repo/mcp',
        repos       => 'non-free',
        release     => 'trusty/current',
        key         => '882F7199B20F94BD7E3E690EFADD8D64B1275EA3',
        include_src => false,
      }
    }
  }
}

class vendortools::hp::params {
  case $::osfamily {
    'RedHat': {
      if versioncmp($::operatingsystemrelease, '7.0') >= 0 {
        $hpssacli_package_name = 'hpssacli'
      } else {
        $hpssacli_package_name = 'hpacucli'
      }
    }
    'Debian': {
      $hpssacli_package_name = 'hpssacli'
    }
  }
}

class vendortools::hp (
  $hpssacli_package_name = $::vendortools::hp::params::hpssacli_package_name,
) inherits ::vendortools::hp::params
{

  include vendortools::hp::repo

  package { 'hp-health' :
    ensure  => latest,
    require => Class['vendortools::hp::repo'],
    notify  => Service['hp-health'],
  }

  package { [ $hpssacli_package_name, 'hponcfg' ] :
    ensure  => 'latest',
    require => Class['vendortools::hp::repo'],
  }

  service { 'hp-health' :
    ensure     => running,
    enable     => true,
    hasrestart => true,
    pattern    => 'hpasm*',
    require    => Package['hp-health'],
  }

  ########################################
  # HP-specific SNMP modules

  package { 'hp-snmp-agents' :
    ensure   => latest,
    require  => Class['vendortools::hp::repo'],
    notify   => Service['hp-snmp-agents'],
  }

  service { 'hp-snmp-agents' :
    ensure  => running,
    require => Package['hp-snmp-agents'],
  }
}
