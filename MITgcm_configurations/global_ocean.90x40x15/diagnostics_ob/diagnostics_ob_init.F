#include "DIAGNOSTICS_OB_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C !ROUTINE: DIAGNOSTICS_OB_INIT

C !INTERFACE:
      SUBROUTINE DIAGNOSTICS_OB_INIT( myThid )

C     !DESCRIPTION:
C     Initialize list of all available diagnostics

C     !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#include "DIAGNOSTICS_OB.h"

C     !INPUT/OUTPUT PARAMETERS:
C     myThid ::  my Thread Id number
      INTEGER myThid
CEOP

#ifdef ALLOW_DIAGNOSTICS
C     !LOCAL VARIABLES:
C     === Local variables ===
C     diagNum   :: diagnostics number in the (long) list of available diag.
C     diagMate  :: diag. mate number in the (long) list of available diag.
C     diagName  :: local short name (8c) of a diagnostics
C     diagCode  :: local parser field with characteristics of the diagnostics
C              cf head of S/R DIAGNOSTICS_INIT_EARLY or DIAGNOSTICS_MAIN_INIT
C     diagUnits :: local string (16c): physical units of a diagnostic field
C     diagTitle :: local string (80c): description of field in diagnostic
      INTEGER       diagNum
      INTEGER       diagMate
      CHARACTER*8   diagName
      CHARACTER*16  diagCode
      CHARACTER*16  diagUnits
      CHARACTER*80  diagTitle

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

c     IF ( useDiagnotics ) THEN

        diagName = ''
        diagCode = ''
        diagUnits = ''
        diagTitle = ''

        diagName  = 'diOBSta1'
        diagTitle =
     &        'Scalar state variable 1 for package diagnostics_ob'
        diagUnits = 'unit            '
        diagCode  = 'SM      MR      '
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I          diagName, diagCode, diagUnits, diagTitle, 0, myThid )

        diagName  = 'diOBSta2'
        diagTitle =
     &        'Scalar state variable 2 for package diagnostics_ob'
        diagUnits = 'unit            '
        diagCode  = 'SM      MR      '
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I          diagName, diagCode, diagUnits, diagTitle, 0, myThid )

        diagName  = 'diOBStaU'
        diagTitle =
     &        'uVel-type state variable for package diagnostics_ob'
        diagUnits = 'unit            '
        diagCode  = 'UM      MR      '
        diagMate  = diagNum + 2
        IF ( diagOB_StaV_Cgrid ) diagCode(2:2) = 'U'
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I   diagName, diagCode, diagUnits, diagTitle, diagMate, myThid )

        diagName  = 'diOBStaV'
        diagTitle =
     &        'vVel-type state variable for package diagnostics_ob'
        diagUnits = 'unit            '
        diagCode  = 'VM      MR      '
        diagMate  = diagNum
        IF ( diagOB_StaV_Cgrid ) diagCode(2:2) = 'V'
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I   diagName, diagCode, diagUnits, diagTitle, diagMate, myThid )

        diagName  = 'diOBSur1'
        diagTitle = 'Surface field 1 for package diagnostics_ob'
        diagUnits = 'unit            '
        diagCode  = 'SM      L1      '
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I          diagName, diagCode, diagUnits, diagTitle, 0, myThid )

        diagName  = 'diOBSur2'
        diagTitle = 'Surface field 2 for package diagnostics_ob'
        diagUnits = 'unit            '
        diagCode  = 'SM      L1      '
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I          diagName, diagCode, diagUnits, diagTitle, 0, myThid )

        diagName  = 'diOBdTdt'
        diagTitle = ' Pot.Temp. tendency from package diagnostics_ob'
        diagUnits = 'K/s             '
        diagCode  = 'SMR     MR      '
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I          diagName, diagCode, diagUnits, diagTitle, 0, myThid )

        diagName  = 'diOBdSdt'
        diagTitle = ' Salinity  tendency from package diagnostics_ob'
        diagUnits = 'psu/s           '
        diagCode  = 'SMR     MR      '
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I          diagName, diagCode, diagUnits, diagTitle, 0, myThid )

        diagName  = 'diOBdUdt'
        diagTitle = 'u-Velocity tendency from package diagnostics_ob'
        diagUnits = 'm/s^2           '
        diagCode  = 'UMR     MR      '
        diagMate  = diagNum + 2
        IF ( diagOB_Tend_Cgrid ) diagCode(2:2) = 'U'
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I   diagName, diagCode, diagUnits, diagTitle, diagMate, myThid )

        diagName  = 'diOBdVdt'
        diagTitle = 'v-Velocity tendency from package diagnostics_ob'
        diagUnits = 'm/s^2           '
        diagCode  = 'VMR     MR      '
        diagMate  = diagNum
        IF ( diagOB_Tend_Cgrid ) diagCode(2:2) = 'V'
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I   diagName, diagCode, diagUnits, diagTitle, diagMate, myThid )

C--     an example of how to set "free levels option" diagnostics
        diagName  = 'diOBLev3'
        diagTitle = '3-levels field for package diagnostics_ob'
        diagUnits = 'unit            '
        diagCode  = 'SM      MX      '
        CALL DIAGNOSTICS_ADDTOLIST( diagNum,
     I          diagName, diagCode, diagUnits, diagTitle, 0, myThid )
        CALL DIAGNOSTICS_SETKLEV( diagName, 3, myThid )

c     ENDIF

#endif /* ALLOW_DIAGNOSTICS */

      RETURN
      END
