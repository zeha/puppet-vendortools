# Copyright (c) 2013-2014 Voalte Inc. All rights reserved.
class vendortools::dell {

  Package {
    schedule => daily ,
  }

  yumrepo { 'dell-omsa-indep' :
    descr          => 'DELL OMSA repository - Hardware independent' ,
    mirrorlist     => 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver' ,
    gpgkey         => 'http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-dell http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-libsmbios' ,
    failovermethod => 'priority' ,
    enabled        => '1' ,
    gpgcheck       => '1' ,
    priority       => '10' ,
    protect        => '0' ,
  }


  yumrepo { 'dell-omsa-specific' :
    descr          => 'DELL OMSA repository - Hardware specific' ,
    mirrorlist     => 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver' ,
    gpgkey         => 'http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-dell http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-libsmbios' ,
    failovermethod => 'priority' ,
    enabled        => '1' ,
    gpgcheck       => '1' ,
    priority       => '10' ,
  }

  package { [ 'Lib_Utils' , 'MegaCli' ] :
    ensure  => absent ,
  }

  package { [ 'yum-dellsysid' , 'dell_ft_install' ] :
    ensure  => latest ,
    require => Yumrepo['dell-omsa-indep'] ,
  }

  package { 'srvadmin-base' :
    ensure  => latest ,
    require => Package['yum-dellsysid'] ,
  }

  package { [
      'srvadmin-storage' ,
      'srvadmin-omcommon' ,
      'srvadmin-omacore' ,
      'srvadmin-storageservices' ,
    ] :
    ensure  => latest ,
    require => Package['srvadmin-base'] ,
  }

  package { 'perl-Config-Tiny' :
    ensure  => latest ,
  }

  service { 'dataeng' :
    ensure     => running ,
    enable     => true ,
    hasrestart => true ,
    pattern    => 'dsm_sa_datamgrd' ,
    require    => Package['srvadmin-storage'] ,
  }
}
