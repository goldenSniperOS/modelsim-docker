FROM centos:7

LABEL mantainer="Adrian Ruiz aerf2007@gmail.com"

ARG version_modelsim="16.0"
ARG build_modelsim="211"
ARG bin_modelsim="ModelSimSetup-${version_modelsim}.0.${build_modelsim}-linux.run"
ARG url_donwload_modelsim="http://download.altera.com/akdlm/software/acdsinst/${version_modelsim}/${build_modelsim}/ib_installers/${bin_modelsim}"
ARG path_install_modelsim="/tmp"

ENV PATH="/vsim-ase/bin:${PATH}"

##Last Version 18
# http://download.altera.com/akdlm/software/acdsinst/18.1std/625/ib_installers/ModelSimSetup-18.1.0.625-linux.run

##Version 16
#http://download.altera.com/akdlm/software/acdsinst/16.0/211/ib_installers/ModelSimSetup-16.0.0.211-linux.run


# for modelsim
## modelsim's url ref : https://gist.github.com/zweed4u/ecc03ade1da8c51127a5485830d7a621
## installation process ref: https://fpga.kice.tokyo/design/centos7-modelsim

# Fedora 30
# RUN yum update -y && \
#   yum install -y glibc.i686 glibc-devel.i686 libX11.i686 unixODBC-devel.i686 unixODBC.i686 zeromq.i686 alsa-lib.i686 \
#   libxml2.i686 libedit.i686 libXi.i686 libX11.i686 libX11-devel.i686 libXext.i686 libXext-devel.i686 libXft.i686 \
#   libXft-devel.i686 libXau.i686 libXdmcp.i686 libXrender.i686 libXt.i686 libXtst.i686 wget libgcc.i686 bzip2 bzip2-libs gcc \
#   gcc-c++ libstdc++-devel.i686 ncurses-devel.i686 ncurses-compat-libs.i686 ncurses-libs.i686 automake firefox xauth make nano

# Ubuntu
# RUN apt-get update && \
#     apt-get install -y binutils libc6:i386 libncurses5:i386 libxtst6:i386 libxft2:i386 libc6:i386 libncurses5:i386 \
#     libstdc++6:i386 libc6-dev-i386 libxft2 lib32z1 lib32ncurses5 wget firefox xauth

# Centos 7
RUN yum update -y && \
    ## Install required packages
    yum install -y \
    glibc.i686 \
    glibc-devel.i686 \
    libX11-devel.i686 \
    libXext-devel.i686 \
    libXft-devel.i686 \
    ncurses-libs.i686 \
    wget \
    bzip2 \
    bzip2-libs \
    bzip2-devel.i686 \
    nano \
    xauth && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    ## Download And Install ModelSim
    wget --spider -nv --timeout 10 -t 1 ${url_donwload_modelsim} && \
    echo "Downloading ModelSim..." && \
    wget -c -nv -P ${path_install_modelsim}  ${url_donwload_modelsim} && \
    chmod a+x ${path_install_modelsim}/${bin_modelsim} && \
    echo "Installing ModelSim..." && \
    ## Version 16 Build 211 Setup
    ${path_install_modelsim}/${bin_modelsim} --mode unattended --installdir ${path_install_modelsim} --unattendedmodeui none && \
    ## Version 18 Build 625 Setup
    #${path_install_modelsim}/${bin_modelsim} --mode unattended --unattendedmodeui none --installdir ${path_install_modelsim} --accept_eula 1 && \
    ## for bug in ver.16.0
    cd ${path_install_modelsim}/modelsim_ase; ln -s linux linux_rh60 && rm -rf ${path_install_modelsim}/modelsim_ase/altera && \
    ## Test bin
    ${path_install_modelsim}/modelsim_ase/bin/vsim -c -version && echo "ModelSim has installed successflly" && \
    ## Freetype Libraries
    wget -c -P ${path_install_modelsim} https://dl.dries007.net/lib32-freetype2-2.5.0.1.tar.xz && \
    tar -xvf ${path_install_modelsim}/lib32-freetype2-2.5.0.1.tar.xz -C ${path_install_modelsim}/modelsim_ase && \
    ## Bug LibBZ
    ln -s /usr/lib/libbz2.so ${path_install_modelsim}/modelsim_ase/lib32/libbz2.so.1.0 && \
    ## Linking Lib32 on VSIM
    sed -i --follow-symlinks '/^dir=.*/a export LD_LIBRARY_PATH=${dir}\/lib32\/' ${path_install_modelsim}/modelsim_ase/bin/vsim && \
    ##Clean Image Size
    rm -f ${path_install_modelsim}/${bin_modelsim} && rm -f ${path_install_modelsim}/lib32-freetype2-2.5.0.1.tar.xz && \
    ## Adding to Path
    mv ${path_install_modelsim}/modelsim_ase /vsim-ase && vsim -c -version && echo "ModelSim configured successflly"

## Freetype Libs Compile
# RUN wget -c -P ${path_install_modelsim} http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.bz2
# RUN tar -xjvf ${path_install_modelsim}/freetype-2.4.12.tar.bz2 -C ${path_install_modelsim}
# RUN ${path_install_modelsim}/freetype-2.4.12/configure --build=i686-pc-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
# RUN cd ${path_install_modelsim}/freetype-2.4.12
# RUN make -j8
    
## Install FreeTypeLibs on ModelSim
# RUN mkdir ${path_install_modelsim}/modelsim_ase/lib32
# RUN cp ${path_install_modelsim}/freetype-2.4.12/objs/.libs/libfreetype.so* ${path_install_modelsim}/modelsim_ase/lib32 