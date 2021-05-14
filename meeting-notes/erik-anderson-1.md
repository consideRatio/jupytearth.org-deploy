Meeting notes for meet with Anderson 7th May

action points
    - [x] slurm youtube videos
    - [ ] puppet youtube videos
        - [ ] learn about hiera.yaml
    - [x] differentiate bash/ansible/puppet
          - bash: create/destroy scripts
          - ansible: sync state once
          - puppet: continuously sync state
    - [ ] explore and investigate slurm cloud scheduling / elastic stuff
    - [ ] explore how to configure user environment, pip packages for example
    - [ ] explore how to configure jupyterhub
    - [ ] investigate how to access my own account in ipa.
    - [ ] what is the NFS server used for, what files go there and what don't?
    - [ ] explore how cvmfs works
    - [ ] explore how to make binderhub HPC compatible
        - SlurmBinderSpawner, repo2singularity



Terminology k8s
    - nodes/pod, labels, taints/tolerations, resource requests, affinity/nodeSelector, priority

Terminology slurm
    - account, account-priority, queue, queue-priority, cpu-hours, partitions/queues
    - reservations: an account-priority coupled to accounts and resources during a given time frame
    - request: a gpu of certain type (constraints?)

Slurm commands of use:
    - sinfo
    - squeue
    - scancel
    - srun -n 1 --pty 

To enter the live puppet configuration found at
https://github.com/ComputeCanada/puppet-magic_castle, do this:

```
ssh -A centos@login1.mc.jupytearth.org
ssh mgmt1
cd /etc/puppetlabs/code/environments/production
```



### Protect myself from committing secrets

https://github.com/thoughtworks/talisman



### modules

The build software and put it on the HTTP based filesystem (cvmfs), and
magic_castle is mounting it as read only.

https://github.com/ComputeCanada/puppet-magic_castle/blob/2f016324fa7163008705aec10122b49f0304489a/site/profile/manifests/cvmfs.pp

JupyterLab extension: https://github.com/cmd-ntrf/jupyter-lmod

lmod is the software providing the module executable



### Overview

https://github.com/ComputeCanada/magic_castle
https://github.com/ComputeCanada/puppet-magic_castle
https://github.com/ComputeCanada/puppet-jupyterhub
