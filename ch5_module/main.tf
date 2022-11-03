module "sg_for_instance" {
    source = "./modules/sg"

    #name = "sg_for_instance"
    sg_name = "allow-http"
    sg_discription = "Allow http ingrass and egress all allow"
    vpc_id = module.vpc_and_subnet.vpc_id
    #tags_name =  "${var.project_code}-allow-http"
    global_ip = var.global_ip
    project_code = var.project_code
  
}

module "vpc_and_subnet" {
    source = "./modules/vpc"

    vpc_cidr = var.vpc_cidr
    project_code = var.project_code
    subnet = var.subnet
}

module "web_server" {
    source = "./modules/compute"

    keypair = var.keypair
    project_code = var.project_code
    security_group_id = module.sg_for_instance.security_group_id
    subnet_a_id = module.vpc_and_subnet.subnet_a_id
}