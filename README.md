# Rocprof compute 101 on adastra

https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-6.4.3/how-to/use.html

## Setup tutorial env

### Log into accelerated node

This tutorial is meant to be followed on a adasra MI250X via an interactive session. Ask for a node, and log into it.
```bash
salloc --account=genden15 --constraint=MI250 --job-name="rocprof_tutorial" --gpus-per-node=1 --nodes=1 --time=1:00:00
```

`squeue --me` should show you the allocated node. Log into it via ssh e.g. `ssh g1015`

only one gpu so

```bash
export HIP_VISIBLE_DEVICES="0"
```

### Load modules
We don't want to make it complicated and stick with stable rocm on adastra provided by cray

```bash
module load cpe/25.09 PrgEnv-cray craype-accel-amd-gfx90a rocm cray-python
```

`module list` should show

```bash
module list

Currently Loaded Modules:
  1) craype-x86-trento    3) cce/20.0.0               5) libfabric/2.2.0rc1   7) craype/2.7.35      9) cray-mpich/9.0.1     11) PrgEnv-cray/8.6.0        13) rocm/6.4.3
  2) craype-network-ofi   4) perftools-base/25.09.0   6) cpe/25.09            8) cray-dsmml/0.3.1  10) cray-libsci/25.09.0  12) craype-accel-amd-gfx90a  14) cray-python/3.11.7
```

### Get rocprof-compute working
If you try to launch `rocprof-compute` you will get an error for missing python packages. So, install them in a local venv (in `/WORK`) to not explode your Inodes. In `$WORK`:

```bash
python3 -m venv ./venv_rocprof_compute #Create venv
source ./venv_rocprof_compute/bin/activate #activate venv
pip3 install -r /lus/home/softs/rocm/6.4.3/libexec/rocprofiler-compute/requirements.txt
```

Later if you re-connect, just source the env.

Now check that `rocprof-compute` command works:

```bash
(venv_rocprof_compute) [genden15] rbourgeois@g1015:/lus/work/RES1/genden15/rbourgeois/test_rocprof$ rocprof-compute
usage: rocprof-compute [mode] [options]

Command line interface for AMD's GPU profiler, ROCm Compute Profiler
[...]
```

### Check that toolchain is okay
Build and run the tutorial

```c++
mkdir build ; cd build
cmake ..
make -j
./vcopy -n 1048576 -b 256 
```

and put il all together 

```
rocprof-compute profile --name vcopy -- ./vcopy -n 1048576 -b 256
```

#
```
cmake -DCMAKE_TOOLCHAIN_FILE=XXX ..
```