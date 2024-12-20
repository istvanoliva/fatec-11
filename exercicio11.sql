CREATE TABLE tb_log (
    id SERIAL PRIMARY KEY,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nome_procedimento VARCHAR(200)
);

CREATE OR REPLACE PROCEDURE sp_cadastrar_cliente (IN nome VARCHAR(200), IN codigo INT DEFAULT NULL)
LANGUAGE plpgsql
AS $$
BEGIN
    IF codigo IS NULL THEN
        INSERT INTO tb_cliente (nome) VALUES (nome);
    ELSE
        INSERT INTO tb_cliente (codigo, nome) VALUES (codigo, nome);
    END IF;

    -- Inserir registro no log
    INSERT INTO tb_log (nome_procedimento) VALUES ('sp_cadastrar_cliente');
END;
$$;

CREATE OR REPLACE PROCEDURE sp_total_pedidos_cliente (IN cod_cliente INT)
LANGUAGE plpgsql
AS $$
DECLARE
    total_pedidos INT;
BEGIN
    SELECT COUNT(*) INTO total_pedidos
    FROM tb_pedido
    WHERE cod_cliente = cod_cliente;

    RAISE NOTICE 'O cliente possui % pedidos.', total_pedidos;

    -- Inserir registro no log
    INSERT INTO tb_log (nome_procedimento) VALUES ('sp_total_pedidos_cliente');
END;
$$;

CREATE OR REPLACE PROCEDURE sp_total_pedidos_cliente_out (IN cod_cliente INT, OUT total_pedidos INT)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(*) INTO total_pedidos
    FROM tb_pedido
    WHERE cod_cliente = cod_cliente;

    -- Inserir registro no log
    INSERT INTO tb_log (nome_procedimento) VALUES ('sp_total_pedidos_cliente_out');
END;
$$;

CREATE OR REPLACE PROCEDURE sp_total_pedidos_cliente_inout (INOUT cod_cliente INT)
LANGUAGE plpgsql
AS $$
DECLARE
    total_pedidos INT;
BEGIN
    SELECT COUNT(*) INTO total_pedidos
    FROM tb_pedido
    WHERE cod_cliente = cod_cliente;

    cod_cliente := total_pedidos;

    -- Inserir registro no log
    INSERT INTO tb_log (nome_procedimento) VALUES ('sp_total_pedidos_cliente_inout');
END;
$$;

CREATE OR REPLACE PROCEDURE sp_cadastrar_varios_clientes (
    VARIADIC nomes VARCHAR[],
    OUT resultado TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    nome VARCHAR;
BEGIN
    FOREACH nome IN ARRAY nomes LOOP
        INSERT INTO tb_cliente (nome) VALUES (nome);
    END LOOP;

    resultado := 'Os clientes: ' || array_to_string(nomes, ', ') || ' foram cadastrados';

    -- Inserir registro no log
    INSERT INTO tb_log (nome_procedimento) VALUES ('sp_cadastrar_varios_clientes');
END;
$$;

DO $$
DECLARE
    resultado TEXT;
BEGIN
    CALL sp_cadastrar_varios_clientes('Pedro', 'Ana', 'João', resultado);
    RAISE NOTICE '%', resultado;
END;
$$;

