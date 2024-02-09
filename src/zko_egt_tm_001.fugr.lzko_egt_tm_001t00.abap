*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZKO_EGT_T_DEPBLG................................*
DATA:  BEGIN OF STATUS_ZKO_EGT_T_DEPBLG              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZKO_EGT_T_DEPBLG              .
CONTROLS: TCTRL_ZKO_EGT_T_DEPBLG
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZKO_EGT_T_ODUL..................................*
DATA:  BEGIN OF STATUS_ZKO_EGT_T_ODUL                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZKO_EGT_T_ODUL                .
CONTROLS: TCTRL_ZKO_EGT_T_ODUL
            TYPE TABLEVIEW USING SCREEN '0003'.
*...processing: ZKO_EGT_T_TTLBLG................................*
DATA:  BEGIN OF STATUS_ZKO_EGT_T_TTLBLG              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZKO_EGT_T_TTLBLG              .
CONTROLS: TCTRL_ZKO_EGT_T_TTLBLG
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZKO_EGT_T_DEPBLG              .
TABLES: *ZKO_EGT_T_ODUL                .
TABLES: *ZKO_EGT_T_TTLBLG              .
TABLES: ZKO_EGT_T_DEPBLG               .
TABLES: ZKO_EGT_T_ODUL                 .
TABLES: ZKO_EGT_T_TTLBLG               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
