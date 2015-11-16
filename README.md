Windows based Apache Cassandra development environment
======================================================

This project aims to ease the burden of installing, configuring and later on scaling a local Cassandra cluster to test local developments. It has a pre requisite of having a Visual Studio 2010 (or newer version) with NuGet installed as its package manager. Once the this previous step is fulfilled, configuring the environment can be done from a `.bat` file.   

In order to achieve what was mentioned the installation and configuration is handled by a set of known tools:
 - [NuGet](https://docs.nuget.org/) (Visual Studio package manager), will be used to install a Windows package manager
 - [Chocolatey](https://github.com/chocolatey/choco/wiki) (Windows package manager), it will handle the installation of the needed components for the virtualized environment (which is based on Vagrant and VirtualBox)
 - [Vagrant](https://docs.vagrantup.com/v2/), it will manage the provisioning of our virtualized environment based on scripting 
 - [VirtualBox](https://www.virtualbox.org/manual/UserManual.html), our host virtualization provider  
 - [Docker](https://docs.docker.com/userguide/), our container runtime.

We will not run into the details on how each of those tools work, but using the provided links more information can be found on each of them. 

## How the automation works

Using NuGet we can from the integrated Visual Studio command line install Chocolatey and add it to the Windows command line doing:
``` bash
PM>Install-Package chocolatey 
... // some magic trickery happens here... 
PM>Initialize-Chocolatey
```

Later we should be able to use the `choco` command on any freshly opened cmd. So, using Chocolatey we will be able to run a script that installs our main dependencies: VirtualBox and Vagrant. The script devenv-setup.bat will complete that task. 

Once we cloned this repo to a local directory (lets say `<local-devenv>`), we can open a `CMD` and navigate to `<local-devenv>`, then running `devenv-setup.bat` will install all the needed components for our development environment. 

### Fixing Problems

It is possible that the `PATH` variable is really clogged and the `setx` command does not work as expected (it supports 1024 characters as parameter), a solution to this problems is to add the Cygwin `bin` directory to the Windows path for the current `CMD` with:
``` bash
SET PATH=%PATH%;C:\tools\cygwin\bin
```
This should solve the problems to access linux commands that may are needed moving forward. 

## Running the development environment

Ok, so now we have everything we need on the local computer and we are in the `<local-devenv>` directory on a `CMD` (also Cygwin console can be used for full Linux command goodness), booting up our Cassandra installation should be easy as running `vagrant up --provision`. The first time we do this it may take a while since it needs to download everything from the internet (coffee and wired network recommended), virtual OS image, install packages, docker images, etc. The next time a `vagrant up` will boot up the machine and start the Cassandra installation in it.

If everything went smooth we should be able to connect to a local Cassandra instance using:
``` c#
// Connect to the demo keyspace on our cluster running at 127.0.0.1
Cluster cluster = Cluster.Builder().AddContactPoint("127.0.0.1").Build();
ISession session = cluster.Connect("demo");
```
but maybe we would like to experiment with the cassandra `CQLSH` command ourselves, so running `vagrant ssh` on the `<local-devenv>` directory will get us inside the Linux installation that hosts our Cassandra cluster. Once in it running `cqlsh` we will be able to interact with the cluster directly. 

## Adding new nodes to the cluster dynamically

If we found ourselves with the need of having multiple Cassandra nodes running in our development environment we can login into our local Linux box with the `vagrant ssh` command and then run the next commands:
``` bash
$ cd /vagrant
$ sh devenv-add-cassandra-node.sh nodeN 100 // receives the new node's name and a number to do a port shift
```
this just started a new node into our Cassandra cluster all in the local enviroment.

## Other useful commands inside Vagrant

There are a set of scripts that can be used to clean up, stop, clean restart the Cassandra devenv:
``` bash
devenv-cleanup.sh        // delete all local data (does not recreates schemas)
devenv-create-schema.sh  // create the schema based on the latest local version
devenv-restart-clean.sh  // clean up data, start the Cassandra server and re creates the schema
devenv-status.sh         // shows the Docker instances running in the machine
devenv-stop.sh           // stops all the Docker instances in the machine
```

## Accessing OpsCenter

Our Cassandra development environment comes with OpsCenter installed, so we can access to it going to `http://localhost:8888` on any browser, then configuring our already created cluster with the address `` the OpsCenter will start loading the current state into the page. For more information on how to use OpsCenter visit this [link](http://docs.datastax.com/en/opscenter/5.1/opsc/about_c.html).
