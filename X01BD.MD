# -- 26-08-2020 --
* re-based again, u can <a href="https://github.com/ZyCromerZ/android_kernel_asus_X01BD_old/tree/rebase-20200825-initial">check this tree</a> if u want
* maybe fix battery temp issue (higher than real)
* wifi drivers kernel using from tags "LA.UM.7.2.r1-09100-sdm660.0" (from pie) to fix slow wifi speed
* added back all feature from previous kernel
* add new varian, Tercydux-Santuy and Tercydux-Hareudang
* build using proton and dtc

Notes:
* for new variant kernels <a href="https://github.com/ZyCromerZ/android_kernel_asus_X01BD_old/blob/changelogs/README.MD">check here</a> for more detail

# -- 01-08-2020 --
* upstream to 4.4.232
* upstream caf tags to LA.UM.8.2.r1-07100-sdm660.0
* re enable LD DEAD CODE DATA ELIMINATION

# -- 25-07-2020 --
* upstream to 4.4.231
* rebased kernel from @Rk585 kernel (many things like kernel drivers, NFC check support, brightness slider fix added from his kernel)
* Fixed brightness slider not working significantly from 0 to 50%
* Added back all features from previous kernels
* Added 'Speaker Gain' in sound tweaks (from @SonalSingh18 kernels)
* Added back my previous feature to kernels
