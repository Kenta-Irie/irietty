#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <regex.h>

int main(void){
  size_t jmax=1206, imax=1206;
  char dname[]="../../geog/topo_30s";
  int i;
  unsigned short data[jmax*imax];
  char ifile[1025], ofile[1025];
  FILE *fp;
  DIR *dir;
  struct dirent *dp;
  regex_t reg;
  regmatch_t match[1];

  regcomp (&reg, "[0-9]*[-][0-9]*[.][0-9]*[-][0-9]*$", REG_EXTENDED);
  dir=opendir(dname);
  while(1){
    dp = readdir (dir);
    if (dp == NULL){break;}
    sprintf (ifile, "%s", dp->d_name);
    if(regexec (&reg, ifile, 1, match, 0) == 0){
      printf ("File = %s\n", ifile);
      sprintf (ofile, "%s", ifile);
      sprintf (ifile, "%s/%s", dname, ofile);
      fp = fopen (ifile, "rb");
      fread (data, 2, jmax*imax, fp);
      fclose(fp);
      for (i=0;i<=jmax*imax-1;i++){
	if (data[i] != 0){
	  data[i] = 0;
	}
      }
      fp = fopen (ofile, "wb");
      fwrite (data, 2, jmax*imax, fp);
      fclose(fp);
    }
  }
  return 0;
}
