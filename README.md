# Provision image with Openstack CLI

Scripts for setting up workshop images using cloud-init and nectar's openstack cli

Note: This won't run on SAHMRI network due to firewall.

You could I suppose set up a "nectar head node" which could be used to provision the others.


## Install / activate openstack environment

You need to download the OpenStack RC File from the Nectar dashboard before running this.

```
source sourceme.sh
```

## Set up template instance

This instance will run the setup.sh script via cloud-init.
It will probably take a little while, but all requirements for the workshop will be installed.
(Look at logs on nectar to be sure that everything is complte)

```
openstack stack create --template template.yml \
    --parameter key_name=john_workstation \
    --parameter flavor=m3.small \
    workshop-template
```

## Do any custom modifications of the instance

Anything you do here will be copied to the final instance, so set it up however you want.

```
# Extract IP address of instance
openstack stack resource list workshop-template --format csv | grep OS::Nova::Server | cut -d, -f2 | xargs -I {} openstack server show {} -f value -c addresses
```

I'm assuming space will be at a premium, so I clean up a lot of stuff:
```
sudo apt remove linux-firmware
sudo apt autoremove
sudo apt autoclean
sudo apt clean
conda clean --all
```

You can also edit /etc/motd..

## Snapshot template-instance

A snapshot will save a qcow2 image of this instance that can then be used to spin up
multiple other instances. Saving this takes a while.

```
openstack server image create workshop-template --name workshop-image
```

## Start the workshop stack

The password is provided by this command. The user name is "user".

```
openstack stack create --template multi-instance.yml \
    --parameter key_name=john_workstation \
    --parameter password=mySecurePassword \
    --parameter image=workshop-image \
    --parameter flavor=m3.small \
    --parameter server_count=10 \
    workshop
```

Extract IP addresses for entire group:
```
openstack stack resource show workshop server_group -f value -c physical_resource_id | xargs -I {} openstack stack resource list {} --format csv | grep OS::Nova::Server | cut -d, -f2 | xargs -I {} openstack server show {} -f value -c addresses
```

Delete entire stack:
```
openstack stack delete workshop
```

## Other links for management

https://docs.openstack.org/newton/user-guide/cli-create-and-manage-stacks.html

https://tutorials.rc.nectar.org.au/orchestration/04-using-the-cli


# TODO

- should use my laptop public key...
