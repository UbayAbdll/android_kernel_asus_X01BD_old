#! /bin/bash

 # Script For Building Android Kernel
 #
 # Copyright (c) 2020 ZyCromerZ <neetroid97@gmail.com>
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #      http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 #

# Function to show an informational message
# need to defined
# - branch
# - spectrumFile
# Then call CompileKernel and done

getInfo() {
    echo -e "\e[1;32m$*\e[0m"
}

getInfoErr() {
    echo -e "\e[1;41m$*\e[0m"
}

mainDir=$PWD

kernelDir=$mainDir

clangDir=$mainDir/clang

gcc64Dir=$mainDir/gcc64

gcc32Dir=$mainDir/gcc32

AnykernelDir=$mainDir/Anykernel3

# SpectrumDir=$mainDir/Spectrum

DoInitial(){
    getInfo ">> cloning clang . . . <<"
    git clone https://github.com/NusantaraDevs/DragonTC -b 10.0 $clangDir --depth=1
    getInfo ">> cloning gcc64 . . . <<"
    git clone https://github.com/ZyCromerZ/aarch64-linux-android-4.9/ -b android-10.0.0_r47 $gcc64Dir --depth=1
    getInfo ">> cloning gcc32 . . . <<"
    git clone https://github.com/ZyCromerZ/arm-linux-androideabi-4.9/ -b android-10.0.0_r47 $gcc32Dir --depth=1
    getInfo ">> cloning Anykernel . . . <<"
    git clone https://github.com/ZyCromerZ/AnyKernel3 -b master $AnykernelDir --depth=1
    # getInfo ">> cloning Spectrum . . . <<"
    # git clone https://github.com/ZyCromerZ/Spectrum -b master $SpectrumDir --depth=1
    
    DEVICE="Asus Max Pro M2"
    CODENAME="X01BD"
    SaveChatID="-1001205448228" ## group save kernel files
    ARCH="arm64"
    TypeBuild="Stable"
    DEFFCONFIG="X01BD_defconfig"
    GetBD=$(date +"%m%d")
    GetCBD=$(date +"%Y-%m-%d")
    TotalCores=$(nproc --all)
    TypeBuildTag="AOSP"
    SendInfo='belum'
    SetTag="LA.UM.8.2.r1"
    SetLastTag="sdm660.0"
    export KBUILD_BUILD_USER="ZyCromerZ"
    if [ ! -z "$DRONE_BUILD_NUMBER" ];then
        export KBUILD_BUILD_VERSION=$DRONE_BUILD_NUMBER
        export KBUILD_BUILD_HOST="DroneCI-server"
    else
        export KBUILD_BUILD_HOST="Another-server"
    fi
    ClangType="$($clangDir/bin/clang --version | head -n 1)"
    KBUILD_COMPILER_STRING="$ClangType"
    if [ -e $gcc64Dir/bin/aarch64-linux-android-gcc ];then
        gcc64Type="$($gcc64Dir/bin/aarch64-linux-android-gcc --version | head -n 1)"
    else
        cd $gcc64Dir
        gcc64Type=$(git log --pretty=format:'%h: %s' -n1)
        cd $mainDir
    fi
    if [ -e $gcc32Dir/bin/arm-linux-androideabi-gcc ];then
        gcc32Type="$($gcc32Dir/bin/arm-linux-androideabi-gcc --version | head -n 1)"
    else
        cd $gcc32Dir
        gcc32Type=$(git log --pretty=format:'%h: %s' -n1)
        cd $mainDir
    fi
    cd $kernelDir
    KVer=$(make kernelversion)
    HeadCommitId=$(git log --pretty=format:'%h' -n1)
    HeadCommitMsg=$(git log --pretty=format:'%s' -n1)
    cd $mainDir
}

tg_send_info(){
    # group to send kernel build status
    if [ ! -z "$2" ];then
        curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$2" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="$1"
    else
        curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="-1001205448228" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="$1"
    fi
}

tg_send_files(){
    # group to send kernel files
    KernelFiles="$(pwd)/$RealZipName"
	MD5CHECK=$(md5sum "$KernelFiles" | cut -d' ' -f1)
    MSG="✅ <b>Build Success</b> 
- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s) </code> 

<b>MD5 Checksum</b>
- <code>$MD5CHECK</code>

<b>Zip Name</b> 
- <code>$ZipName</code>"

	curl --progress-bar -F document=@"$KernelFiles" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
	-F chat_id="$SaveChatID"  \
	-F "disable_web_page_preview=true" \
	-F "parse_mode=html" \
	-F caption="$MSG"


    if [ ! -z "$1" ];then
        tg_send_info "$MSG" "$1"
    else
        tg_send_info "$MSG"
    fi
    # remove files after build done
    rm -rf $KernelFiles
}

CompileKernel(){
    cd $kernelDir
    export KBUILD_COMPILER_STRING
    MAKE+=(
            ARCH=$ARCH \
            SUBARCH=$ARCH \
            PATH=$clangDir/bin:$gcc64Dir/bin/:$gcc32Dir/bin/:/usr/bin:${PATH} \
            CC=clang \
            CROSS_COMPILE=aarch64-linux-android- \
            CROSS_COMPILE_ARM32=arm-linux-androideabi- \
            CLANG_TRIPLE=aarch64-linux-gnu-
    )
    # rm -rf out # always remove out directory :V
    BUILD_START=$(date +"%s")
    if [ "$SendInfo" != 'sudah' ];then
        MSG="<b>🔨 New Kernel On The Way</b>%0A<b>Device: $DEVICE</b>%0A<b>Codename: $CODENAME</b>%0A<b>Branch: $branch</b>%0A<b>Build Date: $GetCBD </b>%0A<b>Host Core Count : $TotalCores cores </b>%0A<b>Kernel Version: $KVer</b>%0A<b>Last Commit-Id: $HeadCommitId </b>%0A<b>Last Commit-Message: $HeadCommitMsg </b>%0A<b>Builder Info: </b>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A<code>- $ClangType </code>%0A<code>- $gcc64Type </code>%0A<code>- $gcc32Type </code>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A%0A #$TypeBuildTag  #$TypeBuild"
        if [ ! -z "$1" ];then
            tg_send_info "$MSG" "$1"
        else
            tg_send_info "$MSG" 
        fi
        SendInfo='sudah'
    fi
    LastHeadCommitId=$(git log --pretty=format:'%h' -n1)
    make -j${TotalCores}  O=out ARCH="$ARCH" "$DEFFCONFIG"
    make -j${TotalCores}  O=out \
        ARCH=$ARCH \
        SUBARCH=$ARCH \
        PATH=$clangDir/bin:$gcc64Dir/bin/:$gcc32Dir/bin/:/usr/bin:${PATH} \
        CC=clang \
        CROSS_COMPILE=aarch64-linux-android- \
        CROSS_COMPILE_ARM32=arm-linux-androideabi- \
        CLANG_TRIPLE=aarch64-linux-gnu-
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [ -f $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb ];then
        cp -af $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb $AnykernelDir
        KName=$(cat "$(pwd)/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
        if [ $TypeBuild == "Stable" ];then
            ZipName="[DTC][$GetBD][$CODENAME]$KVer-$KName-$LastHeadCommitId.zip"
        else
            ZipName="[DTC][$GetBD][$TypeBuild][$CODENAME]$KVer-$KName-$LastHeadCommitId.zip"
        fi
        # RealZipName="[$GetBD]$KVer-$HeadCommitId.zip"
        RealZipName="$ZipName"
        if [ ! -z "$2" ];then
            MakeZip "$2"
        else
            MakeZip
        fi
    else
        MSG="<b>❌ Build failed</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        if [ ! -z "$2" ];then
            tg_send_info "$MSG" "$2"
        else
            tg_send_info "$MSG" 
        fi
        exit -1
    fi
}

CompileKernelGcc(){
    cd $kernelDir
    export KBUILD_COMPILER_STRING
    MAKE+=(
            ARCH=$ARCH \
            SUBARCH=$ARCH \
            PATH=$gcc64Dir/bin/:$gcc32Dir/bin/:/usr/bin:${PATH} \
            CROSS_COMPILE=aarch64-linux-android- \
            CROSS_COMPILE_ARM32=arm-linux-androideabi-
    )
    # rm -rf out # always remove out directory :V
    BUILD_START=$(date +"%s")
    if [ "$SendInfo" != 'sudah' ];then
        MSG="<b>🔨 New Kernel On The Way</b>%0A<b>Device: $DEVICE</b>%0A<b>Codename: $CODENAME</b>%0A<b>Branch: $branch</b>%0A<b>Build Date: $GetCBD </b>%0A<b>Build Number: $DRONE_BUILD_NUMBER </b>%0A<b>Build Link Progress:</b><a href='https://cloud.drone.io/NEETroid/droneci-builder/$DRONE_BUILD_NUMBER/1/2'> Check Here </a>%0A<b>Host Core Count : $TotalCores cores </b>%0A<b>Kernel Version: $KVer</b>%0A<b>Last Commit-Id: $HeadCommitId </b>%0A<b>Last Commit-Message: $HeadCommitMsg </b>%0A<b>Builder Info: </b>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A<code>- $gcc64Type </code>%0A<code>- $gcc32Type </code>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A%0A #$TypeBuildTag  #$TypeBuild"
        if [ ! -z "$1" ];then
            tg_send_info "$MSG" "$1"
        else
            tg_send_info "$MSG" 
        fi
        SendInfo='sudah'
    fi

    LastHeadCommitId=$(git log --pretty=format:'%h' -n1)
    make -j${TotalCores}  O=out ARCH="$ARCH" "$DEFFCONFIG"
    make -j${TotalCores}  O=out \
        ARCH=$ARCH \
        SUBARCH=$ARCH \
        PATH=$clangDir/bin:$gcc64Dir/bin/:$gcc32Dir/bin/:/usr/bin:${PATH} \
        CROSS_COMPILE=aarch64-linux-android- \
        CROSS_COMPILE_ARM32=arm-linux-androideabi-
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [ -f $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb ];then
        cp -af $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb $AnykernelDir
        KName=$(cat "$(pwd)/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
        if [ $TypeBuild == "Stable" ];then
            ZipName="[GCC][$GetBD][$KernelFor][$CODENAME]$KVer-$KName-$LastHeadCommitId.zip"
        else
            ZipName="[GCC][$GetBD][$KernelFor][$TypeBuild][$CODENAME]$KVer-$KName-$LastHeadCommitId.zip"
        fi
        # RealZipName="[$GetBD]$KVer-$HeadCommitId.zip"
        RealZipName="$ZipName"
        if [ ! -z "$2" ];then
            MakeZip "$2"
        else
            MakeZip
        fi
    else
        MSG="<b>❌ Build failed</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        if [ ! -z "$2" ];then
            tg_send_info "$MSG" "$2"
        else
            tg_send_info "$MSG" 
        fi
        exit -1
    fi
}


MakeZip(){
    cd $AnykernelDir
    # if [ ! -z "$spectrumFile" ];then
    #     cp -af $SpectrumDir/$spectrumFile init.spectrum.rc && sed -i "s/persist.spectrum.kernel.*/persist.spectrum.kernel $KName/g" init.spectrum.rc
    # fi
    # cp -af anykernel-real.sh anykernel.sh && sed -i "s/kernel.string=.*/kernel.string=$KName-$HeadCommitId by ZyCromerZ/g" anykernel.sh

    zip -r9 "$RealZipName" * -x .git README.md anykernel-real.sh .gitignore *.zip
    if [ ! -z "$1" ];then
        tg_send_files "$1"
    else
        tg_send_files
    fi

}
