# INFO branch kernel for X01BD
* <a href="https://github.com/ZyCromerZ/android_kernel_asus_X01BD_old/tree/20200911/qk-ul"> QuantumKiller-uL Kernel Source </a>
* <a href="https://github.com/ZyCromerZ/android_kernel_asus_X01BD_old/tree/20200911/qk-l"> QuantumKiller-L Kernel Source </a>
* <a href="https://github.com/ZyCromerZ/android_kernel_asus_X01BD_old/tree/20200911/qk-n"> QuantumKiller-N Kernel Source </a>

# INFO kernel
* P = Kernel for Android 9 (Pie) ROMs
* Q = Kernel for Android 10 (Q) ROMs
* uL = 1.95 Ghz CPU + 585 MHz GPU Kernel + Undervolted (for battery backup, same as L but more underclock by default)
* L = 2.2 GHz CPU + 585 MHz GPU Kernel + Undervolted (for battery backup)
* N = 2.2 GHz CPU + 585 MHz GPU Kernel + No Undervolt (for balanced)
* 60 Hz, 65 Hz, 71 Hz = Refresh rate variants of same kernel. 
* DeathFLower-Fischl = 2.2Ghz CPU + 585Mhz GPU kernel + No Undervolt (N performance version)
* DeathFLower-Mona = 2.2Ghz CPU + 750z GPU kernel + No Undervolt (for more performance)
# Notes
* (60 Hz & 65 Hz is supported by almost all display panels. So, you can use as per your choice. 71 Hz is supported by very less display panels and you might get freeze issues. If you get freeze issues on 71 Hz kernel then switch to 60/65 Hz kernel. More refresh rate means more smoothness and more battery usage)
* DTC, GCC, Stormbreaker, Avalon, Proton etc. are different tools to compile kernels, you can find more about them by Google Search. Which one is better? - Try them and find out yourself.
* If you are getting issues like freeze, random shutdown, random reboot with UV kernels like 'uL' & 'L' version then don't use these kernels. Instead use 'N' version.
* open <a href="https://github.com/ZyCromerZ/android_kernel_asus_X01BD_old/blob/changelogs/X01BD.MD">X01BD.MD</a> to see changelogs
* open <a href="https://github.com/ZyCromerZ/android_kernel_asus_X01BD_old/blob/changelogs/download.MD">download.MD</a> to see all download links for stable build
* <a href="https://github.com/ZyCromerZ/android_kernel_asus_X01BD_old/commit/ad37d3e8088a6fbbcce5d9b622688bf1fbe615d2">revert this commits</a> to fix wifi not working for Android 9 custom roms