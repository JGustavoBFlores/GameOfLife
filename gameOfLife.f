      PROGRAM GAMEOFLIFE
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER (iter=30, ixwidth=20, iywidth=20) !iterations and grid size
      LOGICAL, DIMENSION(0:ixwidth+1,0:iywidth+1) :: old,new
      INTEGER, DIMENSION(  ixwidth  ,  iywidth  ) :: mOut
      CHARACTER(12) frmt
      CHARACTER(8 ) files(iter)


C Create data files to save the iterations      
      CALL dataFiles(iter,files)
C Create a special format according to the height of the grid
      CALL frmtWrttr(frmt,ixwidth)

C Lets set every cell to be DEAD (0) in both matrices
      new=.FALSE. 
      old=.FALSE. 
      if(any(old))STOP'what?'

C Here we must define what cells are alive
C Eventually, subroutines to fill coordinates
C should be written, specially to build
C specific structures

C For now lets write a beacon:

      old(5,7)=.TRUE.
      old(5,8)=.TRUE.
      old(6,8)=.TRUE.
      old(7,5)=.TRUE.
      old(8,5)=.TRUE.
      old(8,6)=.TRUE.
    
C Now lets write a glider:
      old=.FALSE.
  
      old(1,15)=.TRUE.
      old(2,15)=.TRUE.
      old(3,15)=.TRUE.
      old(2,17)=.TRUE.
      old(3,16)=.TRUE.
   
C We gotta run through iter iterations
      DO K=1,iter
      IF(K.EQ.1)GOTO 212
C Loop through the whole grid
      DO I=1,ixwidth
      DO J=1,iywidth

       nCntr=0 !Counter of live neighbors
        DO i1=I-1,I+1 !loop around the neighbors
        DO j1=J-1,J+1 
         IF(old(i1,j1)) nCntr = nCntr+1
        END DO
        END DO
        IF(old(I,J))THEN !ALIVE cell (1)
         nCntr=nCntr-1   !substract one because we
                         !counted it on the previous
                         ! loop
         IF((nCntr.EQ.2).OR.(nCntr.EQ.3)) THEN !survival
          new(I,J)=.TRUE.
         ELSE                                  !death
          new(I,J)=.FALSE.
         END IF
        ELSE !DEAD cell (0)                              
         IF(                (nCntr.EQ.3)) THEN !reproduction
          new(I,J)=.TRUE.
         ELSE !stay dead
          new(I,J)=.FALSE.
         END IF
        END IF 
      END DO
      END DO      

C Time to save result to the old matrix to repeat the steps
C and also write a binary matrix of 0's and 1's to plot
      old=new
 212  CONTINUE     
      mOut=0
      OPEN(UNIT=1,FILE=files(K))
       DO I=1,ixwidth
        DO J=1,iywidth
         IF(old(I,J))mOut(I,J)=1
        END DO
       END DO

       DO I=1,iywidth !This will write the matrix upside down
                      !but is alright because gnuplot will flip it again
        WRITE(1,frmt) (mOut(J,I),J=1,ixwidth)
       END DO
      CLOSE(1) 
      END DO

      CALL SYSTEM('mkdir library')
      CALL SYSTEM('mv data* library/.')
      END PROGRAM

C This subroutine creates N data files named data####
C  and moves them to a directory called library
      SUBROUTINE dataFiles(N,files)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER(8) files(N)
      OPEN(UNIT=2,FILE='listOfFiles')
      DO I=1,N
       WRITE(files(i),'(A,I4.4)') 'data',I
       WRITE(2,'(2A)') 'library/',files(I)
      END DO
      END SUBROUTINE
C This subroutine creates a format named frmt
C  so we can read/write our matrix to a file
      SUBROUTINE frmtWrttr(frmt,N)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*12  frmt
      WRITE(frmt,'(I4.4)')N
      frmt=TRIM(frmt)//TRIM('(I1,X)')
      frmt=TRIM('(')//TRIM(frmt)
      frmt=TRIM(frmt)//TRIM(')')
      END SUBROUTINE
