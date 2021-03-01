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
    key => "AAAAB3NzaC1yc2EAAAADAQABAAABgQC+SawtVhFRBz39jqcGG9+QZPmDZr2ANWeTBo1MRuKZ2g0ZE2ruw12Od7LsPEVLPpJ8p876VPQEhz3wNSEbgUMhzsjDNkfqtOFac1h9SFmVEua2YX43WnhYPhgk+qDF+qDoOY4o81rbtks0hkRRlfO1EOf59+e6zxPzvH5uwXNGd0qXBGfzWJ+NhjmncxTvRBmdS7zju2DG1tXuw8JTqKcyZ/3uYamIaRi5aOh2Unpv9mEj94LDfbwA1RuJIJqIXwh8zoZ3bG/EBPLLrQh6QVbuL7FSUzY6yVCytH8QlfogvdPfoS0n8kxJJxWtIEyRa8tbtjL6ycorF4Ad47QKfgfv4G6DvHu1iyXxVHZcK/WZ1BYFTXaGgUDqY+usbKAJ0PUiX6LLQm9XKySlANXfRKR+f9iYsf2i0maD9imJDKbUM6cKyuTzQAHPuiN0LvZTJ8urz0Weg8gejQ9NF8Z9mfErDcvmS06uqi0qmidXg1R07v0qM0p0zOB0gXYuRFFzIa0=",
    type => "ssh-rsa",
    user => $user,
    require => File["/home/${user}/.ssh/id_rsa.pub"],  
  }
}



