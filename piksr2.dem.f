        PROGRAM D8R2
C       Driver for routine PIKSR2
        use piksrt_dim, only : DIV,FMT,I,J,X,A,piksr2,read_file,iFMT
        implicit none
        integer B
        real Br
        DIMENSION B(X),Br(X)
        call read_file
C       Generate B array
        DO I=1,X
           B(I)=I
        enddo
C       Sort A and mix B
        Br=real(B)
        CALL PIKSR2(X,A,Br)
        WRITE(*,*) 'After sorting A and mixing B, array A is:'
        DO I=1,X/DIV
           WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
        enddo
        WRITE(*,*) '...and array B is:'
        DO I=1,X/DIV
           WRITE(*,iFMT) (B(DIV*(I-1)+J), J=1,DIV)
        enddo
        WRITE(*,*) 'press RETURN to continue...'
        READ(*,*)
C       Sort B and mix A
        Br=real(B)
        CALL PIKSR2(X,Br,A)
        WRITE(*,*) 'After sorting B and mixing A, array A is:'
        DO I=1,X/DIV
           WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
        enddo
        WRITE(*,*) '...and array B is:'
        DO I=1,X/DIV
           WRITE(*,iFMT) (B(DIV*(I-1)+J), J=1,DIV)
        enddo
        END
