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
- Go to `MITgcm/mysetups/ECCOv4/` and download `code_flt/` + `input_flt/` as follows:

```
cd MITgcm/mysetups/ECCOv4/
git clone https://github.com/gaelforget/MITgcm_flt
```

- [Compile the model](https://eccov4.readthedocs.io/en/latest/runs.html) but with `-mods="../MITgcm_flt/code_flt ../code"`. If you are using gfortran for example you want to use the `linux_amd64_gfortran` option file:

```
cd MITgcm/mysetups/ECCOv4/build
../../../tools/genmake2 -mods="../MITgcm_flt/code_flt ../code" -optfile \
     ../../../tools/build_options/linux_amd64_gfortran -mpi
make depend
make -j 4
cd ..
```

- Prepare the run directory using the following sequence where it is assumed that `init_flt/` contains initial conditions provided by user (e.g., see **How To -- Initialize `pkg/flt`**).

```
mkdir run
cd run
ln -s ../build/mitgcmuv .
ln -s ../MITgcm_flt/input_flt/* .
ln -s ../input/* .
ln -s ../inputs_baseline2/input*/* .
ln -s ../forcing_baseline2 .
ln -s ../init_flt/* .
```

- [Run the model](https://eccov4.readthedocs.io/en/latest/runs.html) using your favorite computer and shell script.
- Plot output as needed using your favorite software (e.g., see **How To -- Plot Trajectory Output**).

### 2.1) Notes on "How To -- Use `pkg/flt` in ECCO"

The included, preliminary setup will need to be modified; in particular:

- Once all variables needed to setup `pkf/offline` have been generated using the full model then one should be able to run `pkf/flt` in offline mode (see **How To -- Use `pkg/offline` In ECCO**).
- The preliminary `pkf/flt` setup provided here is for a simple 2D problem where particles drift at the surface using uVel, vVel, wVel. Dealing with 3D problems may require including bolus and diffusivity components or modifying the fortran code.
- The handling of diffusion components as noise remains to be looked at. There are several terms (redi, ggl, convection, background) that may require distinct treaments. For example, the vertical component associated with redi may need to be separated from the implicit terms.
- In the 3D case, it is not clear whether the current treatment of grid spacing factors is adequate (heterogeneity in DRF/DRC? partial cells? R*?) when converting between x,y,z coordinates and local fractional horizontal indices.
- Current interpolation schemes may not ensure conservation, incompressibility asumptions, etc.; e.g., there may be advantages to using linear interpolation individually in each coordinate.

### 2.2) How To -- Initialize `pkg/flt`

Download [gcmfaces](https://gcmfaces.readthedocs.io/en/latest/) to use it along with `MITgcm_flt/tools/`. 

```
cd MITgcm/mysetups/ECCOv4/
git clone https://github.com/gaelforget/gcmfaces
```

Open `Matlab` and go to `MITgcm/mysetups/ECCOv4/` and execute `create_init_flt.m`.

```
cd MITgcm/mysetups/ECCOv4/
addpath(genpath([pwd '/gcmfaces/']));
addpath(genpath([pwd '/MITgcm_flt/tools/']));
create_init_flt;
```

### 2.3) How To -- Plot Trajectory Output

After having completed a model run, it's time to plot and analyze results. In `Matlab` for example, one can use `read_flt_traj.m` and `plot_flt_traj.m` as shown below [^read_flt_traj]. 


```
cd MITgcm/mysetups/ECCOv4/
addpath(genpath([pwd '/MITgcm_flt/tools/']));
dirRun=[pwd filesep 'run' filesep];
[flts,data,header]=read_flt_traj([dirRun 'float_trajectories'],4);
plot_flt_traj(flts(1:100:end));
```

## 3) How To -- Use `pkg/offline` In ECCO

First, download ECCO v4r2's [nctiles_climatology/](https://eccov4.readthedocs.io/en/latest/downloads.html) into `MITgcm/mysetups/ECCOv4/` and use e.g. `create_input_offline.m` to generate `input_climatology/`. 

```
cd MITgcm/mysetups/ECCOv4/
addpath(genpath([pwd '/MITgcm_flt/tools/']));
create_input_offline;
```

Then, follow the same directions as in **How To -- Use `pkg/flt` In ECCO** but with `code_off`, `input_off`, and `input_climatology` replacing `code_flt`, `input_flt`, and `init_flt`. 

Running this `mitgcmuv` should generate monthly output via `pkg/diagnostics` comparable to the original from `nctiles_climatology/` (e.g. see `tools/check_run_offline.m`).

### 3.1) Notes on "Use `pkg/offline` In ECCO"


The included, preliminary setup will need to be re-evaluated; in particular:

- maybe uvel, uvel, and wvel should be used in place of uvelmass, etc.?
- maybe the divergent part of the velocity field needs to be subtracted?
- maybe the gm component (uvelstar, etc.) needs to be added to the velocity field?
- maybe various diffusion terms (redi, ggl, convection, background) need to be accounted for?

If variables are needed that are not available online (i.e., in [nctiles_climatology/](https://eccov4.readthedocs.io/en/latest/downloads.html)) then the full model needs to be re-ran to generate new output (see **How To -- Use `pkg/flt` In ECCO** and [pkg/diagnostics](https://mitgcm.readthedocs.io/en/latest/outp_pkgs/outp_pkgs.html)).

## 4) How To -- Use `pkg/offline` + `pkg/flt` In ECCO

Proceed as before but with a few modifications:

- Uncomment the `#flt` line that in `code_off/packages.conf` . 
- Add ` useFLT             = .TRUE.,` in `input_off/data.pkg` .
- Compile with:

```
../../../tools/genmake2 -mods="../MITgcm_flt/code_off ../MITgcm_flt/code_flt ../code" \
     -optfile ../../../tools/build_options/linux_amd64_gfortran -mpi
```

- Setup the run directory as:

```
mkdir run
cd run
ln -s ../build/mitgcmuv .
ln -s ../MITgcm_flt/input_off/* .
ln -s ../MITgcm_flt/input_flt/* .
ln -s ../input/* .
ln -s ../inputs_baseline2/input*/* .
ln -s ../forcing_baseline2 .
ln -s ../input_climatology/* .
ln -s ../init_flt/* .
```


## Appendix 1) Initial Test Material From 2017/02


The `201702files/` folder contains:

- `pkg_flt_diff` summarizes modifications made to MITgcm/pkg/flt before compiling it
- `FLT_SIZE.h` is a compile time option file
- `data.flt` is a run time option file
- `ini_pos.bin` is an initial condition file
- `prep_ini2.m` was used to prepare `ini_pos.bin`
- `read_flt_traj2.m` is used in `plot_traj2.m` to read in the model output (`float_trajectories.???.001.data`)
- `plot_traj2.m` plots the trajectories (model output) in global projection using m_map and gcmfaces


## Appendix 2) Just in case ...

In case your build option file does not handle the case of multiple `mods` directories as one would expect you can try something like this:

```
mkdir code_flt_online
cp -p MITgcm_flt/code_flt/* code_flt_online/
cp -p code/* code_flt_online/
#/bin/cp: overwrite 'code_flt_online/packages.conf'? n

cd build
../../../tools/genmake2 -mods=../code_flt_online \
     -optfile ../../../tools/build_options/linux_amd64_gfortran -mpi
```

And this for the offline+flt case:

```
mkdir code_flt_offline
#mkdir: cannot create directory 'code_flt_offline': File exists
cp -p MITgcm_flt/code_off/* code_flt_offline/
cp -p MITgcm_flt/code_flt/* code_flt_offline/
#/bin/cp: overwrite 'code_flt_offline/packages.conf'? n
cp -p code/* code_flt_offline/
#/bin/cp: overwrite 'code_flt_offline/packages.conf'? n

cd build
../../../tools/genmake2 -mods=../code_flt_offline \
     -optfile ../../../tools/build_options/linux_amd64_gfortran -mpi
```

[^read_flt_traj]: The execution of `read_flt_traj` can take a few minutes.
