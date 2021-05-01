This is the deployment of [magic_castle](https://github.com/ComputeCanada/magic_castle) for the Jupyter Meets the Earth Project.

### Work log and decisions
- Google drive document with [AWS Experimental hub requirements](https://docs.google.com/document/d/1l0nl89z8h1TgGoqlxrzSvH3oVwZRQvMiBauYAC7CAMM/edit#)
- Use AWS account managed by Fernando Pérez at https://286354552638.signin.aws.amazon.com/console
- Locate in the AWS region us-west-2 because it is close to [cmip6-pds dataset](https://registry.opendata.aws/cmip6/).
- I'm using jmte.sundellopensource.com as a domain name atm to not get stuck needing to register a new domain name or similar.
- I registered jupytearth.org for 1 USD / month using Google to quickly also make use of this projects automatic ability to configure the DNS records.
- I opened some issues and PRs to address smaller issues I experienced.
- magic_castle is up and running at mc.jupytearth.org, where the associated jupyterhub is available at jupyter.mc.jupytearth.org but what else is going on? Hmm... By visiting JupyterHub you can find a link to create an account at least.

### Feedback
#### Image not found

Running `terraform apply` where I had not changed the `image` under the `aws` module, I received the following error:

```
│ Error: InvalidAMIID.NotFound: The image id '[ami-033e6106180a626d0]' does not exist
│ 	status code: 400, request id: da173d2f-44c3-4348-b55c-8c56963d1409
│ 
│   on aws/infrastructure.tf line 67, in resource "aws_instance" "instances":
│   67: resource "aws_instance" "instances" 
```

I'm not sure how to proceed with regards to this, but I guess this is like choosing the aws instances system hard drive. I don't know if the image listed was an official one, or if I'm required to make it available in the region of my choice or similar.

Update 1: It seems like using https://gist.github.com/gene1wood/56e42097e0f0ac1aace14cbc41ee3e11 to choose an alternative CentOS 7 image identifier associated with our AWS region could work.

Update 2: I found that the lists were outdated, and I had to use the associated script to get the absolute latest version for my region.

Update 3: I ran into another error.

```
│ Error: Error launching source instance: OptInRequired: In order to use this AWS Marketplace product you need to accept terms and subscribe. To do so please visit https://aws.amazon.com/marketplace/pp?sku=aw0evgkw8e5c1q413zgy5pjce
│ 	status code: 401, request id: ceea85bc-733b-4cb0-824b-d8ff6a788817
│ 
│   on aws/infrastructure.tf line 67, in resource "aws_instance" "instances":
│   67: resource "aws_instance" "instances" {
```

This was resolved by following the comment. I understood it to not incur additional costs to request use of CentOS 7 as an image on the AWS machines, and that what I did by accepting this was the use of a AWS marketplace managed CentOS 7 image rather than a AWS managed image.

#### HCL files?

> 4.1 source
>
> The first line of the module block indicates to Terraform where it can find the HCL files that defines the resources that wil constitute your future cluster. In the releases, this variable is a relative path to the cloud provider folder (i.e.: ./openstack).

HCL had not been mentioned before.

#### /docs/README.md -> 1. Setup -> Confusion -> Resolution in /docs/README.md steps

I raised many questions when reading the AWS specific README.md on how to configure `main.tf`. Those questions had answers in `/docs/README.md` but I didn't know because I was linked off and expected to do these steps and then return.

Suggestion: to add a pointer in the AWS specific README.md and/or main.tf that details on how to configure is documented in the `/docs/README.md` file.

#### Configuration of `domain` is a bit vague

I realized you are expected to provide `my-domain.com` in the domain field, not `my-cluster-name.my-domain.com`. Where the availability of jupyterhub etc will be is unclear as well but I guess `jupyter.my-cluster-name.my-domain.com`.

Being explicit about this with an example docs/README.md could be suitable.

I'm also curious if a wildcard certificate is acquired or certs for each separate service.
