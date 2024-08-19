# Create a virtual env
python -m venv env
source env/bin/activate

# install requirements
pip install python-openstackclient
pip install python-heatclient

# get this from the nectar gui
source SAGC-DataViz-openrc.sh
