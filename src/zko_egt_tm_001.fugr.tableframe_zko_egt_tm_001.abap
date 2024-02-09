*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZKO_EGT_TM_001
*   generation date: 28.07.2023 at 11:21:35
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZKO_EGT_TM_001     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
