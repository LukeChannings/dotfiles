function krun --description "Run an ephemeral container in a kubernetes cluster"
    argparse --name=krun 'H/hostname=' 'a/arch=' d/debug -- $argv
    or return

    set -x LC_ALL C
    set -l USAGE "krun <image> [-H|--hostname=node-hostname] [-a|--arch=architecture]"

    set -l image $argv[1]
    set -l randomAffix (cat /dev/random | tr -dc '[:lower:]' | head -c 8)

    if ! test -n "$image"
        echo $USAGE
        return
    end

    set -l spec '
---
apiVersion: v1
kind: Namespace
metadata:
  name: krun
---
kind: Pod
apiVersion: v1
metadata:
  name: krun-'$randomAffix'
  namespace: krun
spec:
  containers:
    - name: shell
      image: '$image'
      tty: true
      stdin: true
      command: ["/bin/sh"]
  restartPolicy: Never'

    if test -n "$_flag_hostname" -o -n "$_flag_arch"
        set spec $spec(echo -e '\n  nodeSelector:' | string collect)
        if test -n "$_flag_hostname"
            set spec $spec(echo -e '\n    kubernetes.io/hostname: '$_flag_hostname | string collect)
        end
        if test -n "$_flag_arch"
            set spec $spec(echo -e '\n    kubernetes.io/arch: '$_flag_arch | string collect)
        end
    end

    if test -n "$_flag_debug"
        echo $spec
    end

    echo $spec | kubectl apply -f -

    kubectl wait --for=condition=Ready -n krun pod krun-$randomAffix

    kubectl attach -n krun krun-$randomAffix -it --pod-running-timeout=2m0s

    kubectl delete -n krun pod krun-$randomAffix &
end
