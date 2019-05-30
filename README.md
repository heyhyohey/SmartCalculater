# Complier-of-SmartCalculator
Compiler project

smart calculator to C complier

ex)
==========  before  ===========
B=20.0*5;
C=B+20;
C=C-40.7;
if(C>=100) then print C;
else  print "Small";
  print "END";
endif;

==========  after  ===========

#include <stdio.h>

int main()
{
  double C;
  double B;
  B=20.0*5;
  C=B+20;
  C=C-40.7;
  if(C>=100) {
    printf("%lf\n", C);
  }
  else {
    printf("Small\n");
    printf("END\n");
  }
  return 0;
}

Usage in ubuntu
./parser source.dat
