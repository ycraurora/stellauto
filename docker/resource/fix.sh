# !/bin/bash

cd ~
tar xvf glibc-2.28.tar.gz
# rm -rf ~/.vscode-server/bin/*-legacy
server_path=$(ls ~/.vscode-server/bin/)
for i in $server_path; do
    echo "Fixing $i"
    node_path="/home/stella/.vscode-server/bin/$i/node"
    echo "Fixing $node_path"
    ./patchelf --set-rpath /home/stella/glibc/lib:/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu $node_path
    ./patchelf --set-interpreter /home/stella/glibc/lib/ld-linux-x86-64.so.2 $node_path
done
touch /tmp/vscode-skip-server-requirements
rm -rf glibc-2.28.tar.gz
