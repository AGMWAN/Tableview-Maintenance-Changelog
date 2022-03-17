* <HEADER>------------------------------------------------------------------------------------------+
* Date Time / Name Firstname (sy-uname)                    / Ticket: XXXXXX
* +-----------------------------------------------------------------------------------------</HEADER>

DATA: lo_view TYPE REF TO zcl_view_maintenance.
FIELD-SYMBOLS: <gs_structure> TYPE any.

FORM initialization.

  DATA(lv_viewname) = x_header-viewname.

  ASSIGN (lv_viewname) TO <gs_structure>.
  lo_view = NEW #( iv_viewname = CONV #( lv_viewname )
                   is_data = VALUE zst_view_maintenance(
                                      status = REF #( <status> )
                                      extract = REF #( extract[] )
                                      total = REF #( total[] )
                                      maint_mode = REF #( maint_mode )
                                      vim_total_struc = REF #( <vim_total_struc> )
                                   )
  ).

  lo_view->show_docu( ).

ENDFORM.

FORM add_record.

  lo_view->changelog( EXPORTING iv_new = abap_true CHANGING cs_record = <gs_structure> ).

ENDFORM.

FORM fill_hidden_fields.

  lo_view->changelog( CHANGING cs_record = <gs_structure> ).

ENDFORM.

FORM at_leave.

  CHECK lo_view IS NOT INITIAL.
  lo_view->exit( ).

ENDFORM.