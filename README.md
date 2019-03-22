# MITgcm_flt

This repo provides tools to use `MITgcm/pkg/flt/` with global grids that often rely on `pkg/exch2/`. This `README.md` provides user directions plus bits of documentation.


## 1) Repo Folder Contents

- `code_flt/` contains compile time options / settings plus a few modified function files. The latter would eventually be merged into the main `MITgcm` repo.
- `input_flt/` contains run time options / settings.
- `tools/` contains tools to prepare model input and analyze model output.
- `201702files/` contains initial testing stuff from 2017/02 (see below).


## 2) How To -- Run

To run the model and pkg/flt concurrently (i.e., in online mode) proceed as follows.

- [Download the setup](https://eccov4.readthedocs.io/en/latest/downloads.html)
- add `code_flt/` and `input_flt/` into `MITgcm/mysetups/ECCOv4/`
- [Compile the model](https://eccov4.readthedocs.io/en/latest/runs.html) but with `-mods="../code_flt ../code"`.
- Prepare the run directory, within `MITgcm/mysetups/ECCOv4/`, using the following sequence. It is assumed that `init_flt/` has e.g. been created by the user (see subsequent section).

```
mkdir run
cd run
ln -s ../build/mitgcmuv .
ln -s ../input_flt/* .
ln -s ../input/* .
ln -s ../inputs_baseline2/input*/* .
ln -s ../forcing_baseline2 .
ln -s ../init_flt/* .
```

- [Run the model](https://eccov4.readthedocs.io/en/latest/runs.html) using your favorite computer and shell script.

## 3) How To -- Initialize

Add `tools/` into `MITgcm/mysetups/ECCOv4/` and download [gcmfaces](https://gcmfaces.readthedocs.io/en/latest/) into `tools/`. Download [nctiles_grid/](https://eccov4.readthedocs.io/en/latest/downloads.html) into `MITgcm/mysetups/ECCOv4/`. Open `Matlab` and go to `MITgcm/mysetups/ECCOv4/` and execute commands below.

```
addpath(genpath([pwd filesep 'tools' filesep]));
create_init_flt;
```

## 4) How To -- Plot

With the same preliminary steps as in `How To -- Initialize` and after having completed `How To -- Run`, it's time to plot results [^read_flt_traj]. 


```
addpath(genpath([pwd filesep 'tools' filesep]));
dirRun=[pwd filesep 'run' filesep];
[flts,data,header]=read_flt_traj([dirRun 'float_trajectories'],4);
plot_flt_traj(flts);
```



## initial testing stuff (`201702files/`)


- `pkg_flt_diff` summarizes modifications made to MITgcm/pkg/flt before compiling it
- `FLT_SIZE.h` is a compile time option file
- `data.flt` is a run time option file
- `ini_pos.bin` is an initial condition file
- `prep_ini2.m` was used to prepare `ini_pos.bin`
- `read_flt_traj2.m` is used in `plot_traj2.m` to read in the model output (`float_trajectories.???.001.data`)
- `plot_traj2.m` plots the trajectories (model output) in global projection using m_map and gcmfaces



[^read_flt_traj]: The execution of `read_flt_traj` can take a long time.
