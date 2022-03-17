  METHOD show_docu.

    DATA: lv_typekind TYPE ddtypekind,
          ls_head     TYPE thead,
          lt_lines    TYPE TABLE OF tline,
          lt_html     TYPE STANDARD TABLE OF htmlline,
          lv_url      TYPE c.

    IF mo_docking_container IS INITIAL.

      CALL FUNCTION 'DDIF_TYPEINFO_GET'
        EXPORTING
          typename = CONV typename( mv_viewname )
        IMPORTING
          typekind = lv_typekind.

      DATA(lv_id) = SWITCH doku_id( lv_typekind WHEN 'VIEW' THEN 'VW' WHEN 'TABL' THEN 'TB' ).

      CALL FUNCTION 'DOCU_GET'
        EXPORTING
          id     = lv_id
          langu  = sy-langu
          object = CONV doku_obj( mv_viewname )
        IMPORTING
          head   = ls_head
        TABLES
          line   = lt_lines
        EXCEPTIONS
          OTHERS = 1.

      DATA(lv_size) = COND i( WHEN lines( lt_lines ) = '0' THEN 0 ELSE '400' ).

      mo_docking_container = NEW #( side = cl_gui_docking_container=>dock_at_right extension = lv_size no_autodef_progid_dynnr = abap_true ).

      IF lt_lines IS INITIAL.

        mo_html_viewer = NEW #( parent = mo_docking_container ).

        CALL FUNCTION 'CONVERT_ITF_TO_HTML'
          EXPORTING
            i_header       = ls_head
          TABLES
            t_itf_text     = lt_lines
            t_html_text    = lt_html
          EXCEPTIONS
            syntax_check   = 1
            replace        = 2
            illegal_header = 3
            OTHERS         = 4.

        IF sy-subrc IS INITIAL.
          mo_html_viewer->load_data( IMPORTING assigned_url = lv_url CHANGING data_table = lt_html EXCEPTIONS OTHERS = 4 ).
          IF sy-subrc IS INITIAL.
            mo_html_viewer->show_url( EXPORTING url = lv_url ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.