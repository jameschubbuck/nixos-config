while true; do
        # Fetch battery details
        current=$(cat /sys/class/power_supply/BAT1/current_now)
        voltage=$(cat /sys/class/power_supply/BAT1/voltage_now)
        charge_now=$(cat /sys/class/power_supply/BAT1/charge_now)   # in microAh
        charge_full=$(cat /sys/class/power_supply/BAT1/charge_full) # in microAh

        # Calculate power draw in watts
        power_draw=$(echo "scale=2; $current / 1000000 * $voltage / 1000000" | bc)

        # Calculate battery percentage
        if [ "$charge_full" -ne 0 ]; then
                battery_percentage=$(echo "scale=2; $charge_now / $charge_full * 100" | bc)
        else
                battery_percentage=0
        fi

        # Calculate total energy in Wh
        total_energy=$(echo "scale=2; $charge_full / 1000000 * $voltage / 1000000" | bc)

        # Display the results in one line with color formatting
        printf "\r\e[32mCurrent Power Draw: %.2f W | Battery Percentage: %.2f %% | Total Energy: %.2f Wh\e[0m" \
                "$power_draw" "$battery_percentage" "$total_energy"

        # Update every second
        sleep 1
done
