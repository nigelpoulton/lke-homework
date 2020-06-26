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

## Week 3 homework tasks

This week's lab assumes you already have an LKE cluster with `kubectl` configured. 

The homework is split into four sections: 

1. Deploy a Pod and lose data
2. Create a persistent volume
3. Connect the volume to a Pod and write data to it
4. Delete the Pod and prove the data still exists

### Deploy a Pod and lose some data

The following steps will create a new Pod and write some data to it, delete the Pod, recreate it, and prove that the data is no longer present. This demonstrates that data written to a Pod is lost when the Pod is lost/deleted.

1. Use `kubectl apply -f` to deploy a new Pod form the `week3/pod.yml` file
2. Uae `kubectl exec -it testpod bash` to connect your terminal to the Pod
3. Write some data to the Pod: `mkdir test && echo "LKE FTW" > /test/newfile`
4. Verify the data was successfully written (`cat /test/newfile`)
5. Disconnect from the Pod (`exit`) and delete the Pod (`kubectl delete pod testpod`)
6. Recreate the Pod from the same `week3.pod.yml` file
7. Prove the data is not in this new Pod (`kubectl exec testpod cat /test/newfile`)

Delete the Pod form this example.

### Create a persistent volume

These steps will create a new block storage volume on the Linode storage back-end. The process will create a new Persistent Volume Claim (PVC) on your LKE cluster. The PVC references the `linode-block-storage-retain` StorageClass (SC) that already exists on the cluster and automatically creates a new block storage volume on the Linode back-end as well as an associated Persisten Volume object on the LKE cluster. 

1. Run `kubectl get sc` to list existing StorageClass objects on the cluster
2. Use `kubectl apply -f` to create anew PVC from the `week3/pvc.yml` file
3. Check that new PVC and PV objects have been created (`kubectl get pv` and `kubectl get pvc`)
4. Check the Linode Cloud Console in a web browser and verify a new block storage volume has been created

At this point a new block storage volume has been created on the Linode cloud and an associated PV object has been created on the LKE cluster. A PVC object has also been created. In the next section you'll deploy a new Pod that mounts a volume via the PVC just created.

### Connect the volume to a Pod and write data to it

In this step you'll deploy a new Pod that mounts a volume via the newly created PVC. The YAML file tells the Pod (container) to mount the volume directly to `/data`. You'll write some data to a new file in `/data`.

1. Create a new Pod form the `week3/volpod.yml` file
2. Exec onto the Pod with `kubectl exec -it volpod bash`
3. Write some data to a new file called `persistent` in `/data` (`echo "Linode rocks" > /data/persistent`)
4. Disconnect from the Pod (`exit`)
5. Verify the data was written (`kubectl exec volpod cat /data/persistent`)

At this point you there are no Pod running, but the PV, PVC and block storage volume on the Linode back-end still exist.

### Delete the Pod and prove the data still exists

In these steps you'll delete `volpod`, verify the volume related objects still exist, start a new Pod and connect the volume to it, and verify the data is in tact.

1. Delete `volpod` Pod with `kubectl delete pod volpod`
2. Verify the PV and PVC still exist (`kubectl get pv` and `kubectl get pvc`)
3. Use the Linode Cloud Dashboard to verify the block storage volume still exists on the Linode back-end
4. Deploy a new Pod from the `week3/rescuepod.yml` file (inspect the YAML file to see that it mounts the volume that you write data to in the previous section)
5. Connect to the Pod with `kubectl exec -it rescuepod bash`
6. Verify the file and data created in the previous step are now present in the `/linode` directory (`cat /linode/persistent`)

These three sections showed how the lifecycle of data and volumes can be decoupled from the lifecycle of Pods, allowing data to persist and be accessible after the Pod that created it has been deleted.

Feel free to reach out to @nigelpoulton and @linode on Twitter, as well as see my books and video courses (nigelpoulton.com) for more detailed explanations. Enjoy!