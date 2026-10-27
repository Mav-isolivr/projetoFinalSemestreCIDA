# Modelo de Requisitos

**UFSC — CIN8003 — Bancos de Dados e Aplicações**  
**Docente:** Moisés Lima Dutra  
**Aluna:** Maria Vithória de Oliveira  
**Cenário:** floricultura

## 1. Descrição do cenário

A floricultura vende flores e ornamentos. O cliente inicia a compra, define o que deseja e paga. O pedido sempre tem um destinatário, que pode ser o próprio cliente ou outra pessoa.

O vendedor atende, registra o pedido e só pode fazer isso se estiver ativo. O jardineiro monta o arranjo, cuida da poda e administra o estoque de flores, sementes e ornamentos. O entregador leva o pedido quando a forma escolhida não é a retirada no local.

A entrega pode ser comum ou surpresa. Na surpresa, o destinatário não fica sabendo do pedido até receber, e a retirada no local não é permitida. Depois da entrega, o cliente pode deixar um feedback. Se o pedido for cancelado depois que flores ou ornamentos já foram usados, esses itens não voltam ao estoque, porque são perecíveis.

## 2. Stakeholders

- **Cliente:** inicia a compra, paga e informa as especificações do pedido.
- **Destinatário:** pessoa que recebe o produto ou a entrega. É o alvo da logística.
- **Vendedor:** atende, registra o pedido e valida as condições da venda.
- **Entregador:** transporta o pedido nas entregas comuns ou surpresa.
- **Jardineiro:** manipula os recursos perecíveis, monta os arranjos e controla o estoque. Atua como responsável técnico da floricultura.

## 3. Entidades

- **Pessoa:** identificação comum de clientes e funcionários (nome, documentos e contato).
- **Cliente, Vendedor, Entregador e Jardineiro:** papéis especializados de pessoa. O vendedor tem status ativo ou inativo.
- **Turno:** dia (de 1 a 6), carga horária e período da escala.
- **Estoque:** local de armazenamento sob responsabilidade de um jardineiro, com a quantidade de sementes.
- **Tipo de flor:** espécie, cor, tamanho, preço de catálogo não se aplica aqui; o catálogo traz nome, cor, tamanho e quantidade disponível.
- **Ornamento:** item decorativo (cor, tamanho, fitas e indicação de poda) ligado a uma flor e a um estoque, com quantidade própria.
- **Destinatário:** quem recebe o pedido, com nome e endereço.
- **Pagamento:** valor, modalidade (débito ou crédito) e parcelamento.
- **Pedido:** venda que reúne cliente, destinatário, pagamento, vendedor e, quando couber, entregador e jardineiro. Guarda data, status e modalidade (retirada, entrega ou surpresa).
- **Item do pedido:** cada flor ou ornamento incluído no pedido, com a quantidade.
- **Comissão:** valor devido ao profissional que de fato trabalhou naquele pedido.
- **Feedback:** nota e comentário opcionais, ligados a um pedido já entregue.
- **Entrega surpresa:** dados da entrega sigilosa (ocasião, local e sigilo), ligada a um único pedido.

## 4. Regras de negócio

1. Um cliente faz um ou vários pedidos. Um pedido pertence a um único cliente.
2. Todo pedido relaciona um cliente e um destinatário.
3. Todo pedido tem destinatário. O pedido não pode ser gravado sem ele.
4. Vendedor, entregador e jardineiro que atuarem no pedido recebem comissão por esse trabalho. A comissão aponta o pedido e exatamente um desses profissionais, e esse profissional tem de ser o que está associado ao pedido.
5. O entregador só entra quando o pedido não é retirado no local. Na retirada, não há entregador.
6. Um pedido pode reunir várias flores e vários ornamentos. O vínculo é feito pelos itens do pedido. Cada item é uma flor ou um ornamento, com quantidade maior que zero.
7. Um ornamento pertence a uma flor. Uma flor pode ter vários ornamentos.
8. Um jardineiro gerencia um ou mais estoques. Cada estoque tem um jardineiro responsável.
9. Todo pedido tem uma forma de pagamento, do mesmo cliente e do mesmo vendedor do pedido.
10. Ao usar flor ou ornamento no pedido, a quantidade correspondente sai do estoque. Não se aceita item sem saldo.
11. O feedback é opcional e só existe depois que o pedido foi entregue. Cada pedido tem no máximo um feedback, e o feedback guarda o pedido avaliado.
12. Entrega surpresa exige entregador. Retirada no local não pode ser surpresa.
13. Na entrega surpresa, o destinatário não sabe do pedido até a entrega. O sigilo fica registrado e é obrigatório.
14. Só vendedor com status ativo registra pedido e recebe comissão.
15. Se o pedido for cancelado depois que o jardineiro já usou flores ou ornamentos, esses recursos não retornam ao estoque utilizável. Os itens permanecem gravados para auditoria.

## 5. Requisitos funcionais

- RF01. Cadastrar pessoas e o papel de cada uma: cliente, vendedor, entregador ou jardineiro.
- RF02. Manter a escala de turnos e associar cada funcionário a um turno.
- RF03. Registrar estoques, tipos de flor e ornamentos, com quantidades.
- RF04. Registrar um pedido com cliente, destinatário, pagamento, vendedor e itens.
- RF05. Aceitar retirada no local, entrega comum ou entrega surpresa.
- RF06. Atribuir entregador somente quando houver entrega.
- RF07. Atribuir o jardineiro que monta o arranjo.
- RF08. Calcular e guardar a comissão de quem trabalhou no pedido.
- RF09. Baixar o estoque no momento em que o item entra no pedido.
- RF10. Permitir cancelamento sem devolver itens perecíveis ao estoque.
- RF11. Registrar feedback apenas de pedido entregue.
- RF12. Impedir venda e comissão de vendedor inativo.

## 6. Requisitos de dados

- CPF único. Data de nascimento, telefone e endereço guardados como texto.
- Dia do turno de 1 a 6.
- Status do pedido: aberto, em preparo, entregue ou cancelado.
- Modalidade do pedido: retirada, entrega ou surpresa.
- Status do vendedor: ativo ou inativo, com ativo como padrão.
- Pagamento somente em débito ou crédito. Parcelamento mínimo de 1.
- Nota do feedback de 1 a 5.
- Poda do ornamento: sim ou não.
- Integridade referencial obrigatória, com proibição de apagar um registro que ainda seja referenciado.
- A baixa de estoque, o bloqueio de vendedor inativo, o feedback após a entrega e a exigência de modalidade surpresa são garantidos por gatilhos no banco.
