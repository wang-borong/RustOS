#!/usr/bin/env python

# docker network inspect bridge
# get Name 'qemugdb' field and get its ip


import argparse
import subprocess
import json

def shellout(cmd_str):
    return subprocess.Popen(cmd_str, shell=True, stdout=subprocess.PIPE).stdout

def get_docker_qemugdb_ip():
    stdout = shellout('docker network inspect bridge')
    if stdout != None:
        docker_netinfo_json = json.loads(stdout.read())
        if len(docker_netinfo_json[0]['Containers']) == 0:
            exit(1)
        for container_hash in docker_netinfo_json[0]['Containers']:
            if docker_netinfo_json[0]['Containers'][container_hash]['Name'] == 'qemugdb':
                return docker_netinfo_json[0]['Containers'][container_hash]['IPv4Address'].split('/')[0]

parser = argparse.ArgumentParser(description='docker remote gdb runner')
parser.add_argument('-ip', action='store', type=str, help='e.g., 172.17.0.2')
parser.add_argument('-k', )

args = parser.parse_args()

if args.ip == None:
    qemugdb_ip = get_docker_qemugdb_ip()
else:
    qemugdb_ip = args.ip


kernel_file = args.k

gdb_cmd = "docker run -it --rm --privileged -v $PWD:/home/rustenv/workdir -w /home/rustenv/workdir rustos riscv64-elf-gdb -ex 'target remote {}:1234' -ex 'file {}' -ex 'set arch riscv:rv64'".format(qemugdb_ip, kernel_file)

subprocess.call(gdb_cmd, shell=True)
