
#!/bin/bash
#Configuración servidor consul (backend Service 2)
# Este fragmento configura un agente Consul para el servicio backend 2.
#consul agent -node=agent-servidor2 -bind=192.168.100.8 -enable-script-checks=true -data-dir=/tmp/consul -config-dir=/etc/consul.d

echo "configurando dependencias servicio2"
#consul agent -node=agent-servidor2 -bind=192.168.100.8 -enable-script-checks=true -data-dir=/tmp/consul -config-dir=/etc/consul.d -retry-join "192.168.100.6" -retry-join "192.168.100.7" &
echo "configurando service discovery con consul"

# Copia los archivos de configuración necesarios para Consul en el modo cliente.
sudo cp --force /vagrant/provision/servicio2/config.json /etc/consul.d/client/
sudo cp --force /vagrant/provision/servicio2/consul-client.service /etc/systemd/system/
sudo chmod 777 /etc/systemd/system/consul-client.service

# Configura un servicio web en Consul y realiza una recarga para aplicar la configuración.
echo "web-service provision" 
sudo cp --force /vagrant/provision/servicio2/web-service.json /etc/consul.d/
consul reload

sudo systemctl daemon-reload
sudo systemctl enable consul-client
sudo systemctl start consul-client
sudo systemctl restart consul-client

# Instala Node.js y dependencias para el servicio web.
echo "configurando servicio web con NodeJS"  
sudo apt update -y && apt upgrade -y
apt-get install net-tools -y
# apt install apache2 -y
# systemctl enable apache2
# sudo cp --force /vagrant/provision/servicio2/index.html /var/www/html/index.html
# systemctl start apache2
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo apt install npm -y
sudo cp --force /vagrant/provision/servicio2/app/index.js /home/vagrant/ 
npm install consul
npm install express

# Correr ninguna pagina web en puerto 3000 por default ip 192.168.100.8:3000
# Ejecuta la aplicación web en el puerto 3000 y en segundo plano.
# También proporciona comentarios sobre cómo probar el equilibrador de carga en diferentes puertos.
node index.js 3000 &
# Para correr y evaluar load balancer correr en solicitudes en servicio 2 
#node index.js 3001 &
#node index.js 3002 &
#node index.js 3003 &
#node index.js 3004 &

# kill process based on PID 
# sudo fuser 3000/tcp # port by default
# sudo kill 3000