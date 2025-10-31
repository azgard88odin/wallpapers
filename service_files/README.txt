These service files must be run and a 'user' service.
These service files were created and tested on a debian based system.

Place both of these files within the following directory:
	~/.config/systemd/user
If this directory does not yet exist, create it with the following command:
	mkdir -p ~/.config/systemd/user

Copy the service files into the user systemd directory:
	cp ~/Documents/wallpapers/service_files/* ~/.config/systemd/user/

Reload all user daemons, enable the service timer and enjoy
	systemctl --user daemon-reload
	systemctl --user enable set_random_wallpapers.timer
	systemctl --user start set_random_wallpapers.timer

The service is currently configured to execute every hour.
This can be changed by changing the 'OnUnitActiveSec' value in the .service file:
	OnUnitActiveSec=60sec	=	every 60 seconds
	OnUnitActiveSec=30min	=	every 30 minutes
	OnUnitActiveSec=3h	=	every 3 hours

If you wanted to test if the service works immediately, run the following:
	systemctl --user start set_random_wallpapers.service

You should see that both the lockscreen and desktop wallpapers changed.
If the lockscreen did not change or the service did not work, please ensure you have installed the required extensions.
