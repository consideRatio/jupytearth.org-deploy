- 389 database (RedHat product), ldap-database
    - When you recreate the mgmt node, this databse is lost. All the previous users are whiped when mgmt node is recreated.
    - The FreeIPA service is whiped

- NFS storage
    - /home, /project, /scratch
    - These volumes are not necessarily recreated if the mgmt node is recreated.
    - Terraform assumed the persistent storage volume could be kept because the mgmt node was recreated
    - Dedicated volume (EBS disk, Google Persistent Disk)

- /etc/passwd describes the local users of the instance, which won't be the same as the FreeIPA users.


Choice of HPC software:
- Uncommon:
    - Puppet is not common in HPC, but used by compute canada
    - Puppet syncs files but each node has a local copy.
    - FreeIPA: where is your user server, free IPA responds
    - consul (not many installations on HPC on the earth :D)

- Common:
    - CFEngine, centrally organized disk that propegates to the other nodes
    - XCat
    - Instead of FreeIPA, An OpenLDAP server to manage users

Needs of a dynamic system vs static system:
- magic_castle is written

Users:
- When a user is referenced that doesn't exists, FreeIPA is referenced through a LDAP client
- Some users are created on local nodes, such as the centos user, as a failsafe if FreeIPA is down for example.
- `id fperez` would give me a lookup if needed, but note there is a cache used (ssh-d cache) so it can take some minutes
- ipa is a CLI for FreeIPA
    - a deeper level is using a ldap-tool, but this is more advanced and perhaps not recommended.
    -
- Kerberos

What about...
- Consul: puppet has a shortcoming, and consul was added to resolve it.
    - consul can help update configuration files just in time. The mgmt node uses consul to inform nodes about changes.
    - consul has been used to collect metrics from "all consul nodes"
    - puppet could only do it every X minute etc.

Decision point:
- Should a DB live on a mgmt node's instance disk, or a dedicated disk?
- If you want to have an SSH key added after you have built your cluster, perhaps... use another thing...
    - `clush -w node[1] echo 'hello world'` - Run a command on all nodes
    - Add public key to /centos/.ssh/authorized_keys
    - Register SSH key using IPA admin board



Q:
- core oversubscription - On HPC, only one user can use a core by default on a classical HPC cluster. It is called core oversubscription to be able to let different jobs use the same cores.
    - if core oversubscription is enabled, cores can only be shared by up to four jobs
- configuring jh:
    - in puppet there is the concept of "data" and "code".
    - in order to inject different values for the "data", you can update...
    - hieradata, variable can be defined, which will override data used by by the puppet data.
        - jupyterhub::oversubscription::true
        - https://github.com/ComputeCanada/magic_castle/tree/main/docs#413-hieradata-optional
        - https://github.com/ComputeCanada/puppet-jupyterhub#hieradata-configuration
        - https://github.com/ComputeCanada/puppet-jupyterhub/blob/main/data/common.yaml (default values for the puppet module)

Account/groups:
- When a user is added to a group matches the def-..., then a script is run to couple things to the slurmdbd represented in JupyterHub spawn options.

/etc/puppetlabs/data

if you modify your input data for puppetserver, 