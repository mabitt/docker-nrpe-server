# docker-nrpe-server
nagios-nrpe-server running on docker

- Use env var to sett your nagios server. -e "NAGIOS_SERVER=10.0.0.1"
- Mount your own config files into the container. -v /srv/nrpe-server/nrpe.d:/etc/nagios/nrpe.d

For example:

```shell
docker run -d --name nrpe-server -p 5666:5666 -e "NAGIOS_SERVER=10.0.0.1" mabitt/docker-nrpe-server
```

/etc/nagios/nrpe_local.cfg
```
command[check_users]=/usr/lib/nagios/plugins/check_users -w 5 -c 10
command[check_load]=/usr/lib/nagios/plugins/check_load -w 15,10,5 -c 30,25,20
command[check_disk]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10%
command[check_zombie_procs]=/usr/lib/nagios/plugins/check_procs -w 5 -c 10 -s Z
command[check_total_procs]=/usr/lib/nagios/plugins/check_procs -w 200 -c 250
command[check_mem]=/usr/lib/nagios/plugins/check_mem.sh -w 500 -c 100 -p
```
