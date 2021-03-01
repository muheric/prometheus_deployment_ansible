hosts=(34.216.32.99 52.13.27.87 35.161.143.20)

for host in "${hosts[@]}"; do
    # Skip the current host.
    if [ "$HOSTNAME" = "$host" ]; then
        continue
    fi

    # Copy the current host's id to each other host.
    # Asks for password.
    ssh-copy-id cloud_user@"$host"
done

# Get the id's from each host.
for host in "${hosts[@]}"; do
    # Skip the current host.
    if [ "$HOSTNAME" = "$host" ]; then
        continue
    fi

    ssh cloud_user@"$host" 'cat -i ~/.ssh/id_rsa.pub' >> host-ids
done

for host in "${hosts[@]}"; do
    # Skip the current host.
    if [ "$HOSTNAME" = "$host" ]; then
        continue
    fi

    # This might work but I'm not sure.
    ssh-copy-id -i host-ids cloud_user@"$host"
    # If that didn't work then this should.
    #ssh "$host" 'cat >> .ssh/authorized_keys' <host-ids
done
