! This fortran program can convert netCDF data like a wrfout into binary data. 
! when you compile this program,
! gfortran test.f90 -L/usr/local/netcdf-c-4.7.3/lib -lnetcdf -L/usr/local/netcdf-fortran-4.5.2/lib/ -lnetcdff

program nc_to_dat

  implicit none
  include 'path_to_dir/netcdf.inc'

  integer(4),parameter::nx=200,ny=188,nz=49,nt=1
  integer(4)::ncid,status,rhid
  real(4)::psfc(nx,ny,nt),slp(nx,ny,nt)
  character(128)::input,output,var
  integer(4)::x,y,z,t

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  var='VAR' ! use the capital letters
  input='path_to_dir/wrfout_d01_xxxxxx'

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
  status=nf_open(input, nf_nowrite, ncid) !open file and get netcdf ID(ncid)
  status=nf_inq_varid(ncid, var, rhid) !get variable ID(rhid)
  status=nf_get_var_real(ncid, rhid, psfc) ! read variable
  status=nf_close(ncid) ! close file

! Initialize variable !
  do t=1,nt
     do y=1,ny
        do x=1,nx
           slp(x,y,t)=0.
           slp(x,y,t)=slp(x,y,t)+psfc(x,y,t)
        end do
     end do
  end do


! output as binary data !
  write(output,'("test.dat")')
  open(10,file=output,status='unknown',form='unformatted',access='direct',recl=4*nx*ny*nt)
  write(10,rec=1)slp
  close(10)
  
end program nc_to_dat

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!     2021/1/12 Kenta Irie @ DPRI,Kyoto University     !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
