waybar | while read -r line; do
        echo "$line"
        if echo "$line" | grep -q "Bar configured"; then
                librepods
                pkill -f waybar
                break
        fi
done
