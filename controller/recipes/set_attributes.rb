# Get the name of the largest Volume Group
node.set[:volume_group][:name]=%x[vgs --sort -size --rows | grep VG -m 1 | awk '{print $2}'][0..-2]
