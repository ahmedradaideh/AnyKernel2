#!/system/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

################################################################################

{

sleep 10

# Disable thermal hotplug to switch governor
write /sys/module/msm_thermal/core_control/enabled 0

# Set sync wakee policy tunable
write /proc/sys/kernel/sched_prefer_sync_wakee_to_waker 1

# Bring back main cores CPU 0,2
write /sys/devices/system/cpu/cpu0/online 1
write /sys/devices/system/cpu/cpu2/online 1

# Configure governor settings for little cluster
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "interactive"
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load 1
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif 1
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay 19000
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load 90
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate 20000
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq 960000
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy 1
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads 80
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time 19000
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis 79000
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 307200
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif 1
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/enable_prediction 1

# Configure governor settings for big cluster
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor "interactive"
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/use_sched_load 1
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/use_migration_notif 1
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/above_hispeed_delay "19000 1400000:39000 1700000:19000 2100000:79000"
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/go_hispeed_load 90
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_rate 20000
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/hispeed_freq 1248000
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/io_is_busy 1
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/target_loads "85 1500000:90 1800000:70 2100000:95"
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/min_sample_time 19000
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/max_freq_hysteresis 59000
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 307200
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/ignore_hispeed_on_notif 1
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/enable_prediction 1

# Re-enable thermal hotplug
write /sys/module/msm_thermal/core_control/enabled 1

# Configure governor for devfreq/kgsl
write /sys/class/devfreq/soc:qcom,cpubw/governor "bw_hwmon"
write /sys/class/kgsl/kgsl-3d0/devfreq/governor "msm-adreno-tz"

# Input boost configuration
write /sys/module/cpu_boost/parameters/input_boost_freq "1286400 1363200"
write /sys/module/cpu_boost/parameters/input_boost_ms 90
write /sys/module/cpu_boost/parameters/input_boost_freq_s2 "1132800 1209600"
write /sys/module/cpu_boost/parameters/input_boost_ms_s2 150
write /sys/module/msm_performance/parameters/cpu_min_freq "0:307200 1:307200 2:307200 3:307200"

# Setting b.L scheduler parameters
write /proc/sys/kernel/sched_boost 0
write /proc/sys/kernel/sched_migration_fixup 1
write /proc/sys/kernel/sched_upmigrate 95
write /proc/sys/kernel/sched_downmigrate 90
write /proc/sys/kernel/sched_freq_inc_notify 400000
write /proc/sys/kernel/sched_freq_dec_notify 400000
write /proc/sys/kernel/sched_spill_nr_run 3
write /proc/sys/kernel/sched_init_task_load 100

}&
