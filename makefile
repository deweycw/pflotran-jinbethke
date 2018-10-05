#
# This is the master makefile for PFLOTRAN
#
#    makefile.inc is generated by ./configure 
include makefile.inc

TEST_LOG="${PFLOTRAN_DIR_LOC}/src/pflotran/test.log"
PFLOTRAN_EXE="${PFLOTRAN_DIR_LOC}/src/pflotran/pflotran"
PFLOTRAN_LIB="${PFLOTRAN_DIR_LOC}/src/pflotran/libpflotran.a"
PFLOTRANCHEM_LIB="${PFLOTRAN_DIR_LOC}/src/pflotran/libpflotranchem.a"

# build pflotran and libpflotran.a
all:
	@cd ${PFLOTRAN_DIR_LOC}/src/pflotran ;\
           make pflotran libpflotran.a libpflotranchem.a PETSC_DIR=${PETSC_DIR_LOC} PETSC_ARCH=${PETSC_ARCH_LOC} 2>&1 | tee make.log
	@if [ -e "${PFLOTRAN_EXE}" -a -e "${PFLOTRAN_LIB}" -a -e "${PFLOTRANCHEM_LIB}" ] ; then \
          echo "pflotran, libpflotran.a, and libpflotranchem.a successfully built." ;\
        else \
          echo "failed building pflotran, libpflotran.a, and/or libpflotranchem.a"; exit 1 ;\
        fi

clean:
	@cd ${PFLOTRAN_DIR_LOC}/src/pflotran ; make clean

check:
	-@cd ${PFLOTRAN_DIR_LOC}/src/pflotran; make check PETSC_DIR=${PETSC_DIR_LOC} PETSC_ARCH=${PETSC_ARCH_LOC} 2>&1 | tee -a test.log
	@if [ -e "$TEST_LOG" ]; then \
          PASSED=$(grep -c "Failed" $TEST_LOG) ;\
          echo $PASSED ;\
          if [ $PASSED -gt "0" ]; then \
             echo "PFLOTRAN test failed." ;\
          else \
             echo "PFLOTRAN test passed" ;\
         fi;\
       fi


install: all
	@if [ "${PREFIX_LOC}"  = "" ]; then \
           echo "PREFIX not set. Skipping installation." ; \
        else \
          echo "Installing PFLOTRAN at ${PREFIX_LOC}." ;\
          mkdir -p ${PREFIX_LOC} ;\
          mkdir -p ${PREFIX_LOC}/bin ;\
          mkdir -p ${PREFIX_LOC}/lib ;\
          mkdir -p ${PREFIX_LOC}/include ;\
          mkdir -p ${PREFIX_LOC}/share/pflotran ;\
          cp -f ${PFLOTRAN_EXE} ${PREFIX_LOC}/bin/. ;\
          cp -f ${PFLOTRAN_LIB} ${PREFIX_LOC}/lib/. ;\
          cp -f ${PFLOTRAN_DIR_LOC}/src/pflotran/*.mod ${PREFIX_LOC}/include/. ;\
          cp -f ${PFLOTRANCHEM_LIB} ${PREFIX_LOC}/lib/. ;\
          cp -Rf ${PFLOTRAN_DIR_LOC}/regression_tests ${PREFIX_LOC}/share/pflotran/. ;\
        fi

