---
title: "Auto-mounting NFS NAS with wakeonlan"
date: 2023-03-21
draft: true
---

First attempt: bash function with sudo

Second attempt: autofs

* gebruik type nfs4
* sudo automount -f -v to run in foreground for debugging
* "attempting to mount entry /mnt/.git"

* er moet een timeout tussen. werkte wel met bash functie, niet met autofs

sources:

https://help.ubuntu.com/community/Autofs
https://stackoverflow.com/questions/27715023/are-there-programmable-automount-autofs-hooks-in-linux-systemd
https://stackoverflow.com/questions/617182/how-can-i-suppress-all-output-from-a-command-using-bash
https://dj-does.medium.com/nfs-mounts-and-wake-on-lan-25c0c1d55c90
https://www.redhat.com/sysadmin/mount-nfs-filesystems-autofs
https://www.kernel.org/doc/html/latest/filesystems/autofs.html
https://stackoverflow.com/questions/15901239/in-bash-how-do-you-see-if-a-string-is-not-in-an-array

query (type 'quit' to exit): : I have a NAS that shuts down when it is not being used for an hour and it can be turned on again by wakeonlan. I also have mounted some folder on my computer with NFS. Now, when the NAS shuts down, while the folders are still mounted, my Debian Linux system with Cionnamon desktop gets very confused. To the point that I need to restart. What can I do about this?
─────────────────────────────────────────────────────────────────────── assistant ───────────────────────────────────────────────────────────────────────
There are a few things you can do to prevent this issue:

1 Unmount the NFS shares when not in use: You can use the umount command to unmount the NFS shares when you're not using them. This will prevent your   
system from getting confused when the NAS shuts down. You can also write a script to automatically unmount the shares when the NAS is not in use.     
2 Use autofs: Autofs is a program that automatically mounts and unmounts NFS shares when they are accessed and not in use, respectively. This can help  
prevent your system from getting confused when the NAS shuts down.                                                                                    
3 Use soft mount option: When mounting the NFS share, you can use the soft option. This means that if the NFS server is not available, the system will  
fail the operation after re-trying a few times, rather than hanging indefinitely. This can help prevent your system from getting confused when the NAS
shuts down.                                                                                                                                           
4 Use a cron job to check NAS status: You can set up a cron job to periodically check the status of the NAS. If the NAS is not available, the cron job  
can unmount the NFS shares, preventing your system from getting confused.                                                                             
5 Configure your NAS to stay on: If none of the above options work for you, you might consider configuring your NAS to stay on all the time. This will  
prevent the issue from occurring, but it will also consume more power.

Remember to always backup your data before making any changes to your system or NAS.                                                                     
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
query (type 'quit' to exit): : How can I use autofs in combination with wakeonlan?
─────────────────────────────────────────────────────────────────────── assistant ───────────────────────────────────────────────────────────────────────
To use autofs in combination with wakeonlan, you need to set up a script that will wake up your NAS before trying to access it. Here's a basic example of
how you can do this:

1 Install autofs and wakeonlan: If you haven't already, install autofs and wakeonlan on your Debian system. You can do this with the following commands:

    sudo apt-get update                                                                                                                                  
    sudo apt-get install autofs wakeonlan                                                                                                                

2 Create a wakeonlan script: Create a script that will wake up your NAS. Replace "MAC_ADDRESS" with the MAC address of your NAS:

    #!/bin/bash                                                                                                                                          
    /usr/bin/wakeonlan MAC_ADDRESS                                                                                                                       
    sleep 20                                                                                                                                             

Save this script as /usr/local/sbin/wake-nas.                                                                                                         
3 Make the script executable: Run the following command to make the script executable:

    sudo chmod +x /usr/local/sbin/wake-nas                                                                                                               

4 Configure autofs: Edit the /etc/auto.master file and add the following line:

    /mnt /etc/auto.nas --timeout=60 --ghost                                                                                                              

This tells autofs to automatically mount and unmount the NFS shares located in /mnt.                                                                  
5 Create the autofs map file: Create a new file called /etc/auto.nas and add the following line:

    nas -fstype=nfs,rw,hard,intr,exec,proto=tcp,port=2049 :/usr/local/sbin/wake-nas:/path/to/nas                                                         

Replace "/path/to/nas" with the path to your NAS.                                                                                                     
6 Restart autofs: Restart the autofs service to apply the changes:

    sudo service autofs restart                                                                                                                          


Now, whenever you try to access the NFS share, autofs will first run the wakeonlan script to wake up your NAS, then mount the share. After 60 seconds of
inactivity, the share will be unmounted again.                                                                                                           
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
query (type 'quit' to exit): : Does this configuration work if i have multiple folders that are mounted? I have /mnt/nas/audio, /mnt/nas/backup, /mnt/nas/docs, etc.
─────────────────────────────────────────────────────────────────────── assistant ───────────────────────────────────────────────────────────────────────
Yes, you can use autofs with multiple folders. You just need to add each folder to the autofs map file. Here's how you can do it:

1 Edit the autofs map file: Open the /etc/auto.nas file you created earlier and add a line for each folder you want to mount. For example:

    audio -fstype=nfs,rw,hard,intr,exec,proto=tcp,port=2049 :/usr/local/sbin/wake-nas:/path/to/nas/audio                                                 
    backup -fstype=nfs,rw,hard,intr,exec,proto=tcp,port=2049 :/usr/local/sbin/wake-nas:/path/to/nas/backup                                               
    docs -fstype=nfs,rw,hard,intr,exec,proto=tcp,port=2049 :/usr/local/sbin/wake-nas:/path/to/nas/docs                                                   

Replace "/path/to/nas/audio", "/path/to/nas/backup", and "/path/to/nas/docs" with the actual paths to your folders on the NAS.                        
2 Restart autofs: Restart the autofs service to apply the changes:

    sudo service autofs restart                                                                                                                          


Now, whenever you try to access any of the NFS shares, autofs will first run the wakeonlan script to wake up your NAS, then mount the share. After 60    
seconds of inactivity, the share will be unmounted again.