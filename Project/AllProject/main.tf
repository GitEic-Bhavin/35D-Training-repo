module "nodes" {
    source = "./modules/nodes"
    ami = "ami-0892a9c01908fafd1"
    instance_type = "t2.medium"
    master_sg_name = "bhavin-master-sg"
    master_node_name = "bhavin-master-node"

    worker_sg_name = "bhavin-worker-sg"
    worker_node_name = ["bhavin-worker-node1", "bhavin-worker-node-2"]    

    
}