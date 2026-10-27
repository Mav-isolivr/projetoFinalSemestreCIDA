# Modelo Lógico

**UFSC — CIN8003 — Bancos de Dados e Aplicações**  
**Docente:** Moisés Lima Dutra  
**Aluna:** Maria Vithória de Oliveira  
**Cenário:** floricultura

Notação: a chave primária está marcada com PK. A chave estrangeira aparece como `atributo -> Tabela(coluna)`. UNIQUE, NOT NULL, CHECK e DEFAULT estão indicados na restrição correspondente.

## Esquema relacional

**Pessoa** (id PK, nome, sobrenome, cpf, data_nascimento, numero_contato, email_contato, endereco, relacao)

- cpf UNIQUE NOT NULL
- relacao CHECK (`cliente`, `funcionario`)

**Turno** (id PK, dia, horas, periodo)

- dia entre 1 e 7
- horas maior que zero
- periodo CHECK (`manhã`, `tarde`, `noite`)

**Cliente** (id PK, id_pessoa)

- id_pessoa NOT NULL UNIQUE -> Pessoa(id)

**Vendedor** (id PK, id_pessoa, id_turno, status)

- id_pessoa NOT NULL UNIQUE -> Pessoa(id)
- id_turno NOT NULL -> Turno(id)
- status NOT NULL DEFAULT `ativo` CHECK (`ativo`, `inativo`)

**Entregador** (id PK, id_pessoa, id_turno)

- id_pessoa NOT NULL UNIQUE -> Pessoa(id)
- id_turno NOT NULL -> Turno(id)

**Jardineiro** (id PK, id_pessoa, id_turno)

- id_pessoa NOT NULL UNIQUE -> Pessoa(id)
- id_turno NOT NULL -> Turno(id)

**Estoque** (id PK, sementes, id_jardineiro)

- sementes NOT NULL DEFAULT 0, maior ou igual a zero
- id_jardineiro NOT NULL -> Jardineiro(id)

**Tipo_flores** (id PK, nome, cor, tamanho, quantidade, id_estoque)

- tamanho maior que zero
- quantidade NOT NULL DEFAULT 0, maior ou igual a zero
- id_estoque NOT NULL -> Estoque(id)

**Ornamento** (id PK, cor, tamanho, fitas, podacao, quantidade, id_estoque, id_flores)

- tamanho maior que zero
- podacao CHECK (`sim`, `não`); fitas é opcional
- quantidade NOT NULL DEFAULT 0, maior ou igual a zero
- id_estoque NOT NULL -> Estoque(id)
- id_flores NOT NULL -> Tipo_flores(id)

**Destinatario** (id PK, nome, endereco, numero_contato)

- nome e endereco NOT NULL
- numero_contato opcional

**Pagamento** (id PK, valor, tipo, parcelamento, id_cliente, id_vendedor)

- valor maior que zero
- tipo CHECK (`debito`, `credito`)
- parcelamento NOT NULL DEFAULT 1, maior ou igual a 1
- id_cliente NOT NULL -> Cliente(id)
- id_vendedor NOT NULL -> Vendedor(id)

**Pedido** (id PK, data_pedido, status, modalidade, id_cliente, id_destinatario, id_pagamento, id_vendedor, id_entregador, id_jardineiro)

- data_pedido NOT NULL DEFAULT data corrente
- status NOT NULL DEFAULT `aberto` CHECK (`aberto`, `em_preparo`, `entregue`, `cancelado`)
- modalidade NOT NULL CHECK (`retirada`, `entrega`, `surpresa`)
- id_cliente NOT NULL -> Cliente(id)
- id_destinatario NOT NULL -> Destinatario(id)
- id_pagamento NOT NULL UNIQUE -> Pagamento(id)
- id_vendedor NOT NULL -> Vendedor(id)
- id_entregador -> Entregador(id), nulo somente quando a modalidade é `retirada`
- id_jardineiro -> Jardineiro(id), opcional
- CHECK: retirada sem entregador; entrega e surpresa com entregador

**Item_pedido** (id PK, id_pedido, id_tipo_flor, id_ornamento, quantidade)

- id_pedido NOT NULL -> Pedido(id)
- id_tipo_flor -> Tipo_flores(id)
- id_ornamento -> Ornamento(id)
- quantidade maior que zero
- CHECK: o item é uma flor ou um ornamento, nunca os dois e nunca nenhum

**Comissao** (id PK, valor_por_pedido, id_pedido, id_vendedor, id_entregador, id_jardineiro)

- valor_por_pedido maior ou igual a zero
- id_pedido NOT NULL -> Pedido(id)
- id_vendedor -> Vendedor(id)
- id_entregador -> Entregador(id)
- id_jardineiro -> Jardineiro(id)
- CHECK: exatamente uma das três chaves de profissional está preenchida

**Feedback** (id PK, nota, descricao, id_pedido)

- nota entre 1 e 5
- descricao opcional
- id_pedido NOT NULL UNIQUE -> Pedido(id)

**Entrega_surpresa** (id PK, tipo_entrega, local, sigilo, id_pedido)

- tipo_entrega e local NOT NULL
- sigilo NOT NULL DEFAULT `sim` CHECK (`sim`)
- id_pedido NOT NULL UNIQUE -> Pedido(id)

## Ações referenciais

Toda chave estrangeira usa `ON DELETE RESTRICT` e `ON UPDATE CASCADE`. Não se apaga pessoa, pedido, flor ou ornamento enquanto houver registro dependente. Os itens do pedido cancelado permanecem para auditoria e, por isso, também bloqueiam a exclusão do pedido.

## Gatilhos

- Baixa a quantidade da flor ou do ornamento ao incluir o item. Se o saldo não cobrir a quantidade, a inclusão é recusada.
- O cancelamento não devolve quantidade ao estoque. Não há gatilho de estorno.
- O pedido só é aceito se o vendedor estiver ativo, e se o pagamento for desse cliente e desse vendedor.
- A comissão de vendedor só é aceita se ele estiver ativo, e o profissional da comissão tem de ser o mesmo associado ao pedido.
- O feedback só é aceito se o status do pedido for `entregue`.
- A entrega surpresa só é aceita se a modalidade do pedido for `surpresa`.
- Cliente só referencia pessoa com relação `cliente`. Vendedor, entregador e jardineiro só referenciam pessoa com relação `funcionario`.

## Decisões em relação ao esboço inicial

O esboço inicial não carregava com chave estrangeira ligada e deixava regras sem onde serem garantidas. O esquema acima ajusta estes pontos:

- `Item_pedido` passa a existir, porque um pedido tem várias flores e vários ornamentos.
- A comissão deixa de ser apontada pelo profissional. Ela aponta o pedido e o profissional, o que elimina o ciclo vendedor → comissão → pedido → vendedor.
- O pedido ganha data, status, modalidade e destinatário obrigatório. Assim dá para exigir entregador na entrega, feedback só após a entrega e auditoria do cancelamento.
- A entrega surpresa liga-se ao pedido, em relação 1:1 opcional, e não ao destinatário.
- O jardineiro que cuida de vários estoques é representado por `Estoque.id_jardineiro`, não por uma única chave de estoque dentro do jardineiro.
- A quantidade vendável fica em `Tipo_flores` e em `Ornamento`. `Estoque` guarda as sementes e o jardineiro responsável.
- CPF, telefone e datas são texto. A coluna de endereço se chama `endereco`.
