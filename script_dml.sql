-- UFSC - CIN8003 - Bancos de Dados e Aplicacoes
-- Docente: Moises Lima Dutra
-- Aluna: Maria Vitoria de Oliveira
-- Cenario: floricultura
--
-- Script DML. A ordem respeita as chaves estrangeiras.
-- A data 31/09/2002 do esboco original nao existe; Felipe ficou com 2002-09-30.
-- A baixa de estoque ocorre nos gatilhos, ao inserir item_pedido.

PRAGMA foreign_keys = ON;

BEGIN;

INSERT INTO pessoa (nome, sobrenome, cpf, data_nascimento, numero_contato, email_contato, endereco, relacao) VALUES
  ('Ana', 'Silva', '11122233341', '2001-10-30', '988881111', 'ana.silva@email.com', 'Rua A, 123', 'funcionario'),
  ('Bruno', 'Santos', '22233344452', '1985-01-28', '977772222', 'bruno.santos@email.com', 'Rua B, 456', 'funcionario'),
  ('Carla', 'Oliveira', '33344455563', '1996-06-12', '966663333', 'carla.oliveira@email.com', 'Rua C, 789', 'funcionario'),
  ('Daniel', 'Souza', '44455566674', '1998-08-21', '955554444', 'daniel.souza@email.com', 'Rua D, 101', 'funcionario'),
  ('Eduarda', 'Lima', '55566677885', '1999-11-05', '944445555', 'eduarda.lima@email.com', 'Rua E, 202', 'funcionario'),
  ('Felipe', 'Costa', '66677788896', '2002-09-30', '933336666', 'felipe.costa@email.com', 'Rua F, 303', 'funcionario'),
  ('Gabriel', 'Pereira', '77788899907', '1977-04-22', '922227777', 'gabriel.pereira@email.com', 'Rua G, 404', 'funcionario'),
  ('Helena', 'Almeida', '88899900018', '1989-07-01', '911118888', 'helena.almeida@email.com', 'Rua H, 505', 'funcionario'),
  ('Igor', 'Ferreira', '99900011129', '2004-06-04', '900009999', 'igor.ferreira@email.com', 'Rua I, 606', 'funcionario'),
  ('Juliana', 'Martins', '10111213140', '1996-09-04', '999990000', 'juliana.martins@email.com', 'Rua J, 707', 'funcionario'),
  ('Lucas', 'Barbosa', '12131415161', '2003-02-28', '988880001', 'lucas.barbosa@email.com', 'Rua K, 808', 'funcionario'),
  ('Mariana', 'Rocha', '13141516172', '2000-03-19', '977770002', 'mariana.rocha@email.com', 'Rua L, 909', 'funcionario'),
  ('Roberto', 'Dias', '14151617183', '1996-12-09', '966554433', 'roberto.dias@email.com', 'Av. Central, 1000', 'cliente'),
  ('Patrícia', 'Mendes', '15161718194', '1986-03-08', '955443322', 'patricia.mendes@email.com', 'Rua das Flores, 45', 'cliente'),
  ('Marcos', 'Vinicius', '16171819205', '2003-05-23', '944332211', 'marcos.vinicius@email.com', 'Praça da Matriz, 12', 'cliente'),
  ('Beatriz', 'Castro', '17181920216', '2000-11-21', '933221100', 'beatriz.castro@email.com', 'Alameda das Rosas, 300', 'cliente');

INSERT INTO turno (dia, horas, periodo) VALUES
  (1, 8, 'manhã'),
  (1, 8, 'tarde'),
  (2, 8, 'manhã'),
  (2, 8, 'tarde'),
  (3, 8, 'manhã'),
  (3, 8, 'tarde'),
  (4, 8, 'manhã'),
  (4, 8, 'tarde'),
  (5, 8, 'manhã'),
  (5, 8, 'tarde'),
  (6, 4, 'tarde'),
  (6, 4, 'manhã');

INSERT INTO cliente (id_pessoa) VALUES
  (13),
  (14),
  (15),
  (16);

INSERT INTO vendedor (id_pessoa, id_turno, status) VALUES
  (1, 1, 'ativo'),
  (2, 2, 'ativo'),
  (3, 3, 'ativo'),
  (4, 4, 'inativo'),
  (5, 5, 'ativo'),
  (6, 6, 'inativo');

INSERT INTO jardineiro (id_pessoa, id_turno) VALUES
  (7, 7),
  (8, 8);

INSERT INTO entregador (id_pessoa, id_turno) VALUES
  (9, 9),
  (10, 10),
  (11, 11),
  (12, 12);

-- Gabriel (1) cuida de dois estoques. Helena (2) cuida de dois estoques.
INSERT INTO estoque (sementes, id_jardineiro) VALUES
  (300, 1),
  (200, 1),
  (450, 2),
  (600, 2);

INSERT INTO tipo_flores (nome, cor, tamanho, quantidade, id_estoque) VALUES
  ('Rosa', 'Vermelha', 30, 40, 1),
  ('Margarida', 'Branca', 20, 30, 2),
  ('Girassol', 'Amarela', 45, 20, 3),
  ('Orquídea', 'Roxa', 25, 15, 4);

INSERT INTO ornamento (cor, tamanho, fitas, podacao, quantidade, id_estoque, id_flores) VALUES
  ('Dourado', 10, 'Cetim', 'não', 20, 1, 1),
  ('Prateado', 15, 'Renda', 'não', 15, 2, 2),
  ('Vermelho', 12, 'Seda', 'sim', 10, 3, 3);

INSERT INTO destinatario (nome, endereco, numero_contato) VALUES
  ('Carlos Silva', 'Av. do Trabalho, 500', '988770011'),
  ('Ana Souza', 'Rua das Acácias, 88', '977660022'),
  ('Mariana Dias', 'Rua da Loja, 1', '966550033'),
  ('Paulo Roberto', 'Rua do Comércio, 40', '955440044');

INSERT INTO pagamento (valor, tipo, parcelamento, id_cliente, id_vendedor) VALUES
  (150, 'credito', 2, 1, 1),
  (200, 'debito', 1, 2, 2),
  (80, 'credito', 1, 3, 3),
  (300, 'debito', 3, 4, 5);

-- 1 surpresa entregue, 2 entrega comum entregue, 3 retirada entregue, 4 entrega cancelada.
-- Daniel (vendedor 4) e Felipe (vendedor 6) estao inativos e nao registram pedido.
INSERT INTO pedido (
  data_pedido, status, modalidade,
  id_cliente, id_destinatario, id_pagamento, id_vendedor, id_entregador, id_jardineiro
) VALUES
  ('2026-10-01', 'entregue', 'surpresa', 1, 1, 1, 1, 1, 1),
  ('2026-10-05', 'entregue', 'entrega', 2, 2, 2, 2, 2, 2),
  ('2026-10-08', 'entregue', 'retirada', 3, 3, 3, 3, NULL, 1),
  ('2026-10-12', 'cancelado', 'entrega', 4, 4, 4, 5, 3, 2);

-- Quantidades iniciais menos o que sai aqui:
-- Rosa 40-12=28, Margarida 30-6=24, Girassol 20-3=17, Orquidea 15-5=10.
-- Ornamentos 20-1=19, 15-1=14, 10-1=9.
-- O pedido 4 foi cancelado depois do uso: as 5 orquideas nao voltam ao estoque.
INSERT INTO item_pedido (id_pedido, id_tipo_flor, id_ornamento, quantidade) VALUES
  (1, 1, NULL, 12),
  (1, NULL, 1, 1),
  (2, 2, NULL, 6),
  (2, NULL, 2, 1),
  (3, 3, NULL, 3),
  (3, NULL, 3, 1),
  (4, 4, NULL, 5);

INSERT INTO comissao (valor_por_pedido, id_pedido, id_vendedor, id_entregador, id_jardineiro) VALUES
  (50, 1, 1, NULL, NULL),
  (25, 1, NULL, 1, NULL),
  (35, 1, NULL, NULL, 1),
  (45, 2, 2, NULL, NULL),
  (30, 2, NULL, 2, NULL),
  (40, 2, NULL, NULL, 2),
  (60, 3, 3, NULL, NULL),
  (40, 3, NULL, NULL, 1),
  (30, 4, 5, NULL, NULL),
  (45, 4, NULL, NULL, 2);

INSERT INTO feedback (nota, descricao, id_pedido) VALUES
  (5, 'Excelente atendimento e flores lindas!', 1),
  (4, 'Entrega rápida, gostei muito.', 2),
  (5, 'O arranjo superou as expectativas!', 3);

INSERT INTO entrega_surpresa (tipo_entrega, local, sigilo, id_pedido) VALUES
  ('Aniversario', 'Trabalho', 'sim', 1);

COMMIT;
