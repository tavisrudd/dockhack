dockhack
========

Some rudimentary utils I cooked up to introspect &amp; hack docker containers from the host

Usage
=====
```
  dockhack last_id | last
    prints the full id of the last container to run
    short-hand for `docker ps -l -q --no-trunc`

  dockhack get_id CID
    resolve and print the full SHA version of a container ID

  dockhack get_prop CID PROP
    lookup a container property via `docker inspect --format`

  dockhack get_ip CID
    print the container's IPv4 address

  dockhack get_root_pid CID
    print the container's top-level PID

  dockhack pids CID
    print a comma delimited list of all PIDs in the container

  dockhack fsroot CID
    print the mount path of the container's filesystem inside /var/lib/docker

  dockhack dhtop CID
    run htop, on the host, with the PIDs limited to those in the container

  dockhack dssh CID
    ssh into the container, assuming you've got init+sshd running
  
  The following require the `cgroup-bin` package (cgexec, lscgroup,
  etc.) and `nsenter`
  (http://man7.org/linux/man-pages/man1/nsenter.1.html) from
  util-linux version 2.23 or greater

  dockhack inside CID <any command available in the container plus its args>
    run a command inside the container cgroups + namespaces BUT without
    dropping any capabilities. This is useful for a) running
    privileged commands inside a non-privileged container and b) doing
    the equivalent of lxc-attach when running docker with
    libcontainer.
    e.g.
      ip route ...
      mount ....
      tcpdump ...

  dockhack cg_exec CID <any command available in the host plus its args>
    a wrapper around `cgexec` from `cgroup-bin` which wires up the
    required arguments. This uses the host's filesystem and, thus, the
    command must be available on the host.

  dockhack ns_enter CID <any command available in the container plus its args>
    a wrapper around `nsenter` from `util-linux` which wires up the
    required arguments. It uses the mount, uts, ipc, pid and net namespaces.

  dockhack supported_cgroups CID
    print a comma separated list of cgroups used for the container

  dockhack get_caps CID
    print the list of posix capabilities available in the container
    requires the ruby gem `cap2`

where 
  CID := { container-long-sha | container-short-sha | container-name | l | last}
      l is a short-hand for last
      e.g. 6a3827868f31
           6a3827868f31b549e2cfcf47e0f28a1ecc631aeec7a661c5a3cfa3966a66ca1d
           compassionate_lovelace
  PROP := anything that would resolve correctly in `docker inspect --format '{{PROP}}'`
```
