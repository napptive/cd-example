#/bin/bash

if [[ -z "${PLAYGROUND_PAT}" ]]; then
  echo "PLAYGROUND_PAT must be set with your Personal Access Token"
  return 1
else
  echo "PLAYGROUND_PAT is set."
fi

echo "Downloading NAPPTIVE Playground CLI"
curl -O https://storage.googleapis.com/artifacts.playground.napptive.dev/installer.sh && bash installer.sh

echo "Downloading Kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl

echo "Login into NAPPTIVE Playground"
playground login --pat 

export PATH=$PATH:$(pwd)
echo "Forcing rolling update to download newest image"
kubectl --kubeconfig napptive-kubeconfig patch deployment cd-example -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"CI-updated\":\"`date +'%s'`\"}}}}}"