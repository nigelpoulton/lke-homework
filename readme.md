# Linode Kubernetes Engine homework assignments

Thanks for joining our live labs!

Homework assignments are listed below and the aim is to have fun learning and to do as much as possible with as little help from Google as possible. 

If you get stuck or have any questions, ping me publicly on [Twitter](https://twitter.com/nigelpoulton) or [LinkedIn](https://www.linkedin.com/in/nigelpoulton/). I'd also love to know how you get on with the homework!

Happy learning. @nigelpoulton


## Week 1 homework tasks

This week's lab focussed on building an LKE cluster, configuring kubectl, and deploying an app. I reckon you should be able to complete step 1 without any help, but I also reckon you'll need a bunch of help for steps 3 and 4 (I know I would).

The `app.yml` file is in the `week1` folder of this repo.

1. Build an LKE cluster with a single node pool comprising two nodes
2. Install `kubectl` on your laptop/desktop
3. Configure `kubectl` to talk to your new LKE cluster (Linode allows you to download the `config` file)
4. Deploy the [`nigelpoulton/lke-nodebalancer:1.0`](https://hub.docker.com/repository/docker/nigelpoulton/lke-nodebalancer) application using a Deployment YAML file
5. **Remember to delete your cluster when you're finished.** Failure to do this will incur costs.

## Week 2 homework tasks

This week's lab assumes you already have an LKE cluster. You will deploy three types of Kubernetes Service. **The ClusterIP** Service will allow Pods inside the cluster to connect to the app. The **NodePort** Service will ebanle external clients to connect via any cluster node on a dedicated network port. The **LoadBalancer** Service will create a highly-available internet-facing NodeBalancer on the Linode Cloud that you can use to connect to the app.

All required YAML files are in the `week2` folder of this repo.

### Deploy the app

1. Use `kubectl appl -f <filename>` to deploy the sample app from `/week2/app.yml`
2. Use `kubectl get` commands to check the status of the app. You can check the status of the Deployment and Pods

### Use a ClusterIP Service

ClusterIP Services create a stable DNS name and IP address that other Pods on the cluster can use to connect to the app.

1. Deploy a ClusterIP Service from `/week2/svc-clusterip.yml`
2. Use `kubectl get svc` to verify it's DNS name and IP
3. Deploy a *jump Pod* from `week2/jump-pod.yml` 
4. Connect to the jump Pod with `kubectl exec -it jump-pod /bin/bash`
5. Curl the IP or name of the ClusterIP Service deployed in step 3. It will connect you to the app

### Use a NodePort Service

NodePort Services map a network port (between 30000-32767) on every node in the cluster. You can then point a web browser at a combination of any node IP and the NodePort value.

1. Deploy a NodePort Service from `/week2/svc-nodeport.yml`
2. Use `kubectl get svc` to verify the NodePort value of the Service
3. Get the public IP of any of you cluster nodes (you can find this info on the `Linodes` tab of the Linode cloud console)
4. Point a web browser to the IP of the cluster node (Linode isntance) on the NodePort value (should be 31111). It will connect to the app

### Use a LoadBalancer Service

LoadBalancer Services integrate with the Linode Cloud to create a highly-available public-facing Linode NodeBalancer. You can connect to this NodeBalancer and reach the running application.

1. Deploy a LoadBalancer Service from `/week2/svc-loadbalancer.yml`
2. Use `kubectl get svc` to verify obtain the public IP address allocated to the Service
3. Point a web browser to the IP to connect to the app
4. Inspect the NodeBalancer configuration from the `NodeBalancers` tab of the Linode Cloud Console
5. Use `kubectl delete svc lke-loadbalancer` to delete the K8s Service **and** Linode NodeBalancer. Failure to do this will incur costs to your Linode account

**Remember to delete your LKE cluster. Failure to do this will incur costs to your Linode account.**
