# postfix_bexporter


postfix_bexporter is a Prometheus metrics exporter, written in Bash. Supposed to be small and with very limited functionality.

# Installation

There are several options of how to install the software.

## Install on RHEL/CentOS 8

Not available yet

## Install on RHEL/CentOS 7

Yum repository URL: [https://yum.reinvented-stuff.com/rhel/7/](https://yum.reinvented-stuff.com/rhel/7/)
Yum configuration: [reinvented-stuff.repo](https://yum.reinvented-stuff.com/rhel/7/reinvented-stuff.repo)
GPG Public Key: [RPM-GPG-KEY-RNVSTFF-7](https://yum.reinvented-stuff.com/rhel/7/RPM-GPG-KEY-RNVSTFF-7)

### Add Reinvented Stuff's Yum repository

In order to use our repository, you can use `yum-config-manager` tool to fetch .repo file from our server and include it to the local Yum configuration. The repository will become available right away.

Alternatively you can manually download and copy `reinvented-stuff.repo` file into `/etc/yum.repos.d` on your server.

<details>
	<summary>Adding Reinvented Stuff Yum repository</summary>

$ sudo yum-config-manager --add-repo https://yum.reinvented-stuff.com/rhel/7/reinvented-stuff.repo
Loaded plugins: fastestmirror
adding repo from: https://yum.reinvented-stuff.com/rhel/7/reinvented-stuff.repo
grabbing file https://yum.reinvented-stuff.com/rhel/7/reinvented-stuff.repo to /etc/yum.repos.d/reinvented-stuff.repo
repo saved to /etc/yum.repos.d/reinvented-stuff.repo

</details>

### Install package using yum

After the repo is 

<details>
	<summary>Installing package</summary>

$ sudo yum install postfix_bexporter
Loaded plugins: fastestmirror
Determining fastest mirrors
epel/x86_64/metalink                                              | 6.2 kB  00:00:00     
 * base: mirror.23media.com
 * epel: epel.mirror.wearetriple.com
 * extras: mirror.fra10.de.leaseweb.net
 * updates: mirror.eu.oneandone.net
base                                                              | 3.6 kB  00:00:00     
epel                                                              | 4.7 kB  00:00:00     
extras                                                            | 2.9 kB  00:00:00     
reinvented-stuff                                                  | 2.9 kB  00:00:00     
updates                                                           | 2.9 kB  00:00:00     
Resolving Dependencies
--> Running transaction check
---> Package postfix_bexporter.x86_64 0:1.0.3-1 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=========================================================================================
 Package                   Arch           Version         Repository                Size
=========================================================================================
Installing:
 postfix_bexporter         x86_64         1.0.3-1         reinvented-stuff          10 k

Transaction Summary
=========================================================================================
Install  1 Package

Total download size: 10 k
Installed size: 3.0 k
Is this ok [y/d/N]: y
Downloading packages:
postfix_bexporter-1.0.3-1.x86_64.rpm                              |  10 kB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : postfix_bexporter-1.0.3-1.x86_64                                      1/1 
  Verifying  : postfix_bexporter-1.0.3-1.x86_64                                      1/1 

Installed:
  postfix_bexporter.x86_64 0:1.0.3-1                                                     

Complete!

</details>

# How to use

Environment variables:
PROMETHEUS_URL — URL to your Prometheus
PIPE — Path for temporary FIFO
