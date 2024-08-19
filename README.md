
Scripts for setting up workshop images using cloud-init and nectar's openstack cli

This doesn't seem to work from SAHMRI. As usual everything useful is blocked.

You could I suppose set up a "nectar head node" which could be used to provision the others, I suppose.

Let's actually do that. It'll make it easier for others to help out.

```
python -m venv env
source env/bin/activate

pip install python-openstack
pip install python-heatclient

source SAGC-DataViz-openrc.sh # get this from the nectar gui
```


# Get image

https://docs.openstack.org/heat/train/getting_started/create_a_stack.html

# Manage stack

https://docs.openstack.org/newton/user-guide/cli-create-and-manage-stacks.html


# Setup

https://tutorials.rc.nectar.org.au/orchestration/04-using-the-cli



# Creation

```

openstack stack create --template workshop-init.yml --parameter key_name=john_workstation workshop1

openstack stack show workshop1

# extract IP address
openstack stack resource list workshop1 --format csv | grep OS::Nova::Server | cut -d, -f2 | xargs -I {} openstack server show {} -f value -c addresses

# IPs, with a servergroup
openstack stack resource show newstack server_group -f value -c physical_resource_id | xargs -I {} openstack stack resource list {} --format csv | grep OS::Nova::Server | cut -d, -f2 | xargs -I {} openstack server show {} -f value -c addresses



# delete
openstack stack delete workshop1

```

