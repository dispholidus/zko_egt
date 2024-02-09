*&---------------------------------------------------------------------*
*& Include          Z_KEMALO_EX_EASY_011_FORM
*&---------------------------------------------------------------------*

FORM form1.
  WRITE : 'Burak'.
ENDFORM.

FORM form2.
  WRITE : 'yapar'.
ENDFORM.

FORM form3.
  WRITE : 'yazılım'.
ENDFORM.

FORM form4.
  WRITE : 'hiç'.
ENDFORM.

FORM form5.
  WRITE : 'ama'.
ENDFORM.

FORM form6.
  WRITE : 'zorlanıyor'.
ENDFORM.

FORM form7.
  WRITE : 'dillerinden'.
ENDFORM.

FORM form8.
  WRITE : 'için'.
ENDFORM.

FORM form9.
  WRITE : 'zor'.
ENDFORM.

FORM form10.
  WRITE : 'biraz'.
ENDFORM.

FORM form11.
  WRITE : 'değil'.
ENDFORM.

FORM form12.
  WRITE : 'isterse'.
ENDFORM.

FORM form13.
  WRITE : 'abap'.
ENDFORM.

* 1 13 3 10 6 5 3 7 13 1 8 4 9 11 /
* 1 10 12 2 / 1 3 7 13 3 9 11

FORM hepsini_yaz.
  perFORM form1.
  perform form13.
  perform form3.
  perform form10.
  perform form6.
  perform form5.
  perform form3.
  perform form7.
  perform form13.
  perform form1.
  perform form8.
  perform form4.
  perform form9.
  perform form11.
  write: / .
  perform form1.
  perform form10.
  perform form12.
  perform form2.
  write: / .
  perform form1.
  perform form3.
  perform form7.
  perform form13.
  perform form3.
  perform form9.
  perform form11.
  ENDFORM.
