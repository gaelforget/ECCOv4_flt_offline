# MITgcm_flt

**Content:** This repo provides tools to use `MITgcm/pkg/flt/` and with global grids that often rely on `pkg/exch2/`. Use of `MITgcm/pkg/offline/` is also explored. This `README.md` provides user directions plus bits of documentation. All contents should be regarded as work in progress that remains to be properly tested, vetted, and adapted before scientific use or online publication. For the time being, I therefore ask that you **please do not share this repository**.

**Author:** `gforget@mit.edu`

**Date:** `2019/03/12`

## 1) Repo Folders

- `code_flt/` and `code_off/` contain compile time options / settings plus a few modified function files which would eventually be merged into the main `MITgcm` repo.
- `input_flt/` and `input_off/` contain run time options / settings.
- `tools/` contains tools to prepare model input and analyze model output.
- `201702files/` contains initial testing stuff from 2017/02 (see below).


## 2) How To -- Use `pkg/flt` In ECCO

To run the model and pkg/flt concurrently (i.e., in online mode) proceed as follows.

- [Download the setup](https://eccov4.readthedocs.io/en/latest/downloads.html)
- add `code_flt/` and `input_flt/` into `MITgcm/mysetups/ECCOv4/`
- [Compile the model](https://eccov4.readthedocs.io/en/latest/runs.html) but with `-mods="../code_flt ../code"`.
- Prepare the run directory, within `MITgcm/mysetups/ECCOv4/`, using the following sequence. It is here assumed that initial conditions for `pkg/flt` are provided by the user in `init_flt/` (e.g., see **How To -- Initialize `pkg/flt`**).

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
- Plot output as needed using your favorite software (e.g., see **How To -- Initialize `pkg/flt`**).

### 2.1) Notes on "How To -- Use `pkg/flt` in ECCO"

The included, preliminary setup will need to be modified; in particular:

- Once all variables needed to setup `pkf/offline` have been generated using the full model then one should be able to run `pkf/flt` in offline mode (see **How To -- Use `pkg/offline` In ECCO**).
- The preliminary `pkf/flt` setup provided here is for a simple 2D problem where particles drift at the surface using uVel, vVel, wVel. Dealing with 3D problems may require including bolus and diffusivity components or modifying the fortran code.
- The handling of diffusion components as noise remains to be looked at. There are several terms (redi, ggl, convection, background) that may require distinct treaments. For example, the vertical component associated with redi may need to be separated from the implicit terms.
- In the 3D case, it is not clear whether the current treatment of grid spacing factors is adequate (heterogeneity in DRF/DRC? partial cells? R*?) when converting between x,y,z coordinates and local fractional horizontal indices.
- Current interpolation schemes may not ensure conservation, incompressibility asumptions, etc.; e.g., there may be advantages to using linear interpolation individually in each coordinate.

### 2.2) How To -- Initialize `pkg/flt`

Add `tools/` into `MITgcm/mysetups/ECCOv4/` and download [gcmfaces](https://gcmfaces.readthedocs.io/en/latest/) into `tools/`. Download [nctiles_grid/](https://eccov4.readthedocs.io/en/latest/downloads.html) into `MITgcm/mysetups/ECCOv4/`. Open `Matlab` and go to `MITgcm/mysetups/ECCOv4/` and execute commands below.

```
addpath(genpath([pwd filesep 'tools' filesep]));
create_init_flt;
```

### 2.3) How To -- Plot Trajectory Output

After having completed a model run, it's time to plot and analyze results. In `Matlab` for example, one can use `tools/read_flt_traj.m` and `tools/plot_flt_traj.m` as shown below [^read_flt_traj]. 


```
addpath(genpath([pwd filesep 'tools' filesep]));
dirRun=[pwd filesep 'run' filesep];
[flts,data,header]=read_flt_traj([dirRun 'float_trajectories'],4);
plot_flt_traj(flts(1:100:end));
```

## 3) How To -- Use `pkg/offline` In ECCO

First, download the ECCO v4r2 climatology ([nctiles_climatology/](https://eccov4.readthedocs.io/en/latest/downloads.html)) and use `tools/create_input_offline.m` to generate `input_climatology/*_mon.bin`. 

Then, follow directions from **How To -- Use `pkg/flt` In ECCO** but with `code_off`, `input_off`, and `input_climatology` replacing `code_flt`, `input_flt`, and `init_flt`. 

Doing so will compile and run `mitgcmuv` which should generate monthly output via `pkg/diagnostics`. This output can be compared with the original from `nctiles_climatology/` e.g. using `tools/check_run_offline.m`.

### 3.1) Notes on "Use `pkg/offline` In ECCO"


The included, preliminary setup will need to be re-evaluated; in particular:

- maybe uvel, uvel, and wvel should be used in place of uvelmass, etc.?
- maybe the divergent part of the velocity field needs to be subtracted?
- maybe the gm component (uvelstar, etc.) needs to be added to the velocity field?
- maybe various diffusion terms (redi, ggl, convection, background) need to be accounted for?

If variables are needed that are not available online (i.e., in [nctiles_climatology/](https://eccov4.readthedocs.io/en/latest/downloads.html)) then the full model needs to be re-ran to generate new output (see **How To -- Use `pkg/flt` In ECCO** and [pkg/diagnostics](https://mitgcm.readthedocs.io/en/latest/outp_pkgs/outp_pkgs.html)).

## Appendix 1) Initial Test Material From 2017/02


The `201702files/` folder contains:

- `pkg_flt_diff` summarizes modifications made to MITgcm/pkg/flt before compiling it
- `FLT_SIZE.h` is a compile time option file
- `data.flt` is a run time option file
- `ini_pos.bin` is an initial condition file
- `prep_ini2.m` was used to prepare `ini_pos.bin`
- `read_flt_traj2.m` is used in `plot_traj2.m` to read in the model output (`float_trajectories.???.001.data`)
- `plot_traj2.m` plots the trajectories (model output) in global projection using m_map and gcmfaces



[^read_flt_traj]: The execution of `read_flt_traj` can take a few minutes.
