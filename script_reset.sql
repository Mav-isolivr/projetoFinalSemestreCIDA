-- Limpeza opcional. Nao faz parte da carga entregue em floricultura.db.
-- Apaga os dados na ordem exigida pelas chaves estrangeiras e zera o AUTOINCREMENT.

PRAGMA foreign_keys = ON;

BEGIN;

DELETE FROM feedback;
DELETE FROM entrega_surpresa;
DELETE FROM comissao;
DELETE FROM item_pedido;
DELETE FROM pedido;
DELETE FROM pagamento;
DELETE FROM destinatario;
DELETE FROM ornamento;
DELETE FROM tipo_flores;
DELETE FROM estoque;
DELETE FROM cliente;
DELETE FROM entregador;
DELETE FROM jardineiro;
DELETE FROM vendedor;
DELETE FROM pessoa;
DELETE FROM turno;

DELETE FROM sqlite_sequence;

COMMIT;
