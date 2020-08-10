#What you need
#sudo apt-get install cpufrequtils
#sudo apt-get install sysstat
#Optional: sudo wget https://raw.githubusercontent.com/DavidM42/rpi-cpu.gov/master/install.sh && sudo chmod +x ./install.sh && sudo ./install.sh --nochown && sudo rm install.sh
echo "#################################################################################"

echo "\n Temperatur"
vcgencmd measure_temp | grep -Po '=\K.*'

echo "\n CPU Current"
hz=$(cpufreq-info -w)
mhz=$((hz / 1000))
gov=$(cpufreq-info -c 0 | grep -o '"[^"]\+"')
echo "$mhz mhz $gov"

echo "\n GPU current"
ghz=$(vcgencmd measure_clock v3d | grep -Po '=\K.*')
gmhz=$((ghz / 1000000))
echo "$gmhz mhz"
echo "#################################################################################"

echo "\n Stats"
mpstat

echo "\n Min/Max"
cpufreq-info -s -m

#Optional
#cpu.gov -s

echo "\n"
for src in arm core h264 isp v3d uart pwm emmc pixel vec hdmi dpi; do \
	echo "$src:\t$(vcgencmd measure_clock $src)"; \
done

for id in core sdram_c sdram_i sdram_p; do \
	echo -e "$id:\t$(vcgencmd measure_volts $id)";  \
done
