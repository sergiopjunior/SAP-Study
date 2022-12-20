<<<<<<< HEAD
# Aprendendo o básico sobre orientação a objetos em ABAP

Programação orientada a objetos (POO, ou OOP segundo as suas siglas em inglês) é um paradigma de programação baseado no conceito de "objetos", criados a partir de um esqueleto (classe), que podem conter dados na forma de campos, também conhecidos como *atributos*, e códigos, na forma de procedimentos, também conhecidos como métodos. Os atributos e métodos de um objeto possuem modificadores de acesso e podem ser públicos, protegidos ou privados.

#### Tipos de classes em ABAP

- Local: definida como parte de um programa (executável ou include), pode somente ser utilizada dentro do programa em que foi definida, são úteis em objetos ou funções que serão usados somente em um programa;
- Global: definida através da transação "SE24" (Class Builder), possui uma sintax quase idêntica a de uma classe local, é armazenada no repositório de classes do SAP e pode ser utilizada em qualquer programa.

#### Seções de visibilidade

A declaração de modificadores de acesso em ABAP é feita através de seções de visibilidade, como `PUBLIC SECTION`, `PRIVATE SECTION` e `PROTECTED SECTION`.

#### Atributos e métodos estáticos

O prefixo `CLASS-` para a atributos ou métodos significa que eles serão utilizados de forma estática dentro de suas respectivas classes. Atributos e métodos estáticos pertencem aos componentes estáticos de uma classe e ao contrário dos de instância, que existem separadamente para cada instância de classe (objeto) e só podem ser utilizados após a criação de pelo menos uma instância, são compartilhados entre todas as instâncias da classe.

##### Declarações de atributos e métodos estáticos

```
CLASS-DATA: * Atributo estático
        cls_main TYPE REF TO cl_main.
```

```
CLASS-METHODS: * Método estático
        get_sales_products
          IMPORTING
            p_salesorderuuid TYPE zdemo_soh-salesorderuuid.
```

#### Declarando uma classe

Primeiro definimos a nossa classe, seus métodos, atributos e suas visibilidades.

```
CLASS cl_main DEFINITION.
  PUBLIC SECTION.
    TYPES t_so_salesorderuuid TYPE RANGE OF zdemo_soh-salesorderuuid.
    CLASS-METHODS:
      get_sales_products
        IMPORTING
          so_salesorderuuid TYPE t_so_salesorderuuid.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_soh,
             salesorderuuid TYPE zdemo_soh-salesorderuuid,
             salesorder     TYPE zdemo_soh-salesorder,
           END OF ty_soh,
           BEGIN OF ty_soi,
             salesorderitemuuid TYPE zdemo_soi-salesorderitemuuid,
             salesorderuuid     TYPE zdemo_soh-salesorderuuid,
             product            TYPE zdemo_soi-product,
             grossamount        TYPE zdemo_soi-grossamount,
             quantity           TYPE zdemo_soi-quantity,
           END OF ty_soi,
           BEGIN OF ty_output,
             salesorderuuid     TYPE zdemo_soh-salesorderuuid,
             salesorder         TYPE zdemo_soh-salesorder,
             salesorderitemuuid TYPE zdemo_soi-salesorderitemuuid,
             product            TYPE zdemo_soi-product,
             grossamount        TYPE zdemo_soi-grossamount,
             quantity           TYPE zdemo_soi-quantity,
           END OF ty_output.

    CLASS-DATA:
      cls_main TYPE REF TO cl_main.
    DATA:
      it_soh    TYPE TABLE OF ty_soh,
      it_soi    TYPE TABLE OF ty_soi,
      it_output TYPE TABLE OF ty_output.
    DATA:
      wa_soh    TYPE ty_soh,
      wa_soi    TYPE ty_soi,
      wa_output TYPE ty_output.

    METHODS:
      get_data
        IMPORTING
          so_salesorderuuid TYPE t_so_salesorderuuid,
      process_data,
      make_output
        RETURNING
          VALUE(it_fieldcat) TYPE lvc_t_fcat,
      display.

ENDCLASS.
```

Em seguida declaramos a implementação da classe e de seus métodos.

```
CLASS cl_main IMPLEMENTATION.
  METHOD get_sales_products.
    CREATE OBJECT cls_main.
    cls_main->get_data( so_salesorderuuid[] ).
    cls_main->process_data( ).
    cls_main->display( ).

  ENDMETHOD.

  METHOD get_data.
    SELECT salesorderuuid
         salesorder
    FROM zdemo_soh
    INTO TABLE it_soh
    WHERE salesorderuuid IN so_salesorderuuid.

    IF sy-subrc EQ 0.
      SELECT salesorderuuid
             salesorderitemuuid
             product
             grossamount
             quantity
        FROM zdemo_soi
        INTO TABLE it_soi
        FOR ALL ENTRIES IN it_soh
        WHERE salesorderuuid EQ it_soh-salesorderuuid.
    ENDIF.

  ENDMETHOD.

  METHOD process_data.
    SORT: it_soh BY salesorderuuid,
          it_soi BY salesorderuuid salesorderitemuuid.

    LOOP AT it_soi INTO wa_soi.
      CLEAR wa_output.
      CLEAR wa_soh. 
      
      READ TABLE it_soh
            INTO wa_soh
            WITH key salesorderuuid = wa_soi-salesorderitemuuid
            BINARY SEARCH.

      IF wa_soh IS NOT INITIAL.
        wa_output-salesorderuuid = wa_soh-salesorderuuid.
        wa_output-salesorder = wa_soh-salesorder.
        wa_output-salesorderitemuuid = wa_soi-salesorderitemuuid.
        wa_output-product = wa_soi-product.
        wa_output-grossamount = wa_soi-grossamount.
        wa_output-quantity = wa_soi-quantity.

        IF sy-subrc EQ 0.
          APPEND wa_output TO it_output. 
        ENDIF.
      ENDIF.

      CLEAR wa_soi.
    ENDLOOP.

  ENDMETHOD.

  METHOD make_output.
    DATA wa_fieldcat TYPE lvc_s_fcat.

    wa_fieldcat-fieldname = 'salesorderuuid'.
    wa_fieldcat-scrtext_m = 'Order UUID'.
    APPEND wa_fieldcat TO it_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'salesorder'.
    wa_fieldcat-scrtext_m = 'Sales Order Number'.
    APPEND wa_fieldcat TO it_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'salesorderitemuuid'.
    wa_fieldcat-scrtext_m = 'Item UUID'.
    APPEND wa_fieldcat TO it_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'product'.
    wa_fieldcat-scrtext_m = 'Product ID'.
    APPEND wa_fieldcat TO it_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'grossamount'.
    wa_fieldcat-scrtext_m = 'Total Gross Amount'.
    APPEND wa_fieldcat TO it_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'quantity'.
    wa_fieldcat-scrtext_m = 'Quantity'.
    APPEND wa_fieldcat TO it_fieldcat.

  ENDMETHOD.

  METHOD display.
    DATA: wa_layout TYPE lvc_s_layo,
          wa_vari   TYPE disvariant.

    wa_layout-zebra = abap_true.
    wa_layout-cwidth_opt = abap_true.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
        i_callback_program = sy-repid
        is_layout_lvc      = wa_layout
        it_fieldcat_lvc    = make_output( )
      TABLES
        t_outtab           = it_output
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc NE 0.
      MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-003.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
```

#### Criando uma instância de uma classe

Primeiro é definido o objeto.

```
 CLASS-DATA:
        cls_main TYPE REF TO cl_main.
```

Em seguida o objeto é criado.

```
CREATE OBJECT cls_main.
```

Após criada a instância da classe, é possível acessar seus atributos e métodos de instância.

```
 cls_main->get_data( p_salesorderuuid ).
 cls_main->process_data( ).
 cls_main->display( ).
```

#### Utilizando a classe e chamando métodos estáticos

```
INCLUDE zic_sales.

TABLES:
  zdemo_soh.

SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS so_ordid FOR zdemo_soh-salesorderuuid MATCHCODE OBJECT  zsh_salesorderuuid.
SELECTION-SCREEN: END OF BLOCK b_main.

START-OF-SELECTION.
  cl_main=>get_sales_products( so_ordid[] ). * Chamando o método estático "get_sales_products"
=======
# Aprendendo o básico sobre orientação a objetos em ABAP

Programação orientada a objetos (POO, ou OOP segundo as suas siglas em inglês) é um paradigma de programação baseado no conceito de "objetos", criados a partir de um esqueleto (classe), que podem conter dados na forma de campos, também conhecidos como *atributos*, e códigos, na forma de procedimentos, também conhecidos como métodos. Os atributos e métodos de um objeto possuem modificadores de acesso e podem ser públicos, protegidos ou privados.

#### Tipos de classes em ABAP

- Local: definida como parte de um programa (executável ou include), pode somente ser utilizada dentro do programa em que foi definida, são úteis em objetos ou funções que serão usados somente em um programa;
- Global: definida através da transação "SE24" (Class Builder), possui uma sintax quase idêntica a de uma classe local, é armazenada no repositório de classes do SAP e pode ser utilizada em qualquer programa.

#### Seções de visibilidade

A declaração de modificadores de acesso em ABAP é feita através de seções de visibilidade, como `PUBLIC SECTION`, `PRIVATE SECTION` e `PROTECTED SECTION`.

#### Atributos e métodos estáticos

O prefixo `CLASS-` para a atributos ou métodos significa que eles serão utilizados de forma estática dentro de suas respectivas classes. Atributos e métodos estáticos pertencem aos componentes estáticos de uma classe e ao contrário dos de instância, que existem separadamente para cada instância de classe (objeto) e só podem ser utilizados após a criação de pelo menos uma instância, são compartilhados entre todas as instâncias da classe.

##### Declarações de atributos e métodos estáticos

```
CLASS-DATA: * Atributo estático
        cls_main TYPE REF TO cl_main.
```

```
CLASS-METHODS: * Método estático
        get_sales_products
          IMPORTING
            p_salesorderuuid TYPE zdemo_soh-salesorderuuid.
```

#### Declarando uma classe

Primeiro definimos a nossa classe, seus métodos, atributos e suas visibilidades.

```
CLASS cl_main DEFINITION.
  PUBLIC SECTION.
    TYPES t_so_salesorderuuid TYPE RANGE OF zdemo_soh-salesorderuuid.
    CLASS-METHODS:
      get_sales_products
        IMPORTING
          so_salesorderuuid TYPE t_so_salesorderuuid.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_soh,
             salesorderuuid TYPE zdemo_soh-salesorderuuid,
             salesorder     TYPE zdemo_soh-salesorder,
           END OF ty_soh,
           BEGIN OF ty_soi,
             salesorderitemuuid TYPE zdemo_soi-salesorderitemuuid,
             salesorderuuid     TYPE zdemo_soh-salesorderuuid,
             product            TYPE zdemo_soi-product,
             grossamount        TYPE zdemo_soi-grossamount,
             quantity           TYPE zdemo_soi-quantity,
           END OF ty_soi,
           BEGIN OF ty_output,
             salesorderuuid     TYPE zdemo_soh-salesorderuuid,
             salesorder         TYPE zdemo_soh-salesorder,
             salesorderitemuuid TYPE zdemo_soi-salesorderitemuuid,
             product            TYPE zdemo_soi-product,
             grossamount        TYPE zdemo_soi-grossamount,
             quantity           TYPE zdemo_soi-quantity,
           END OF ty_output.

    CLASS-DATA:
      cls_main TYPE REF TO cl_main.
    DATA:
      it_soh    TYPE TABLE OF ty_soh,
      it_soi    TYPE TABLE OF ty_soi,
      it_output TYPE TABLE OF ty_output.
    DATA:
      wa_soh    TYPE ty_soh,
      wa_soi    TYPE ty_soi,
      wa_output TYPE ty_output.

    METHODS:
      get_data
        IMPORTING
          so_salesorderuuid TYPE t_so_salesorderuuid,
      process_data,
      make_output
        RETURNING
          VALUE(it_fieldcat) TYPE lvc_t_fcat,
      display.

ENDCLASS.
```

Em seguida declaramos a implementação da classe e de seus métodos.

```
CLASS cl_main IMPLEMENTATION.
  METHOD get_sales_products.
    CREATE OBJECT cls_main.
    cls_main->get_data( so_salesorderuuid[] ).
    cls_main->process_data( ).
    cls_main->display( ).

  ENDMETHOD.

  METHOD get_data.
    SELECT salesorderuuid
         salesorder
    FROM zdemo_soh
    INTO TABLE it_soh
    WHERE salesorderuuid IN so_salesorderuuid.

    IF sy-subrc EQ 0.
      SELECT salesorderuuid
             salesorderitemuuid
             product
             grossamount
             quantity
        FROM zdemo_soi
        INTO TABLE it_soi
        FOR ALL ENTRIES IN it_soh
        WHERE salesorderuuid EQ it_soh-salesorderuuid.
    ENDIF.

  ENDMETHOD.

  METHOD process_data.
    SORT: it_soh BY salesorderuuid,
          it_soi BY salesorderuuid salesorderitemuuid.

    LOOP AT it_soi INTO wa_soi.
      CLEAR wa_output.
      CLEAR wa_soh. 
      
      READ TABLE it_soh
            INTO wa_soh
            WITH key salesorderuuid = wa_soi-salesorderitemuuid
            BINARY SEARCH.

      IF wa_soh IS NOT INITIAL.
        wa_output-salesorderuuid = wa_soh-salesorderuuid.
        wa_output-salesorder = wa_soh-salesorder.
        wa_output-salesorderitemuuid = wa_soi-salesorderitemuuid.
        wa_output-product = wa_soi-product.
        wa_output-grossamount = wa_soi-grossamount.
        wa_output-quantity = wa_soi-quantity.

        IF sy-subrc EQ 0.
          APPEND wa_output TO it_output. 
        ENDIF.
      ENDIF.

      CLEAR wa_soi.
    ENDLOOP.

  ENDMETHOD.

  METHOD make_output.
    DATA wa_fieldcat TYPE lvc_s_fcat.

    wa_fieldcat-fieldname = 'salesorderuuid'.
    wa_fieldcat-scrtext_m = 'Order UUID'.
    APPEND wa_fieldcat TO it_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'salesorder'.
    wa_fieldcat-scrtext_m = 'Sales Order Number'.
    APPEND wa_fieldcat TO it_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'salesorderitemuuid'.
    wa_fieldcat-scrtext_m = 'Item UUID'.
    APPEND wa_fieldcat TO it_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'product'.
    wa_fieldcat-scrtext_m = 'Product ID'.
    APPEND wa_fieldcat TO it_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'grossamount'.
    wa_fieldcat-scrtext_m = 'Total Gross Amount'.
    APPEND wa_fieldcat TO it_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'quantity'.
    wa_fieldcat-scrtext_m = 'Quantity'.
    APPEND wa_fieldcat TO it_fieldcat.

  ENDMETHOD.

  METHOD display.
    DATA: wa_layout TYPE lvc_s_layo,
          wa_vari   TYPE disvariant.

    wa_layout-zebra = abap_true.
    wa_layout-cwidth_opt = abap_true.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
        i_callback_program = sy-repid
        is_layout_lvc      = wa_layout
        it_fieldcat_lvc    = make_output( )
      TABLES
        t_outtab           = it_output
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc NE 0.
      MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-003.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
```

#### Criando uma instância de uma classe

Primeiro é definido o objeto.

```
 CLASS-DATA:
        cls_main TYPE REF TO cl_main.
```

Em seguida o objeto é criado.

```
CREATE OBJECT cls_main.
```

Após criada a instância da classe, é possível acessar seus atributos e métodos de instância.

```
 cls_main->get_data( p_salesorderuuid ).
 cls_main->process_data( ).
 cls_main->display( ).
```

#### Utilizando a classe e chamando métodos estáticos

```
INCLUDE zic_sales.

TABLES:
  zdemo_soh.

SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS so_ordid FOR zdemo_soh-salesorderuuid MATCHCODE OBJECT  zsh_salesorderuuid.
SELECTION-SCREEN: END OF BLOCK b_main.

START-OF-SELECTION.
  cl_main=>get_sales_products( so_ordid[] ). * Chamando o método estático "get_sales_products"
>>>>>>> origin/main
```