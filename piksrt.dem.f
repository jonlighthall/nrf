      PROGRAM D8R1
C     Driver for routine PIKSRT
      use piksrt_dim, only : DIV,FMT,I,J,X,A,piksrt,read_file
      implicit none
      call read_file
C     Print original array
      WRITE(*,*) 'Before sorting, array is:'
      DO I=1,X/DIV
         WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
      enddo
C     Sort array
      CALL PIKSRT(X,A)
C     Print sorted array
      WRITE(*,*) 'After sorting, array is:'
      DO I=1,X/DIV
         WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
      enddo
      END
