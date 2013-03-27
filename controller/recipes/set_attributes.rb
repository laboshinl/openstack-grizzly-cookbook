# Get the name of the public interface
node.set[:controller][:public_iface]=%x[ip a | awk '/#{node[:controller][:public_ip]}/ { print $7 }'][0..-2]

