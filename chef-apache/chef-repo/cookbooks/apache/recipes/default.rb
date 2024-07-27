# Receta/cookbook
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2024, The Authors, All Rights Reserved.

apt_update "Update the apt cache daily" do # recurso tipo apt_update encargado de refrescar la cache del gestor de paquetes
  frequency 86400 # Acción periódica que se repetirá cada 86400 seg. (1 dia)
  action :periodic # Acción que indica que si la linea anterior no se ha realizado hace al menos 1 día, se volverá a ejecutar
end

package 'apache2' # Indica a chef que el paquete apache2 debe estar instalado - acción por defecto

service 'apache2' do # Se inidica nombre del servicio 'apache2'
  supports :status => true # support inidica el estado del servicio mediante el sistema operativo
  action :nothing # Action con valor 'nothing' indica que no se haga nada cuando chef lea el recurso
end

# Primer recurso
# Tipo file - nos permite gestionar los ficheros del nodo
file '/etc/apache2/sites-enabled/000-default.conf' do # recurso tipo file 'ruta especificada'
  action :delete # Argumento action indica si deseamos borrar el fichero
end


# Segundo recurso
# Tipo template - nos permite procesar una plantilla del servidor y guardarla el fichero en la ruta especificada
template '/etc/apache2/sites-available/vagrant.conf' do # Recurso template 'ruta especificada'
  source 'virtual-hosts.conf.erb' # Source proporciona ruta de la plantilla a utilizar - Plantilla .erb indica formato de plantilla en Ruby
  notifies :restart, resources(:service => "apache2") # notifies notificara los cambios producidos y provocara que los recargue la conf. de apache
end

# Tercer recurso
# Tipo link - Genera enlace simbólico en la máquina destino 
link '/etc/apache2/sites-enabled/vagrant.conf' do # Genera enlace simbólico indicando la ruta del enlace a crear
  to '/etc/apache2/sites-available/vagrant.conf' # To indica el fichero a enlazar
  notifies :restart, resources(:service => "apache2") # notifies notificara los cambios producidos y provocara que los recargue la conf. de apache
end

# Cuarto Recurso
# Tipo cookbook_file - Permite copiar un fichero desde el directorio cookbook al nodo
#cookbook_file "/vagrant/index.html" do # Cookbook_file copia el recurso en la ruta partiendo del directorio files a la ruta especificada
#  source 'index.html' # Soruce proporciona la ruta del fichero a utilizar
#  only_if do # condiciona la ejecucion del recurso para que se cumpla la condición
#    File.exist?('/etc/apache2/sites-enabled/vagrant.conf') # pregunta por la existencia del fichero que debería ser creado anteriormente
    # Utiliza /vagrant como destino del fichero index.html que hemos copiado
#  end
#end

# Tambien se puede definir una variable como atributo que se pueda referir desde ambos sitios
# Ejemplo....

# default['apache']['documen_root'] = "/vagrant" # Define atributo tipo default

# Ejemplo de attributes/default.rb
 cookbook_file "#{node['apahe']['document_root']}/index.html" do # Cookbook_file copia el recurso en la ruta partiendo del directorio files a la ruta especificad
   source 'index.html' # Soruce proporciona la ruta del fichero a utilizar
   only_if do # condiciona la ejecucion del recurso para que se cumpla la condición
     File.exist?('/etc/apache2/sites-enabled/vagrant.conf') # pregunta por la existencia del fichero que debería ser creado anteriormente
    # Utiliza /vagrant como destino del fichero index.html que hemos copiado
   end
 end

include_recipe '::facts' # incluye el contenido creado en el fichero facts.rb
