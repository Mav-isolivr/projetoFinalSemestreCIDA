# Projeto Final — Floricultura

**UFSC — CIN8003 — Bancos de Dados e Aplicações**  
**Docente:** Moisés Lima Dutra  
**Aluna:** Maria Vithória de Oliveira

Cenário de uma floricultura. O vendedor atende o cliente e registra o pedido. O cliente pode retirar no local ou pedir entrega, inclusive uma entrega surpresa para o destinatário. O jardineiro cuida das flores, da poda, da montagem dos arranjos e do estoque. O entregador faz o transporte quando a retirada não é no local.

## Arquivos

| Arquivo | Conteúdo |
| --- | --- |
| [docs/modelo_de_requisitos.md](docs/modelo_de_requisitos.md) | Levantamento e análise de requisitos |
| [docs/modelo_conceitual.md](docs/modelo_conceitual.md) | Diagrama entidade-relacionamento |
| [docs/diagrama_mer.png](docs/diagrama_mer.png) | Foto do diagrama entidade-relacionamento |
| [docs/modelo_logico.md](docs/modelo_logico.md) | Esquema relacional |
| [script_ddl.sql](script_ddl.sql) | Criação das tabelas, restrições e gatilhos |
| [script_dml.sql](script_dml.sql) | Carga de dados do cenário |
| [script_reset.sql](script_reset.sql) | Limpeza opcional do banco (não faz parte da carga) |
| [floricultura.db](floricultura.db) | Banco SQLite já criado e alimentado |

## Banco de dados

O arquivo `floricultura.db` já contém o esquema e os dados. Para recriá-lo do zero, apague o arquivo e execute os scripts nesta ordem, com chaves estrangeiras ligadas (os próprios scripts emitem `PRAGMA foreign_keys = ON`):

```bash
sqlite3 floricultura.db ".read script_ddl.sql"
sqlite3 floricultura.db ".read script_dml.sql"
```

No SQLite, a verificação de chave estrangeira vale para a conexão. Quem abrir o banco em outro programa deve executar `PRAGMA foreign_keys = ON` antes de inserir ou alterar dados.

`script_reset.sql` apaga os dados e os contadores de `AUTOINCREMENT`. Ele não foi aplicado no arquivo `floricultura.db` entregue.
