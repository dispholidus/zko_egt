REPORT  zupload.

PARAMETERS:
  p_fname TYPE string LOWER CASE.

DATA:
  gt_content       TYPE STANDARD TABLE OF tdline,
  gt_content_final TYPE STANDARD TABLE OF tdline,
  len              TYPE i,
  xstr_content     TYPE xstring.

START-OF-SELECTION.

  "Upload the file to Internal Table
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = p_fname
      filetype                = 'BIN'
    IMPORTING
      filelength              = len
    TABLES
      data_tab                = gt_content
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE 'Unable to upload file' TYPE 'E'.
  ENDIF.

  "Convert binary itab to xstring
  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = len
*     FIRST_LINE   = 0
*     LAST_LINE    = 0
    IMPORTING
      buffer       = xstr_content
    TABLES
      binary_tab   = gt_content
    EXCEPTIONS
      failed       = 1
      OTHERS       = 2.
  IF sy-subrc <> 0.
    MESSAGE 'Unable to convert binary to xstring' TYPE 'E'.
  ENDIF.

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = xstr_content
    TABLES
      binary_tab = gt_content_final.


  BREAK-POINT.
