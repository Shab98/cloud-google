Vagrant.configure("2") do |config|
  config.vm.box = "google/gce"

  config.vm.provider :google do |google, override|
    google.google_project_id = "vagrant-303411"
    google.google_json_key_location = "vagrant-303411-4bb19da15c7e.json"

    google.image_family = 'ubuntu-1604-lts'

    override.ssh.username = "shab"
    override.ssh.private_key_path = "~/.ssh/id_rsa"
    #override.ssh.private_key_path = "~/.ssh/google_compute_engine"
  end
  
  # Manage /etc/hosts on host and VMs
  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true  
  config.hostmanager.include_offline = true
  config.hostmanager.ignore_private_ip = true  
  
  config.vm.provision "shell", inline: <<-SHELL
    wget https://apt.puppetlabs.com/puppet5-release-$(lsb_release -cs).deb
    dpkg -i puppet5-release-$(lsb_release -cs).deb
    apt-get -qq update
    apt-get install -y puppet-agent
  SHELL

  machines = 2.times.map{ |i| "app#{i}" }
  
  machines.each_index do |idx|
    ip="10.0.5.#{idx+10}"
    config.vm.define machines[idx] do |c|
      c.vm.hostname=machines[idx]
      c.vm.network :private_network, ip: ip
      
      c.vm.provision "shell", privileged: false, inline: <<-SHELL
        cp /vagrant/ssh/* ~/.ssh
        cat /vagrant/ssh/id_rsa.pub >> ~/.ssh/authorized_keys
      SHELL
      
      c.vm.provision :shell, inline: "echo Started #{machines[idx]}..."
      
      c.vm.provision :puppet do |p|
        p.environment_path="environments"
        p.environment = "test"
        p.manifests_path = "environments/test/manifests"        
        p.manifest_file = "base-hadoop.pp"
        p.options = "--debug --verbose"          
      end
    end
  end
    
  config.vm.define "master" , primary: true do |c|
    c.vm.hostname="master"
    c.vm.network :private_network, ip: "10.0.5.2"
    c.vm.provision :shell, inline: 'echo Started hadoop-master...'
    c.vm.provision :hostmanager
    
    c.vm.network :forwarded_port, guest: 9870, host: 50070 # NameNode web interface
    c.vm.network :forwarded_port, guest: 8088, host: 8088   # YARN web interface
    
    c.vm.provision :puppet do |p|
      p.environment_path="environments"
      p.environment = "test"
      p.manifests_path = "environments/test/manifests"
      p.manifest_file = "base-hadoop.pp"
      p.options = "--debug --verbose"
    end

    c.vm.provision "shell", run: "always" do |p|
      p.privileged=false
      p.inline= <<-SHELL
          source /home/shab/hadoop-common.sh      
          id
          start-dfs.sh
          start-yarn.sh
          wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1lHA__LfMEEuDQajciWqvGKlOTbx0gvPJ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1lHA__LfMEEuDQajciWqvGKlOTbx0gvPJ" -O file.zip && rm -rf /tmp/cookies.txt
          wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1aYiaralEKoX-BjhbM4Euwtjq398AJN2Z' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1aYiaralEKoX-BjhbM4Euwtjq398AJN2Z" -O mapreduce.jar && rm -rf /tmp/cookies.txt
          unzip file.zip
          wget ftp://custsrv1.bth.se/FTP/ClonyMcCloneface/Return-of-the-Jedi.tar.gz
          tar -xf Return-of-the-Jedi.tar.gz
          rm Return-of-the-Jedi.tar.gz
      SHELL
      
    end
  end
  
end
