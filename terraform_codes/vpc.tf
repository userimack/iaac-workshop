resource "aws_vpc" "custom_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = merge(
    var.common_tags,
    {
      Name = "Custom-VPC"
    }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)


  tags = merge(
    var.common_tags,
    {
      Name = "Public-Subnet-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.common_tags,
    {
      Name = "Private-Subnet-${count.index + 1}"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = merge(
    var.common_tags,
    {
      name = "igw"
    }
  )
}

# Publiс routes
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "public-route-table"
    }
  )
}

# Route table association
resource "aws_route_table_association" "route_table_association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_route.id

}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.custom_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}
