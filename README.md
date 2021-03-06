# aws-terraform-example
example of launching an ec2 instance with terraform

### Terraform Usage
First, you will need [install](http://t1cg.io/blog/post/start-with-terraform/) terraform.

When using terraform your main.tf files is where the action happens.
In order to provision resources you'll need an AWS secret key and access key.
These are different from your pub and pem keys used to ssh into ec2 servers.
Read the [terraform](https://www.terraform.io/docs/) docs to help distinguish the two
key types, and to help you find out how to get terraform connected to your AWS account.

In any directory with a main.tf child file:

`terraform plan` - shows you the resources your main.tf file will provision

`terraform apply` - executes the provisioning of desired resources stated in your main.tf file


### Ansible Usage
First, you will need [install](http://docs.ansible.com/ansible/intro_installation.html) ansible.

The [inventory.ini](http://docs.ansible.com/ansible/intro_inventory.html) file is personal to you.  Here you'll include IPs you wish to connect with and
the credentials ansible can use to connect to said IPs.

The [ansible.cfg](http://docs.ansible.com/ansible/intro_configuration.html) lets you control how you want ansible to act.

By convention playbook files start with "playbook".  In a playbook users include different ansible modules
which run different services.  A playbook may consist of one or many.  Examples of modules can be service,
copy, synchronize, user, raw.  Check out the ansible [docs](http://docs.ansible.com/ansible/) for more info.

`ansible-playbook -i inventory.ini playbook-your-playbook.yml` - exuecutes your playbook
