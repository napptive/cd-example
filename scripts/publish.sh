#/bin/bash

if [[ -z "${PLAYGROUND_PAT}" ]]; then
  echo "PLAYGROUND_PAT must be set with your Personal Access Token"
  return 1
else
  echo "PLAYGROUND_PAT is set."
fi

echo "Downloading NAPPTIVE Playground CLI"
curl -O https://storage.googleapis.com/artifacts.playground.napptive.dev/linux/playground/playground_v1.0.0-rc4.tgz
tar --strip-components=1 -zxf playground_v1.0.0-rc4.tgz
chmod +x playground

echo "Downloading Kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl

echo "Login into NAPPTIVE Playground"
./playground login --pat 

echo "Obtaining kube-config"
./playground get-kubeconfig 

echo "Deploying latest versions"
./playground cluster info 
export PATH=$PATH:$(pwd)
echo "Checking if application needs to be deployed"
kubectl --kubeconfig napptive-kubeconfig get applicationconfigurations.core.oam.dev cd-example
if [ $? -eq 0 ]; then
    echo "Forcing rolling update to download newest image"
    kubectl --kubeconfig napptive-kubeconfig patch deployment cd-example -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"CI-updated\":\"`date +'%s'`\"}}}}}"
else
    echo "Launching application"
    kubectl --kubeconfig napptive-kubeconfig create -f ./build/k8s
fi