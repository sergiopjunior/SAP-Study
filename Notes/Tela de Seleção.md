# O que é uma tela de selção?

Tela de seleção (Selection Screen) é uma tela gerada a partir de instruções ABAP e é utilizada para obter informações dos usuários e controlar o fluxo do programa.

#### Criando uma tela de seleção

Para criar uma tela de seleção é definido um bloco das seguintes formas:

##### Tela sem frame e título

Código:

```
SELECTION-SCREEN: BEGIN OF BLOCK b_main.
    PARAMETERS: p_ex TYPE mara-matnr.
SELECTION-SCREEN: END OF BLOCK b_main.
```

Output:

![image-20220915150627130](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915150627130.png)

##### Tela com frame e título

Código:

```
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
	PARAMETERS: p_ex TYPE mara-matnr.
SELECTION-SCREEN: END OF BLOCK b1.
```

O trecho `WITH FRAME` significa que o bloco b1 será exibido dentro de um frame (uma caixa) e `TITLE TEXT-001` especifica a variável texto que será utilizada para nomear o campo.

Output:

![image-20220915150530642](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915150530642.png)

#### Elementos básicos de uma tela de seleçãos

- Parameter (Um campo de s para a inserção de um único valor de um tipo de dado definido);
- Checkbox;
- Radiobutton.

#### Parameter

Definindo um parameter do tipo "**matnr**" (campo da tabela mara):

```
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
	PARAMETERS: p_ex TYPE mara-matnr.
SELECTION-SCREEN: END OF BLOCK b1.
```

Output:

![image-20220915150530642](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915150530642.png)

#### Checkbox

Definindo um checkbox:

```
SELECTION-SCREEN: BEGIN OF BLOCK b_main.
  PARAMETERS: p_chkbox AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: END OF BLOCK b_main.
```

O trecho `DEFAULT 'X'` informa que o checkbox será marcado por padrão, da mesma forma que `DEFAULT '''` faria com que o checkbox fosse desmarcado por padrão.

Output:

![image-20220915151049311](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915151049311.png)

#### Radiobutton

Definindo radiobuttons:

```
SELECTION-SCREEN: BEGIN OF BLOCK b_main.
    PARAMETERS: r1 RADIOBUTTON GROUP rad1,
                            r2 RADIOBUTTON GROUP rad1 DEFAULT 'X',
                            r3 RADIOBUTTON GROUP rad1,

                            s1 RADIOBUTTON GROUP rad2,
                            s2 RADIOBUTTON GROUP rad2,
                            s3 RADIOBUTTON GROUP rad2 DEFAULT 'X'.
SELECTION-SCREEN: END OF BLOCK b_main.
```

Os trechos `GROUP rad1` e `GROUP rad2`informam os grupos dos radiobuttons.

Output:

![image-20220915151727207](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915151727207.png)

#### Select Options

Select Options nada mais é do que uma tabela interna do tipo "**Range**" (estrutura de dados), que armazena um intervalo de valores especificado pelo usuário e pode ser utilizada em operações `SELECT`.

Definindo um Select Options do tipo matnr:

```
TABLES: mara.

SELECTION-SCREEN: BEGIN OF BLOCK b_main.
      SELECT-OPTIONS: so_matkl FOR mara-matnr.
SELECTION-SCREEN: END OF BLOCK b_main.
```

O trecho `TABLES: mara` declara a tabela a qual pertence o campo que será atribuído ao select options, essa declaração é necessária para que o SO "enxergue" a tabela.

Output:

![image-20220915152205765](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915152205765.png)