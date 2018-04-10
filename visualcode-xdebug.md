# Enabling VSCode and Xdebug inside Docker
PHP-FPM will be running inside a container, therefore your localhost IP will not work.

## Configuring Docker and Xdebug
You need to change the placeholders on the `config/php-fpm/docker-php-ext-xdebug.ini` file.

To get your machine IP, you can just search for it on your favorite search engine 
or you can run `ipconfig getifaddr en0` (MacOS/Linux) - or `en1`, depending on your config - after getting your docker running. 

To search for the xdebug.so file, you can run  

```
docker-compose exec --user www-data phpfpm find /usr/local/lib/php/extensions -name xdebug.so
```

That will print the path for that file inside the docker image.  

You need to reboot your docker image after making these changes.

## VSCode 
After installing an add-on to debug PHP (we use [PHP Debug](https://github.com/felixfbecker/vscode-php-debug)), add the path of the docker image to your launch.json:
```
"pathMappings": {
    "/var/www/html": "/Users/{YOUR_USERNAME}/{THE_GIT_FOLDER}/wordpress",
}
```

## NOTE
If debugging still doesn't work after completing the setup above, you may need to create a loopback IP.

Run

```
sudo ifconfig lo0 alias 10.254.254.254
```

And add 10.254.254.254

To the `config/php-fpm/docker-php-ext-xdebug.ini` file and restart the docker images.

### Make it permanent - MacOS
The problem with the approach above is that it doesn’t persist across reboots. 
To have it persist across reboots, we need to create a “launchd” daemon that configures additional IPv4 address.

To achieve this we run the following commands:

```
$ cat << EOF | sudo tee -a /Library/LaunchDaemons/com.wp-construct.loopback1.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.wp-construct.loopback1</string>
    <key>ProgramArguments</key>
    <array>
        <string>/sbin/ifconfig</string>
        <string>lo0</string>
        <string>alias</string>
        <string>127.0.1.1</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF
```

This will create a plist file with the desired commands.

Then, we start the service up with:

```
$ sudo launchctl load /Library/LaunchDaemons/com.wp-construct.loopback1.plist
```

And make sure it works:

````
$ sudo launchctl list | grep com.wp-construct
-   0   com.wp-construct.loopback1
````

````
$ ifconfig lo0
lo0: flags=8049<UP,LOOPBACK,RUNNING,MULTICAST> mtu 16384
    options=1203<RXCSUM,TXCSUM,TXSTATUS,SW_TIMESTAMP>
    inet 127.0.0.1 netmask 0xff000000 
    inet6 ::1 prefixlen 128 
    inet6 fe80::1%lo0 prefixlen 64 scopeid 0x1 
    inet 127.0.1.1 netmask 0xff000000 
    nd6 options=201<PERFORMNUD,DAD>
````

Thank you [Felipe Alfaro](https://blog.felipe-alfaro.com/2017/03/22/persistent-loopback-interfaces-in-mac-os-x/) for the tips!
