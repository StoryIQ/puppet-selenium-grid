class selenium_grid {

  class hub($version, $ensure='running') {
    
    class {"install": 
      version => $version,
    }
     
    service { 'segrid2hub':
      ensure     => $ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require => Exec["hub-service"],
    }
  }

  class install($version) {
    case $operatingsystem {
      debian, ubuntu: {
        $supported = true
        $service_name = 'ntp'
        $conf_file    = 'ntp.conf.debian'
      }
      default: {
        $supported = false
        notify { "${module_name}_unsupported":
          message => "The ${module_name} module is not supported on ${::operatingsystem}",
        }
      }
    }

    $directory="/opt/selenium/grid2"
    $user="seleniumgrid"
    $selenium_standalone="$directory/selenium-server-standalone.jar"
    
    if ($supported == true) {

      user { $user:
        ensure => "present",
      }

      file { ["/opt/selenium", $directory]:
        ensure => "directory",
        owner  => $user,
        group => $user,
        mode   => 750,
        require => User[$user],
      }

      exec { "download" :
        command => "wget -O $directory/selenium-server-standalone-$version.jar  https://selenium.googlecode.com/files/selenium-server-standalone-$version.jar",
        path => "/usr/bin:/bin:/usr/sbin:/sbin",
        unless => "ls $directory | grep selenium-server-standalone-$version.jar",
        require => File[$directory],
      }

      file { $selenium_standalone :
        ensure => "present",
        owner  => $user,
        group => $user,
        mode   => 750,
        source => "$directory/selenium-server-standalone-$version.jar",
        require => Exec["download"],
      }

      file { "/etc/init.d/segrid2hub" :
        ensure => "present",
        mode   => 750,
        source => "puppet:///modules/selenium_grid/segrid2hub",
        require => File[$selenium_standalone],
      }

      exec { "hub-service" :
        command => "sudo update-rc.d segrid2hub defaults",
        path => "/usr/bin:/bin:/usr/sbin:/sbin",
        require => [File["/etc/init.d/segrid2hub"], File["$directory/hub"]],
      }

      file { "$directory/hub" :
        ensure => "present",
        owner  => $user,
        group => $user,
        mode => 750,
        source => "puppet:///modules/selenium_grid/hub",
        require => File[$selenium_standalone],
      }

    }

  }

}
