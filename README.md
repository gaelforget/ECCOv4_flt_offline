# MITgcm_flt
tools to use MITgcm/pkg/flt with llc and cs grids

### Files from initial testing phase (2017/02):

- `pkg_flt_diff` summarizes modifications made to MITgcm/pkg/flt before compiling it
- `FLT_SIZE.h` is a compile time option file
- `data.flt` is a run time option file
- `ini_pos.bin` is an initial condition file
- `prep_ini2.m` was used to prepare `ini_pos.bin`
- `read_flt_traj2.m` is used in `plot_traj2.m` to read in the model output (`float_trajectories.???.001.data`)
- `plot_traj2.m` plots the trajectories (model output) in global projection using m_map and gcmfaces
