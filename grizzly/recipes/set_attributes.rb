node.set[:controller][:public_iface]=%x[ip a | awk '/#{node[:controller][:public_ip]}/ { print $7 }'][0..-2]
node.set[:node][:private_ip]= (require 'socket'; UDPSocket.open {|s| s.connect(node[:controller][:private_ip], 1); s.addr.last})

