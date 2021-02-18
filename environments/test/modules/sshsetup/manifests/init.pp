#
# Setup passphraseless ssh
# --------------------
class sshsetup {
  $user = "shab"

  file {
    "/home/${user}/.ssh":
      ensure => "directory",
      owner => "${user}",
      group => "${user}",
      mode => "750",
  }


  file {
    "/home/${user}/.ssh/id_rsa":
      source => "puppet:///modules/hadoop/id_rsa",
      ensure => present,
      mode => "600",
      owner => $user,
      group => $user,
      require => File["/home/${user}/.ssh"],
      
  }

  file {
    "/home/${user}/.ssh/id_rsa.pub":
      source => "puppet:///modules/hadoop/id_rsa.pub",
      ensure => present,
      mode => "644",
      owner => $user,
      group => $user,
      require => File["/home/${user}/.ssh"],
      
  }

  file {
    "/home/${user}/.ssh/config":
      owner => $user,
      group => $user,
      mode => "755",
      content => "StrictHostKeyChecking no",
      require => File["/home/${user}/.ssh/id_rsa.pub"],
      
  }

  ssh_authorized_key { "ssh_key":
    ensure => present,
    key => "key",
    type => "ssh-rsa",
    user => $user,
    require => File["/home/${user}/.ssh/id_rsa.pub"],  
  }
}



