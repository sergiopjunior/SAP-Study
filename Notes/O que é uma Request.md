# O que é uma Request

Request ou Transport Request (requisição de transporte) é um container que contém modificações feitas no ambiente de desenvolvimento, com a intenção de enviá-las para outro ambiente (ex: qualidade, produção) através do sistema de transporte. Além disso, traz informações sobre o tipo de mudança, propósito do transporte, categoria da Request e o sistema de destino. 

#### Tasks

Dentro de cada Request existem uma ou mais Tasks (tarefas), que é a unidade mínima de mudança transportável e não pode ser transportada por si só, apenas como parte de uma Request. Tasks ão armazenadas em Requests assim como arquivos são armazenados em pastas. Uma Task é uma lista de objetos que foram modificados por um determinado usuário e pode somente ser associada e liberada por um único usuário. Porém múltiplos usuários podem ser associados a uma Request, que pode conter múltiplas Tasks.

#### Tipos de Requests mais usadas

- Customizing Request: usada para transportar dados;
- Workbench Request: usada para transportar objetos;
- Transport of Copies: usada para transportar uma cópia de uma Request, sem a necessidade de liberar a Request original (evita a criação de múltiplas Requests).

#### Como criar uma Request?

1- Acesse a transação "SE09":

![image-20220915103554500](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915103554500.png)



2- Clique no botão de criação de requests:

![image-20220915103724127](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915103724127.png)

3- Selecione o tipo da Request e clique no botão de confirmação:

![image-20220915104101111](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915104101111.png)

4- Coloque a descrição da Request e o ambiente alvo para qual será transportada, depois clique no botão de salvar:

![image-20220915104702860](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915104702860.png)

5- Uma tela de exibição de Requests será exibida, mostrando a Request criada e suas Tasks:

![image-20220915105126995](C:\Users\UpWardfy\AppData\Roaming\Typora\typora-user-images\image-20220915105126995.png)

Com a Request criada, basta apenas começar a criar objetos e adicioná-los a ela.