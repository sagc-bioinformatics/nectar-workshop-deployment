# Add Termuin repository
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb noble main" | tee /etc/apt/sources.list.d/adoptium.list > /dev/null

# Update package lists
apt update

# Install Termuin
apt install -y temurin-21-jdk

# Create local bin
su - user -c "mkdir -p ~/.local/bin"

su - user -c 'bash -s' <<'EOF'

# Install Nextflow
cd /home/user/.local/bin && curl -s https://get.nextflow.io | bash
nextflow info

# Install conda/mamba (miniforge)
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p /home/user/.miniforge3
rm Miniforge3-$(uname)-$(uname -m).sh
cd ~/.local/bin && ln -s ~/.miniforge3/bin/mamba . && ln -s ~/.miniforge3/bin/conda .
mamba init && conda init && conda config --set auto_activate_base false

# Create snakemake env, and link to the executable
mamba create -y -c conda-forge -c bioconda -n snakemake snakemake
cd ~/.local/bin && ln -s ~/.miniforge3/envs/snakemake/bin/snakemake .

# Get data
cd
git clone https://github.com/snakemake/snakemake-tutorial-data.git
mv snakemake-tutorial-data/data/ .
rm -rf snakemake-tutorial-data

# Get bash script and some conf files
git clone https://github.com/sagc-bioinformatics/nextflow-example-workflow-2024.git
mv nextflow-example-workflow-2024/assets bash
rm -rf nextflow-example-workflow-2024

EOF
