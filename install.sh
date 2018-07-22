echo "Use JDK8"
export JAVA_HOME=<your_install_path>

git clone -b branch-2.3 https://github.com/apache/spark.git
build/mvn -DskipTests -P kubernetes clean package

#If Dockerfile Check
#cat ./resource-managers/kubernetes/docker/src/main/dockerfiles/spark/Dockerfile

#If kubectl not have been installed, 'brew install kubernetes-cli' 
#wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-200.0.0-darwin-x86_64.tar.gz
# google-cloud-sdk/install.sh
# If you try cloud environment, setup environment values
# gcloud config set project <project-name>
# gcloud config set compute/zone us-central1-a
# gcloud config set container/cluster <name>
# gcloud container clusters get-credentials <name>
# gcloud config list
#bin/docker-image-tool.sh -r <your_username> -t <version> build
#bin/docker-image-tool.sh -r <your_username> -t <version> push

# If you try local environment, install minikube
#bin/docker-image-tool.sh -m -t testing build
#curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/darwin/amd64/kubectl
# curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.18.0/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
# minikube --memory 8192 --cpus 3 start
#kubectl config use-context minikube

kubectl cluster-info
#If differece between Client and Server, Error may exist lately.
kubectl create serviceaccount spark
kubectl create clusterrolebinding spark-role --clusterrole=edit  --serviceaccount=default:spark --namespace=default
bin/spark-submit  \
    --master k8s://https://localhost:6443  \
    --deploy-mode cluster  \
    --conf spark.executor.instances=3  \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark  \
    --conf spark.kubernetes.container.image=<your_username>/spark:<version>  \
    --class org.apache.spark.examples.SparkPi  \
    --name spark-pi  \
    local:///opt/spark/examples/target/scala-2.11/jars/spark-examples_2.11-2.3.3-SNAPSHOT.jar

#dashboard check
kubectl proxy
#minikube dashboard

#delete pods
#kubectl delete pod spark-pi-XXXX-driver

#stop localhost
#minikube stop
#minikube delete

# Ref
#https://blue1st-tech.hateblo.jp/entry/2017/04/24/090000
#https://qiita.com/fredge@github/items/360b59aa0c6773d5f564
