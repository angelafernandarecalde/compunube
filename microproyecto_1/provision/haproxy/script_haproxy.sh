
#!/bin/bash
#Configuración servidor consul (frontend Haproxy)
#consul agent with user interface, devolper mode, server(leader)

# Este fragmento configura un agente Consul con interfaz de usuario,
# modo de desarrollo y configuración de servidor (líder).

echo "configurando dependencias haproxy"
#consul agent -ui -dev -server -bootstrap-expect=1 -node=agent-haproxy -bind=192.168.100.6 -http-addr=0.0.0.0:8500 -client=0.0.0.0 -data-dir=/tmp/consul -config-dir=/etc/consul.d -enable-script-checks=true -retry-join "192.168.100.7" -retry-join "192.168.100.8" &

echo "configurando service discovery con consul"
# Copia los archivos de configuración necesarios para Consul.
# Estos archivos definen configuraciones específicas para el servicio haproxy.
sudo cp --force /vagrant/provision/haproxy/config.json /etc/consul.d/
sudo cp --force /vagrant/provision/haproxy/consul.service /etc/systemd/system/
sudo chmod 777 /etc/systemd/system/consul.service

# Configura un servicio web en Consul y realiza una recarga para aplicar la configuración.
echo "web-service provision" 
sudo cp --force /vagrant/provision/haproxy/web-service.json /etc/consul.d/
consul reload

# Recarga servicios del sistema y habilita y arranca el servicio Consul.
sudo systemctl daemon-reload
sudo systemctl daemon-reload
sudo systemctl enable consul.service
sudo systemctl start consul.service
sudo systemctl restart consul.service

# Actualiza el sistema, instala herramientas de red y haproxy
echo "configurando haproxy" 
sudo apt update -y && apt upgrade -y
apt-get install net-tools -y
sudo apt install haproxy -y

#  Configura un error especifico del haproxy.
echo "configurando error modificado" 
sudo cp --force /vagrant/provision/haproxy/503.http /etc/haproxy/errors/

# Habilitar y configurar el haproxy, y reiniciarlo
sudo systemctl enable haproxy
sudo cp --force /vagrant/provision/haproxy/haproxy.cfg /etc/haproxy/
sudo systemctl restart haproxy
sudo systemctl start haproxy

echo "finalizacion provision" 

echo "Artillery"
## Pruebas Load Balancer con Artillery
# Instalar Node.js y la herramienta de prueba de carga Artillery.
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo apt install npm -y
sudo npm install -g artillery@latest
# Test Load Balancer Artillery 5 Escenarios
#artillery quick --count 10 -n 20 http://192.168.100.6/

##Escenario de Carga Baja:
# Prueba 10 solicitudes en total.
# 2 solicitudes concurrentes por prueba.
# Velocidad de solicitud: 1 solicitud por segundo.
# artillery quick --count 10 -n 2 -r 1 http://192.168.100.6/

## Escenario de Carga Moderada:
# Prueba 20 solicitudes en total.
# 5 solicitudes concurrentes por prueba.
# Velocidad de solicitud: 5 solicitudes por segundo.
# artillery quick --count 20 -n 5 -r 5 http://192.168.100.6/

## Escenario de Carga Alta:
# Prueba 50 solicitudes en total.
# 10 solicitudes concurrentes por prueba.
# Velocidad de solicitud: 10 solicitudes por segundo.
# artillery quick --count 50 -n 10 -r 10 http://192.168.100.6/

# Escenario de Prueba Intensiva:
# Prueba 100 solicitudes en total.
# 20 solicitudes concurrentes por prueba.
# Velocidad de solicitud: 15 solicitudes por segundo.
# artillery quick --count 100 -n 20 -r 15 http://192.168.100.6/

# Escenario de Estrés:
# Prueba 200 solicitudes en total.
# 30 solicitudes concurrentes por prueba.
# Velocidad de solicitud: 20 solicitudes por segundo.
# artillery quick --count 200 -n 30 -r 20 http://192.168.100.6/
