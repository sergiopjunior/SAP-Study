*&---------------------------------------------------------------------*
*& Report YINFINITFY_EX07                                              *
*&                                                                     *
*& (Leia o help do comando FORM) Faça uma rotina que receba 4          *
*& variáveis globais sendo elas do mesmo tipo. Cada variável será      *
*& recebida de uma maneira diferente: 2 usando a adição USING e 2      *
*& usando a adição CHANGING do comando FORM. Em cada situação utilize  *
*& e omita a adição VALUE. Imprima o conteúdo das variáveis antes da   *
*& rotina ser chamada, no começo da rotina, no final da rotina e após  *
*& a sua chamada. Verificar como o conteúdo das variáveis se comporta  *
*& no debug.                                                           *
*&---------------------------------------------------------------------*

REPORT yinfinitfy_ex07.

DATA: v_var1 TYPE i VALUE 2,
      v_var2 TYPE i VALUE 2,
      v_var3 TYPE i,
      v_var4 TYPE i.

START-OF-SELECTION.
  PERFORM print_values USING 'Antes da rotina->'.

  PERFORM change_var_content USING v_var1  v_var2
                                     CHANGING v_var3 v_var4.

  PERFORM print_values USING 'Depois da rotina->'.

FORM change_var_content USING p_var1 TYPE i  p_var2 TYPE i
                                 CHANGING v_var3 v_var4.
  PERFORM print_values USING 'Começo da rotina->'.
  p_var1 = 1.
  p_var2 = 1.
  v_var3 = 1.
  v_var4 = 1.
  PERFORM print_values USING 'Final da rotina->'.
ENDFORM.


FORM print_values USING p_title TYPE char20.
  WRITE: p_title, 'Var1:', v_var1, 'Var2:', v_var2, 'Var3:', v_var3, 'Var4:', v_var4, /.
ENDFORM.