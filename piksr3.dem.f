        PROGRAM D8R2
C       Driver for routine PIKSR3
        use piksrt_dim, only : DIV,FMT,I,J,X,A,piksr3,read_file,iFMT
        implicit none
        integer B,C
        real Br,Cr
        DIMENSION B(X),C(X),Br(X),Cr(X)
        call read_file
C       Generate B and C arrays
        DO I=1,X
           B(I)=I
           C(I)=(int(A(I))+B(I))/2
        enddo
C       Sort A and mix B,C
        Br=real(B)
        Cr=real(C)
        CALL PIKSR3(X,A,Br,Cr)
        WRITE(*,*) 'After sorting A and mixing B and C, array A is:'
        DO I=1,X/DIV
           WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
        enddo
        WRITE(*,*) '...and array B is:'
        DO I=1,X/DIV
           WRITE(*,iFMT) (B(DIV*(I-1)+J), J=1,DIV)
        enddo
        WRITE(*,*) '...and array C is:'
        DO I=1,X/DIV
           WRITE(*,iFMT) (C(DIV*(I-1)+J), J=1,DIV)
        enddo
        WRITE(*,*) 'press RETURN to continue...'
        READ(*,*)
C       Sort B and mix A,C
        Br=real(B)
        Cr=real(C)
        CALL PIKSR3(X,Br,A,Cr)
        WRITE(*,*) 'After sorting B and mixing A and C, array A is:'
        DO I=1,X/DIV
           WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
        enddo
        WRITE(*,*) '...and array B is:'
        DO I=1,X/DIV
           WRITE(*,iFMT) (B(DIV*(I-1)+J), J=1,DIV)
        enddo
        WRITE(*,*) '...and array C is:'
        DO I=1,X/DIV
           WRITE(*,iFMT) (C(DIV*(I-1)+J), J=1,DIV)
        enddo
        END
