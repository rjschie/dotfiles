
set -g RUNPOD "$CODE/github.com/runpod/runpodctl/bin/runpodctl"
alias rpod="$RUNPOD"

alias rpodconnect="kitty +kitten ssh runpod"

function rpodStart
  set -l IMG "runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04"
  set -l GPU "NVIDIA GeForce RTX 4090"
  set -l VOLUMEID "0hk1169ryp"
  set -l CPU 16
  set -l MEM 62
  set -l DC "US-OR-1"

  set -l FLAGS "--gpuType"
  set -la FLAGS "'$GPU'"

  set -la FLAGS "--gpuCount"
  set -la FLAGS "1"

  set -la FLAGS "--imageName"
  set -la FLAGS "'$IMG'"

  set -la FLAGS "--dataCenterId"
  set -la FLAGS "'$DC'"

  set -la FLAGS "--ports"
  set -la FLAGS "'22/tcp'"

  set -la FLAGS "--vcpu"
  set -la FLAGS "$CPU"

  set -la FLAGS "--mem"
  set -la FLAGS "$MEM"

  set -la FLAGS "--templateId"
  set -la FLAGS "runpod-torch-v240"

  set -la FLAGS "--networkVolumeId"
  set -la FLAGS "'$VOLUMEID'"
  
  set -la FLAGS "--volumePath"
  set -la FLAGS "/workspace"

  set -la FLAGS "--volumeSize"
  set -la FLAGS "0"
  
  set -la FLAGS "--secureCloud"
  set -la FLAGS "--startSSH"

  echo "$RUNPOD create pod $FLAGS"
  echo ""
  $RUNPOD create pod $FLAGS
end

##
#{"operationName":"Mutation","variables":{"input":{"cloudType":"SECURE","containerDiskInGb":20,"volumeInGb":0,"deployCost":0.69,"gpuCount":1,"gpuTypeId":"NVIDIA GeForce RTX 4090","minMemoryInGb":62,"minVcpuCount":16,"startJupyter":false,"startSsh":true,"globalNetwork":false,"templateId":"runpod-torch-v240","volumeKey":null,"ports":"8888/http,22/tcp","dataCenterId":"US-OR-1","networkVolumeId":"0hk1169ryp"}},"query":"mutation Mutation($input: PodFindAndDeployOnDemandInput) {\n  podFindAndDeployOnDemand(input: $input) {\n    id\n    imageName\n    env\n    machineId\n    machine {\n      podHostId\n      __typename\n    }\n    __typename\n  }\n}"}

