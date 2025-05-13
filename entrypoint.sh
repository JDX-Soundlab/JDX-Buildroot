#!/bin/bash
#set -euxo pipefail

# Set locale to C.UTF-8
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

cat << "EOF"

Welcome to the JDX Buildroot Environment!

    /$$$$$ /$$$$$$$  /$$   /$$        /$$$$$$                                      /$$ /$$                 /$$      
   |__  $$| $$__  $$| $$  / $$       /$$__  $$                                    | $$| $$                | $$      
      | $$| $$  \ $$|  $$/ $$/      | $$  \__/  /$$$$$$  /$$   /$$ /$$$$$$$   /$$$$$$$| $$        /$$$$$$ | $$$$$$$ 
      | $$| $$  | $$ \  $$$$/       |  $$$$$$  /$$__  $$| $$  | $$| $$__  $$ /$$__  $$| $$       |____  $$| $$__  $$
 /$$  | $$| $$  | $$  >$$  $$        \____  $$| $$  \ $$| $$  | $$| $$  \ $$| $$  | $$| $$        /$$$$$$$| $$  \ $$
| $$  | $$| $$  | $$ /$$/\  $$       /$$  \ $$| $$  | $$| $$  | $$| $$  | $$| $$  | $$| $$       /$$__  $$| $$  | $$
|  $$$$$$/| $$$$$$$/| $$  \ $$      |  $$$$$$/|  $$$$$$/|  $$$$$$/| $$  | $$|  $$$$$$$| $$$$$$$$|  $$$$$$$| $$$$$$$/
 \______/ |_______/ |__/  |__/       \______/  \______/  \______/ |__/  |__/ \_______/|________/ \_______/|_______/ 

Bottom Text

EOF

while true; do
    read -p "Proceed with build? (y/n): " continue_build
    case ${continue_build^^} in
        [Y]*) 
            echo "Starting build process..."
            break
            ;;
        [N]*) 
            echo "Dropping to interactive shell..."
            exec /bin/bash -i  # Replace current process with interactive shell
            ;;
        *) 
            echo "y or n"
            ;;
    esac
done

# Update the kernel configuration
make olddefconfig

# Build Toolchain & Sources
echo "Building Toolchain..."
make toolchain
# echo "Building Sources.."
# make source

# Build Kernel
#echo "Building Kernel..."
#make V=2 linux

# Build RootFS
#echo "Building RootFS..."
make V=1 2>&1 | tee build.log

# Pre-Kernel Packaging Prereqs
echo "Preparing to Package Distroboot Kernel..."
ln -s output/images/Image kernel-pack/boot/Image
ln -s kernel-prereq/dts/rockchip/rk3399-firefly-aio-lvds.dtb kernel-pack/boot/rk3399-firefly-aio-lvds.dtb

# Package Kernel
echo "Packaging Kernel..."
cd kernel-pack/
genext2fs -b 32768 -B $((32*1024*1024/32768)) -d boot/ -i 8192 -U boot_rk3399.img
cd ..

# Create Symlinks for Rockdev
ln -s ./kernel-pack/boot_rk3399.img ./rockdev/Image/boot.img
ln -s ./output/images/rootfs.ext2 ./rockdev/Image/rootfs.ext4
ln -s ./output/images/rootfs.ext2 ./rockdev/Image/rootfs.img

# Package Bootloader
echo "Packaging Bootloader..."
cd output/images
mkimage -n rk3399 -T rksd -d u-boot-tpl.bin idbloader.img
mkimage -n rk3399 -T rksd -d u-boot-spl.bin idbspl.img


# Deploy the Steamhappy
echo "Deploying the Steamhappy..."
echo "                                                          
                               :+###*:                    
                    :--.     +#########=                  
                 =########: *###%%######*                 
                ############-** =# .#####*                
              .#####%:  =###*.  -+   #####                
              =####:=%    *##=       *####.               
              +####        ##*       #####.               
             *=####+       *##      ######-:              
           -#*=#####+     =##*-+*########.+**             
          =###*=#######*#####-++*######=-+**#*:           
         -*###**+*#*+-#####*::.=*##+:-==***###*:          
        .*############+..:-.....-+++*.**#######*          
        =#############*  #%%%%%%%+   ###########*:        
   ==-..#############*:       .      +###########=        
  *##############*++:                  .+*########.       
  .*****************.                  =**********-       
   :****************.                  ************       
    .=**************.                 .************-      
      +*************.                 +************=      
      +*************-    ::::::       +************+      
      =*************+  .::::::::.    :*************+      
      -++++++++++++++  ::::::::::.   ++++++++++++++=      
       ++++++++++++++.::::::::::::  -++++++++++++++-      
       -++++++++++++++.=:::::::::::.+++++++++++++++       
        =+++++++++++++=#+:::::::::.+++++++++++++++-       
        .=+++++++++++++::::-+-+#-.+++++++++++++++=        
          -+++++++++++++-:*%%%%=-+++++++++++++++=         
           .===============-.-=================-          
             .===============================-            
                -=========================-:              
                   .:=================-:.                 
                      :=====:.                            
                       .-==-.                             
                          .                               
                                                          
                                                          "

echo "Build complete. Dropping to interactive shell..."
exec /bin/bash -i # Replace current process with interactive shell

