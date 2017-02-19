vagrant-aws-route53
===============

A Vagrant plugin assigns the public IP of the instance which vagrant-aws provider created to a specific Route 53 record set. 

### Assigns the IP / the public DNS name when (A record / CNAME record)

* initial ```vagrant up```
* ```vagrant up``` the halted instance. 

### Assigns 0.0.0.0 when

* ```vagrant halt```
* ```vagrant destroy```

### does not

* creates another hosted zone or record set.
* destroys hosted zone or record set.

## Prerequisite

* vagrant-aws

## Install

```zsh
$ vagrant install vagrant-aws-route53
```

## Record Set Options

* %w(test.oogatta.com. A) - uses public IP of EC2 Instance 
* %w(test.oogatta.com. CNAME) - uses public DNS name of EC2 Instance (within AWS datacenter points to internal IP, otherwise to public IP)

## Config

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box       = 'dummy'
  config.ssh.username = 'oogatta'

  config.vm.provider :aws do |aws, override|
    aws.ami                       = 'ami'
    aws.access_key_id             = 'key_id'
    aws.secret_access_key         = 'secret_key'
    aws.region                    = 'ap-northeast-1'
    aws.instance_type             = 't2.medium'

    override.route53.hosted_zone_id = 'Z1JUXXXXXXXXXX'
    override.route53.record_set     = %w(test.oogatta.com. A)
  end

end
```
