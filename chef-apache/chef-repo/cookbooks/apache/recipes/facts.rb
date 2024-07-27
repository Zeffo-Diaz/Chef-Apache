# Creacion de variables con Ohai
#log 'Showing machine Ohai attributes' do
#  message "Machine with #{node['memory']['total']} of memory and #{node['cpu']['total']}processor/s¸ \\nPlease check access to http://#{node[:network][:interfaces][:enp0s8][:addresses].detect{|k,v| v[:family] == 'inet'}.first}"
#end

# codigo mejorado

log 'Showing machine Ohai attributes' do
  message lazy { # message junto con lazy asegura que los atributos de node se evaluan en tiempo de ejecucion
    memory_total = node['memory']['total']  # cantidad de memoria disponible en la VM
    cpu_total = node['cpu']['total'] # Cantidad de cpu disponible en la VM
    ip_address = node[:network][:interfaces][:enp0s8][:addresses].detect { |k, v| v[:family] == 'inet' }.first
    # Direccion ip dentro de la VM que se accede mediente vagrant ssh y ohai
    
    "Machine with #{memory_total} of memory and #{cpu_total} processor/s\n" \
    "Please check access to http://#{ip_address}"
  }
  level :info
end
