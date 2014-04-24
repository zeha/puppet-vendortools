#Copyright (c) 2013-2014 Voalte Inc. All rights reserved.
class venortools::hp {

  Package {
    schedule => daily,
  }

  yumrepo { 'HP-MCP' :
    descr          => 'HP Software Delivery Repository for MCP' ,
    baseurl        => 'http://downloads.linux.hp.com/SDR/downloads/MCP/CentOS/$releasever/$basearch/current' ,
    gpgkey         => 'http://downloads.linux.hp.com/SDR/downloads/MCP/GPG-KEY-mcp' ,
    failovermethod => 'priority',
    enabled        => '1',
    gpgcheck       => '0',
    priority       => '10',
  }

  package { 'hp-health' :
    ensure  => latest ,
    require => Yumrepo['HP-MCP'] ,
    notify  => Service['hp-health'] ,
  }
    
  package { [ 'hpacucli' , 'hponcfg' ] :
    ensure  => 'latest' ,
    require => Yumrepo['HP-MCP'] ,
  }

  service { 'hp-health' :
    ensure     => running ,
    enable     => true ,
    hasrestart => true ,
    pattern    => "hpasm*" ,
    require    => Package['hp-health'] ,
  }

  ########################################
  # HP-specific SNMP modules

  package { 'hp-snmp-agents' :
    ensure   => latest ,
    require  => Yumrepo['HP-MCP'] ,
    notify   => Service['hp-snmp-agents'] ,
  }

  service { 'hp-snmp-agents' :
    ensure  => running ,
    require => Package['hp-snmp-agents'] ,
  }

}
