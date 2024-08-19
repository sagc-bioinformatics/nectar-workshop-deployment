# Provision image with Openstack CLI


Scripts for setting up workshop images using cloud-init and nectar's openstack cli

Note: This won't run on SAHMRI network due to firewall.

You could I suppose set up a "nectar head node" which could be used to provision the others.


## Install the cli tool

```
# Create a virtual env
python -m venv env
source env/bin/activate

# install requirements
pip install python-openstack
pip install python-heatclient

# get this from the nectar gui
source SAGC-DataViz-openrc.sh 
```


## Manage stack

https://docs.openstack.org/newton/user-guide/cli-create-and-manage-stacks.html

https://tutorials.rc.nectar.org.au/orchestration/04-using-the-cli



## Creation

```

openstack stack create --template workshop-init.yml --parameter key_name=john_workstation workshop

openstack stack show workshop

# extract IP address
openstack stack resource list workshop1 --format csv | grep OS::Nova::Server | cut -d, -f2 | xargs -I {} openstack server show {} -f value -c addresses

# IPs, with a servergroup
openstack stack resource show newstack server_group -f value -c physical_resource_id | xargs -I {} openstack stack resource list {} --format csv | grep OS::Nova::Server | cut -d, -f2 | xargs -I {} openstack server show {} -f value -c addresses


# delete
openstack stack delete workshop1

```

# Snapshot creation

`openstack server image create myInstance --name myInstanceSnapshot`



# conda

wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

bash Miniforge3-$(uname)-$(uname -m).sh -b -p /home/user/.miniforge3

`cd ~/.local/bin && ln -s ~/.miniforge3/bin/mamba .`
