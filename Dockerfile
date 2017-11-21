    # CUDA 8.0
    #
    # VERSION               0.0.1

    FROM      nvidia/cuda:9.0-devel-ubuntu16.04
    LABEL     maintainer="allen7575@gmail.com"

    ##
    ## Ubuntu - Packages - Search
    ## https://packages.ubuntu.com/search?suite=xenial&section=all&arch=amd64&searchon=contents&keywords=Search
    ##
    
    ###
    ### solve for
    ### >>> WARNING - libGL.so not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ### >>> WARNING - libX11.so not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ### >>> WARNING - Xlib.h not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ### >>> WARNING - gl.h not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ###
    ### 2_Graphics/volumeFiltering
    ### 2_Graphics/simpleGL
    ### 2_Graphics/bindlessTexture
    ### 2_Graphics/volumeRender
    ### 2_Graphics/Mandelbrot
    ### 2_Graphics/marchingCubes
    ### 2_Graphics/simpleTexture3D
    ### 3_Imaging/imageDenoising
    ### 3_Imaging/recursiveGaussian
    ### 3_Imaging/simpleCUDA2GL
    ### 3_Imaging/postProcessGL
    ### 3_Imaging/bicubicTexture
    ### 3_Imaging/boxFilter
    ### 3_Imaging/SobelFilter
    ### 3_Imaging/cudaDecodeGL
    ### 3_Imaging/bilateralFilter
    ### 5_Simulations/particles
    ### 5_Simulations/smokeParticles
    ### 5_Simulations/oceanFFT
    ### 5_Simulations/fluidsGL
    ### 5_Simulations/nbody
    ### 6_Advanced/FunctionPointers
    ### 7_CUDALibraries/randomFog
    ###
    RUN apt update && apt -y install libgl1-mesa-dev

    ###
    ### solve for
    ### >>> WARNING - libGLU.so not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ### >>> WARNING - glu.h not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ### 
    RUN apt update && apt -y install libglu1-mesa-dev

    ###
    ### solve for
    ### /usr/bin/ld: cannot find -lglut
    ### https://stackoverflow.com/questions/15064159/usr-bin-ld-cannot-find-lglut
    ###
    RUN apt update && apt -y install freeglut3-dev

    ### 
    ### solve for
    ### >>> WARNING - egl.h not found, please install egl.h <<<
    ### >>> WARNING - eglext.h not found, please install eglext.h <<<
    ### >>> WARNING - gl31.h not found, please install gl31.h <<<
    ###
    ### 2_Graphics/simpleGLES_EGLOutput
    ### 2_Graphics/simpleGLES
    ### 2_Graphics/simpleGLES_screen
    ### 5_Simulations/nbody_opengles
    ### 5_Simulations/fluidsGLES
    ### 5_Simulations/nbody_screen
    ###
    RUN apt update && apt -y install libgles2-mesa-dev


    ###
    ### You should also search 'UBUNTU_PKG_NAME = "nvidia-367"' and replace it to 'UBUNTU_PKG_NAME = "nvidia"' 
    ### for all matched files in the NVIDIA_CUDA-8.0_Samples folder to make it works.
    ###
    RUN mkdir /usr/lib/nvidia && \
        `### solve for  /usr/bin/ld: cannot find -lnvcuvid` \
        `### 3_Imaging/cudaDecodeGL` \
        ln -s /usr/local/nvidia/lib64/libnvcuvid.so.1 /usr/lib/nvidia/libnvcuvid.so && \
        `### solve for >>> WARNING - libEGL.so not found, please install libEGL.so <<<` \
        `### 3_Imaging/EGLStreams_CUDA_Interop `\
        ln -s /usr/local/nvidia/lib64/libEGL.so.1 /usr/lib/nvidia/libEGL.so && \
        `### solve for >>> WARNING - libGLES.so not found, please install libGLES.so <<<` \
        `### 2_Graphics/simpleGLES_EGLOutput` \
        `### 2_Graphics/simpleGLES` \
        `### 2_Graphics/simpleGLES_screen` \
        `### 5_Simulations/nbody_opengles` \
        `### 5_Simulations/fluidsGLES` \
        `### 5_Simulations/nbody_screen` \
        ln -s /usr/local/nvidia/lib64/libGLESv2_nvidia.so.2 /usr/lib/nvidia/libGLESv2.so


    ### install & start sshd server
    ### for ssh login & X11 forward use
    RUN apt update && apt -y install ssh

    ### enable ssh root login
    RUN sed -i "s/PermitRootLogin/# PermitRootLogin/g" /etc/ssh/sshd_config
    RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

    ### change password with username:password
    RUN echo root:root | chpasswd

    ### first start to preserve all SSH host keys
    RUN service ssh start
    
    ### install vim
    RUN apt update && apt -y install vim

    RUN apt update && apt -y install sshfs

    ###
    ### add nvcc PATH for ssh interactive
    ### unix - How do I set $PATH such that `ssh user@host command` works? - Stack Overflow 
    ### https://stackoverflow.com/questions/940533/how-do-i-set-path-such-that-ssh-userhost-command-works
    ###
    #RUN sed -i '/interactively/ i export PATH=$PATH:/usr/local/cuda-8.0/bin\n' /root/.bashrc

    ### Newby question to CUDA container and ssh · Issue #36 · NVIDIA/nvidia-docker 
    ### https://github.com/NVIDIA/nvidia-docker/issues/36
    RUN echo "export PATH=$PATH" >> /etc/profile && \
        echo "ldconfig" >> /etc/profile

    ### make dir for mount point use
    RUN mkdir ~/project2

    EXPOSE 22

    #ENTRYPOINT [ "/usr/sbin/sshd", "-d"]
    CMD    ["bash"]


