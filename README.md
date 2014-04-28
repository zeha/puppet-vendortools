Build status:  [![Build Status](https://travis-ci.org/Voalte/puppet-vendortools.svg?branch=master)](https://travis-ci.org/Voalte/puppet-vendortools)

# vendortools puppet module 

v0.0.1 - John Simpson, Jeff Palmer 2013-10-04

This module installs the appropriate packages and services to interact with
the machine's hardware. It uses the "manufacturer" fact to choose one of
several manufacturer-specific modules. If the hardware is not recognized, the
module does nothing.

## Apple - hardware::apple

Apple hardware is recognized, but the hardware::apple module currently doesn't
do anything.

## Dell - hardware::dell

* Installs the Dell OSMA yum repositories (one applies to all hardware,
the other is specific to each model number).
* Installs several Dell packages.
* Ensures that the "dataeng" service (part of Dell's storage management
framework) is running.

## HP - hardware::hp

* Installs the HP Software Delivery Repository.
* Installs several HP-specific packages.
* Ensures that the "hp-health" service is running.
* If the "hp-health" package is updated, the "hp-health" service is restarted.

## IBM - hardware::ibm

IBM hardware is recognized, but the hardware::ibm module currently does not
do anything.

## VMWare - hardware::vmware

VMWare guests are recognized, but the hardware::vmware module currently does
not do anything.

// Copyright (c) 2013-2014 Voalte Inc. All rights reserved
