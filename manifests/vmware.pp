# Copyright (c) 2013-2014 Voalte Inc. All rights reserved.
class vendortools::vmware {

  yumrepo { 'vmware-tools-collection' :
    descr    => "VMWare ESXi 5.5 Guest Tools for RHEL/CentOS ${operatingsystemmajrelease} ${architecture}",
    baseurl  => "http://packages.vmware.com/tools/esx/5.5/rhel${operatingsystemmajrelease}/${architecture}",
    gpgkey   => 'http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub',
    enabled  => '1',
    gpgcheck => '1',
  }

  package { 'vmware-tools-esx-nox' :
    ensure  => installed,
    require => Yumrepo['vmware-tools-collection'],
  }

}
