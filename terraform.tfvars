accounts = [{
  key      = "master"
  provider = "aws"
  id       = "111111111111"
  name     = "Master"
  region   = "us-west-1"
  backend  = "s3"
},{
  key      = "logs"
  provider = "aws"
  id       = "222222222222"
  name     = "Log Archive"
  region   = "us-west-1"
  backend  = "s3"
},{
  key      = "audit"
  provider = "aws"
  id       = "333333333333"
  name     = "Audit"
  region   = "us-west-1"
  backend  = "s3"
},{
  key      = "aft"
  provider = "aws"
  id       = "444444444444"
  name     = "Management"
  region   = "us-west-1"
  backend  = "s3"
}]