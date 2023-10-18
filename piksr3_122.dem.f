        PROGRAM D8R2
        use piksrt_dim, only : FMT,iFMT,read_file,I,J,A
C       Driver for routine PIKSR3_122
        implicit none
        interface
           SUBROUTINE piksr3_122(n,arr,bn,brr,cn,crr)
           INTEGER, intent(in) :: n,bn,cn,brr(n,bn),crr(n,cn)
           REAL, intent(in) :: arr(n)
           end subroutine
        end interface

        integer B,C
        INTEGER, PARAMETER :: X=6, Y=2, DIV=2
        DIMENSION B(X,Y),C(X,Y)
        call read_file
C       Generate B and C arrays
        DO I=1,X
           DO J=1,Y
              B(I,J)=I-1+J-1
              C(I,J)=(int(A(I))+B(I,J))/2+J-1
           ENDDO
        ENDDO
C       Print original arrays
        WRITE(*,*) 'Before sorting, array A is:'
        DO I=1,X/DIV
           WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
        enddo
        WRITE(*,*) '...and array B is:'
        DO I=1,X/DIV
           WRITE(*,iFMT) (B(DIV*(I-1)+J,:), J=1,DIV)
        enddo
        WRITE(*,*) '...and array C is:'
        DO I=1,X/DIV
           WRITE(*,iFMT) (C(DIV*(I-1)+J,:), J=1,DIV)
        enddo
        WRITE(*,*) 'press RETURN to continue...'
        READ(*,*)
C       Sort B and mix A,C
        CALL PIKSR3_122(X,A,Y,B,Y,C)
        WRITE(*,*) 'After sorting A and mixing B and C, array A is:'
        DO I=1,X/DIV
           WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
        enddo
        WRITE(*,*) '...and array B is:'
        DO I=1,X/DIV
           WRITE(*,iFMT) (B(DIV*(I-1)+J,:), J=1,DIV)
        enddo
        WRITE(*,*) '...and array C is:'
        DO I=1,X/DIV
           WRITE(*,iFMT) (C(DIV*(I-1)+J,:), J=1,DIV)
        enddo
        END
