# Copyright (c) 2013-2014 Voalte Inc. All rights reserved.
class vendortools {

  ########################################
  # Note that the regular expressions here are also used in the
  # voalte-snmp module's snmpd.conf template file. If you update this list
  # and the change affects SNMP, be sure to update the snmpd.conf template
  # as well.

  case $::manufacturer {
    /(?i:^apple)/       : { include vendortools::apple   }
    /(?i:^dell)/        : { include vendortools::dell    }
    /(?i:^hp pavilion)/ : { }
    /(?i:^hp)/          : { include vendortools::hp      }
    /(?i:^ibm)/         : { include vendortools::ibm     }
    /(?i:^vmware)/      : { include vendortools::vmware  }
    default             : { }
  }
}
