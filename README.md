#Selenium Grid Puppet Module

A Puppet Module for Installing and Managing Selenium Grid2 on Ubuntu and Debian Systems.

## Getting Started

This is intended to be a re-usable
[Puppet](http://www.puppetlabs.com/puppet/introduction/) module that you can
include in your own tree.

In order to add this module, run the following commands in your own Git puppet tree:

```% git submodule add git://github.com/StoryIQ/puppet-selenium-grid.git modules/selenium_grid```
```% git submodule update --init```

### Setting up a Hub

Add the following to your Puppet manifest to setup a Hub. This will Download Selenium Grid2, configure it as
 a Service, and will start the hub using the installed service. Grid2 requires a Java Virtual Machine to be 
 installed, but this module makes no attempt at installing the Java dependency.

```class { "selenium_grid::hub":
    version => "2.21.0",
}```

The service can be stopped with the following

```class { "selenium_grid::hub":
    version => "2.21.0",
    ensure => "stopped",
}```


