












C     *==========================================================*
C     | SBO_OPTIONS.h
C     | o CPP options file for SBO package.
C     *==========================================================*
C     | Use this file for selecting options within the SBO
C     | package.
C     *==========================================================*








CBOP
C !ROUTINE: CPP_OPTIONS.h
C !INTERFACE:
C #include "CPP_OPTIONS.h"

C !DESCRIPTION:
C *==================================================================*
C | main CPP options file for the model:
C | Control which optional features to compile in model/src code.
C *==================================================================*
CEOP

C CPP flags controlling particular source code features

C-- Forcing code options:

C o Shortwave heating as extra term in external_forcing.F
C Note: this should be a run-time option

C o Include/exclude Geothermal Heat Flux at the bottom of the ocean

C o Allow to account for heating due to friction (and momentum dissipation)

C o Allow mass source or sink of Fluid in the interior
C   (3-D generalisation of oceanic real-fresh water flux)

C o Include pressure loading code

C o Include/exclude balancing surface forcing fluxes code

C o Include/exclude balancing surface forcing relaxation code

C o Include/exclude checking for negative salinity

C-- Options to discard parts of the main code:

C o Exclude/allow external forcing-fields load
C   this allows to read & do simple linear time interpolation of oceanic
C   forcing fields, if no specific pkg (e.g., EXF) is used to compute them.

C o Include/exclude phi_hyd calculation code

C-- Vertical mixing code options:

C o Include/exclude call to S/R CONVECT

C o Include/exclude call to S/R CALC_DIFFUSIVITY

C o Allow full 3D specification of vertical diffusivity

C o Allow latitudinally varying BryanLewis79 vertical diffusivity

C o Exclude/allow partial-cell effect (physical or enhanced) in vertical mixing
C   this allows to account for partial-cell in vertical viscosity and diffusion,
C   either from grid-spacing reduction effect or as artificially enhanced mixing
C   near surface & bottom for too thin grid-cell

C-- Time-stepping code options:

C o Include/exclude combined Surf.Pressure and Drag Implicit solver code

C o Include/exclude Implicit vertical advection code

C o Include/exclude AdamsBashforth-3rd-Order code

C-- Model formulation options:

C o Allow/exclude "Exact Convervation" of fluid in Free-Surface formulation
C   that ensures that d/dt(eta) is exactly equal to - Div.Transport

C o Allow the use of Non-Linear Free-Surface formulation
C   this implies that grid-cell thickness (hFactors) varies with time

C o Include/exclude nonHydrostatic code

C o Include/exclude GM-like eddy stress in momentum code

C-- Algorithm options:

C o Use Non Self-Adjoint (NSA) conjugate-gradient solver

C o Include/exclude code for single reduction Conjugate-Gradient solver

C o Choices for implicit solver routines solve_*diagonal.F
C   The following has low memory footprint, but not suitable for AD
C   The following one suitable for AD but does not vectorize

C-- Retired code options:

C o Use LONG.bin, LATG.bin, etc., initialization for ini_curviliear_grid.F
C   Default is to use "new" grid files (OLD_GRID_IO undef) but OLD_GRID_IO
C   is still useful with, e.g., single-domain curvilinear configurations.

C-- Other option files:

C o Execution environment support options
CBOP
C     !ROUTINE: CPP_EEOPTIONS.h
C     !INTERFACE:
C     include "CPP_EEOPTIONS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP\_EEOPTIONS.h                                         |
C     *==========================================================*
C     | C preprocessor "execution environment" supporting        |
C     | flags. Use this file to set flags controlling the        |
C     | execution environment in which a model runs - as opposed |
C     | to the dynamical problem the model solves.               |
C     | Note: Many options are implemented with both compile time|
C     |       and run-time switches. This allows options to be   |
C     |       removed altogether, made optional at run-time or   |
C     |       to be permanently enabled. This convention helps   |
C     |       with the data-dependence analysis performed by the |
C     |       adjoint model compiler. This data dependency       |
C     |       analysis can be upset by runtime switches that it  |
C     |       is unable to recoginise as being fixed for the     |
C     |       duration of an integration.                        |
C     |       A reasonable way to use these flags is to          |
C     |       set all options as selectable at runtime but then  |
C     |       once an experimental configuration has been        |
C     |       identified, rebuild the code with the appropriate  |
C     |       options set at compile time.                       |
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C=== Macro related options ===
C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working set size.
C     However, on vector CRAY systems this degrades performance.
C     Enable to switch REAL4_IS_SLOW from genmake2 (with LET_RS_BE_REAL4):

C--   Control use of "double" precision constants.
C     Use D0 where it means REAL*8 but not where it means REAL*16

C--   Enable some old macro conventions for backward compatibility

C=== IO related options ===
C--   Flag used to indicate whether Fortran formatted write
C     and read are threadsafe. On SGI the routines can be thread
C     safe, on Sun it is not possible - if you are unsure then
C     undef this option.

C--   Flag used to indicate whether Binary write to Local file (i.e.,
C     a different file for each tile) and read are thread-safe.

C--   Flag to turn off the writing of error message to ioUnit zero

C--   Alternative formulation of BYTESWAP, faster than
C     compiler flag -byteswapio on the Altix.

C--   Flag to turn on old default of opening scratch files with the
C     STATUS='SCRATCH' option. This method, while perfectly FORTRAN-standard,
C     caused filename conflicts on some multi-node/multi-processor platforms
C     in the past and has been replace by something (hopefully) more robust.

C--   Flag defined for eeboot_minimal.F, eeset_parms.F and open_copy_data_file.F
C     to write STDOUT, STDERR and scratch files from process 0 only.
C WARNING: to use only when absolutely confident that the setup is working
C     since any message (error/warning/print) from any proc <> 0 will be lost.

C=== MPI, EXCH and GLOBAL_SUM related options ===
C--   Flag turns off MPI_SEND ready_to_receive polling in the
C     gather_* subroutines to speed up integrations.

C--   Control MPI based parallel processing
CXXX We no longer select the use of MPI via this file (CPP_EEOPTIONS.h)
CXXX To use MPI, use an appropriate genmake2 options file or use
CXXX genmake2 -mpi .
CXXX #undef  1

C--   Control use of communication that might overlap computation.
C     Under MPI selects/deselects "non-blocking" sends and receives.
C--   Control use of communication that is atomic to computation.
C     Under MPI selects/deselects "blocking" sends and receives.

C--   Control XY periodicity in processor to grid mappings
C     Note: Model code does not need to know whether a domain is
C           periodic because it has overlap regions for every box.
C           Model assume that these values have been
C           filled in some way.

C--   disconnect tiles (no exchange between tiles, just fill-in edges
C     assuming locally periodic subdomain)

C--   Always cumulate tile local-sum in the same order by applying MPI allreduce
C     to array of tiles ; can get slower with large number of tiles (big set-up)

C--   Alternative way of doing global sum without MPI allreduce call
C     but instead, explicit MPI send & recv calls. Expected to be slower.

C--   Alternative way of doing global sum on a single CPU
C     to eliminate tiling-dependent roundoff errors. Note: This is slow.

C=== Other options (to add/remove pieces of code) ===
C--   Flag to turn on checking for errors from all threads and procs
C     (calling S/R STOP_IF_ERROR) before stopping.

C--   Control use of communication with other component:
C     allow to import and export from/to Coupler interface.

C--   Activate some pieces of code for coupling to GEOS AGCM


CBOP
C     !ROUTINE: CPP_EEMACROS.h
C     !INTERFACE:
C     include "CPP_EEMACROS.h"
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP_EEMACROS.h
C     *==========================================================*
C     | C preprocessor "execution environment" supporting
C     | macros. Use this file to define macros for  simplifying
C     | execution environment in which a model runs - as opposed
C     | to the dynamical problem the model solves.
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C     Flag used to indicate which flavour of multi-threading
C     compiler directives to use. Only set one of these.
C     USE_SOLARIS_THREADING  - Takes directives for SUN Workshop
C                              compiler.
C     USE_KAP_THREADING      - Takes directives for Kuck and
C                              Associates multi-threading compiler
C                              ( used on Digital platforms ).
C     USE_IRIX_THREADING     - Takes directives for SGI MIPS
C                              Pro Fortran compiler.
C     USE_EXEMPLAR_THREADING - Takes directives for HP SPP series
C                              compiler.
C     USE_C90_THREADING      - Takes directives for CRAY/SGI C90
C                              system F90 compiler.






C--   Define the mapping for the _BARRIER macro
C     On some systems low-level hardware support can be accessed through
C     compiler directives here.

C--   Define the mapping for the BEGIN_CRIT() and  END_CRIT() macros.
C     On some systems we simply execute this section only using the
C     master thread i.e. its not really a critical section. We can
C     do this because we do not use critical sections in any critical
C     sections of our code!

C--   Define the mapping for the BEGIN_MASTER_SECTION() and
C     END_MASTER_SECTION() macros. These are generally implemented by
C     simply choosing a particular thread to be "the master" and have
C     it alone execute the BEGIN_MASTER..., END_MASTER.. sections.

CcnhDebugStarts
C      Alternate form to the above macros that increments (decrements) a counter each
C      time a MASTER section is entered (exited). This counter can then be checked in barrier
C      to try and detect calls to BARRIER within single threaded sections.
C      Using these macros requires two changes to Makefile - these changes are written
C      below.
C      1 - add a filter to the CPP command to kill off commented _MASTER lines
C      2 - add a filter to the CPP output the converts the string N EWLINE to an actual newline.
C      The N EWLINE needs to be changes to have no space when this macro and Makefile changes
C      are used. Its in here with a space to stop it getting parsed by the CPP stage in these
C      comments.
C      #define IF ( a .EQ. 1 ) THEN  IF ( a .EQ. 1 ) THEN  N EWLINE      CALL BARRIER_MS(a)
C      #define ENDIF    CALL BARRIER_MU(a) N EWLINE        ENDIF
C      'CPP = cat $< | $(TOOLSDIR)/set64bitConst.sh |  grep -v '^[cC].*_MASTER' | cpp  -traditional -P'
C      .F.f:
C      $(CPP) $(DEFINES) $(INCLUDES) |  sed 's/N EWLINE/\n/' > $@
CcnhDebugEnds

C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working
C     set size. However, on vector CRAY systems this degrades
C     performance.
C- Note: global_sum/max macros were used to switch to  JAM routines (obsolete);
C  in addition, since only the R4 & R8 S/R are coded, GLOBAL RS & RL macros
C  enable to call the corresponding R4 or R8 S/R.



C- Note: a) exch macros were used to switch to  JAM routines (obsolete)
C        b) exch R4 & R8 macros are not practically used ; if needed,
C           will directly call the corrresponding S/R.

C--   Control use of JAM routines for Artic network (no longer supported)
C     These invoke optimized versions of "exchange" and "sum" that
C     utilize the programmable aspect of Artic cards.
CXXX No longer supported ; started to remove JAM routines.
CXXX #ifdef LETS_MAKE_JAM
CXXX #define CALL GLOBAL_SUM_R8 ( a, b) CALL GLOBAL_SUM_R8_JAM ( a, b)
CXXX #define CALL GLOBAL_SUM_R8 ( a, b ) CALL GLOBAL_SUM_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RS ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RL ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RS ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RL ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #endif

C--   Control use of "double" precision constants.
C     Use d0 where it means REAL*8 but not where it means REAL*16

C--   Substitue for 1.D variables
C     Sun compilers do not use 8-byte precision for literals
C     unless .Dnn is specified. CRAY vector machines use 16-byte
C     precision when they see .Dnn which runs very slowly!

C--   Set the format for writing processor IDs, e.g. in S/R eeset_parms
C     and S/R open_copy_data_file. The default of I9.9 should work for
C     a long time (until we will use 10e10 processors and more)



C o Include/exclude single header file containing multiple packages options
C   (AUTODIFF, COST, CTRL, ECCO, EXF ...) instead of the standard way where
C   each of the above pkg get its own options from its specific option file.
C   Although this method, inherited from ECCO setup, has been traditionally
C   used for all adjoint built, work is in progress to allow to use the
C   standard method also for adjoint built.
c#ifdef 
c# include "ECCO_CPPOPTIONS.h"
c#endif


C     Package-specific Options & Macros go here



      Real*8 FUNCTION SBO_RHO( DPT, LAT, S, T )
C     /==========================================================C     | Real*8 FUNCTION SBO_RHO                                     |
C     | o Compute density for SBO package.                       |
C     |==========================================================|
C     | CHECK VALUE:                                             |
C     | DPT=5000; LAT=30; S=30; T=30; SBO_RHO=1038.298           |
C     \==========================================================/
      IMPLICIT NONE

C     == Routine arguments ==
C     SBO_RHO - density (kg/m^3)
C     DPT     - depth (m)
C     LAT     - latitude north (deg)
C     S       - salinity (PSU)
C     T       - potential temperature (deg C)
      
      Real*8 DPT,LAT,S,T

      Real*8 PLAT,D,C1,P,PR,Q,X,SR,V350P,B

      Real*8 PI
      PARAMETER ( PI    = 3.14159265358979323844d0   )
      
C     First convert depth to pressure
C     Ref: Saunders, "Practical Conversion of Pressure to Depth",
C     J. Phys. Oceanog., April 1981.
C     CHECK VALUE: P80=7500.004 DBARS;FOR LAT=30 DEG., DEPTH=7321.45 METERS

      PLAT=abs(LAT*pi/180.)
      D=sin(PLAT)
      C1=5.92E-3+(D*D)*5.25E-3
      P=((1-C1)-sqrt(((1-C1)**2)-(8.84E-6*abs(DPT))))/4.42E-6

C     Second convert temperature from potential to in situ
C     REF: BRYDEN,H.,1973,DEEP-SEA RES.,20,401-408
C     FOFONOFF,N.,1977,DEEP-SEA RES.,24,489-491
C     CHECKVALUE: THETA= 36.89073 C,S=40 (IPSS-78),T0=40 DEG C,
C     P0=10000 DECIBARS,PR=0 DECIBARS
      
      PR = P
      P  = 0.
      Q = PR*((((-2.1687E-16*T+1.8676E-14)*T-4.6206E-13)*P+
     &     ((2.7759E-12*T-1.1351E-10)*(S-35.0)+
     &     ((-5.4481E-14*T+8.733E-12)*T-6.7795E-10)*T+
     &     1.8741E-8))*P+(-4.2393E-8*T+1.8932E-6)*(S-35.0)+
     &     ((6.6228E-10*T-6.836E-8)*T+8.5258E-6)*T+3.5803E-5)
      
      T = T + 0.5*Q
      P = P + 0.5*PR
      x = PR*((((-2.1687E-16*T+1.8676E-14)*T-4.6206E-13)*P+
     &     ((2.7759E-12*T-1.1351E-10)*(S-35.0)+
     &     ((-5.4481E-14*T+8.733E-12)*T-6.7795E-10)*T+
     &     1.8741E-8))*P+(-4.2393E-8*T+1.8932E-6)*(S-35.0)+
     &     ((6.6228E-10*T-6.836E-8)*T+8.5258E-6)*T+3.5803E-5)
      
      T = T + 0.29289322*(x-Q)
      Q = 0.58578644*x + 0.121320344*Q
      x = PR*((((-2.1687E-16*T+1.8676E-14)*T-4.6206E-13)*P+
     &     ((2.7759E-12*T-1.1351E-10)*(S-35.0)+
     &     ((-5.4481E-14*T+8.733E-12)*T-6.7795E-10)*T+
     &     1.8741E-8))*P+(-4.2393E-8*T+1.8932E-6)*(S-35.0)+
     &     ((6.6228E-10*T-6.836E-8)*T+8.5258E-6)*T+3.5803E-5)
      
      T = T + 1.707106781*(x-Q)
      Q = 3.414213562*x - 4.121320344*Q
      P = P + 0.5*PR 
      x = PR*((((-2.1687E-16*T+1.8676E-14)*T-4.6206E-13)*P+
     &     ((2.7759E-12*T-1.1351E-10)*(S-35.0)+
     &     ((-5.4481E-14*T+8.733E-12)*T-6.7795E-10)*T+
     &     1.8741E-8))*P+(-4.2393E-8*T+1.8932E-6)*(S-35.0)+
     &     ((6.6228E-10*T-6.836E-8)*T+8.5258E-6)*T+3.5803E-5)
      T = T + (x-2.0*Q)/6.0

C     Third compute density
C     BASED ON 1980 EQUATION
C     OF STATE FOR SEAWATER AND 1978 PRACTICAL SALINITY SCALE.
C     REFERENCES
C     MILLERO, ET AL (1980) DEEP-SEA RES.,27A,255-264
C     MILLERO AND POISSON 1981,DEEP-SEA RES.,28A PP 625-629.
C     BOTH ABOVE REFERENCES ARE ALSO FOUND IN UNESCO REPORT 38 (1981)
C     CHECK VALUE: SIGMA = 59.82037  KG/M**3 FOR S = 40 (IPSS-78) ,
C     T = 40 DEG C, P0= 10000 DECIBARS.

C     CONVERT PRESSURE TO BARS AND TAKE SQUARE ROOT SALINITY.
      P=P/10.
      SR = sqrt(abs(S))

C     INTERNATIONAL ONE-ATMOSPHERE EQUATION OF STATE OF SEAWATER
      x = (4.8314E-4 * S +
     &     ((-1.6546E-6*T+1.0227E-4)*T-5.72466E-3) * SR +
     &     (((5.3875E-9*T-8.2467E-7)*T+7.6438E-5)*T-4.0899E-3)*T
     &     +8.24493E-1)*S + ((((6.536332E-9*T-1.120083E-6)
     &     *T+1.001685E-4)*T-9.095290E-3)*T+6.793952E-2)*T-28.263737
      
C     SPECIFIC VOLUME AT ATMOSPHERIC PRESSURE
      V350P = 1.0/1028.1063
      x = -x*V350P/(1028.1063+x)

C     COMPUTE COMPRESSION TERMS
      SR = ((((9.1697E-10*T+2.0816E-8)*T-9.9348E-7) * S + 
     &     (5.2787E-8*T-6.12293E-6)*T+3.47718E-5) *P + 
     &     (1.91075E-4 * SR + (-1.6078E-6*T-1.0981E-5)*T+2.2838E-3) * 
     &     S + ((-5.77905E-7*T+1.16092E-4)*T+1.43713E-3)*T-0.1194975) 
     &     *P + (((-5.3009E-4*T+1.6483E-2)*T+7.944E-2) * SR + 
     &     ((-6.1670E-5*T+1.09987E-2)*T-0.603459)*T+54.6746) * S + 
     &     (((-5.155288E-5*T+1.360477E-2)*T-2.327105)*T+148.4206)*T -
     &     1930.06
      
C     EVALUATE PRESSURE POLYNOMIAL
      B  = (5.03217E-5*P+3.359406)*P+21582.27
      x = x*(1.0 - P/B) + (V350P+x)*P*SR/(B*(B+SR))
      SR = V350P*(1.0 - P/B)
      SBO_RHO = 1028.106331 + P/B/SR - x / (SR*(SR+x))

      RETURN
      END
