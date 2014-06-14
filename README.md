# puppet-tsm [![Build Status] (https://secure.travis-ci.org/nosolutions/puppet-tsm.png)](http://travis-ci.org/nosolutions/puppet-tsm) [![Coverage Status](https://coveralls.io/repos/nosolutions/puppet-tsm/badge.png)](https://coveralls.io/r/nosolutions/puppet-tsm)

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with tsm](#setup)
    * [What tsm affects](#what-tsm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with tsm](#beginning-with-tsm)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

Install and manage TSM (Tivoli Storage Manager) client with puppet. It's
heavily inspired by the puppetlabs-ntp module.

This is currently work in progress!

##Module Description

This module handles installing, configuring and running the IBM Tivoli
Storage Manager (TSM) client on the following operating systems:

* RedHat Linux 5/6
* CentOS 5/6
* Oracle Linux 5/6
* Scientific Linux 5/6
* Solaris 10/11

##Setup

### What tsm effects

* TSM package (TIVsm-Ba and TIVsm-API)
* TSM configuration files (dsm.sys and InclExcl)
* TSM service (dsmsched)

###Setup requirements

For RedHat Linux you need a yum repository that contains the rpm
packages IBM provides in the TSM installation tar.gz.

These usually are

* TIVsm-API64.x86_64.rpm
* gskssl64-8.0.14.26.linux.x86_64.rpm
* gskcrypt64-8.0.14.26.linux.x86_64.rpm
* TIVsm-BA.x86_64.rpm

For Solaris 10 and 11 you need a HTTP server that provides the
following packages for downloading:

* TIVsmCapi.pkg
* TIVsmCba.pkg
* gsk8cry32.pkg
* gsk8cry64.pkg
* gsk8ssl32.pkg
* gsk8ssl64.pkg

IBM provides the gsk packages as file systems packages (thanks IBM!),
so you have to translate them with pkgtrans:

   pkgtrans . gskssl32.pkg gsk8ssl32/

and copy them to your HTTP download location. You are going to need two
download locations: one for sparc and one for i386 (see params.pp for
an example).

###Beginning with tsm

Include class TSM on hosts where you would like to install the TSM
client packages. By default no config files will be overridden. The
TSM class just makes sure the TSM packages are installed.

##Usage

All available options (see [init.pp](manifests/init.pp)) should be
changed via the main tsm class.

The default *dsm.sys* template only sets

* COMMMethod
* TCPPort
* TCPServeraddress

if you would like to add additional default options for nodes, you
have to use a hash (parameter config_hash) or hiera. Here's a hiera
example:

    tsm::config_hash:
        errorlogname: "/var/log/dsmerror.log"
        errorlogretention: "31 D"
        schedlogname: "/var/log/dsmsched.log"
        schedlogretention: "30 d"
        nodename: "%{::hostname}"
        inclexcl: "/opt/tivoli/tsm/client/ba/bin/InclExcl"
        passwordaccess: "generate"
        domain: "all-local"
        makesparsefile: "no"

There is also the possibility to add node local options to
*dsm.sys.local*. Settings in *dsm.sys.local* are going to be merged
into the global *dsm.sys* on the next puppet run.

### The Include/Exclude file

If there is no */opt/tivoli/tsm/client/ba/bin/InclExcl* file
available, this module also deploys a default *InclExcl* file.

For a puppet managed include/exclude file set *inclexcl_replace* to
*true*.

In the case of a puppet managed include/exclude file, you can add
local include/exclude rules to
*/opt/tivoli/tsm/clien/ba/bin/InclExcl.local* and add a second
inclexcl option that points to
*/opt/tivoli/tsm/clien/ba/bin/InclExcl.local* to *dsm.sys*. For
example add the following to *dsm.sys.local*:

    inclexcl /opt/tivoli/tsm/client/ba/bin/InclExcl.local

##Reference

Please see [init.pp](manifests/init.pp) for an explanation of all available options.

##Limitations

This module has been built on and tested against Puppet 3.1.0 and higher.

The module has been tested on:

* RedHat Enterprise Linux 5/6
* Solaris 10 i386/sparc
* Solaris 11 i386/sparc

##Development

Fork me and create pull requests.

###Contributors

The list of contributors can be found at:
[https://github.com/nosolutions/puppet-tsm/graphs/contributors](https://github.com/nosolutions/puppet-tsm/graphs/contributors)
