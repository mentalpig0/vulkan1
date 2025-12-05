# Vulkan1
Project from @mentalpig0

## installation
This are the step I followed to install the project.
Using Ubuntu on WSL 
```bash
# clone the repo
git clone https://github.com/mentalpig0/vulkan1.git
cd vulkan1
sudo apt-get install libglfw3-dev libglm-dev pkg-config libxxf86vm-dev libxi-dev vulkan-validationlayers vulkan-tools glslang-tools

# I also had to recompile the shaders for some reason, likely unneeded on linux proper
# glslangValidator -V frag.frag 
# glslangValidator -V vert.vert

# run make
make clean run
```
