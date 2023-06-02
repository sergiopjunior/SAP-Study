*&---------------------------------------------------------------------*
*& Report ZPR_SP_DATA_EXTRACTOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpr_sp_data_extractor.

SELECT land1,
        regio,
        cityc,
        bezei
  FROM t005h
  INTO TABLE @DATA(gt_city)
  WHERE spras = 'E'.

DATA(gt_csv) = VALUE string_table( FOR <lfw_city> IN gt_city
                                  (
                                   |{ <lfw_city>-land1 };{ <lfw_city>-regio };{ <lfw_city>-cityc };{ <lfw_city>-bezei }|
                                  )
                                  ).

DATA(lv_path) = |C:\\Users\\Sérgio Henrique\\Desktop\\data.csv|.
CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
    filename                        = lv_path
    CODEPAGE                        = '4110'
  tables
    data_tab                        = gt_csv
 EXCEPTIONS
   FILE_WRITE_ERROR                = 1
   NO_BATCH                        = 2
   GUI_REFUSE_FILETRANSFER         = 3
   INVALID_TYPE                    = 4
   NO_AUTHORITY                    = 5
   UNKNOWN_ERROR                   = 6
   HEADER_NOT_ALLOWED              = 7
   SEPARATOR_NOT_ALLOWED           = 8
   FILESIZE_NOT_ALLOWED            = 9
   HEADER_TOO_LONG                 = 10
   DP_ERROR_CREATE                 = 11
   DP_ERROR_SEND                   = 12
   DP_ERROR_WRITE                  = 13
   UNKNOWN_DP_ERROR                = 14
   ACCESS_DENIED                   = 15
   DP_OUT_OF_MEMORY                = 16
   DISK_FULL                       = 17
   DP_TIMEOUT                      = 18
   FILE_NOT_FOUND                  = 19
   DATAPROVIDER_EXCEPTION          = 20
   CONTROL_FLUSH_ERROR             = 21
   OTHERS                          = 22
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


*cl_demo_output=>display( gt_csv ).