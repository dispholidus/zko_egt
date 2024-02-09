*&---------------------------------------------------------------------*
*& Report ZKO_EGT_MAIL_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZKO_EGT_MAIL_001.

DATA: go_gbt       TYPE REF TO cl_gbt_multirelated_service,
      go_bcs       TYPE REF TO cl_bcs,
      go_doc_bcs   TYPE REF TO cl_document_bcs,
      go_recipient TYPE REF TO if_recipient_bcs,
      gt_soli      TYPE TABLE OF soli,
      gv_status    TYPE bcs_rqst,
      gv_content   TYPE string.


START-OF-SELECTION.

  CREATE OBJECT go_gbt.
  gv_content = 'TEST E-MAİL GÖNDERİM DENEME.'. "Mail Content
  gt_soli = cl_document_bcs=>string_to_soli( ip_string = gv_content ).


  CALL METHOD go_gbt->set_main_html
    EXPORTING
      content = gt_soli.
  go_doc_bcs = cl_document_bcs=>create_from_multirelated(
  i_subject          = 'TEST MAİL BAŞLIK' "Mail Başlık

  i_multirel_service = go_gbt
  ).

  go_recipient = cl_cam_address_bcs=>create_internet_address(
                   i_address_string = 'kemal.ozkan@vektora.com' "gönderilmek istenen e-mail adresi
               ).
  go_bcs = cl_bcs=>create_persistent( ).
  go_bcs->set_document( i_document = go_doc_bcs ).
  go_bcs->add_recipient( EXPORTING i_recipient = go_recipient ).

  gv_status = 'N'.
  CALL METHOD go_bcs->set_status_attributes
    EXPORTING
      i_requested_status = gv_status.

  go_bcs->send( ).
  COMMIT WORK.
