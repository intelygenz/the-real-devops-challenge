locals {
    # in order to prevent the vpc deletion from subnets
    vpc_id = coalescelist (aws_vpc_ipv4_cidr_block_association.this[*].vpc_id, aws_vpc.this[*].id, [""])[0]
    

    private_subnets = tomap({
    for subnet_key, subnet in var.subnets :
    subnet_key => subnet
    if subnet.IsPrivate == true
    })

    public_subnets = tomap({
    for subnet_key, subnet in var.subnets :
    subnet_key => subnet
    if subnet.IsPrivate == false
    })
    
}
