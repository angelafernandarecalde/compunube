
#!/bin/bash
echo "Installing dependencies Consul ..."
cd /usr/bin

# Descargar y agregar la clave GPG de HashiCorp al almacén de claves
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
# Agregar el repositorio de HashiCorp al sources.list
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Actualizar y instalar Consul y net-tools
sudo apt update -y && sudo apt install consul -y
apt-get install net-tools -y

# Crear carpetas para scripts y configuración de Consul
sudo mkdir -p /etc/consul.d/scripts
sudo mkdir -p /var/consul
sudo mkdir -p /etc/consul.d/client

echo "Consul Key Generator"