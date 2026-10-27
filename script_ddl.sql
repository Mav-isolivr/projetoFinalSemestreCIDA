-- UFSC - CIN8003 - Bancos de Dados e Aplicacoes
-- Docente: Moises Lima Dutra
-- Aluna: Maria Vitoria de Oliveira
-- Cenario: floricultura
--
-- Script DDL. Cria tabelas, restricoes e gatilhos.
-- Execute em um banco vazio. Para recriar, apague floricultura.db antes.

PRAGMA foreign_keys = ON;

CREATE TABLE pessoa (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  sobrenome TEXT NOT NULL,
  cpf TEXT NOT NULL UNIQUE,
  data_nascimento TEXT NOT NULL,
  numero_contato TEXT NOT NULL,
  email_contato TEXT NOT NULL,
  endereco TEXT NOT NULL,
  relacao TEXT NOT NULL CHECK (relacao IN ('cliente', 'funcionario'))
);

CREATE TABLE turno (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dia INTEGER NOT NULL CHECK (dia BETWEEN 1 AND 6),
  horas INTEGER NOT NULL CHECK (horas > 0),
  periodo TEXT NOT NULL CHECK (periodo IN ('manhã', 'tarde', 'noite'))
);

CREATE TABLE cliente (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_pessoa INTEGER NOT NULL UNIQUE,
  FOREIGN KEY (id_pessoa) REFERENCES pessoa(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE vendedor (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_pessoa INTEGER NOT NULL UNIQUE,
  id_turno INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'ativo' CHECK (status IN ('ativo', 'inativo')),
  FOREIGN KEY (id_pessoa) REFERENCES pessoa(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_turno) REFERENCES turno(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE entregador (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_pessoa INTEGER NOT NULL UNIQUE,
  id_turno INTEGER NOT NULL,
  FOREIGN KEY (id_pessoa) REFERENCES pessoa(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_turno) REFERENCES turno(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE jardineiro (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_pessoa INTEGER NOT NULL UNIQUE,
  id_turno INTEGER NOT NULL,
  FOREIGN KEY (id_pessoa) REFERENCES pessoa(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_turno) REFERENCES turno(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE estoque (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sementes INTEGER NOT NULL DEFAULT 0 CHECK (sementes >= 0),
  id_jardineiro INTEGER NOT NULL,
  FOREIGN KEY (id_jardineiro) REFERENCES jardineiro(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE tipo_flores (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  cor TEXT NOT NULL,
  tamanho INTEGER NOT NULL CHECK (tamanho > 0),
  quantidade INTEGER NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
  id_estoque INTEGER NOT NULL,
  FOREIGN KEY (id_estoque) REFERENCES estoque(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ornamento (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cor TEXT NOT NULL,
  tamanho INTEGER NOT NULL CHECK (tamanho > 0),
  fitas TEXT,
  podacao TEXT CHECK (podacao IN ('sim', 'não')),
  quantidade INTEGER NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
  id_estoque INTEGER NOT NULL,
  id_flores INTEGER NOT NULL,
  FOREIGN KEY (id_estoque) REFERENCES estoque(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_flores) REFERENCES tipo_flores(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE destinatario (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  endereco TEXT NOT NULL,
  numero_contato TEXT
);

CREATE TABLE pagamento (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  valor INTEGER NOT NULL CHECK (valor > 0),
  tipo TEXT NOT NULL CHECK (tipo IN ('debito', 'credito')),
  parcelamento INTEGER NOT NULL DEFAULT 1 CHECK (parcelamento >= 1),
  id_cliente INTEGER NOT NULL,
  id_vendedor INTEGER NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_vendedor) REFERENCES vendedor(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE pedido (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  data_pedido TEXT NOT NULL DEFAULT (date('now')),
  status TEXT NOT NULL DEFAULT 'aberto' CHECK (status IN ('aberto', 'em_preparo', 'entregue', 'cancelado')),
  modalidade TEXT NOT NULL CHECK (modalidade IN ('retirada', 'entrega', 'surpresa')),
  id_cliente INTEGER NOT NULL,
  id_destinatario INTEGER NOT NULL,
  id_pagamento INTEGER NOT NULL UNIQUE,
  id_vendedor INTEGER NOT NULL,
  id_entregador INTEGER,
  id_jardineiro INTEGER,
  CHECK (
    (modalidade = 'retirada' AND id_entregador IS NULL)
    OR (modalidade IN ('entrega', 'surpresa') AND id_entregador IS NOT NULL)
  ),
  FOREIGN KEY (id_cliente) REFERENCES cliente(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_destinatario) REFERENCES destinatario(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_pagamento) REFERENCES pagamento(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_vendedor) REFERENCES vendedor(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_entregador) REFERENCES entregador(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_jardineiro) REFERENCES jardineiro(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE item_pedido (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_pedido INTEGER NOT NULL,
  id_tipo_flor INTEGER,
  id_ornamento INTEGER,
  quantidade INTEGER NOT NULL CHECK (quantidade > 0),
  CHECK (
    (id_tipo_flor IS NOT NULL AND id_ornamento IS NULL)
    OR (id_tipo_flor IS NULL AND id_ornamento IS NOT NULL)
  ),
  FOREIGN KEY (id_pedido) REFERENCES pedido(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_tipo_flor) REFERENCES tipo_flores(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_ornamento) REFERENCES ornamento(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE comissao (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  valor_por_pedido INTEGER NOT NULL CHECK (valor_por_pedido >= 0),
  id_pedido INTEGER NOT NULL,
  id_vendedor INTEGER,
  id_entregador INTEGER,
  id_jardineiro INTEGER,
  CHECK (
    (id_vendedor IS NOT NULL AND id_entregador IS NULL AND id_jardineiro IS NULL)
    OR (id_vendedor IS NULL AND id_entregador IS NOT NULL AND id_jardineiro IS NULL)
    OR (id_vendedor IS NULL AND id_entregador IS NULL AND id_jardineiro IS NOT NULL)
  ),
  FOREIGN KEY (id_pedido) REFERENCES pedido(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_vendedor) REFERENCES vendedor(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_entregador) REFERENCES entregador(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_jardineiro) REFERENCES jardineiro(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE feedback (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nota INTEGER NOT NULL CHECK (nota BETWEEN 1 AND 5),
  descricao TEXT,
  id_pedido INTEGER NOT NULL UNIQUE,
  FOREIGN KEY (id_pedido) REFERENCES pedido(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE entrega_surpresa (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tipo_entrega TEXT NOT NULL,
  local TEXT NOT NULL,
  sigilo TEXT NOT NULL DEFAULT 'sim' CHECK (sigilo = 'sim'),
  id_pedido INTEGER NOT NULL UNIQUE,
  FOREIGN KEY (id_pedido) REFERENCES pedido(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Papel da pessoa

CREATE TRIGGER trg_cliente_eh_cliente
BEFORE INSERT ON cliente
WHEN (SELECT relacao FROM pessoa WHERE id = NEW.id_pessoa) IS NOT 'cliente'
BEGIN
  SELECT RAISE(ABORT, 'Cliente deve referenciar uma pessoa com relacao cliente');
END;

CREATE TRIGGER trg_vendedor_eh_funcionario
BEFORE INSERT ON vendedor
WHEN (SELECT relacao FROM pessoa WHERE id = NEW.id_pessoa) IS NOT 'funcionario'
BEGIN
  SELECT RAISE(ABORT, 'Vendedor deve referenciar uma pessoa com relacao funcionario');
END;

CREATE TRIGGER trg_entregador_eh_funcionario
BEFORE INSERT ON entregador
WHEN (SELECT relacao FROM pessoa WHERE id = NEW.id_pessoa) IS NOT 'funcionario'
BEGIN
  SELECT RAISE(ABORT, 'Entregador deve referenciar uma pessoa com relacao funcionario');
END;

CREATE TRIGGER trg_jardineiro_eh_funcionario
BEFORE INSERT ON jardineiro
WHEN (SELECT relacao FROM pessoa WHERE id = NEW.id_pessoa) IS NOT 'funcionario'
BEGIN
  SELECT RAISE(ABORT, 'Jardineiro deve referenciar uma pessoa com relacao funcionario');
END;

-- Regra 14: vendedor ativo

CREATE TRIGGER trg_pedido_vendedor_ativo
BEFORE INSERT ON pedido
WHEN (SELECT status FROM vendedor WHERE id = NEW.id_vendedor) != 'ativo'
BEGIN
  SELECT RAISE(ABORT, 'Vendedor inativo nao pode registrar pedido');
END;

CREATE TRIGGER trg_pedido_pagamento_coerente
BEFORE INSERT ON pedido
WHEN (SELECT id_cliente FROM pagamento WHERE id = NEW.id_pagamento) != NEW.id_cliente
  OR (SELECT id_vendedor FROM pagamento WHERE id = NEW.id_pagamento) != NEW.id_vendedor
BEGIN
  SELECT RAISE(ABORT, 'Pagamento deve ser do mesmo cliente e do mesmo vendedor do pedido');
END;

CREATE TRIGGER trg_comissao_vendedor_ativo
BEFORE INSERT ON comissao
WHEN NEW.id_vendedor IS NOT NULL
  AND (SELECT status FROM vendedor WHERE id = NEW.id_vendedor) != 'ativo'
BEGIN
  SELECT RAISE(ABORT, 'Vendedor inativo nao pode receber comissao');
END;

-- Regra 4: comissao do profissional que esta no pedido

CREATE TRIGGER trg_comissao_profissional_do_pedido
BEFORE INSERT ON comissao
WHEN (
    NEW.id_vendedor IS NOT NULL
    AND (
      (SELECT id_vendedor FROM pedido WHERE id = NEW.id_pedido) IS NULL
      OR NEW.id_vendedor != (SELECT id_vendedor FROM pedido WHERE id = NEW.id_pedido)
    )
  )
  OR (
    NEW.id_entregador IS NOT NULL
    AND (
      (SELECT id_entregador FROM pedido WHERE id = NEW.id_pedido) IS NULL
      OR NEW.id_entregador != (SELECT id_entregador FROM pedido WHERE id = NEW.id_pedido)
    )
  )
  OR (
    NEW.id_jardineiro IS NOT NULL
    AND (
      (SELECT id_jardineiro FROM pedido WHERE id = NEW.id_pedido) IS NULL
      OR NEW.id_jardineiro != (SELECT id_jardineiro FROM pedido WHERE id = NEW.id_pedido)
    )
  )
BEGIN
  SELECT RAISE(ABORT, 'Comissao deve ser do profissional associado ao pedido');
END;

-- Regra 10: baixa de estoque. Nao ha estorno no cancelamento (regra 15).

CREATE TRIGGER trg_baixa_flor
BEFORE INSERT ON item_pedido
WHEN NEW.id_tipo_flor IS NOT NULL
BEGIN
  SELECT CASE
    WHEN (SELECT quantidade FROM tipo_flores WHERE id = NEW.id_tipo_flor) < NEW.quantidade
    THEN RAISE(ABORT, 'Estoque insuficiente de flores')
  END;
  UPDATE tipo_flores
     SET quantidade = quantidade - NEW.quantidade
   WHERE id = NEW.id_tipo_flor;
END;

CREATE TRIGGER trg_baixa_ornamento
BEFORE INSERT ON item_pedido
WHEN NEW.id_ornamento IS NOT NULL
BEGIN
  SELECT CASE
    WHEN (SELECT quantidade FROM ornamento WHERE id = NEW.id_ornamento) < NEW.quantidade
    THEN RAISE(ABORT, 'Estoque insuficiente de ornamento')
  END;
  UPDATE ornamento
     SET quantidade = quantidade - NEW.quantidade
   WHERE id = NEW.id_ornamento;
END;

-- Regra 11: feedback somente apos a entrega

CREATE TRIGGER trg_feedback_apos_entrega
BEFORE INSERT ON feedback
WHEN (SELECT status FROM pedido WHERE id = NEW.id_pedido) IS NOT 'entregue'
BEGIN
  SELECT RAISE(ABORT, 'Feedback so pode ser registrado apos a entrega do pedido');
END;

-- Regra 12: entrega surpresa exige a modalidade correspondente.
-- O entregador obrigatorio ja e garantido pelo CHECK de pedido.

CREATE TRIGGER trg_surpresa_so_na_modalidade
BEFORE INSERT ON entrega_surpresa
WHEN (SELECT modalidade FROM pedido WHERE id = NEW.id_pedido) IS NOT 'surpresa'
BEGIN
  SELECT RAISE(ABORT, 'Entrega surpresa exige modalidade surpresa no pedido');
END;
